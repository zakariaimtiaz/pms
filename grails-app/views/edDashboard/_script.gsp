<script type="text/x-kendo-template" id="gridToolbar">
<ul id="menuGrid" class="kendoGridMenu">
    <li onclick="showEdDashboardEntryModal();"><i class="fa fa-plus-square"></i>Add</li>
    <li onclick="editDashboard();"><i class="fa fa-edit"></i>Edit</li>
    <li onclick="deleteDashboard();"><i class="fa fa-trash-o"></i>Delete</li>
</ul>
</script>

<script language="javascript">
    var serviceId, subDate, gridIssues, dataSource;

    $(document).ready(function () {
        onLoadEdDashboardPage();
        if ('${subDate}' != '') {
            loadData();
        }
    });
    function activaTab(tab) {
        $('.nav-tabs a[href="#' + tab + '"]').tab('show');
    }
    function loadData() {
        initIssueGrid();
        loadUnresolveData();
        initResolvedIssueGrid();
        initUpcomingIssueGrid();
    }
    function onLoadEdDashboardPage() {
        activaTab('menu1');
        serviceId = ${serviceId};
        subDate = '${subDate}';
        $('#hfSubmissionDate').val(subDate);
        var m = $('#month').kendoDatePicker({
            format: "MMMM yyyy",
            parseFormats: ["yyyy-MM-dd"],
            start: "year",
            depth: "year",
            change: loadData
        }).data("kendoDatePicker");
        m.min(moment(subDate).format('YYYY-MM-DD'));
        $('#month').val(moment(subDate).format('MMMM YYYY'));
        initializeForm($("#edDashboardForm"), onSubmitEdDashboard);
        dropDownService.value(serviceId);
        defaultPageTile("Create Ed Dashboard", "edDashboard/show");
    }
    function initDataSource() {
        serviceId = $('#serviceId').val();
        var month = $('#month').val();
        dataSource = new kendo.data.DataSource({
            transport: {
                read: {
                    url: "${createLink(controller: 'edDashboard', action: 'list')}",
                    data: {serviceId: serviceId, month: month},
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
                        issueName: {type: "string"},
                        description: {type: "string"},
                        remarks: {type: "string"},
                        edAdvice: {type: "string"}
                    }
                },
                parse: function (data) {
                    checkIsErrorGridKendo(data);
                    return data;
                }
            },
            sort: {field: 'id', dir: 'asc'},
            pageSize: false,
            serverPaging: true,
            serverFiltering: true,
            serverSorting: true
        });
    }

    function initIssueGrid() {
        initDataSource();
        $("#gridIssues").kendoGrid({
            dataSource: dataSource,
            // height: getGridHeightKendo(),
            selectable: true,
            sortable: true,
            resizable: true,
            reorderable: true,
            pageable: false,
            columns: [
                {field: "issueName", title: "Issue", width: "10%", sortable: false, filterable: false},
                {field: "description", title: "Description", width: "35%", sortable: false, filterable: false},
                {
                    field: "remarks",
                    title: "Remarks and Recommendations",
                    width: "30%",
                    sortable: false,
                    filterable: false
                },
                {field: "edAdvice", title: "ED's Advice", width: "25%", sortable: false, filterable: false}
            ],
            filterable: {
                mode: "row"
            },
            toolbar: kendo.template($("#gridToolbar").html())
        });
        gridIssues = $("#gridIssues").data("kendoGrid");
        $("#menuGrid").kendoMenu();
    }

    function loadUnresolveData() {
        var actionUrl = "${createLink(controller:'edDashboard', action: 'unresolveList')}";
        serviceId = $('#serviceId').val();
        var month = $('#month').val();
        jQuery.ajax({
            type: 'post',
            data: {serviceId: serviceId, month: month},
            url: actionUrl,
            success: function (data, textStatus) {
                $('#tableData').html('');
                $('#tableData').html(data.tableHtml);
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                console.info('error');
            },
            complete: function (XMLHttpRequest, textStatus) {
                console.info('complete');
            }

        });
    }
    function deleteDashboard() {
        if (executeCommonPreConditionForSelectKendo(gridIssues, 'issue') == false) {
            return;
        }
        var msg = 'Are you sure you want to delete the selected record?',
                url = "${createLink(controller: 'edDashboard', action:  'delete')}";
        confirmDelete(msg, url, gridIssues);
    }
    function editDashboard() {
        if (executeCommonPreConditionForSelectKendo(gridIssues, 'issue') == false) {
            return;
        }
        $("#createEdDashboardModal").modal('show');
        $('#headingLabelNew').text("ED's Dashboard Issue Edit");
        $('#issueName').show();
        $('#divIssueIdDDL').hide();
        var issues = getSelectedObjectFromGridKendo(gridIssues);
        $('#hfId').val(issues.id);
        $('#issueName').text(issues.issueName);
        $('#descriptionNew').val(issues.description);
        $('#remarksNew').val(issues.remarks);
    }
