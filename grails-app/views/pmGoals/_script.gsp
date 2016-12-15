<script type="text/x-kendo-template" id="gridToolbar">
<ul id="menuGrid" class="kendoGridMenu">
    <sec:access url="/pmGoals/create">
        <li onclick="addService();"><i class="fa fa-plus-square"></i>Add</li>
    </sec:access>
    <sec:access url="/pmGoals/update">
        <li onclick="editService();"><i class="fa fa-edit"></i>Edit</li>
    </sec:access>
    <sec:access url="/pmGoals/delete">
        <li onclick="deleteService();"><i class="fa fa-trash-o"></i>Delete</li>
    </sec:access>
</ul>
</script>

<script language="javascript">
    var gridGoal, dataSource, goalModel,dropDownService, serviceId;

    $(document).ready(function () {
        onLoadGoalPage();
        initGoalGrid();
        initObservable();
    });

    function onLoadGoalPage() {
        $("#rowGoals").hide();
        serviceId = ${serviceId};
        initializeForm($("#goalForm"), onSubmitGoal);
        defaultPageTile("Create Goal",null);
    }

    function executePreCondition() {
        if (!validateForm($("#goalForm"))) {
            return false;
        }
        return true;
    }

    function onSubmitGoal() {
        if (executePreCondition() == false) {
            return false;
        }

        setButtonDisabled($('#create'), true);
        showLoadingSpinner(true);
        var actionUrl = null;
        if ($('#id').val().isEmpty()) {
            actionUrl = "${createLink(controller:'pmGoals', action: 'create')}";
        } else {
            actionUrl = "${createLink(controller:'pmGoals', action: 'update')}";
        }

        jQuery.ajax({
            type: 'post',
            data: jQuery("#goalForm").serialize(),
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
                var newEntry = result.pmGoal;
                if ($('#id').val().isEmpty() && newEntry != null) { // newly created
                    var gridData = gridGoal.dataSource.data();
                    gridData.unshift(newEntry);
                } else if (newEntry != null) { // updated existing
                    var selectedRow = gridGoal.select();
                    var allItems = gridGoal.items();
                    var selectedIndex = allItems.index(selectedRow);
                    gridGoal.removeRow(selectedRow);
                    gridGoal.dataSource.insert(selectedIndex, newEntry);
                }
                emptyForm();
                showSuccess(result.message);
            } catch (e) {
                // Do Nothing
            }
        }
    }

    function emptyForm() {
        clearForm($("#goalForm"), $('#serviceId'));
        initObservable();
        dropDownService.value(serviceId);
        $('#create').html("<span class='k-icon k-i-plus'></span>Create");
    }
    function resetForm() {
        initObservable();
        dropDownService.value(serviceId);
        $('#rowGoals').hide();
    }

    function initDataSource() {
        dataSource = new kendo.data.DataSource({
            transport: {
                read: {
                    url: "${createLink(controller: 'pmGoals', action: 'list')}",
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
                        goal: { type: "string" },
                        serviceId: { type: "number" },
                        service: { type: "string" },
                        serShortName: { type: "string" },
                        sequence: { type: "number" }
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

    function initGoalGrid() {
        initDataSource();
        $("#gridGoal").kendoGrid({
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
                {field: "serShortName", title: "Sector/CSU", width: 30, sortable: false, filterable: false},
                {field: "sequence", title: "ID#", width: 20, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()},headerAttributes: {style: setAlignCenter()}
                },
                {field: "goal", title: "Goal Statement", width: 200, sortable: false, filterable: false}
            ],
            filterable: {
                mode: "row"
            },
            toolbar: kendo.template($("#gridToolbar").html())
        });
        gridGoal = $("#gridGoal").data("kendoGrid");
        $("#menuGrid").kendoMenu();
    }

    function initObservable() {
        goalModel = kendo.observable(
                {
                    goal: {
                        id: "",
                        version: "",
                        goal: "",
                        serviceId: ""
                    }
                }
        );
        kendo.bind($("#application_top_panel"), goalModel);
    }

    function deleteService() {
        if (executeCommonPreConditionForSelectKendo(gridGoal, 'goal') == false) {
            return;
        }
        var msg = 'Are you sure you want to delete the selected record?',
                url = "${createLink(controller: 'pmGoals', action:  'delete')}";
        confirmDelete(msg, url, gridGoal);
    }
    function addService(){
        $("#rowGoals").show();
        dropDownService.value(serviceId);
    }
    function editService() {
        if (executeCommonPreConditionForSelectKendo(gridGoal, 'goal') == false) {
            return;
        }
        $("#rowGoals").show();
        var goal = getSelectedObjectFromGridKendo(gridGoal);
        showService(goal);
    }

    function showService(goal) {
        goalModel.set('goal', goal);
        $('#create').html("<span class='k-icon k-i-plus'></span>Update");
    }

</script>
