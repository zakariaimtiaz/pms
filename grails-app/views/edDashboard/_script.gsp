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

        initializeForm($("#edDashboardForm"), onSubmitEdDashboard);
        defaultPageTile("Create Ed Dashboard",null);
        dropDownService.value(serviceId);
    }
    function makeNonEditable(){
        var mon = $('#month').val();
        $('input[type="text"], textarea').attr('readonly','readonly');
        $('input[type="text"], textarea').val('');
        $('#month').val(mon);
        isReadyForSave = false;
    }
    function loadFollowupMonth(ele){
        var id=ele.id;
        var issueId=id.substring(9,id.length);

        if(document.querySelector('input[name='+id+']:checked').value=='New') {
            $('#description' + issueId).val('');
            $('#remarks' + issueId).val('');
            $('#edAdvice' + issueId).val('');
            $('#followupMonth' + issueId).val('');
            $('#description' + issueId).prop('readOnly',false);
            $('#divfollowupMonth' + issueId).hide();
        }
        else {
            $('#divfollowupMonth' + issueId).show();
            $('#followupMonth' + issueId).kendoDatePicker({
                format: "MMMM yyyy",
                parseFormats: ["yyyy-MM-dd"],
                start: "year",
                depth: "year",
                change: loadMonthAndIssueData
            }).data("kendoDatePicker");
        }
    }
    function loadMonthAndIssueData(){
        var id=$(':focus').attr('id');
        var issueId=id.substring(13,id.length);
        var actionUrl = "${createLink(controller:'edDashboard', action: 'retrieveIssueAndMonthData')}";
        serviceId=$('#serviceId').val();
        var month=$(':focus').val();
      //  alert(issueId);
        jQuery.ajax({
            type: 'post',
            data: {serviceId:serviceId,month:month,issueId:issueId},
            url: actionUrl,
            success: function (data, textStatus) {
                if (data.isError) {
                    showError(data.message);
                    return false;
                }

                if(data.lst!=null) {
                    $('#description' + issueId).val(data.lst.description);
                    $("#remarks"+issueId).attr('title', data.lst.remarks);
                   // $("#remarks" + issueId).attr('template','#=trimTextForKendo('+ data.lst.remarks+',70)#');

                    //$('#remarks' + issueId).val(data.lst.remarks);
                    $('#edAdvice' + issueId).val(data.lst.edAdvice);
                    $('#description' + issueId).prop('readOnly',true);
                }else{
                    $('#description' + issueId).val('');
                    $('#remarks' + issueId).val('');
                    $('#edAdvice' + issueId).val('');
                    $('#description' + issueId).prop('readOnly',false);
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
            showSuccess(result.message);
        }
        showLoadingSpinner(false);
    }

</script>
