<style type="text/css">
.k-widget.k-window {
    width: 500px;
    height: 300px;
}
.k-edit-buttons {
    width: 480px;
}
</style>

<script language="javascript">
    var dropDownService,gridHR, gridField, gridGovt, gridDonor, gridNP, gridCssp,gridNoIssue,notSubmitted, tmp1 = '';
    $(document).ready(function () {
        onLoadInfoPage();
        initGridHR();
        initGridField();
        initGridGovt();
        initGridDonor();
        initGridNP();
        initGridCssp();
        initGridNoIssue();
        initGridNotSubmitted();
        activaTab('menu1');
        populateAllDashboard();
    });

    function onLoadInfoPage() {
        var str = moment().subtract(1, 'months').format('MMMM YYYY');

        $('#month').kendoDatePicker({
            format: "MMMM yyyy",
            parseFormats: ["yyyy-MM-dd"],
            start: "year",
            depth: "year",
            change: populateAllDashboard
        }).data("kendoDatePicker");
        $('#month').val(str);

        if(!${isSysAdmin} && !${isTopMan} && !${isSpAdmin} && !${isMultiDept}){
            dropDownService.value(${serviceId});
            dropDownService.readonly(true);
            $("#btnDiv").hide();
        }
        hideSettingTabs();
        defaultPageTile("Ed's Dashboard", 'reports/showEdDashBoard');
    }
    function activaTab(tab) {
        $('.nav-tabs a[href="#' + tab + '"]').tab('show');
    }
    function hideSettingTabs(){
        document.getElementById("lst7").children[0].style.display = "none";
        document.getElementById("lst8").children[0].style.display = "none";
    }
    function onclickWithoutIssue(){
        var x = document.getElementById('lst7').children[0];
        if (x.style.display === 'none') {
            x.style.display = 'block';
            activaTab('menu7');
            $("#lblWithoutIssue").text('');
            $("#lblWithoutIssue").text('Hide Without Issue');
            document.getElementById("btn1").style.background ='#5cb85c';
        } else {
            x.style.display = 'none';
            activaTab('menu1');
            $("#lblWithoutIssue").text('');
            $("#lblWithoutIssue").text('Show Without Issue');
            document.getElementById("btn1").style.background ='#f3f3f4';
        }
    }
    function onclickNotSubmit(){
        var x = document.getElementById('lst8').children[0];
        if (x.style.display === 'none') {
            x.style.display = 'block';
            activaTab('menu8');
            $("#lblNotSubmit").text('');
            $("#lblNotSubmit").text('Hide Not Submitted');
            document.getElementById("btn2").style.background ='#5cb85c';
        } else {
            x.style.display = 'none';
            activaTab('menu1');
            $("#lblNotSubmit").text('');
            $("#lblNotSubmit").text('Show Not Submitted');
            document.getElementById("btn2").style.background ='#f3f3f4';
        }
    }
    function initGridHR() {
        $("#gridHR").kendoGrid({
            dataSource: {
                transport: {
                    read: {
                        url: false,
                        dataType: "json",
                        type: "post"
                    }
                },
                schema: {
                    type: 'json',
                    data: "hr",
                    model: {
                        id: "ID",
                        fields: {
                            ID             : {type: "number"},
                            SERVICE_ID     : {editable: false, type: "number"},
                            SERVICE        : {editable: false, type: "string"},
                            ISSUE          : {editable: false, type: "string"},
                            REMARKS        : {editable: false, type: "string"},
                            IS_FOLLOWUP    : {editable: false, type: "boolean"},
                            FOLLOWUP_MONTH : {editable: false, type: "string"},
                            ADVICE         : {type: "string"}
                        }
                    },
                    parse: function (data) {
                        if(data.hrCount!='undefined'){
                            $("#spanHR").html('');
                            $("#spanHR").html('HR Issues (' + data.hrCount + ')');
                        }
                        return data;
                    }
                },
                batch: true,
                serverPaging: true,
                serverSorting: true
            },
            autoBind: false,
            height: getGridHeightKendo() - 140,
            selectable: true,
            sortable: false,
            pageable: false,
            columns: [
                {
                    field: "SERVICE", title: "<b>CSU/Sector</b>", width: 180, sortable: false, filterable: false,
                    template: "<b>#=SERVICE#</b>"
                },
                {
                    field: "ISSUE", title: "<b>Issues & Crisis</b>", width: 250, sortable: false, filterable: false,
                    template: "#=IS_FOLLOWUP?formatIssue(FOLLOWUP_MONTH,ISSUE):ISSUE#"
                },
                {
                    field: "REMARKS", title: "<b>Remarks</b>", width: 250, sortable: false, filterable: false
                },
                {field: "ADVICE", title: "<b>ED's Advice</b>", width: "250px",editor: textAreaInitialize }
                <g:if test="${isAssist}">
                , {command: {text: " Advice", click: showDetails}, width: "10%"}
                </g:if>
            ]
        });
        gridHR = $("#gridHR").data("kendoGrid");
    }
    function initGridField() {
        $("#gridField").kendoGrid({
            dataSource: {
                transport: {
                    read: {
                        url: false,
                        dataType: "json",
                        type: "post"
                    }
                },
                schema: {
                    type: 'json',
                    data: "fld",
                    model: {
                        id: "ID",
                        fields: {
                            ID             : {type: "number"},
                            SERVICE_ID     : {editable: false, type: "number"},
                            SERVICE        : {editable: false, type: "string"},
                            ISSUE          : {editable: false, type: "string"},
                            REMARKS        : {editable: false, type: "string"},
                            IS_FOLLOWUP    : {editable: false, type: "boolean"},
                            FOLLOWUP_MONTH : {editable: false, type: "string"},
                            ADVICE         : {type: "string"}
                        }
                    },
                    parse: function (data) {
                        if(data.fldCount!='undefined'){
                            $("#spanFld").html('');
                            $("#spanFld").html('Beneficiary/Field Issues (' + data.fldCount + ')');
                        }
                        return data;
                    }
                },
                batch: true,
                serverPaging: true,
                serverSorting: true
            },
            autoBind: false,
            height: getGridHeightKendo() - 140,
            selectable: true,
            sortable: false,
            pageable: false,
            columns: [
                {
                    field: "SERVICE", title: "<b>CSU/Sector</b>", width: 180, sortable: false, filterable: false,
                    template: "<b>#=SERVICE#</b>"
                },
                {
                    field: "ISSUE", title: "<b>Issues & Crisis</b>", width: 250, sortable: false, filterable: false,
                    template: "#=IS_FOLLOWUP?formatIssue(FOLLOWUP_MONTH,ISSUE):ISSUE#"
                },
                {
                    field: "REMARKS", title: "<b>Remarks</b>", width: 250, sortable: false, filterable: false
                },
                {field: "ADVICE", title: "<b>ED's Advice</b>", width: "250px",editor: textAreaInitialize }
                <g:if test="${isAssist}">
                , {command: {text: " Advice", click: showDetails}, width: "10%"}
                </g:if>
            ]
        });
        gridField = $("#gridField").data("kendoGrid");
    }
    function initGridGovt() {
        $("#gridGovt").kendoGrid({
            dataSource: {
                transport: {
                    read: {
                        url: false,
                        dataType: "json",
                        type: "post"
                    }
                },
                schema: {
                    type: 'json',
                    data: "govt",
                    model: {
                        id: "ID",
                        fields: {
                            ID             : {type: "number"},
                            SERVICE_ID     : {editable: false, type: "number"},
                            SERVICE        : {editable: false, type: "string"},
                            ISSUE          : {editable: false, type: "string"},
                            REMARKS        : {editable: false, type: "string"},
                            IS_FOLLOWUP    : {editable: false, type: "boolean"},
                            FOLLOWUP_MONTH : {editable: false, type: "string"},
                            ADVICE         : {type: "string"}
                        }
                    },
                    parse: function (data) {
                        if(data.govtCount!='undefined'){
                            $("#spanGvt").html('');
                            $("#spanGvt").html('Government Issues (' + data.govtCount + ')');
                        }
                        return data;
                    }
                },
                batch: true,
                serverPaging: true,
                serverSorting: true
            },
            autoBind: false,
            height: getGridHeightKendo() - 140,
            selectable: true,
            sortable: false,
            pageable: false,
            columns: [
                {
                    field: "SERVICE", title: "<b>CSU/Sector</b>", width: 180, sortable: false, filterable: false,
                    template: "<b>#=SERVICE#</b>"
                },
                {
                    field: "ISSUE", title: "<b>Issues & Crisis</b>", width: 250, sortable: false, filterable: false,
                    template: "#=IS_FOLLOWUP?formatIssue(FOLLOWUP_MONTH,ISSUE):ISSUE#"
                },
                {
                    field: "REMARKS", title: "<b>Remarks</b>", width: 250, sortable: false, filterable: false
                },
                {field: "ADVICE", title: "<b>ED's Advice</b>", width: "250px",editor: textAreaInitialize }
                <g:if test="${isAssist}">
                , {command: {text: " Advice", click: showDetails}, width: "10%"}
                </g:if>
            ]
        });
        gridGovt = $("#gridGovt").data("kendoGrid");
    }
    function initGridDonor() {
        $("#gridDonor").kendoGrid({
            dataSource: {
                transport: {
                    read: {
                        url: false,
                        dataType: "json",
                        type: "post"
                    }
                },
                schema: {
                    type: 'json',
                    data: "dnr",
                    model: {
                        id: "ID",
                        fields: {
                            ID             : {type: "number"},
                            SERVICE_ID     : {editable: false, type: "number"},
                            SERVICE        : {editable: false, type: "string"},
                            ISSUE          : {editable: false, type: "string"},
                            REMARKS        : {editable: false, type: "string"},
                            IS_FOLLOWUP    : {editable: false, type: "boolean"},
                            FOLLOWUP_MONTH : {editable: false, type: "string"},
                            ADVICE         : {type: "string"}
                        }
                    },
                    parse: function (data) {
                        if(data.dnrCount!='undefined'){
                            $("#spanDnr").html('');
                            $("#spanDnr").html('Donor Issues (' + data.dnrCount + ')');
                        }
                        return data;
                    }
                },
                batch: true,
                serverPaging: true,
                serverSorting: true
            },
            autoBind: false,
            height: getGridHeightKendo() - 140,
            selectable: true,
            sortable: false,
            pageable: false,
            columns: [
                {
                    field: "SERVICE", title: "<b>CSU/Sector</b>", width: 180, sortable: false, filterable: false,
                    template: "<b>#=SERVICE#</b>"
                },
                {
                    field: "ISSUE", title: "<b>Issues & Crisis</b>", width: 250, sortable: false, filterable: false,
                    template: "#=IS_FOLLOWUP?formatIssue(FOLLOWUP_MONTH,ISSUE):ISSUE#"
                },
                {
                    field: "REMARKS", title: "<b>Remarks</b>", width: 250, sortable: false, filterable: false
                },
                {field: "ADVICE", title: "<b>ED's Advice</b>", width: "250px",editor: textAreaInitialize }
                <g:if test="${isAssist}">
                , {command: {text: " Advice", click: showDetails}, width: "10%"}
                </g:if>
            ]
        });
        gridDonor = $("#gridDonor").data("kendoGrid");
    }
    function initGridNP() {
        $("#gridNP").kendoGrid({
            dataSource: {
                transport: {
                    read: {
                        url: false,
                        dataType: "json",
                        type: "post"
                    }
                },
                schema: {
                    type: 'json',
                    data: "np",
                    model: {
                        id: "ID",
                        fields: {
                            ID             : {type: "number"},
                            SERVICE_ID     : {editable: false, type: "number"},
                            SERVICE        : {editable: false, type: "string"},
                            ISSUE          : {editable: false, type: "string"},
                            REMARKS        : {editable: false, type: "string"},
                            IS_FOLLOWUP    : {editable: false, type: "boolean"},
                            FOLLOWUP_MONTH : {editable: false, type: "string"},
                            ADVICE         : {type: "string"}
                        }
                    },
                    parse: function (data) {
                        if(data.npCount!='undefined'){
                            $("#spanNP").html('');
                            $("#spanNP").html('New Project Issues (' + data.npCount + ')');
                        }
                        return data;
                    }
                },
                batch: true,
                serverPaging: true,
                serverSorting: true
            },
            autoBind: false,
            height: getGridHeightKendo() - 140,
            selectable: true,
            sortable: false,
            pageable: false,
            columns: [
                {
                    field: "SERVICE", title: "<b>CSU/Sector</b>", width: 180, sortable: false, filterable: false,
                    template: "<b>#=SERVICE#</b>"
                },
                {
                    field: "ISSUE", title: "<b>Issues & Crisis</b>", width: 250, sortable: false, filterable: false,
                    template: "#=IS_FOLLOWUP?formatIssue(FOLLOWUP_MONTH,ISSUE):ISSUE#"
                },
                {
                    field: "REMARKS", title: "<b>Remarks</b>", width: 250, sortable: false, filterable: false
                },
                {field: "ADVICE", title: "<b>ED's Advice</b>", width: "250px",editor: textAreaInitialize }
                <g:if test="${isAssist}">
                , {command: {text: " Advice", click: showDetails}, width: "10%"}
                </g:if>
            ]
        });
        gridNP = $("#gridNP").data("kendoGrid");
    }
    function initGridCssp() {
        $("#gridCssp").kendoGrid({
            dataSource: {
                transport: {
                    read: {
                        url: false,
                        dataType: "json",
                        type: "post"
                    }
                },
                schema: {
                    type: 'json',
                    data: "cssp",
                    model: {
                        id: "ID",
                        fields: {
                            ID             : {type: "number"},
                            SERVICE_ID     : {editable: false, type: "number"},
                            SERVICE        : {editable: false, type: "string"},
                            ISSUE          : {editable: false, type: "string"},
                            REMARKS        : {editable: false, type: "string"},
                            IS_FOLLOWUP    : {editable: false, type: "boolean"},
                            FOLLOWUP_MONTH : {editable: false, type: "string"},
                            ADVICE         : {type: "string"}
                        }
                    },
                    parse: function (data) {
                        if(data.csspCount!='undefined'){
                            $("#spanCssp").html('');
                            $("#spanCssp").html('CSU/Sector Specific Issues (' + data.csspCount + ')');
                        }
                        return data;
                    }
                },
                batch: true,
                serverPaging: true,
                serverSorting: true
            },
            autoBind: false,
            height: getGridHeightKendo() - 140,
            selectable: true,
            sortable: false,
            pageable: false,
            columns: [
                {
                    field: "SERVICE", title: "<b>CSU/Sector</b>", width: 180, sortable: false, filterable: false,
                    template: "<b>#=omitRepeated(SERVICE_ID,SERVICE)#</b>"
                },
                {
                    field: "ISSUE", title: "<b>Issues & Crisis</b>", width: 250, sortable: false, filterable: false,
                    template: "#=IS_FOLLOWUP?formatIssue(FOLLOWUP_MONTH,ISSUE):ISSUE#"
                },
                {
                    field: "REMARKS", title: "<b>Remarks</b>", width: 250, sortable: false, filterable: false
                },
                {field: "ADVICE", title: "<b>ED's Advice</b>", width: "250px",editor: textAreaInitialize }
                <g:if test="${isAssist}">
                , {command: {text: " Advice", click: showDetails}, width: "10%"}
                </g:if>
            ]
        });
        gridCssp = $("#gridCssp").data("kendoGrid");
    }
    function initGridNoIssue() {
        $("#gridNoIssue").kendoGrid({
            dataSource: {
                transport: {
                    read: {
                        url: false,
                        dataType: "json",
                        type: "post"
                    }
                },
                schema: {
                    type: 'json',
                    data: "noIssue",total: "noIssueCount",
                    model: {
                        fields: {
                            ID             : {type: "number"},
                            SERVICE_ID     : {type: "number"},
                            SERVICE        : {type: "string"},
                            DEPARTMENT_HEAD: {type: "string"}
                        }
                    },
                    parse: function (data) {
                        if(data.noIssueCount!='undefined'){
                            $("#spanNoIssue").html('');
                            $("#spanNoIssue").html('CSU/Sector Without Issue (' + data.noIssueCount + ')');
                        }
                        return data;
                    }
                },
                batch: true,
                serverPaging: true,
                serverSorting: true
            },
            autoBind: false,
            height: getGridHeightKendo() - 140,
            selectable: true,
            sortable: false,
            pageable: false,
            columns: [
                {
                    field: "SERVICE", title: "<b>CSU/Sector</b>", width: 180, sortable: false, filterable: false
                },
                {
                    field: "DEPARTMENT_HEAD", title: "<b>Remarks</b>", width: 250, sortable: false, filterable: false,
                    template: "<q> I have no issue on current month </q><br/> --- #= DEPARTMENT_HEAD#"
                }
            ]
        });
        gridNoIssue = $("#gridNoIssue").data("kendoGrid");
    }
    function initGridNotSubmitted() {
        $("#gridNotSubmitted").kendoGrid({
            dataSource: {
                transport: {
                    read: {
                        url: false,
                        dataType: "json",
                        type: "post"
                    }
                },
                schema: {
                    type: 'json',
                    data: "notSubmitted",total: "notSubmitCount",
                    model: {
                        fields: {
                            ID             : {type: "number"},
                            SERVICE_ID     : {type: "number"},
                            SERVICE        : {type: "string"}
                        }
                    },
                    parse: function (data) {
                        if(data.notSubmitCount!='undefined'){
                            $("#spanNotSubmit").html('');
                            $("#spanNotSubmit").html('Not Submitted (' + data.notSubmitCount + ')');
                        }
                        return data;
                    }
                },
                batch: true,
                serverPaging: true,
                serverSorting: true
            },
            autoBind: false,
            height: getGridHeightKendo() - 140,
            selectable: true,
            sortable: false,
            pageable: false,
            columns: [
                {
                    field: "SERVICE", title: "<b>CSU/Sector</b>", width: 180, sortable: false, filterable: false
                }
            ]
        });
        gridNotSubmitted = $("#gridNotSubmitted").data("kendoGrid");
    }

    function populateAllDashboard() {
        tmp1 = '';
        var serviceId = $('#serviceId').val();
        if(serviceId==''){ serviceId = 0;}
        var month = $('#month').val();
        var urlHR   = "${createLink(controller: 'reports', action: 'listEdDashBoard')}?month=" + month + "&serviceId=" + serviceId + "&hr=true";
        var urlFld  = "${createLink(controller: 'reports', action: 'listEdDashBoard')}?month=" + month + "&serviceId=" + serviceId + "&fld=true";
        var urlGovt = "${createLink(controller: 'reports', action: 'listEdDashBoard')}?month=" + month + "&serviceId=" + serviceId + "&govt=true";
        var urlDnr  = "${createLink(controller: 'reports', action: 'listEdDashBoard')}?month=" + month + "&serviceId=" + serviceId + "&dnr=true";
        var urlNp   = "${createLink(controller: 'reports', action: 'listEdDashBoard')}?month=" + month + "&serviceId=" + serviceId + "&np=true";
        var urlCssp = "${createLink(controller: 'reports', action: 'listEdDashBoard')}?month=" + month + "&serviceId=" + serviceId + "&cssp=true";
        var urlNoIssue = "${createLink(controller: 'reports', action: 'listEdDashBoard')}?month=" + month + "&serviceId=" + serviceId + "&noIssue=true";
        var notSubmitted = "${createLink(controller: 'reports', action: 'listEdDashBoard')}?month=" + month + "&serviceId=" + serviceId + "&notSubmitted=true";
        populateGridKendo(gridHR, urlHR);
        populateGridKendo(gridField, urlFld);
        populateGridKendo(gridGovt, urlGovt);
        populateGridKendo(gridDonor, urlDnr);
        populateGridKendo(gridNP, urlNp);
        populateGridKendo(gridCssp, urlCssp);
        populateGridKendo(gridNoIssue, urlNoIssue);
        populateGridKendo(gridNotSubmitted, notSubmitted);
        return false;
    }

    function setPreviousMonth() {
        var month = $('#month').val();
        var str = moment(month, 'MMMM YYYY').subtract(1, 'months').format('MMMM YYYY');
        $('#month').val(str);
        populateAllDashboard();
    }
    function setNextMonth() {
        var month = $('#month').val();
        var str = moment(month, 'MMMM YYYY').add(1, 'months').format('MMMM YYYY');
        $('#month').val(str);
        populateAllDashboard();
    }
    function formatIssue(FOLLOWUP_MONTH, ISSUE) {
        return '<font color="#8b0000">First issued at ' + FOLLOWUP_MONTH + '</font> <br/>' + ISSUE;
    }
    function omitRepeated(SERVICE_ID, SERVICE) {
        if (tmp1 == SERVICE_ID) { return '' }
        tmp1 = SERVICE_ID;
        return SERVICE;
    }
    function textAreaInitialize(container, options) {
        $('<textarea name="' + options.field + '" style="width: 326px;height: 220px" />').appendTo(container);
    }
    function showDetails(e) {
        e.preventDefault();
        var dataItem = this.dataItem($(e.currentTarget).closest("tr"));
        $("#viewEdAdviceEntryModal").modal('show');
        $('#hfDashboardId').val(dataItem.ID);
        $('#headingDetailsLabel').text("ED's Advice Panel");
        $('#serviceName').text(dataItem.SERVICE);
        $('#issuedInitiateMonth').text($('#month').val());
        $('#descriptionDetails').text(dataItem.ISSUE);
        $('#edAdvice').val(dataItem.ADVICE);
        loadRemarksAndEdAdvice(dataItem.id);

    }
    function hideDetailsDashboardModal() {
        $("#viewEdAdviceEntryModal").modal('hide');
        $('#headingDetailsLabel').text('');
        $('#serviceName').text('');
        $('#issuedInitiateMonth').text('');
        $('#descriptionDetails').html('');
        $('#allRemarksAdvice').html('');
        $('#edAdvice').val('');
        $('#hfDashboardId').val('');
    }
    function executePreCondition() {
        if (!validateForm($("#viewEdAdviceEntryForm"))) {
            return false;
        }
        return true;
    }
    function onSubmitEdAdviceModal() {
        if (executePreCondition() == false) {
            return false;
        }
        showLoadingSpinner(true);
        var actionUrl = "${createLink(controller:'edDashboard', action: 'update')}?type=EdAdvice";

        jQuery.ajax({
            type: 'post',
            data: jQuery("#viewEdAdviceEntryForm").serialize(),
            url: actionUrl,
            success: function (data, textStatus) {
                hideDetailsDashboardModal();
                executePostCondition(data);
                populateAllDashboard();
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
    function loadRemarksAndEdAdvice(descId) {
        if (descId > 0) {
            descriptionId = descId;
        }
        $("#allRemarksAdvice").html('');
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

                    $("#allRemarksAdvice").html(data.lst[0].remarks);
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
</script>
