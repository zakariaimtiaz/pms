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
    var gridSprints, dataSource, sprintsModel,dropDownService,dropDownGoals,dropDownActions,dropDownEmployee;

    $(document).ready(function () {
        onLoadSprintsPage();
        initSprintsGrid();
        initObservable();
    });

    function onLoadSprintsPage() {
        $("#rowSprint").hide();
        $("#weight").kendoNumericTextBox({
            decimals : 0,
            format   : "### \\%",
            min      : 1,
            max      : 100
        });
        var currentDate = moment().format('dd/MM/yyyy');

        start = $('#start').kendoDatePicker({
            format: "dd/MM/yyyy",
            parseFormats: ["yyyy-MM-dd"],
            change: startChange,
            start: "month",
            depth: "month"
        }).data("kendoDatePicker");

        start.value(currentDate);

        end = $('#end').kendoDatePicker({
            format: "dd/MM/yyyy",
            parseFormats: ["yyyy-MM-dd"],
            start: "month",
            depth: "month"
        }).data("kendoDatePicker");

        end.value(currentDate);
        end.min(start.value());
        dropDownGoals = initKendoDropdown($('#goalId'), null, null, null);
        dropDownActions = initKendoDropdown($('#actionsId'), null, null, null);
        initializeForm($("#sprintsForm"), onSubmitSprints);
        defaultPageTile("Create Steps",null);
    }
    function startChange() {
        var startDate = start.value();
        if (startDate) {
            startDate = new Date(startDate);
            startDate.setDate(startDate.getDate() + 1);
            end.min(startDate);
        }
    }
    function executePreCondition() {
        if (!validateForm($("#sprintsForm"))) {
            return false;
        }
        return true;
    }

    function onSubmitSprints() {
        if (executePreCondition() == false) {
            return false;
        }

        setButtonDisabled($('#create'), true);
        showLoadingSpinner(true);
        var actionUrl = null;
        if ($('#id').val().isEmpty()) {

            actionUrl = "${createLink(controller:'pmSprints', action: 'create')}?resPerson="+dropDownEmployee.text();
        } else {
            actionUrl = "${createLink(controller:'pmSprints', action: 'update')}";
        }

        jQuery.ajax({
            type: 'post',
            data: jQuery("#sprintsForm").serialize(),
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
                var newEntry = result.pmSprints;
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
        clearForm($("#sprintsForm"), null);
        initObservable();
        dropDownService.value('');
        dropDownGoals.value('');
        dropDownActions.value('');
    }
    function resetForm() {
        clearForm($("#sprintsForm"), null);
        initObservable();
        dropDownService.value('');
        dropDownGoals.value('');
        dropDownActions.value('');
        $("#rowSprint").hide();
        $('#create').html("<span class='k-icon k-i-plus'></span>Save");
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
                        actionsId: { type: "number" },
                        weight: { type: "number" },
                        goalId: { type: "number" },
                        goal: { type: "string" },
                        service: { type: "string" },
                        serShortName: { type: "string" },
                        serviceId: { type: "number" },
                        sequence: { type: "string" },
                        target: { type: "string" },
                        resPersonId: { type: "number" },
                        resPerson: { type: "string" },
                        supportDepartment: { type: "string" },
                        remarks: { type: "string" },
                        startDate: { type: "date" },
                        endDate: { type: "date" }
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

    function initSprintsGrid() {
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
                {field: "sequence", title: "Sequence", width: 60, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()},headerAttributes: {style: setAlignCenter()}
                },
                {field: "weight", title: "Weight", width: 60, sortable: false, filterable: false,
                    template:"#=weight # %",attributes: {style: setAlignCenter()},headerAttributes: {style: setAlignCenter()}
                },
                {field: "startDate", title: "Start", width: 80, sortable: false, filterable: false,
                    template:"#=kendo.toString(kendo.parseDate(startDate, 'yyyy-MM-dd'), 'dd/MM/yyyy')#"},
                {field: "endDate", title: "End", width: 80, sortable: false, filterable: false,
                    template:"#=kendo.toString(kendo.parseDate(endDate, 'yyyy-MM-dd'), 'dd/MM/yyyy')#"},
                {field: "sprints", title: "Steps", width: 120, sortable: false, filterable: false},
                {field: "target", title: "Target", width: 80, sortable: false, filterable: false},
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
                        actionsId: "",
                        target: "",
                        weight: "",
                        resPersonId: "",
                        resPerson: "",
                        supportDepartment: "",
                        startDate: "",
                        endDate: ""
                    }
                }
        );
        kendo.bind($("#application_top_panel"), sprintsModel);
    }

    function deleteService() {
        if (executeCommonPreConditionForSelectKendo(gridSprints, 'action') == false) {
            return;
        }
        var msg = 'Are you sure you want to delete the selected sprints?',
                url = "${createLink(controller: 'pmSprints', action:  'delete')}";
        confirmDelete(msg, url, gridSprints);
    }

    function addService() {
        $("#rowSprint").show();
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
        populateGoals(sprints.serviceId,sprints.goalId,sprints.actionsId);
        $('#create').html("<span class='k-icon k-i-plus'></span>Update");
    }

    // To populate Goals List
    function populateGoals(serId,goalId,actionsId) {
        var serviceId = serId?serId:dropDownService.value();
        if (serviceId == '') {
            dropDownGoals.setDataSource(getKendoEmptyDataSource(dropDownGoals, null));
            dropDownActions.setDataSource(getKendoEmptyDataSource(dropDownActions, null));
            dropDownGoals.value('');
            dropDownActions.value('');
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
                    populateActions(actionsId,goalId);
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


    function populateActions(actionsId,goalId) {
        var goalId = goalId?goalId:dropDownGoals.value();
        if (goalId == '') {
            dropDownActions.setDataSource(getKendoEmptyDataSource(dropDownActions, null));
            dropDownActions.value('');
            return false;
        }
        showLoadingSpinner(true);
        $.ajax({
            url: "${createLink(controller: 'pmActions', action: 'lstActionsByGoalId')}?goalId=" + goalId,
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
    function populateStartAndEndDate() {
        var actionId = dropDownActions.value();

        showLoadingSpinner(true);
        $.ajax({
            url:  "${createLink(controller:'pmActions', action: 'actionsStartAndEndDateById')}?actionId=" + actionId,
            success: function (data) {
                if (data.isError) {
                    showError(data.message);
                    return false;
                }
                start.value(data.lstActions.start);
                end.value(data.lstActions.end);
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
