<script language="javascript">
    var serviceId,currentMonth,isReadyForSave=true;

    $(document).ready(function () {
        onLoadEdDashboardPage();
        loadTableData();
    });

    function onLoadEdDashboardPage() {
        serviceId = ${serviceId};
        currentMonth = moment().format('MMMM YYYY');
        $('#month').kendoDatePicker({
            format: "MMMM yyyy",
            parseFormats: ["yyyy-MM-dd"],
            start: "year",
            depth: "year",
            change: makeNonEditable
        }).data("kendoDatePicker");
        $('#month').val(currentMonth);
        $('#hfSubmissionDate').val('${submissionDate}');
        initializeForm($("#edDashboardForm"), onSubmitEdDashboard);
        defaultPageTile("Create Ed Dashboard",null);
        dropDownService.value(serviceId);
    }
    function makeNonEditable(){
        var mon = $('#month').val();
        $('input[type="text"], textarea').attr('readonly','readonly');
        $('input[type="text"], textarea').val('');
        $('#month').val(mon);
//        isReadyForSave = false;
        loadTableData();
    }
    function loadTableData(){
        var actionUrl = "${createLink(controller:'edDashboard', action: 'list')}";
        serviceId=$('#serviceId').val();
        var month=$('#month').val();
        jQuery.ajax({
            type: 'post',
            data: {serviceId:serviceId,month:month},
            url: actionUrl,
            success: function (data, textStatus) {
                $('#tableData').html('');
                $('#tableData').html(data.tableHtml);
                isReadyForSave = true;
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                console.info('error');
            },
            complete: function (XMLHttpRequest, textStatus) {
                console.info('complete');
            }

        });
    }

    function loadFollowupMonth(){
        if(document.querySelector('input[name=selection]:checked').value=='New') {
            $('#description').val('');
            //$('#remarks').val('');
           // $('#edAdvice').val('');
            $('#followupMonth').val('');
            $('#description').prop('readOnly',false);
            $('#divfollowupMonth').hide();
            $('#divOldRemarks').hide();
            $('#divDescFollowupMonthDDL').hide();
            $('#divDescriptionTextArea').show();
        }
        else {
            if($('#hfIsAdditionalModal').val()=='true') {
                $('#divDescriptionTextArea').hide();
                $('#divDescFollowupMonthDDL').show();
                $('#descFollowupMonthDDL').kendoDropDownList({
                    dataTextField: "name",
                    dataValueField: "id",
                    dataSource: getKendoEmptyDataSource

                });
            }
            $('#description').prop('readOnly',true);
            $('#divOldRemarks').show();
            $("#oldRemarks").html('');
            $('#divfollowupMonth').show();
            var fMonth =  $('#followupMonth').kendoDatePicker({
                format: "MMMM yyyy",
                parseFormats: ["yyyy-MM-dd"],
                start: "year",
                depth: "year",
                change: loadMonthAndIssueData
            }).data("kendoDatePicker");

            if($('#hfSubmissionDate').val()!='') {
                var sDate= moment($('#hfSubmissionDate').val()).add(-1, 'months')
                fMonth.max(moment(sDate).format('YYYY-MM-DD'));
            }else{
                var sDate= moment(new Date()).add(-1, 'months')
                fMonth.max(moment(sDate).format('YYYY-MM-DD'));
            }
        }
    }
    function loadMonthAndIssueData(){
        $('#description').val('');
        $('#oldRemarks').html('');
        var issueId= $('#hfClickingRowNo').val();
        if($('#hfIsAdditionalModal').val()=='true'){
            $('#divDescriptionTextArea').hide();
            $('#divDescFollowupMonthDDL').show();
            $('#descFollowupMonthDDL').kendoDropDownList({
                dataTextField: "name",
                dataValueField: "id",
                dataSource: getKendoEmptyDataSource

            });
            descFollowupMonthDDL = $('#descFollowupMonthDDL').data("kendoDropDownList");
            descFollowupMonthDDL.setDataSource(getKendoEmptyDataSource(descFollowupMonthDDL, null));

            var actionUrl = "${createLink(controller:'edDashboard', action: 'retrieveIssueAndMonthData')}";
            serviceId = $('#serviceId').val();
            var month = $('#followupMonth').val();
            jQuery.ajax({
                type: 'post',
                data: {serviceId: serviceId, month: month},
                url: actionUrl,
                success: function (data, textStatus) {
                    if (data.isError) {
                        showError(data.message);
                        return false;
                    }
                    descFollowupMonthDDL.setDataSource(data.lst);
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    console.info('error in DDL');
                },
                complete: function (XMLHttpRequest, textStatus) {
                        var a = $("#description"+issueId).val();
                    if( $('#followupMonth').val()==moment($('#hfFollowupMonthFor' + issueId).val()).format('MMMM YYYY')) {
                        descFollowupMonthDDL.select(function (dataItem) {
                            return dataItem.name === a;
                        });
                        loadRemarksAndEdAdvice(descFollowupMonthDDL.value());
                    }
                }

            });

        }else {
            $('#divDescriptionTextArea').show();
            $('#divDescFollowupMonthDDL').hide();
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
                    if (data.lst != null && data.lst.length>0) {

                        $('#description').val(data.lst[0].description);
                        $("#oldRemarks").html(data.lst[0].remarks);
                        //$('#edAdvice').val(data.lst.edAdvice);
                    }else{
                        showError('No data found.');
                    }
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    showError('No data found.');
                },
                complete: function (XMLHttpRequest, textStatus) {
                    console.info('complete');
                }

            });
        }
    }
    function loadRemarksAndEdAdvice(descId){
        $('#description').val('');
        if($('#descFollowupMonthDDL').data("kendoDropDownList").value()>0){
            $('#description').val($('#descFollowupMonthDDL').data("kendoDropDownList").text());
        }
        $('#oldRemarks').html('');
        var descriptionId = descFollowupMonthDDL.value();
        if(descId>0) {
            descriptionId=descId;
        }
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
    function showRemarksModalForAdditional(rowIdx,maxRowIndex) {
        $("#createCrisisRemarksModal").modal('show');
        $('#hfClickingRowNo').val(maxRowIndex);
        $('#hfIsAdditionalModal').val($('#hfIsAdditional' + (rowIdx)).val());
            $('#headingLabel').text('Sector/CSU Specific Issue');
        $('#selectionNew').prop('checked', true);
        $('#remarks').prop('readonly', false);
        $('#description').prop('readonly', false);
        $('#followupMonth').prop('readOnly',false);
        $('#hfServiceIdModal').val($('#serviceId').val());
        $('#hfMonthModal').val($('#month').val());
        $('#deleteIssue').hide();
    }
    function showRemarksModal(rowIdx) {
        $("#createCrisisRemarksModal").modal('show');
        $('#hfClickingRowNo').val(rowIdx);
        $('#hfIsAdditionalModal').val($('#hfIsAdditional' + (rowIdx)).val());
        if(!$('#issue' + rowIdx).text().isEmpty()) {
            $('#headingLabel').text($('#issue' + rowIdx).text() + ' Issue');
            if($('#hfIsAdditional' + (rowIdx)).val()=='true'){
                $('#headingLabel').text('Sector/CSU Specific '+$('#issue' + rowIdx).text());
            }
        }else{
            $('#headingLabel').text('Sector/CSU Specific Issue');
        }
        $('#selectionNew').prop('checked', true);
        $('#remarks').prop('readonly', false);
        $('#description').prop('readonly', false);
        $('#followupMonth').prop('readOnly',false);
        $('#description').val($('#description' + rowIdx).val());
        $('#deleteIssue').hide();
        if(!$('#description' + rowIdx).val().isEmpty()){
            $('#deleteIssue').show();
        }
        $('#remarks').val($('#remarks' + rowIdx).val());
        $('#hfServiceIdModal').val($('#serviceId').val());
        $('#hfMonthModal').val($('#month').val());
        if($('#hfIsFollowup'+rowIdx).val()=='true') {
            $('#selectionFollowup').prop('checked', true);
            loadFollowupMonth();
            $('#followupMonth').val(moment($('#hfFollowupMonthFor' + rowIdx).val()).format('MMMM YYYY'));
            loadMonthAndIssueData();
        }
    }
    function hideCreateCrisisRemarksModal() {
        $('#descFollowupMonthDDL').val('');
        $('#hfClickingRowNo').val('');
        $('#hfIsAdditionalModal').val('');
        $('#headingLabel').text('');
        $('#selectionNew').attr('checked',true);
        $('#divfollowupMonth').hide();
        $("#oldRemarks").html('');
        $('#divOldRemarks').hide();
        $('#remarks').val('');
        $('#description').val('');
        $('#description').prop('readOnly',false);
        $('#divDescFollowupMonthDDL').hide();
        $('#divDescriptionTextArea').show();
        $('#hfServiceIdModal').val('');
        $('#hfMonthModal').val('');
        $('#followupMonth').val('');
        $("#createCrisisRemarksModal").modal('hide');
    }
    function deleteIssue() {

        var msg = 'Are you sure you want to delete the record?',
                url = "${createLink(controller: 'edDashboard', action:  'delete')}";
        bootbox.confirm(msg, function (result) {
            if (result) {
                showLoadingSpinner(true);
                var id = $('#hfClickingRowNo').val();
                var serviceId = $('#hfServiceIdModal').val();
                var month = $('#hfMonthModal').val();
                $.ajax({
                    url: url + "?id=" + id + "&serviceId=" + serviceId + "&month=" + month,
                    success: function (data, textStatus) {
                        if (data.isError) {
                            showError(data.message);
                            return false;
                        }
                        hideCreateCrisisRemarksModal();
                        executePostCondition(data);
                    },
                    error: function (XMLHttpRequest, textStatus, errorThrown) {
                        afterAjaxError(XMLHttpRequest, textStatus)
                    },
                    complete: function (XMLHttpRequest, textStatus) {
                        showLoadingSpinner(false);
                    },
                    dataType: 'json',
                    type: 'post'
                });
            }
        }).find("div.modal-content").addClass("conf-delete");
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
        if(!isReadyForSave){
            showError("First press View button then press Save");
            return false;
        }
        showLoadingSpinner(true);

        jQuery.ajax({
            type: 'post',
            data: jQuery("#createCrisisRemarksForm").serialize(),
            url: "${createLink(controller:'edDashboard', action: 'create')}",
            success: function (data, textStatus) {
                hideCreateCrisisRemarksModal();
                executePostCondition(data);
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
            showSuccess(result.message);
            loadTableData();
        }
        showLoadingSpinner(false);

    }

</script>
