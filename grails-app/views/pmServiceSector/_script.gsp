<script type="text/x-kendo-template" id="gridToolbar">
<ul id="menuGrid" class="kendoGridMenu">
    <sec:access url="/pmServiceSector/create">
        <li onclick="addService();"><i class="fa fa-plus-square"></i>Add</li>
    </sec:access>
    <sec:access url="/pmServiceSector/update">
    <li onclick="editService();"><i class="fa fa-edit"></i>Edit</li>
</sec:access>
</ul>
</script>

<script language="javascript">
    var gridService, dataSource, serviceModel,dropDownServiceCategory,dropDownDepartmentHead;

    $(document).ready(function () {
        onLoadServicePage();
        initServiceGrid();
        initObservable();
    });

    function onLoadServicePage() {
        $('#rowCSU').hide();
        initializeForm($("#serviceForm"), onSubmitService);
        defaultPageTile("Create Services",null);
    }

    function executePreCondition() {
        if (!validateForm($("#serviceForm"))) {
            return false;
        }
        return true;
    }

    function onSubmitService() {
        if (executePreCondition() == false) {
            return false;
        }
        var actionUrl = null;
        if ($('#id').val().isEmpty()) {
            showError('CSU/Sector is only updatable');
            return false
            %{--actionUrl = "${createLink(controller:'pmServiceSector', action: 'create')}";--}%
        } else {
            setButtonDisabled($('#create'), true);
            showLoadingSpinner(true);
            actionUrl = "${createLink(controller:'pmServiceSector', action: 'update')}";
        }

        jQuery.ajax({
            type: 'post',
            data: jQuery("#serviceForm").serialize(),
            url: actionUrl,
            success: function (data, textStatus) {
                executePostCondition(data);
                setButtonDisabled($('#create'), false);
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
            },
            complete: function (XMLHttpRequest, textStatus) {
                showLoadingSpinner(false);
            },
            dataType: 'json'
        });
        return false;
    }

    function executePostCondition(result) {
        if (result.isError) {
            showError(result.message);
            showLoadingSpinner(false);
        } else {
            try {
                var newEntry = result.pmServiceSector;
                if ($('#id').val().isEmpty() && newEntry != null) { // newly created
                    var gridData = gridService.dataSource.data();
                    gridData.unshift(newEntry);
                } else if (newEntry != null) { // updated existing
                    var selectedRow = gridService.select();
                    var allItems = gridService.items();
                    var selectedIndex = allItems.index(selectedRow);
                    gridService.removeRow(selectedRow);
                    gridService.dataSource.insert(selectedIndex, newEntry);
                }
                resetForm();
                showSuccess(result.message);
            } catch (e) {
                // Do Nothing
            }
        }
    }

    function resetForm() {
        $('#departmentHeadId').val('');
        clearForm($("#serviceForm"), $('#categoryId'));
        initObservable();
        $('#rowCSU').hide();
    }

    function initDataSource() {
        dataSource = new kendo.data.DataSource({
            transport: {
                read: {
                    url: "${createLink(controller: 'pmServiceSector', action: 'list')}",
                    dataType: "json",
                    type: "post"
                }
            },
            schema: {
                type: 'json',
                data: "list", total: "count",
                model: {
                    fields: {
                        id: { type: "number" },
                        version: { type: "number" },
                        name: { type: "string" },
                        categoryId: { type: "number" },
                        categoryName: { type: "string" },
                        contactEmail: { type: "string" },
                        departmentHeadId: { type: "string" },
                        departmentHead: { type: "string" },
                        shortName: { type: "string" },
                        sequence: { type: "number" },
                        isDisplayble: { type: "boolean" },
                        isInSp: { type: "boolean"},
                        isActive: { type: "boolean" }
                    }
                },
                parse: function (data) {
                    checkIsErrorGridKendo(data);
                    return data;
                }
            },
            sort: {field: 'id', dir: 'asc'},
            pageSize: getDefaultPageSize(),
            serverPaging: true,
            serverFiltering: true,
            serverSorting: true
        });
    }

    function initServiceGrid() {
        initDataSource();
        $("#gridService").kendoGrid({
            dataSource: dataSource,
            height: getGridHeightKendo(),
            selectable: true,
            sortable: true,
            resizable: true,
            reorderable: true,
            pageable: {
                refresh: true,
                pageSizes: getDefaultPageSizes(),
                buttonCount: 4
            },
            columns: [
                {field: "categoryName", title: "Category", width: 50, sortable: false, filterable: kendoCommonFilterable()},
                {field: "name", title: "Central Service/Sector", width: 180, sortable: false, filterable: kendoCommonFilterable(97),
                template:"#=name # (#= shortName#)"},
                {field: "departmentHead", title: "Department Head", width: 100, sortable: false, filterable: kendoCommonFilterable()},
                {field: "contactEmail", title: "Notify Email", width: 100, sortable: false, filterable: kendoCommonFilterable()},
                {field: "sequence", title: "Sequence", width: 30, sortable: false, filterable: false}
            ],
            filterable: {
                mode: "row"
            },
            toolbar: kendo.template($("#gridToolbar").html())
        });
        gridService = $("#gridService").data("kendoGrid");
        $("#menuGrid").kendoMenu();
    }

    function initObservable() {
        serviceModel = kendo.observable(
                {
                    service: {
                        id: "",
                        version: "",
                        sequence: "",
                        name: "",
                        shortName: "",
                        categoryId: "",
                        isInSp: true,
                        isDisplayble: true,
                        isActive: true,
                        departmentHeadId: ""
                    }
                }
        );
        kendo.bind($("#application_top_panel"), serviceModel);
    }
    function addService() {
        $('#rowCSU').show();
    }
    function editService() {
        if (executeCommonPreConditionForSelectKendo(gridService, 'service') == false) {
            return;
        }
        $('#rowCSU').show();
        var service = getSelectedObjectFromGridKendo(gridService);
        showService(service);
    }

    function showService(service) {
        serviceModel.set('service', service);
    }

</script>
