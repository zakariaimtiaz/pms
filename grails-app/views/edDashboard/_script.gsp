<script type="text/x-kendo-template" id="gridToolbar">
<ul id="menuGrid" class="kendoGridMenu">
        <li><label class="control-label" style="font-weight: bold; padding-bottom: 5px;">Issues For This Month</label></li>
        <li onclick="showEdDashboardEntryModal();"><i class="fa fa-plus-square"></i>Add</li>

        <li onclick="editDashboard();"><i class="fa fa-edit"></i>Edit</li>

        <li onclick="deleteDashboard();"><i class="fa fa-trash-o"></i>Delete</li>

</ul>
</script>

<script language="javascript">
    var serviceId,subDate;

    $(document).ready(function () {
        onLoadEdDashboardPage();
        if('${subDate}'!='') {
            loadData();
        }
    });
function loadData(){
    initIssueGrid();
    loadUnresolveData();
}
    function onLoadEdDashboardPage() {
        serviceId = ${serviceId};
        subDate = '${subDate}';
        var m= $('#month').kendoDatePicker({
            format: "MMMM yyyy",
            parseFormats: ["yyyy-MM-dd"],
            start: "year",
            depth: "year",
            change:loadData
        }).data("kendoDatePicker");
        m.min(moment(subDate).format('YYYY-MM-DD'));
        $('#month').val(moment(subDate).format('MMMM YYYY'));
        initializeForm($("#edDashboardForm"), onSubmitEdDashboard);
        defaultPageTile("Create Ed Dashboard",null);
        dropDownService.value(serviceId);
    }
    function initDataSource() {
        serviceId=$('#serviceId').val();
        var month=$('#month').val();
        dataSource = new kendo.data.DataSource({
            transport: {
                read: {
                    url: "${createLink(controller: 'edDashboard', action: 'list')}",
                    data: {serviceId:serviceId,month:month},
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
                        issueName: { type: "string" },
                        description: { type: "string" },
                        remarks: { type: "string" },
                        edAdvice: { type: "string" }
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
                {field: "remarks", title: "Remarks and Recommendations", width: "30%", sortable: false, filterable: false},
                {field: "edAdvice", title: "ED's Advice", width: "25%", sortable: false, filterable: false},
            ],
            filterable: {
                mode: "row"
            },
            toolbar: kendo.template($("#gridToolbar").html())
        });
        gridIssues = $("#gridIssues").data("kendoGrid");
        $("#menuGrid").kendoMenu();
    }
    function loadUnresolveData(){
        var actionUrl = "${createLink(controller:'edDashboard', action: 'unresolveList')}";
        serviceId=$('#serviceId').val();
        var month=$('#month').val();
        jQuery.ajax({
            type: 'post',
            data: {serviceId:serviceId,month:month},
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
    function resetForm(){}

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
    function loadIssueDDL(){
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
        var type='New';
        jQuery.ajax({
            type: 'post',
            data: {serviceId: serviceId, month: month,type:type},
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

    function loadFollowupMonth(){
        if(document.querySelector('input[name=selection]:checked').value=='Resolve') {
            $('#followupMonth').val('');
            $('#remarks').val('');
            $('#divfollowupMonth').hide();
            $('#divRemarks').hide();
            $('#divResolveNote').show();
            $('#resolveNote').val('');
        }
        else {
            $('#divResolveNote').hide();
            $('#divRemarks').show();
            $('#divfollowupMonth').show();
            $("#remarks").val('');
            var fMonth =  $('#followupMonth').kendoDatePicker({
                format: "MMMM yyyy",
                parseFormats: ["yyyy-MM-dd"],
                start: "year",
                depth: "year"
            }).data("kendoDatePicker");
            if($('#month').val()!='') {
                var sDate= moment($('#month').val(),'MMMM YYYY').format('YYYY-MM-DD');
                fMonth.min(sDate);
            }else{
                var sDate= new Date();
                fMonth.min(moment(sDate).format('YYYY-MM-DD'));
            }
        }
    }
    function loadRemarksAndEdAdvice(descId){
        if(descId>0) {
            descriptionId=descId;
        }
        $("#oldRemarks").html('');
        var actionUrl = "${createLink(controller:'edDashboard', action: 'retrieveIssueAndMonthData')}";

            jQuery.ajax({
                type: 'post',
                data: {dashboardId:descriptionId},
                url: actionUrl,
                success: function (data, textStatus) {
                    if (data.isError) {
                        showError(data.message);
                        return false;
                    }

                    if (data.lst != null && data.lst.length>0) {
                        $("#oldRemarks").html(data.lst[0].remarks);
                        //$("#remarks").attr('title', data.lst.remarks);
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
        $('#headingLabel').text($('#issue' + rowIdx).text() + ' Issue');
        $('#followupMonth').prop('readOnly',false);
        $('#description').val($('#description' + rowIdx).val());
        $('#oldRemarks').html($('#remarks' + rowIdx).val());
        $('#hfServiceIdModal').val($('#serviceId').val());
        $('#hfMonthModal').val($('#month').val());
        $('#issuedMonth').text($('#issuedMonth'+rowIdx).text());

        if($('#hfIsResolve'+rowIdx).val()=='true') {
            $('#selectionResolve').prop('checked', true);
            $('#divResolveNote').show();
        }
        if($('#hfIsFollowup'+rowIdx).val()=='true') {
            $('#selectionFollowup').prop('checked', true);
            loadFollowupMonth();
            $('#followupMonth').val(moment($('#hfFollowupMonthFor' + rowIdx).val()).format('MMMM YYYY'));
            loadRemarksAndEdAdvice(rowIdx);
            $('#divRemarks').show();
            $('#divResolveNote').hide();
            $('#remarks').val($('#remarks' + rowIdx).val());
        }
    }
    function hideFollowupDashboardModal() {
        $('#hfClickingRowNo').val('');
        $('#selectionResolve').attr('checked',false);
        $('#selectionFollowup').attr('checked',false);
        $('#divfollowupMonth').hide();
        $('#divRemarks').hide();
        $('#divResolveNote').hide();
        $("#oldRemarks").html('');
        $('#remarks').val('');
        $('#resolveNote').val('');
        $('#description').val('');
        $('#hfServiceIdModal').val('');
        $('#hfMonthModal').val('');
        $('#followupMonth').val('');

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
                alert(data.isError);
                if (data.isError) {
                    showError(data.message);
                    return false;
                }
                executePostCondition(data);
                hideFollowupDashboardModal();
                loadUnresolveData();
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

</script>