function resetForm(){
    //This function used for after successful delete
}
    function showEdDashboardEntryModal() {
        $("#createEdDashboardModal").modal('show');
        $('#hfServiceIdNewModal').val($('#serviceId').val());
        $('#hfMonthNewModal').val($('#month').val());
        $('#descriptionNew').val('');
        $('#remarksNew').val('');
        $('#headingLabelNew').text("ED's Dashboard Issue Entry");
        loadIssueDDL();
        dropDownEdDashboardIssues.value('');
    }
    function loadIssueDDL() {
        $('#issueIdDDL').kendoDropDownList({
            dataTextField: "name",
            dataValueField: "id",
            dataSource: getKendoEmptyDataSource

        });
        dropDownEdDashboardIssues = $('#issueIdDDL').data("kendoDropDownList");
        dropDownEdDashboardIssues.setDataSource(getKendoEmptyDataSource(dropDownEdDashboardIssues, null));
        var actionUrl = "${createLink(controller:'edDashboard', action: 'retrieveIssueAndMonthData')}";
        serviceId = $('#serviceId').val();
        var month = $('#month').val();
        var type = 'New';
        jQuery.ajax({
            type: 'post',
            data: {serviceId: serviceId, month: month, type: type},
            url: actionUrl,
            success: function (data, textStatus) {
                if (data.isError) {
                    showError(data.message);
                    return false;
                }
                dropDownEdDashboardIssues.setDataSource(data.lst);
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                console.info('error in DDL');
            },
            complete: function (XMLHttpRequest, textStatus) {
                console.info('complete');
            }

        });
    }
    function onSubmitEdDashboard() {
        if (executePreCondition() == false) {
            return false;
        }
        showLoadingSpinner(true);

        var actionUrl = null;
        if ($('#hfId').val().isEmpty()) {
            actionUrl = "${createLink(controller:'edDashboard', action: 'create')}";
        } else {
            actionUrl = "${createLink(controller:'edDashboard', action: 'update')}";
        }
        jQuery.ajax({
            type: 'post',
            data: jQuery("#createEdDashboardForm").serialize(),
            url: actionUrl,
            success: function (data, textStatus) {
                if (data.isError) {
                    showError(data.message);
                    return false;
                }
                hideEdDashboardModal();
                executePostCondition(data);
                initIssueGrid();
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
    function hideEdDashboardModal() {
        $('#hfServiceIdNewModal').val('');
        $('#hfMonthNewModal').val('');
        $('#hfId').val('');
        $('#descriptionNew').val('');
        $('#remarksNew').val('');
        $('#issueName').hide();
        $('#divIssueIdDDL').show();
        $('#issueId').val('');
        $("#createEdDashboardModal").modal('hide');
    }

    function loadFollowupMonth() {
        $("#remarks").val('');
        $('#resolveNote').val('');
        if (document.querySelector('input[name=selection]:checked').value == 'Resolve') {
            $('#followupMonth').val('');
            $('#divfollowupMonth').hide();
            $('#divRemarks').hide();
            $('#divResolveNote').show();

        }
        else {
            $('#divResolveNote').hide();
            $('#divRemarks').show();
            $('#divfollowupMonth').show();
            var fMonth = $('#followupMonth').kendoDatePicker({
                format: "MMMM yyyy",
                parseFormats: ["yyyy-MM-dd"],
                start: "year",
                depth: "year"
            }).data("kendoDatePicker");
            if ($('#month').val() != '') {
                var sDate = moment($('#month').val(), 'MMMM YYYY').format('YYYY-MM-DD');
                fMonth.min(sDate);
            } else {
                var sDate = new Date();
                fMonth.min(moment(sDate).format('YYYY-MM-DD'));
            }
        }
    }
    function loadRemarksAndEdAdvice(descId) {
        if (descId > 0) {
            descriptionId = descId;
        }
        $("#oldRemarks").html('');
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

                if (data.lst != null && data.lst.length > 0) {
                    $("#oldRemarks").html(data.lst[0].remarks);
                    $("#resolveNote").val(data.lst[0].resolve_note);
                }
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                console.log(errorThrown);
                //console.info('error in 2');
            },
            complete: function (XMLHttpRequest, textStatus) {
                console.info('complete');
            }

        });

    }
    function showRemarksModal(rowIdx) {
        $("#createEdFollowupModal").modal('show');
        $('#hfClickingRowNo').val(rowIdx);
        $('#headingLabel').text($('#issue' + rowIdx).text());
        $('#descriptionDiv').html($('#description' + rowIdx).val());
        $('#description').val($('#description' + rowIdx).val());
        $('#oldRemarks').html($('#remarks' + rowIdx).val());
        $('#hfServiceIdModal').val($('#serviceId').val());
        $('#hfMonthModal').val($('#month').val());
        $('#issuedMonth').text($('#issuedMonth' + rowIdx).text());

        if ($('#hfIsResolve' + rowIdx).val() == 'true') {
            $('#selectionResolve').prop('checked', true);
            $('#divResolveNote').show();
        }
        if ($('#hfIsFollowup' + rowIdx).val() == '1') {
            $('#selectionFollowup').prop('checked', true);
            loadFollowupMonth();
            $('#followupMonth').val(moment($('#hfFollowupMonthFor' + rowIdx).val()).format('MMMM YYYY'));
            $('#divRemarks').show();
            $('#divResolveNote').hide();
            $('#remarks').val($('#remarks' + rowIdx).val());
        }
        loadRemarksAndEdAdvice($('#hfClickingRowNo').val());
    }
    function hideFollowupDashboardModal() {
        $('#hfClickingRowNo').val('');
        document.getElementById("selectionResolve").disabled = false;
        document.getElementById("selectionFollowup").disabled = false;
        $('#selectionResolve').attr('checked', false);
        $('#selectionFollowup').attr('checked', false);
        $("#resolveNote").prop('readonly', false);
        $('#resolveNote').val('');
        $('#divResolveNote').hide();
        $('#followupMonth').val('');
        $('#divfollowupMonth').hide();
        $('#divRemarks').hide();
        $('#remarks').val('');
        $("#oldRemarks").html('');
        $('#descriptionDiv').html('');
        $('#description').val('');
        $('#hfServiceIdModal').val('');
        $('#hfMonthModal').val('');
        $('#btnCreate').show();
        $("#createEdFollowupModal").modal('hide');
    }

    function executePreCondition() {
        if (!validateForm($("#edDashboardForm"))) {
            return false;
        }
        return true;
    }
    function onSubmitFollowupDashboard() {
        if (executePreCondition() == false) {
            return false;
        }

        showLoadingSpinner(true);

        jQuery.ajax({
            type: 'post',
            data: jQuery("#createEdFollowupForm").serialize(),
            url: "${createLink(controller:'edDashboard', action: 'update')}",
            success: function (data, textStatus) {
                if (data.isError) {
                    showError(data.message);
                    return false;
                }
                executePostCondition(data);
                hideFollowupDashboardModal();
                loadUnresolveData();
                var resolveIssue = "${createLink(controller: 'edDashboard', action: 'resolvedList')}";
                var upComingissue = "${createLink(controller: 'edDashboard', action: 'upcomingFollowupList')}";
                populateGridKendo($("#gridResolvedIssues").data("kendoGrid"), resolveIssue);
                populateGridKendo($("#gridUpcomingIssues").data("kendoGrid"), upComingissue);
                //initResolvedIssueGrid();
               // initUpcomingIssueGrid();
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                showError(textStatus.message());
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
            showSuccess(result.message);
        }
        showLoadingSpinner(false);

    }

    function initDataSourceResolved() {
        serviceId = $('#serviceId').val();
        dataSource = new kendo.data.DataSource({
            transport: {
                read: {
                    url: "${createLink(controller: 'edDashboard', action: 'resolvedList')}",
                    data: {serviceId: serviceId},
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
                        issueName: {type: "string"},
                        month: {type: "string"},
                        resolvedMonth: {type: "string"},
                        description: {type: "string"},
                        remarks: {type: "string"},
                        edAdvice: {type: "string"},
                        isEditable: {type: "boolean"}
                    }
                },
                parse: function (data) {
                    checkIsErrorGridKendo(data);
                    return data;
                }
            },
            sort: {field: 'id', dir: 'asc'},
            pageSize: false,
            serverPaging: true,
            serverFiltering: true,
            serverSorting: true
        });
    }
    function initResolvedIssueGrid() {
        initDataSourceResolved();
        $("#gridResolvedIssues").kendoGrid({
            dataSource: dataSource,
            // height: getGridHeightKendo(),
            selectable: false,
            sortable: true,
            resizable: true,
            columns: [
                {field: "issueName", title: "Issue", width: "10%", sortable: false, filterable: false},
                {
                    field: "month", title: "Month", width: "20%", sortable: false, filterable: false,
                    template: "Initiated :<b>#= month #</b> <br/> Resolved :<b>#= resolvedMonth #</b>"
                },
                {field: "description", title: "Description", width: "30%", sortable: false, filterable: false},
                {
                    field: "remarks",title: "Remarks and Recommendations", width: "35%",sortable: false,filterable: false
                },
                {field: "edAdvice", title: "ED's Advice", width: "25%", sortable: false, filterable: false}

                , {command: {text: " Details", click: showDetails}, width: "10%"}

            ],
            reorderable: true,
            pageable: false,
            filterable: {
                mode: "row"
            }
        });
    }

    function showDetails(e) {
        e.preventDefault();
        var dataItem = this.dataItem($(e.currentTarget).closest("tr"));
        $("#createEdFollowupModal").modal('show');
        $('#selectionResolve').prop('checked', true);
        $('#divResolveNote').show();
        $('#headingLabel').text(dataItem.issueName);
        $('#issuedMonth').text(dataItem.month);
        $('#descriptionDiv').text(dataItem.description);
        $('#hfClickingRowNo').val(dataItem.id);
        $('#description').val(dataItem.description);
        $('#hfServiceIdModal').val($('#serviceId').val());
        $('#hfMonthModal').val($('#month').val());

        if (moment($('#hfSubmissionDate').val()).format('YYYY-MM-DD') > moment(dataItem.resolvedMonth, 'MMMM YYYY').format('YYYY-MM-DD')) {
            document.getElementById("selectionResolve").disabled = true;
            document.getElementById("selectionFollowup").disabled = true;
            $('#btnCreate').hide();
            $("#resolveNote").prop('readonly', true)
        }

        loadRemarksAndEdAdvice(dataItem.id);

    }
    function initDataSourceUpcoming() {
        serviceId = $('#serviceId').val();
        var month = $('#month').val();
        dataSource = new kendo.data.DataSource({
            transport: {
                read: {
                    url: "${createLink(controller: 'edDashboard', action: 'upcomingFollowupList')}",
                    data: {serviceId: serviceId, month: month},
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
                        issueName: {type: "string"},
                        month: {type: "string"},
                        followupFor: {type: "string"},
                        description: {type: "string"},
                        remarks: {type: "string"},
                        edAdvice: {type: "string"}
                    }
                },
                parse: function (data) {
                    checkIsErrorGridKendo(data);
                    return data;
                }
            },
            sort: {field: 'id', dir: 'asc'},
            pageSize: false,
            serverPaging: true,
            serverFiltering: true,
            serverSorting: true
        });
    }
    function initUpcomingIssueGrid() {
        initDataSourceUpcoming();
        $("#gridUpcomingIssues").kendoGrid({
            dataSource: dataSource,
            // height: getGridHeightKendo(),
            selectable: false,
            sortable: true,
            resizable: true,
            reorderable: true,
            pageable: false,
            columns: [
                {field: "issueName", title: "Issue", width: "10%", sortable: false, filterable: false},
                {field: "followupFor", title: "Issued On", width: "10%", sortable: false, filterable: false},
                {field: "month", title: "Follow-up On", width: "10%", sortable: false, filterable: false},
                {field: "description", title: "Description", width: "25%", sortable: false, filterable: false},
                {
                    field: "remarks",
                    title: "Remarks and Recommendations",
                    width: "25%",
                    sortable: false,
                    filterable: false
                },
                {field: "edAdvice", title: "ED's Advice", width: "20%", sortable: false, filterable: false}
                , {command: {text: " Edit", click: showDetailsForUpcomingIssues}, width: "10%"}
            ],
            filterable: {
                mode: "row"
            }
        });
    }
    function showDetailsForUpcomingIssues(e) {
        e.preventDefault();
        var dataItem2 = this.dataItem($(e.currentTarget).closest("tr"));
        $("#createEdFollowupModal").modal('show');
        $('#selectionFollowup').prop('checked', true);
        $('#headingLabel').text(dataItem2.issueName);
        $('#issuedMonth').text(dataItem2.month);
        $('#descriptionDiv').html(dataItem2.description);
        $('#hfClickingRowNo').val(dataItem2.id);
        $('#description').val(dataItem2.description);
        $('#hfServiceIdModal').val($('#serviceId').val());
        $('#hfMonthModal').val($('#month').val());
        loadFollowupMonth();
        $('#followupMonth').val(dataItem2.month);
        $('#divResolveNote').hide();
        $('#divRemarks').show();
        $('#remarks').val(dataItem2.remarks);
        loadRemarksAndEdAdvice(dataItem2.id);

    }

</script>
