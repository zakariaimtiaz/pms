<script type="text/x-kendo-template" id="gridToolbar">
<ul id="menuGrid" class="kendoGridMenu">
    <sec:access url="/quartz/create">
        <li onclick="showTrigger();"><i class="fa fa-plus-square-o"></i>New</li>
    </sec:access>
    <sec:access url="/quartz/update">
        <li onclick="editTrigger();"><i class="fa fa-edit"></i>Edit</li>
    </sec:access>
    <sec:access url="/quartz/delete">
        <li onclick="deleteTrigger();"><i class="fa fa-trash-o"></i>Delete</li>
    </sec:access>
    <sec:access url="/quartz/startScheduler">
        <li onclick="startTrigger();"><i class="fa fa-play"></i>Start</li>
    </sec:access>
    <sec:access url="/quartz/stopScheduler">
        <li onclick="stopTrigger();"><i class="fa fa-stop"></i>Stop</li>
    </sec:access>

</ul>
</script>

<script language="javascript">
    var gridQuartz, dataSource, quartzModel;

    $(document).ready(function () {
        onLoadQuartzPage();
        initQuartzGrid();
        initObservable();
    });

    function onLoadQuartzPage() {
        $("#quartzRow").hide();
        initializeForm($("#quartzForm"), onSubmitQuartz);
        defaultPageTile("Create Trigger",null);
    }

    function executePreCondition() {
        if (!validateForm($("#quartzForm"))) {
            return false;
        }
        return true;
    }

    function onSubmitQuartz() {
        if (executePreCondition() == false) {
            return false;
        }
        setButtonDisabled($('#create'), true);
        showLoadingSpinner(true);
        var actionUrl = null;
        if ($('#id').val().isEmpty()) {
            actionUrl = "${createLink(controller:'quartz', action: 'create')}";
        } else {
            actionUrl = "${createLink(controller:'quartz', action: 'update')}";
        }
        jQuery.ajax({
            type: 'post',
            data: jQuery("#quartzForm").serialize(),
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
                var newEntry = result.quartz;
                if ($('#id').val().isEmpty() && newEntry != null) { // newly created
                    var gridData = gridQuartz.dataSource.data();
                    gridData.unshift(newEntry);
                } else if (newEntry != null) { // updated existing
                    var selectedRow = gridQuartz.select();
                    var allItems = gridQuartz.items();
                    var selectedIndex = allItems.index(selectedRow);
                    gridQuartz.removeRow(selectedRow);
                    gridQuartz.dataSource.insert(selectedIndex, newEntry);
                }
                resetForm();
                showSuccess(result.message);
            } catch (e) {
                // Do Nothing
            }
        }
    }

    function resetForm() {
        clearForm($("#quartzForm"), $('#triggerName'));
        initObservable();
        $("#quartzRow").hide();
        $('#create').html("<span class='k-icon k-i-plus'></span>Save");
    }

    function initDataSource() {
        dataSource = new kendo.data.DataSource({
            transport: {
                read: {
                    url: "${createLink(controller: 'quartz', action: 'list')}",
                    dataType: "json",
                    type: "post"
                }
            },
            schema: {
                type: 'json',
                data: "list", total: "count",
                model: {
                    fields: {
                        id               : { type: "number" },
                        version          : { type: "number" },
                        triggerName      : { type: "string" },
                        jobName          : { type: "string" },
                        description      : { type: "string" },
                        cronExpression   : { type: "string" },
                        isActive         : { type: "boolean" },
                        isRunning        : { type: "boolean" }
                    }
                },
                parse: function (data) {
                    checkIsErrorGridKendo(data);
                    return data;
                }
            },
            sort: {field: 'id', dir: 'asc'},
            pageSize: 50,
            serverPaging: true,
            serverFiltering: true,
            serverSorting: true
        });
    }

    function initQuartzGrid() {
        initDataSource();
        $("#gridQuartz").kendoGrid({
            dataSource: dataSource,
            height: getGridHeightKendo(),
            selectable: true,
            sortable: true,
            resizable: true,
            reorderable: true,
            pageable: {
                refresh: true,
                pageSizes: [10, 15, 20],
                buttonCount: 4
            },
            columns: [
                {field: "triggerName", title: "Trigger", width: 70, sortable: false, filterable: false},
                {field: "jobName", title: "Job Name", width: 70, sortable: false, filterable: false},
                {field: "cronExpression", title: "Cron Expression", width: 100, sortable: false, filterable: false},
                {field: "description", title: "Description", width: 150, sortable: false, filterable: false},
                {field: "isActive", title: "Active", width: 50, sortable: false, filterable: false,attributes: {style: setAlignCenter()},
                    headerAttributes: {style: setAlignCenter()}, template:"#=isActive?'YES':'NO'#"},
                {field: "isRunning", title: "Running", width: 50, sortable: false, filterable: false,attributes: {style: setAlignCenter()},
                    headerAttributes: {style: setAlignCenter()}, template:"#=isRunning?'YES':'NO'#"}
            ],
            filterable: {
                mode: "row"
            },
            toolbar: kendo.template($("#gridToolbar").html())
        });
        gridQuartz = $("#gridQuartz").data("kendoGrid");
        $("#menuGrid").kendoMenu();
    }

    function initObservable() {
        quartzModel = kendo.observable(
                {
                    quartz: {
                        id               : "",
                        version          : "",
                        triggerName      : "",
                        jobName          : "",
                        description      : "",
                        cronExpression   : "",
                        isActive         : false,
                        isRunning        : false
                    }
                }
        );
        kendo.bind($("#application_top_panel"), quartzModel);
    }
    function showTrigger() {
        $("#quartzRow").show();
    }
    function editTrigger() {
        if (executeCommonPreConditionForSelectKendo(gridQuartz, 'trigger') == false) {
            return;
        }
        var quartz = getSelectedObjectFromGridKendo(gridQuartz);
        if(quartz.isRunning){
            showError('Trigger is running.Could not possible any change.');
            return;
        }
        $("#quartzRow").show();
        resetQuartz(quartz);
    }

    function resetQuartz(quartz) {
        quartzModel.set('quartz', quartz);
        $('#create').html("<span class='k-icon k-i-plus'></span>Update");
    }

    function deleteTrigger(){
        if (executeCommonPreConditionForSelectKendo(gridQuartz, 'trigger') == false) {
            return;
        }
        var quartz = getSelectedObjectFromGridKendo(gridQuartz);
        if(quartz.isActive){
            showError('Active trigger could not be deleted.');
            return;
        }
        var msg = 'Are you sure you want to delete the selected trigger?',
                url = "${createLink(controller: 'quartz', action:  'delete')}";
        confirmDelete(msg, url, gridQuartz);
    }
    function startTrigger(){
        if (executeCommonPreConditionForSelectKendo(gridQuartz, 'trigger') == false) {
            return;
        }
        var id = getSelectedIdFromGridKendo(gridQuartz);
        jQuery.ajax({
            type: 'post',
            data: {id:id},
            url: "${createLink(controller: 'quartz', action:  'startScheduler')}",
            success: function (data, textStatus) {
                showInfo(data.message);
                gridQuartz.dataSource.read();
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
    function stopTrigger(){
        if (executeCommonPreConditionForSelectKendo(gridQuartz, 'trigger') == false) {
            return;
        }
        var id = getSelectedIdFromGridKendo(gridQuartz);
        jQuery.ajax({
            type: 'post',
            data: {id:id},
            url: "${createLink(controller: 'quartz', action:  'stopScheduler')}",
            success: function (data, textStatus) {
                showInfo(data.message);
                gridQuartz.dataSource.read();
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
</script>
