<script type="text/x-kendo-template" id="gridToolbar">
<ul id="menuGrid" class="kendoGridMenu">
    <sec:access url="/meetingLog/create">
        <li onclick="addNewLog();"><i class="fa fa-plus-square"></i>Add</li>
    </sec:access>
    <sec:access url="/meetingLog/update">
        <li onclick="editMeetingLog();"><i class="fa fa-edit"></i>Edit</li>
    </sec:access>
    <sec:access url="/meetingLog/delete">
        <li onclick="deleteMeetingLog();"><i class="fa fa-trash-o"></i>Delete</li>
    </sec:access>
</ul>
</script>

<script language="javascript">
    var gridMeetingLog,dataSource,logModel,heldOn,dropDownService,multiSelectAttendees,serviceId, isSubmit;

    $(document).ready(function () {
        onLoadLogPage();
        initMeetingLogGrid();
        initObservable();
    });

    function onLoadLogPage() {
        $("#rowMeetingLog").hide();
        serviceId = ${serviceId};
        if(!${isAdmin}){
            $("#serviceId").val(serviceId);
            dropDownService.readonly(true);
        }
        $("#issues").kendoEditor({
            encoded: false,
            resizable: {
                content: false,
                toolbar: true
            },
            tools: [
                "bold",
                "italic",
                "underline",
                "strikethrough",
                "justifyLeft",
                "justifyCenter",
                "justifyRight",
                "justifyFull",
                "insertUnorderedList",
                "insertOrderedList"
            ]
        });
        $("#logStr").kendoEditor({
            encoded: false,
            resizable: {
                content: false,
                toolbar: true
            }
        });
        $("#attendees").kendoMultiSelect({
            dataTextField: "name",
            dataValueField: "id",
            filter: "contains",
            dataSource: getBlankDataSource,
            value: [  ]
        });
        multiSelectAttendees = $("#attendees").data("kendoMultiSelect");
        multiSelectAttendees.setDataSource(${lstEmployee});
        initializeForm($("#meetingLogForm"), onSubmitLog);
        defaultPageTile("Create Log",null);
    }

    function executePreCondition() {
        var serviceId = $("#serviceId").val(),
        heldOn = $("#heldOn").val(),
        attendees = $("#attendees").val(),
        issues = $("#issues").val(),
        logStr = $("#logStr").val();
        if (serviceId=='') {
            showError('Please select service');
            return false;
        }else if(heldOn == ''){
            showError('Please select meeting date');
            return false;
        }else if(attendees == null || attendees == ''){
            showError('Please select attendees');
            return false;
        }else if(issues == null || issues == ''){
            showError('Please insert meeting issues');
            return false;
        }else if (logStr == ''){
            showError('Please insert meeting action log');
            return false;
        }
        return true;
    }

    function onSubmitLog() {
        if (executePreCondition() == false) {
            return false;
        }

        setButtonDisabled($('#create'), true);
        showLoadingSpinner(true);
        var actionUrl = null;
        if ($('#id').val().isEmpty()) {
            actionUrl = "${createLink(controller:'meetingLog', action: 'create')}";
        } else {
            actionUrl = "${createLink(controller:'meetingLog', action: 'update')}";
        }

        jQuery.ajax({
            type: 'post',
            data: jQuery("#meetingLogForm").serialize(),
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
                var newEntry = result.meetingLog;
                if ($('#id').val().isEmpty() && newEntry != null) { // newly created
                    var gridData = gridMeetingLog.dataSource.data();
                    gridData.unshift(newEntry);
                } else if (newEntry != null) { // updated existing
                    var selectedRow = gridMeetingLog.select();
                    var allItems = gridMeetingLog.items();
                    var selectedIndex = allItems.index(selectedRow);
                    gridMeetingLog.removeRow(selectedRow);
                    gridMeetingLog.dataSource.insert(selectedIndex, newEntry);
                }
                emptyForm();
                showSuccess(result.message);
            } catch (e) {
                // Do Nothing
            }
        }
    }

    function emptyForm() {
        clearForm($("#meetingLogForm"), $('#serviceId'));
        initObservable();
        dropDownService.value(serviceId);
    }
    function resetForm() {
        initObservable();
        dropDownService.value(serviceId);
        $('#rowMeetingLog').hide();
        $('#create').html("<span class='k-icon k-i-plus'></span>Save");
    }

    function initDataSource() {
        dataSource = new kendo.data.DataSource({
            transport: {
                read: {
                    url: "${createLink(controller: 'meetingLog', action: 'list')}",
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
                        attendees: { type: "string" },
                        attendeesStr: { type: "string" },
                        serviceId: { type: "number" },
                        meetingTypeId: { type: "number" },
                        meetingType: { type: "string" },
                        service: { type: "string" },
                        heldOn: { type: "date" },
                        issues: { type: "string" },
                        logStr: { type: "string" }
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

    function initMeetingLogGrid() {
        initDataSource();
        $("#gridMeetingLog").kendoGrid({
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
            <g:if test="${isAdmin}">
                {field: "service", title: "Sector/CSU", width: 120, sortable: false, filterable: kendoCommonFilterable(97)},
            </g:if>
            <g:else>
                {field: "service", title: "Sector/CSU", width: 120, sortable: false, filterable: false},
            </g:else>
                {field: "meetingType", title: "Type", width: 50, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()}
                },
                {field: "heldOn", title: "Date", width: 70, sortable: false, filterable: false,
                    template: "#=kendo.toString(kendo.parseDate(heldOn, 'yyyy-MM-dd'), 'dd-MM-yyyy')#",
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()}
                },
                {field: "attendeesStr", title: "Attendees", width: 150, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()}
                },
                {field: "issues", title: "Agenda",width: 100, sortable: false, filterable: false,
                    template: "#=htmlDecode(issues)#"
                },
                {field: "logStr", title: "Action Log",width: 250, sortable: false, filterable: false,
                    template: "#=htmlDecode(logStr)#"
                }
            ],
            filterable: {
                mode: "row"
            },
            toolbar: kendo.template($("#gridToolbar").html())
        });
        gridMeetingLog = $("#gridMeetingLog").data("kendoGrid");
        $("#menuGrid").kendoMenu();
    }
    function htmlDecode(value) {
        return value.replaceHtmlEntites();
    }
    function initObservable() {
        logModel = kendo.observable(
                {
                    meetingLog: {
                        id: "",
                        version: "",
                        attendees: "",
                        meetingTypeId: ${meetingTypeId},
                        heldOn: "",
                        issues: "",
                        logStr: "",
                        serviceId: ""
                    }
                }
        );
        kendo.bind($("#application_top_panel"), logModel);
    }

    function deleteMeetingLog() {
        if (executeCommonPreConditionForSelectKendo(gridMeetingLog, 'log') == false) {
            return;
        }
        var msg = 'Are you sure you want to delete the selected record?',
                url = "${createLink(controller: 'meetingLog', action:  'delete')}";
        confirmDelete(msg, url, gridMeetingLog);
    }
    function addNewLog(){
        $("#rowMeetingLog").show();
        dropDownService.value(serviceId);
    }
    function editMeetingLog() {
        if (executeCommonPreConditionForSelectKendo(gridMeetingLog, 'log') == false) {
            return;
        }
        $("#rowMeetingLog").show();
        var meetingLog = getSelectedObjectFromGridKendo(gridMeetingLog);
        resetFormValue(meetingLog);
    }

    function resetFormValue(meetingLog) {
        $('html,body').scrollTop(0);
        logModel.set('meetingLog', meetingLog);
        var issues = $("#issues").data("kendoEditor");
        issues.value(htmlDecode(meetingLog.issues));
        var logStr = $("#logStr").data("kendoEditor");
        logStr.value(htmlDecode(meetingLog.logStr));
        if (meetingLog.attendees) multiSelectAttendees.value(meetingLog.attendees.split(","));
        $('#create').html("<span class='k-icon k-i-plus'></span>Update");
    }

</script>
