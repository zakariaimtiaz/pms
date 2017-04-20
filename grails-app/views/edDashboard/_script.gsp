<script type="text/x-kendo-template" id="gridToolbar">
<ul id="menuGrid" class="kendoGridMenu">
    <sec:access url="/edDashboard/create">
        <li onclick="addIssues();"><i class="fa fa-plus-square"></i>Add</li>
    </sec:access>
    <sec:access url="/edDashboard/update">
        <li onclick="editIssues();"><i class="fa fa-edit"></i>Edit</li>
    </sec:access>
</ul>
</script>
<script language="javascript">
    var serviceId, currentMonth, dataSource, descFollowupMonthDDL,submissionDate;

    $(document).ready(function () {
        onLoadEdDashboardPage();
        initEdDashboardGrid();
        initObservable();
    });

    function onLoadEdDashboardPage() {
        $("#rowEdDashboard").hide();
        serviceId = ${serviceId};
        currentMonth = moment().format('MMMM YYYY');
        var start = $('#month').kendoDatePicker({
            format: "MMMM yyyy",
            parseFormats: ["yyyy-MM-dd"],
            start: "year",
            depth: "year"
        }).data("kendoDatePicker");

        submissionDate='${submissionDate}';
        var nextMonth = moment(submissionDate).add(1, 'months');
        if(submissionDate!='') {
            var st = new Date(moment(nextMonth));
            start.min(submissionDate);
            start.max(st);
            $('#month').val(moment(submissionDate).format('MMMM YYYY'));
        } else {
            start.min(new Date(moment(new Date()).startOf('year')));
            start.max(new Date(moment(new Date()).endOf('year')));
            $('#month').val(currentMonth);
        }

        initializeForm($("#edDashboardForm"), onSubmitEdDashboard);
        defaultPageTile("Create ED's Dashboard", null);
        dropDownService.value(serviceId);
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
        showLoadingSpinner(true);

        jQuery.ajax({
            type: 'post',
            data: jQuery("#edDashboardForm").serialize(),
            url: "${createLink(controller:'edDashboard', action: 'create')}",
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
        } else {
            initEdDashboardGrid();
            resetForm();
            showSuccess(result.message);
        }
        showLoadingSpinner(false);

    }
    function resetForm() {
        $('#divDescriptionTextArea').show();
        $('#divDescFollowupMonthDDL').hide();
        $('#description').prop('readOnly', false);
        $('#isFollowup').prop('checked', false);
        $('#followupMonth').val('');
        $('#divfollowupMonth').hide();
        clearForm($("#edDashboardForm"), $('#serviceId'));
        initObservable();
        dropDownService.value(serviceId);
        dropDownEdDashboardIssues.value('');
        $("#rowEdDashboard").hide();
        $('#create').html("<span class='k-icon k-i-plus'></span>Save");
    }
    function addIssues() {
        $("#rowEdDashboard").show();
        $('#month').val(currentMonth);
        dropDownService.value(serviceId);
    }
    function editIssues() {
        if (executeCommonPreConditionForSelectKendo(gridEdDashboard, 'edDashboard') == false) {
            return;
        }
        var edDashboard = getSelectedObjectFromGridKendo(gridEdDashboard);
        if (edDashboard.is_submitted) {
            showError('Already Submitted.');
            return;
        }
        $("#rowEdDashboard").show();
        showService(edDashboard);
        if(edDashboard.isFollowup){
          var issueId=edDashboard.issueId;
            $('#divfollowupMonth').show();
            initializeFollowupMonth();
            $('#followupMonth').val(moment(edDashboard.followupMonthFor).format('MMMM YYYY'));

                var actionUrl = "${createLink(controller:'edDashboard', action: 'retrieveIssueAndMonthData')}";
                serviceId = edDashboard.serviceId;
                var month = $('#followupMonth').val();
                jQuery.ajax({
                    type: 'post',
                    data: {serviceId: serviceId, month: month, issueId: issueId},
                    url: actionUrl,
                    success: function (data, textStatus) {
                        if (data.isError) {
                            showError(data.message);
                            return false;
                        }

                        if (data.lst != null) {
                            if (data.isAdditional) {
                                $('#divDescriptionTextArea').hide();
                                $('#divDescFollowupMonthDDL').show();
                                $('#descFollowupMonthDDL').kendoDropDownList({
                                    dataTextField: "name",
                                    dataValueField: "id",
                                    dataSource: getKendoEmptyDataSource

                                });
                                descFollowupMonthDDL = $('#descFollowupMonthDDL').data("kendoDropDownList");
                                descFollowupMonthDDL.setDataSource(getKendoEmptyDataSource(descFollowupMonthDDL, null));
                                descFollowupMonthDDL.setDataSource(data.lst);
                                descFollowupMonthDDL.text(edDashboard.description);
                            }
                            else {
                                $('#divDescriptionTextArea').show();
                                $('#divDescFollowupMonthDDL').hide();
                                $('#description').val(data.lst.description);
                                $("#remarks").attr('title', data.lst.remarks);
                            }


                        } else {
                            $('#description').val('');
                            $('#remarks').val('');
                        }
                        $('#description').prop('readOnly', true);
                    },
                    error: function (XMLHttpRequest, textStatus, errorThrown) {
                        console.info('error');
                    },
                    complete: function (XMLHttpRequest, textStatus) {
                        console.info('complete');
                    }

                });
        }
        else{
            $('#divfollowupMonth').hide();
        }

    }
    function showService(edDashboard) {
        edDashboardModel.set('edDashboard', edDashboard);
        $('#create').html("<span class='k-icon k-i-plus'></span>Update");
    }

    function initObservable() {
        edDashboardModel = kendo.observable(
                {
                    edDashboard: {
                        id: "",
                        version: "",
                        serviceId: "",
                        issueId: "",
                        description: "",
                        remarks: "",
                        edAdvice: "",
                        monthFor: "",
                        followupMonthFor: "",
                        isFollowup: ""
                    }
                }
        );
        kendo.bind($("#application_top_panel"), edDashboardModel);
    }
    function initDataSource() {
        dataSource = new kendo.data.DataSource({
            transport: {
                read: {
                    url: "${createLink(controller: 'edDashboard', action: 'list')}?serviceId=" + dropDownService.value(),
                    dataType: "json",
                    type: "post"
                }
            },
            schema: {
                type: 'json',
                data: "list", total: "count",
                model: {
                    fields: {
                        id: {type: "number"},
                        version: {type: "number"},
                        serviceId: {type: "number"},
                        serShortName: {type: "string"},
                        issueId: {type: "number"},
                        issue_name: {type: "string"},
                        description: {type: "string"},
                        remarks: {type: "string"},
                        ed_advice: {type: "string"},
                        monthFor: {type: "date"},
                        followupMonthFor: {type: "date"},
                        isFollowup: {type: "boolean"},
                        is_additional: {type: "boolean"},
                        is_submitted: {type: "boolean"}
                    }
                },
                parse: function (data) {
                    checkIsErrorGridKendo(data);
                    return data;
                }
            },
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
                <g:if test="${isAdmin}">
                {
                    field: "serShortName",
                    title: "CSU/Sector",
                    width: 80,
                    sortable: false,
                    filterable: kendoCommonFilterable(98)
                },
                </g:if>
                {
                    field: "monthFor", title: "Month", width: 50, sortable: false, filterable: false,
                    template: "#=kendo.toString(kendo.parseDate(monthFor, 'yyyy-MM-dd'), 'MMMM-yy')#"
                },
                {field: "issue_name", title: "Issues", width: 100, sortable: false, filterable: false},
                {field: "description", title: "Crisis & Highlights", width: 150, sortable: false, filterable: false,
                    template: "#=isFollowup?formatIssue(followupMonthFor,description):description#"},
                {
                    field: "remarks", title: "Remarks", width: 150,
                    sortable: false, filterable: false
                },
                {field: "ed_advice", title: "ED's Advice", width: 150, sortable: false, filterable: false}

            ],
            filterable: {
                mode: "row"
            },
            toolbar: kendo.template($("#gridToolbar").html())
        });
        gridEdDashboard = $("#gridEdDashboard").data("kendoGrid");
        $("#menuGrid").kendoMenu();
    }
    $("#gridEdDashboard").kendoTooltip({
        filter: "td:nth-child(9)",
        width: 300,
        position: "top",
        content: function (e) {
            var dataItem = $("#gridEdDashboard").data("kendoGrid").dataItem(e.target.closest("tr"));
            return dataItem.note;
        }
    }).data("kendoTooltip");
    function formatIssue(FOLLOWUP_MONTH, ISSUE) {
        return '<font color="#8b0000">First issued at ' + moment(FOLLOWUP_MONTH).format('MMMM YYYY') + '</font> <br/>' + ISSUE;
    }
    function initializeFollowupMonth(){
        var startFollow = $('#followupMonth').kendoDatePicker({
            format: "MMMM yyyy",
            parseFormats: ["yyyy-MM-dd"],
            start: "year",
            depth: "year",
            change: loadFollowupMonthDesc
        }).data("kendoDatePicker");

        if(submissionDate!='') {
            var prevMonth = moment(submissionDate).add(-1, 'months');
            var st = new Date(moment(prevMonth));
            startFollow.max(st);
            $('#followupMonth').val(moment(st).format('MMMM YYYY'));
        } else{
            startFollow.min(new Date(moment(new Date()).startOf('year')));
            startFollow.max(new Date(moment(new Date())));
            $('#followupMonth').val(new Date(moment(new Date())));
        }
    }
    function loadFollowupMonth(ele) {
        var issueId = dropDownEdDashboardIssues.value();
        if (issueId.isEmpty()) {
            showError('Please select Issue.');
            $('#isFollowup').prop('checked', false);
            return;
        }
        if (!$('#isFollowup').is(':checked')) {
            $('#description').val('');
            $('#remarks').val('');
            $('#followupMonth').val('');
            $('#description').prop('readOnly', false);
            $('#divfollowupMonth').hide();
        }
        else {
            $('#divfollowupMonth').show();
            initializeFollowupMonth();
            if(submissionDate!='') {
                loadFollowupMonthDesc();
            }
        }
    }
    function loadFollowupMonthDesc() {
        var issueId = dropDownEdDashboardIssues.value();
        if (issueId.isEmpty()) {
                $('#description').val('');
                $('#remarks').val('');
                $('#followupMonth').val('');
                $('#description').prop('readOnly', false);
                $('#divfollowupMonth').hide();
                $('#isFollowup').prop('checked', false);
                return;
        }
        if($('#isFollowup').is(':checked')) {

            var actionUrl = "${createLink(controller:'edDashboard', action: 'retrieveIssueAndMonthData')}";
            serviceId = $('#serviceId').val();
            var month = $('#followupMonth').val();
            jQuery.ajax({
                type: 'post',
                data: {serviceId: serviceId, month: month, issueId: issueId},
                url: actionUrl,
                success: function (data, textStatus) {
                    if (data.isError) {
                        showError(data.message);
                        return false;
                    }

                    if (data.lst != null) {
                        if (data.isAdditional) {
                            $('#divDescriptionTextArea').hide();
                            $('#divDescFollowupMonthDDL').show();
                            $('#descFollowupMonthDDL').kendoDropDownList({
                                dataTextField: "name",
                                dataValueField: "id",
                                dataSource: getKendoEmptyDataSource

                            });
                            descFollowupMonthDDL = $('#descFollowupMonthDDL').data("kendoDropDownList");
                            descFollowupMonthDDL.setDataSource(getKendoEmptyDataSource(descFollowupMonthDDL, null));
                            descFollowupMonthDDL.setDataSource(data.lst);
                        }
                        else {
                            $('#divDescriptionTextArea').show();
                            $('#divDescFollowupMonthDDL').hide();
                            $('#description').val(data.lst.description);
                            $("#remarks").attr('title', data.lst.remarks);
                        }


                    } else {
                        $('#description').val('');
                        $('#remarks').val('');
                    }
                    $('#description').prop('readOnly', true);
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    console.info('error');
                },
                complete: function (XMLHttpRequest, textStatus) {
                    console.info('complete');
                }

            });
        }
    }
    function loadRemarksAndEdAdvice(obj) {
        var issueId = dropDownEdDashboardIssues.value();
        var descriptionId = $('#descFollowupMonthDDL').val();
        var actionUrl = "${createLink(controller:'edDashboard', action: 'retrieveIssueAndMonthData')}";

        jQuery.ajax({
            type: 'post',
            data: {dashboardId: descriptionId},
            url: actionUrl,
            success: function (data, textStatus) {
                if (data.isError) {
                    showError(data.message);
                    return false;
                }

                if (data.lst != null) {
                    $('#description').val($('#descFollowupMonthDDL').data("kendoDropDownList").text());
                    $("#remarks").attr('title', data.lst.remarks);
                } else {
                    $('#description').val('');
                    $('#remarks').val('');
                }
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                console.info('error');
            },
            complete: function (XMLHttpRequest, textStatus) {
                console.info('complete');
            }

        });

    }

</script>
