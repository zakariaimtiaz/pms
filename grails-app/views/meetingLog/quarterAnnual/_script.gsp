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
    var gridMeetingLogAQ,dataSource,logModel,heldOn,isSubmit;

    $(document).ready(function () {
        onLoadLogPage();
        initMeetingLogGrid();
        initObservable();
    });

    function onLoadLogPage() {
        $("#rowMeetingLog").hide();
        var start = $('#heldOn').kendoDatePicker({
            format: "dd/MM/yyyy",
            parseFormats: ["yyyy-MM-dd"],
            start: "month",
            depth: "month",
            change: startChange
        }).data("kendoDatePicker");

        var end = $('#endDate').kendoDatePicker({
            format: "dd/MM/yyyy",
            parseFormats: ["yyyy-MM-dd"],
            start: "month",
            depth: "month"
        }).data("kendoDatePicker");
        function startChange() {
            var value = start.value();
            if (value == '' || value == null) {
                $('#endDate').val('');
            }
            if (value) {
               var st = new Date(moment(value).endOf('year'));
                end.min(value);
                end.max(st);
            }
        }
        $("#descStr").kendoEditor({
            encoded: false,
            resizable: {
                content: false,
                toolbar: true
            },
            tools: [
                "bold",
                "italic",
                "underline",
                "backColor",
                "foreColor",
                "justifyLeft",
                "justifyCenter",
                "justifyRight",
                "justifyFull",
                "insertUnorderedList",
                "insertOrderedList"
            ]
        });

        initializeForm($("#meetingLogFormAQ"), onSubmitLog);
        defaultPageTile("Create Log",null);
    }

    function executePreCondition() {
        var serviceId = $("#serviceId").val(),
        heldOn = $("#heldOn").val(),
        attendees = $("#attendees").val(),
        issues = $("#issues").val(),

        descStr = $("#descStr").val();
        if (serviceId=='') {
            showError('Please select service');
            return false;
        }else if(heldOn == ''){
            showError('Please select meeting date');
            return false;
        }else if (descStr == ''){
            showError('Please insert meeting description');
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

        var aFormData = new FormData();
        //var oData = new FormData(document.forms.namedItem("fileinfo"));

        aFormData.append("fileName", $('#fileName').get(0).files[0]);

        $("form input").each(function(i) {
            aFormData.append($(this).attr("name"), $(this).val());
        });
        $("form textarea").each(function(i) {
            aFormData.append($(this).attr("name"), $(this).val());
        });

        $("form select").each(function(i) {
            aFormData.append($(this).attr("name"), $(this).val());
        });

        if ($('#id').val().isEmpty()) {
            actionUrl = "${createLink(controller:'meetingLog', action: 'create')}";
        } else {
            actionUrl = "${createLink(controller:'meetingLog', action: 'update')}";
        }
        //console.log(jQuery("#meetingLogFormAQ").serialize());
        jQuery.ajax({
            type: 'post',
            contentType : false,
            processData : false,
            data:  aFormData,
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
                    var gridData = gridMeetingLogAQ.dataSource.data();
                    gridData.unshift(newEntry);
                } else if (newEntry != null) { // updated existing
                    var selectedRow = gridMeetingLogAQ.select();
                    var allItems = gridMeetingLogAQ.items();
                    var selectedIndex = allItems.index(selectedRow);
                    gridMeetingLogAQ.removeRow(selectedRow);
                    gridMeetingLogAQ.dataSource.insert(selectedIndex, newEntry);
                }
                emptyForm();
                showSuccess(result.message);
            } catch (e) {
                // Do Nothing
            }
        }
    }

    function emptyForm() {
        clearForm($("#meetingLogFormAQ"), $('#serviceId'));
        $('#fileName').val('');
        initObservable();
    }
    function resetForm() {
        initObservable();
        $('#rowMeetingLog').hide();
        $('#create').html("<span class='k-icon k-i-plus'></span>Save");
    }

    function initDataSource() {
        dataSource = new kendo.data.DataSource({
            transport: {
                read: {
                    url: "${createLink(controller: 'meetingLog', action: 'list')}?meetingTypeId=" + ${meetingTypeId},
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
                        serviceId: { type: "number" },
                        meetingTypeId: { type: "number" },
                        meetingType: { type: "string" },
                        heldOn: { type: "date" },
                        endDate: { type: "date" },
                        descStr: { type: "string" },
                        fileName: { type: "string" }
                    }
                },
                parse: function (data) {
                    checkIsErrorGridKendo(data);
                    return data;
                }
            },
            sort: {field: 'heldOn', dir: 'desc'},
            pageSize: getDefaultPageSize(),
            serverPaging: true,
            serverFiltering: true,
            serverSorting: true
        });
    }

    function initMeetingLogGrid() {
        initDataSource();
        $("#gridMeetingLogAQ").kendoGrid({
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
                {field: "heldOn", title: "Start Date", width: 90, sortable: false, filterable: false,
                    template: "#=kendo.toString(kendo.parseDate(heldOn, 'yyyy-MM-dd'), 'dd-MM-yyyy')#",
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()}
                },
                {field: "endDate", title: "End Date", width: 90, sortable: false, filterable: false,
                    template: "#=kendo.toString(kendo.parseDate(endDate, 'yyyy-MM-dd'), 'dd-MM-yyyy')#",
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()}
                },
                {field: "descStr", title: "Description",sortable: false, filterable: false,
                    template: "#=trimTextForKendo(htmlDecode(descStr),500)#"
                },
                {field: "fileName", title: "Download Attachment",sortable: false, filterable: false, width: 150

                }
            ],
            filterable: {
                mode: "row"
            },
            toolbar: kendo.template($("#gridToolbar").html())
        });
        gridMeetingLogAQ = $("#gridMeetingLogAQ").data("kendoGrid");
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
                        serviceId: ${serviceId},
                        meetingTypeId: ${meetingTypeId},
                        meetingCatId: "",
                        heldOn: "",
                        endDate: "",
                        descStr: "",
                        fileName:""
                    }
                }
        );
        kendo.bind($("#application_top_panel"), logModel);
    }

    function deleteMeetingLog() {
        if (executeCommonPreConditionForSelectKendo(gridMeetingLogAQ, 'log') == false) {
            return;
        }
        var msg = 'Are you sure you want to delete the selected record?',
                url = "${createLink(controller: 'meetingLog', action:  'delete')}";
        confirmDelete(msg, url, gridMeetingLogAQ);
    }
    function addNewLog(){
        $("#rowMeetingLog").show();
    }
    function editMeetingLog() {
        if (executeCommonPreConditionForSelectKendo(gridMeetingLogAQ, 'log') == false) {
            return;
        }
        $("#rowMeetingLog").show();
        var meetingLog = getSelectedObjectFromGridKendo(gridMeetingLogAQ);
        resetFormValue(meetingLog);
    }

    function resetFormValue(meetingLog) {
        $('html,body').scrollTop(0);
        logModel.set('meetingLog', meetingLog);
        var descStr = $("#descStr").data("kendoEditor");
        descStr.value(htmlDecode(meetingLog.descStr));
        $('#create').html("<span class='k-icon k-i-plus'></span>Update");
    }

    $("#gridMeetingLogAQ").kendoTooltip({
        show: function(e){
            if(this.content.text().length > 200){
                this.content.parent().css("visibility", "visible");
            }
        },
        hide:function(e){
            this.content.parent().css("visibility", "hidden");
        },
        filter: "td:nth-child(3)",
        width: 450,
        position: "top",
        content: function (e) {
            var dataItem = $("#gridMeetingLogAQ").data("kendoGrid").dataItem(e.target.closest("tr"));
            return dataItem.descStr;
        }
    }).data("kendoTooltip");


</script>
