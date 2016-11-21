<script type="text/x-kendo-template" id="gridToolbar">
<ul id="menuGrid" class="kendoGridMenu">
    <sec:access url="/pmServiceSector/update">
    <li onclick="editService();"><i class="fa fa-edit"></i>Edit</li>
</sec:access>
<sec:access url="/pmServiceSector/delete">
    <li onclick="deleteService();"><i class="fa fa-trash-o"></i>Delete</li>
</sec:access>
</ul>
</script>

<script language="javascript">
    var gridService, dataSource, serviceModel,dropDownServiceCategory;

    $(document).ready(function () {
        onLoadServicePage();
        initServiceGrid();
        initObservable();
    });

    function onLoadServicePage() {
        $('#sequence').kendoNumericTextBox({
            min: 1.00,
            step:1,
            decimals: 2,
            max: 999999999999,
            format: "##.##"

        });
        // initialize form with kendo validator & bind onSubmit event
        initializeForm($("#serviceForm"), onSubmitService);
        // update page title
        defaultPageTile("Create pmServiceSector",null);
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

        setButtonDisabled($('#create'), true);
        showLoadingSpinner(true);
        var actionUrl = null;
        if ($('#id').val().isEmpty()) {
            actionUrl = "${createLink(controller:'pmServiceSector', action: 'create')}";
        } else {
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
        clearForm($("#serviceForm"), $('#categoryId'));
        initObservable();
        $('#create').html("<span class='k-icon k-i-plus'></span>Create");
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
                        shortName: { type: "string" },
                        sequence: { type: "number" }
                    }
                },
                parse: function (data) {
                    checkIsErrorGridKendo(data);
                    return data;
                }
            },
            sort: {field: 'sequence', dir: 'asc'},
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
                {field: "name", title: "Central Service/Sector", width: 180, sortable: false, filterable: kendoCommonFilterable(97)},
                {field: "shortName", title: "Short Name", width: 100, sortable: false, filterable: kendoCommonFilterable()},
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
                        categoryId: ""
                    }
                }
        );
        kendo.bind($("#application_top_panel"), serviceModel);
    }

    function deleteService() {
        if (executeCommonPreConditionForSelectKendo(gridService, 'service') == false) {
            return;
        }
        var msg = 'Are you sure you want to delete the selected pmServiceSector?',
                url = "${createLink(controller: 'pmServiceSector', action:  'delete')}";
        confirmDelete(msg, url, gridService);
    }

    function editService() {
        if (executeCommonPreConditionForSelectKendo(gridService, 'service') == false) {
            return;
        }
        var service = getSelectedObjectFromGridKendo(gridService);
        showService(service);
    }

    function showService(service) {
        serviceModel.set('service', service);
        $('#create').html("<span class='k-icon k-i-plus'></span>Update");
    }

</script>
