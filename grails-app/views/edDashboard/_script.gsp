

<script language="javascript">
    var gridEdDashboard, dataSource, edDashboardModel,dropDownService, serviceId, isSubmit;

    $(document).ready(function () {
        onLoadEdDashboardPage();
        initEdDashboardGrid();
        initObservable();
        isSubmit=${isSubmitted};
    });

    function onLoadEdDashboardPage() {
        $("#rowEdDashboards").hide();
        serviceId = ${serviceId};
        initializeForm($("#edDashboardForm"), onSubmitEdDashboard);
        defaultPageTile("Create Ed Dashboard",null);
    }

    function executePreCondition() {
        if (!validateForm($("#edDashboardForm"))) {
            return false;
        }
        return true;
    }

    function onSubmitEdDashboard() {
        if (executePreCondition() == false) {
            return false;
        }

        setButtonDisabled($('#create'), true);
        showLoadingSpinner(true);
        var actionUrl = null;
        if ($('#id').val().isEmpty()) {
            actionUrl = "${createLink(controller:'EdDashboard', action: 'create')}";
        } else {
            actionUrl = "${createLink(controller:'EdDashboard', action: 'update')}";
        }

        jQuery.ajax({
            type: 'post',
            data: jQuery("#edDashboardForm").serialize(),
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
                var newEntry = result.pmEdDashboard;
                if ($('#id').val().isEmpty() && newEntry != null) { // newly created
                    var gridData = gridEdDashboard.dataSource.data();
                    gridData.unshift(newEntry);
                } else if (newEntry != null) { // updated existing
                    var selectedRow = gridEdDashboard.select();
                    var allItems = gridEdDashboard.items();
                    var selectedIndex = allItems.index(selectedRow);
                    gridEdDashboard.removeRow(selectedRow);
                    gridEdDashboard.dataSource.insert(selectedIndex, newEntry);
                }
                emptyForm();
                showSuccess(result.message);
            } catch (e) {
                // Do Nothing
            }
        }
    }

    function emptyForm() {
        clearForm($("#edDashboardForm"), $('#serviceId'));
        initObservable();
        dropDownService.value(serviceId);
        $('#create').html("<span class='k-icon k-i-plus'></span>Create");
    }
    function resetForm() {
        initObservable();
        dropDownService.value(serviceId);
        $('#rowEdDashboards').hide();
    }

    function initDataSource() {
        dataSource = new kendo.data.DataSource({
            transport: {
                read: {
                    url: "${createLink(controller: 'EdDashboard', action: 'list')}",
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
                        issue_name: { type: "string" },
                        description: { type: "string" },
                        remarks: { type: "string" },
                        ed_advice: { type: "string" }
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

    function initEdDashboardGrid() {
        initDataSource();
        $("#gridEdDashboard").kendoGrid({
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
                {field: "issue_name", title: "Issue", width: 70, sortable: false, filterable: false},
                {field: "description", title: "Description", width: 150, sortable: false, filterable: false},
                {field: "remarks", title: "Remarks", width: 100, sortable: false, filterable: false},
                {field: "ed_advice", title: "Ed's Advice", width: 100, sortable: false, filterable: false},

            ],
            filterable: {
                mode: "row"
            }
        });
        gridEdDashboard = $("#gridEdDashboard").data("kendoGrid");
    }

    function initObservable() {
        edDashboardModel = kendo.observable(
                {
                    edDashboard: {
                        id: "",
                        version: "",
                        monthFor: "",
                        serviceId: ""
                    }
                }
        );
        kendo.bind($("#application_top_panel"), edDashboardModel);
    }

    function deleteService() {
        if (executeCommonPreConditionForSelectKendo(gridEdDashboard, 'edDashboard') == false) {
            return;
        }
        var msg = 'Are you sure you want to delete the selected record?',
                url = "${createLink(controller: 'pmEdDashboards', action:  'delete')}";
        confirmDelete(msg, url, gridEdDashboard);
    }
    function addService(){
        $("#rowEdDashboards").show();
        dropDownService.value(serviceId);
    }
    function editService() {
        if (executeCommonPreConditionForSelectKendo(gridEdDashboard, 'edDashboard') == false) {
            return;
        }
        $("#rowEdDashboards").show();
        var edDashboard = getSelectedObjectFromGridKendo(gridEdDashboard);
        showService(edDashboard);
    }

    function showService(edDashboard) {
        edDashboardModel.set('edDashboard', edDashboard);
        $('#create').html("<span class='k-icon k-i-plus'></span>Update");
    }

</script>
