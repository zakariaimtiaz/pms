<script type="text/x-kendo-template" id="gridToolbar">
<ul id="menuGrid" class="kendoGridMenu">
    <sec:access url="/pmSprints/create">
        <li onclick="addService();"><i class="fa fa-plus-square"></i>Add</li>
    </sec:access>
    <sec:access url="/pmSprints/update">
        <li onclick="editService();"><i class="fa fa-edit"></i>Edit</li>
    </sec:access>
    <sec:access url="/pmSprints/delete">
        <li onclick="deleteService();"><i class="fa fa-trash-o"></i>Delete</li>
    </sec:access>
</ul>
</script>

<script language="javascript">
    var gridSprints, dataSource, sprintsModel,dropDownService,dropDownGoals,dropDownObjectives,dropDownActions;

    $(document).ready(function () {
        onLoadActionPage();
        initActionsGrid();
        initObservable();
    });

    function onLoadActionPage() {
        $("#rowAction").hide();
        $("#weight").kendoNumericTextBox({
            decimals : 0,
            format   : "### \\%",
            min      : 1,
            max      : 100
        });
        $('#start').kendoDatePicker({
            format: "MMMM yyyy",
            parseFormats: ["yyyy-MM-dd"],
            start: "year",
            depth: "year"
        });
        $('#end').kendoDatePicker({
            format: "MMMM yyyy",
            parseFormats: ["yyyy-MM-dd"],
            start: "year",
            depth: "year"
        });
        dropDownGoals = initKendoDropdown($('#goalId'), null, null, null);
        dropDownObjectives = initKendoDropdown($('#objectiveId'), null, null, null);
        dropDownActions = initKendoDropdown($('#actionsId'), null, null, null);
        initializeForm($("#actionForm"), onSubmitAction);
        defaultPageTile("Create Actions",null);
    }

    function executePreCondition() {
        if (!validateForm($("#actionForm"))) {
            return false;
        }
        return true;
    }

    function onSubmitAction() {
        if (executePreCondition() == false) {
            return false;
        }

        setButtonDisabled($('#create'), true);
        showLoadingSpinner(true);
        var actionUrl = null;
        if ($('#id').val().isEmpty()) {
            actionUrl = "${createLink(controller:'pmSprints', action: 'create')}";
        } else {
            actionUrl = "${createLink(controller:'pmSprints', action: 'update')}";
        }

        jQuery.ajax({
            type: 'post',
            data: jQuery("#actionForm").serialize(),
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
                var newEntry = result.pmAction;
                if ($('#id').val().isEmpty() && newEntry != null) { // newly created
                    var gridData = gridSprints.dataSource.data();
                    gridData.unshift(newEntry);
                } else if (newEntry != null) { // updated existing
                    var selectedRow = gridSprints.select();
                    var allItems = gridSprints.items();
                    var selectedIndex = allItems.index(selectedRow);
                    gridSprints.removeRow(selectedRow);
                    gridSprints.dataSource.insert(selectedIndex, newEntry);
                }
                emptyForm();
                showSuccess(result.message);
            } catch (e) {
                // Do Nothing
            }
        }
    }

    function emptyForm() {
        clearForm($("#actionForm"), null);
        initObservable();
        dropDownService.value('');
        dropDownGoals.value('');
        dropDownObjectives.value('');
    }
    function resetForm() {
        clearForm($("#actionForm"), null);
        initObservable();
        dropDownService.value('');
        dropDownGoals.value('');
        dropDownObjectives.value('');
        $("#rowAction").hide();
        $('#create').html("<span class='k-icon k-i-plus'></span>Create");
    }

    function initDataSource() {
        dataSource = new kendo.data.DataSource({
            transport: {
                read: {
                    url: "${createLink(controller: 'pmSprints', action: 'list')}",
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
                        sprints: { type: "string" },
                        objectiveId: { type: "number" },
                        actionsId: { type: "number" },
                        weight: { type: "number" },
                        goalId: { type: "number" },
                        goal: { type: "string" },
                        service: { type: "string" },
                        serShortName: { type: "string" },
                        serviceId: { type: "number" },
                        sequence: { type: "string" },
                        meaIndicator: { type: "string" },
                        target: { type: "string" },
                        resPerson: { type: "string" },
                        strategyMapRef: { type: "string" },
                        supportDepartment: { type: "string" },
                        sourceOfFund: { type: "string" },
                        remarks: { type: "string" },
                        start: { type: "date" },
                        end: { type: "date" }
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

    function initActionsGrid() {
        initDataSource();
        $("#gridSprints").kendoGrid({
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
                {field: "serShortName", title: "Service", width: 60, sortable: false, filterable: false},
                {field: "sequence", title: "Sequence", width: 60, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()},headerAttributes: {style: setAlignCenter()}
                },
                {field: "weight", title: "Weight", width: 60, sortable: false, filterable: false,
                    template:"#=weight # %",attributes: {style: setAlignCenter()},headerAttributes: {style: setAlignCenter()}
                },
                {field: "sprints", title: "Action", width: 120, sortable: false, filterable: false},
                {field: "start", title: "Start", width: 80, sortable: false, filterable: false,
                    template:"#=kendo.toString(kendo.parseDate(start, 'yyyy-MM-dd'), 'MMMM-yy')#"},
                {field: "end", title: "End", width: 80, sortable: false, filterable: false,
                    template:"#=kendo.toString(kendo.parseDate(end, 'yyyy-MM-dd'), 'MMMM-yy')#"},
                {field: "meaIndicator", title: "Measurement Indicator", width: 120, sortable: false, filterable: false},
                {field: "target", title: "Target", width: 80, sortable: false, filterable: false},
                {field: "supportDepartment", title: "Support Department", width: 120, sortable: false, filterable: false},
                {field: "resPerson", title: "Responsible Person", width: 120, sortable: false, filterable: false}
            ],
            filterable: {
                mode: "row"
            },
            toolbar: kendo.template($("#gridToolbar").html())
        });
        gridSprints = $("#gridSprints").data("kendoGrid");
        $("#menuGrid").kendoMenu();
    }

    function initObservable() {
        sprintsModel = kendo.observable(
                {
                    sprints: {
                        id: "",
                        version: "",
                        sequence: "",
                        sprints: "",
                        serviceId: "",
                        goalId: "",
                        objectiveId: "",
                        actionsId: "",
                        meaIndicator: "",
                        target: "",
                        weight: "",
                        resPerson: "",
                        strategyMapRef: "",
                        supportDepartment: "",
                        sourceOfFund: "",
                        start: "",
                        end: ""
                    }
                }
        );
        kendo.bind($("#application_top_panel"), sprintsModel);
    }

    function deleteService() {
        if (executeCommonPreConditionForSelectKendo(gridSprints, 'action') == false) {
            return;
        }
        var msg = 'Are you sure you want to delete the selected sprint?',
                url = "${createLink(controller: 'pmSprints', action:  'delete')}";
        confirmDelete(msg, url, gridSprints);
    }

    function addService() {
        $("#rowAction").show();
    }
    function editService() {
        if (executeCommonPreConditionForSelectKendo(gridSprints, 'action') == false) {
            return;
        }
        addService();
        var sprints = getSelectedObjectFromGridKendo(gridSprints);
        showService(sprints);
    }

    function showService(sprints) {
        sprintsModel.set('sprints', sprints);
        populateGoals(sprints.serviceId,sprints.goalId,sprints.objectiveId);
        $('#create').html("<span class='k-icon k-i-plus'></span>Update");
    }

    // To populate Goals List
    function populateGoals(serId,goalId,objectiveId) {
        var serviceId = serId?serId:dropDownService.value();
        if (serviceId == '') {
            dropDownGoals.setDataSource(getKendoEmptyDataSource(dropDownGoals, null));
            dropDownObjectives.setDataSource(getKendoEmptyDataSource(dropDownObjectives, null));
            dropDownGoals.value('');
            dropDownObjectives.value('');
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
                if(goalId){
                    dropDownGoals.value(goalId);
                    populateObjectives(goalId,objectiveId);
                }
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
        // To populate Objectives List
    function populateObjectives(goalId,objectiveId) {
        var goalsId = goalId?goalId:dropDownGoals.value();
        if (goalsId == '') {
            dropDownObjectives.setDataSource(getKendoEmptyDataSource(dropDownObjectives, null));
            dropDownObjectives.value('');
            return false;
        }
        showLoadingSpinner(true);
        $.ajax({
            url: "${createLink(controller: 'pmObjectives', action: 'lstObjectiveByGoalsId')}?goalId=" + goalsId,
            success: function (data) {
                if (data.isError) {
                    showError(data.message);
                    return false;
                }
                dropDownObjectives.setDataSource(data.lstObjectives);
                if(objectiveId) dropDownObjectives.value(objectiveId);
                populateActions(sprints.actionsId,sprints.objectiveId);
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
    function populateActions(actionsId,objectiveId) {
        var objectiveId = objectiveId?objectiveId:dropDownObjectives.value();
        if (objectiveId == '') {
            dropDownActions.setDataSource(getKendoEmptyDataSource(dropDownActions, null));
            dropDownActions.value('');
            return false;
        }
        showLoadingSpinner(true);
        $.ajax({
            url: "${createLink(controller: 'pmActions', action: 'lstActionsByObjectiveId')}?objectiveId=" + objectiveId,
            success: function (data) {
                if (data.isError) {
                    showError(data.message);
                    return false;
                }
                dropDownActions.setDataSource(data.lstActions);
                if(actionsId) dropDownActions.value(actionsId);
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
