<script type="text/x-kendo-template" id="gridToolbar">
<ul id="menuGrid" class="kendoGridMenu">
<sec:access url="/pmObjectives/create">
    <li onclick="addService();"><i class="fa fa-plus-square"></i>Add</li>
</sec:access>
    <sec:access url="/pmObjectives/update">
    <li onclick="editService();"><i class="fa fa-edit"></i>Edit</li>
</sec:access>
<sec:access url="/pmObjectives/delete">
    <li onclick="deleteService();"><i class="fa fa-trash-o"></i>Delete</li>
</sec:access>
</ul>
</script>

<script language="javascript">
    var gridObjectives, dataSource, objectivesModel,dropDownService,dropDownGoals;

    $(document).ready(function () {
        onLoadObjectivePage();
        initObjectiveGrid();
        initObservable();
    });

    function onLoadObjectivePage() {
        $("#rowObjectives").hide();
        $("#weight").kendoNumericTextBox({
            decimals : 0,
            format   : "### \\%",
            min      : 1,
            max      : 100
        });
        dropDownGoals = initKendoDropdown($('#goalId'), null, null, null);
        initializeForm($("#objectiveForm"), onSubmitObjective);
        defaultPageTile("Create Objectives",null);
    }

    function executePreCondition() {
        if (!validateForm($("#objectiveForm"))) {
            return false;
        }
        return true;
    }

    function onSubmitObjective() {
        if (executePreCondition() == false) {
            return false;
        }

        setButtonDisabled($('#create'), true);
        showLoadingSpinner(true);
        var actionUrl = null;
        if ($('#id').val().isEmpty()) {
            actionUrl = "${createLink(controller:'pmObjectives', action: 'create')}";
        } else {
            actionUrl = "${createLink(controller:'pmObjectives', action: 'update')}";
        }

        jQuery.ajax({
            type: 'post',
            data: jQuery("#objectiveForm").serialize(),
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
                var newEntry = result.pmObjective;
                if ($('#id').val().isEmpty() && newEntry != null) { // newly created
                    var gridData = gridObjectives.dataSource.data();
                    gridData.unshift(newEntry);
                } else if (newEntry != null) { // updated existing
                    var selectedRow = gridObjectives.select();
                    var allItems = gridObjectives.items();
                    var selectedIndex = allItems.index(selectedRow);
                    gridObjectives.removeRow(selectedRow);
                    gridObjectives.dataSource.insert(selectedIndex, newEntry);
                }
                emptyForm();
                showSuccess(result.message);
            } catch (e) {
                // Do Nothing
            }
        }
    }

    function emptyForm() {
        clearForm($("#objectiveForm"), null);
        initObservable();
        dropDownService.value('');
        dropDownGoals.value('');
        $('#create').html("<span class='k-icon k-i-plus'></span>Create");
    }
    function resetForm() {
        clearForm($("#objectiveForm"), null);
        initObservable();
        dropDownService.value('');
        dropDownGoals.value('');
        $("#rowObjectives").hide();
    }

    function initDataSource() {
        dataSource = new kendo.data.DataSource({
            transport: {
                read: {
                    url: "${createLink(controller: 'pmObjectives', action: 'list')}",
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
                        objective: { type: "string" },
                        weight: { type: "number" },
                        goalId: { type: "number" },
                        goal: { type: "string" },
                        service: { type: "string" },
                        serShortName: { type: "string" },
                        serviceId: { type: "number" },
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

    function initObjectiveGrid() {
        initDataSource();
        $("#gridObjectives").kendoGrid({
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
                {field: "serShortName", title: "Service", width: 30, sortable: false, filterable: false},
                {field: "sequence", title: "Sequence", width: 20, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()},headerAttributes: {style: setAlignCenter()}
                },
                {field: "weight", title: "Weight", width: 20, sortable: false, filterable: false,
                    template:"#=weight # %",attributes: {style: setAlignCenter()},headerAttributes: {style: setAlignCenter()}
                },
                {field: "objective", title: "Objective", width: 200, sortable: false, filterable: false}
            ],
            filterable: {
                mode: "row"
            },
            toolbar: kendo.template($("#gridToolbar").html())
        });
        gridObjectives = $("#gridObjectives").data("kendoGrid");
        $("#menuGrid").kendoMenu();
    }

    function initObservable() {
        objectivesModel = kendo.observable(
                {
                    objectives: {
                        id: "",
                        version: "",
                        sequence: "",
                        weight: "",
                        objective: "",
                        serviceId: "",
                        goalId: ""
                    }
                }
        );
        kendo.bind($("#application_top_panel"), objectivesModel);
    }

    function deleteService() {
        if (executeCommonPreConditionForSelectKendo(gridObjectives, 'objective') == false) {
            return;
        }
        var msg = 'Are you sure you want to delete the selected objective?',
                url = "${createLink(controller: 'pmObjectives', action:  'delete')}";
        confirmDelete(msg, url, gridObjectives);
    }
    function addService() {
        $("#rowObjectives").show();
    }
    function editService() {
        if (executeCommonPreConditionForSelectKendo(gridObjectives, 'objective') == false) {
            return;
        }
        $("#rowObjectives").show();
        var objectives = getSelectedObjectFromGridKendo(gridObjectives);
        showService(objectives);
    }

    function showService(objectives) {
        objectivesModel.set('objectives', objectives);
        populateGoals(objectives.serviceId,objectives.goalId);
        $('#create').html("<span class='k-icon k-i-plus'></span>Update");
    }

    // To populate Goals List
    function populateGoals(serId,goalId) {
        var serviceId = serId?serId:dropDownService.value();
        if (serviceId == '') {
            dropDownGoals.setDataSource(getKendoEmptyDataSource(dropDownGoals, null));
            dropDownGoals.value('');
            return false;
        }
        showLoadingSpinner(true);
        $.ajax({
            url: "${createLink(controller: 'pmGoals', action: 'lstGoalsByServiceId')}?serviceId=" + serviceId,
            success: function (data) {
                if (data.isError) {
                    showError(data.message);
                    return false;
                }
                dropDownGoals.setDataSource(data.lstGoals);
                if(goalId) dropDownGoals.value(goalId);
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                afterAjaxError(XMLHttpRequest, textStatus);
            },
            complete: function (XMLHttpRequest, textStatus) {
                showLoadingSpinner(false);
            },
            dataType: 'json',
            type: 'post'
        });
        return true;
    }

</script>
