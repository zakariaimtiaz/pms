<script language="javascript">
    var dropDownService,gridHR, gridField, gridGovt, gridDonor, gridNP, gridCssp, tmp1 = '';
    $(document).ready(function () {
        onLoadInfoPage();
        initGridHR();
        initGridField();
        initGridGovt();
        initGridDonor();
        initGridNP();
        initGridCssp();
        activaTab('menu1');
        populateKendoChart();
    });
    function onLoadInfoPage() {
        var str = moment().subtract(1, 'months').format('MMMM YYYY');

        $('#month').kendoDatePicker({
            format: "MMMM yyyy",
            parseFormats: ["yyyy-MM-dd"],
            start: "year",
            depth: "year",
            change: populateKendoChart
        }).data("kendoDatePicker");
        $('#month').val(str);

        if(!${isSysAdmin} && !${isTopMan}){
            dropDownService.value(${serviceId});
            dropDownService.readonly(true);
        }
        defaultPageTile("Ed's Dashboard", '/reports/showEdDashBoard');
    }
    function activaTab(tab) {
        $('.nav-tabs a[href="#' + tab + '"]').tab('show');
    }
    ;
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
                    parse: function (data) {
                        $("#spanHR").html('');
                        $("#spanHR").html('HR Issues (' + data.hrCount + ')');
                        return data;
                    }
                },
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
                {
                    field: "ADVICE", title: "<b>ED's Advice</b>", width: 250, sortable: false, filterable: false
                }
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
                    parse: function (data) {
                        $("#spanFld").html('');
                        $("#spanFld").html('Beneficiary/Field Issues (' + data.fldCount + ')');
                        return data;
                    }
                },
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
                {
                    field: "ADVICE", title: "<b>ED's Advice</b>", width: 250, sortable: false, filterable: false
                }
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
                    parse: function (data) {
                        $("#spanGvt").html('');
                        $("#spanGvt").html('Government Issues (' + data.govtCount + ')');
                        return data;
                    }
                },
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
                {
                    field: "ADVICE", title: "<b>ED's Advice</b>", width: 250, sortable: false, filterable: false
                }
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
                    parse: function (data) {
                        $("#spanDnr").html('');
                        $("#spanDnr").html('Donor Issues (' + data.dnrCount + ')');
                        return data;
                    }
                },
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
                {
                    field: "ADVICE", title: "<b>ED's Advice</b>", width: 250, sortable: false, filterable: false
                }
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
                    parse: function (data) {
                        $("#spanNP").html('');
                        $("#spanNP").html('New Project Issues (' + data.npCount + ')');
                        return data;
                    }
                },
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
                {
                    field: "ADVICE", title: "<b>ED's Advice</b>", width: 250, sortable: false, filterable: false
                }
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
                    parse: function (data) {
                        $("#spanCssp").html('');
                        $("#spanCssp").html('CSU/Sector Specific Issues (' + data.csspCount + ')');
                        return data;
                    }
                },
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
                {
                    field: "ADVICE", title: "<b>ED's Advice</b>", width: 250, sortable: false, filterable: false
                }
            ]
        });
        gridCssp = $("#gridCssp").data("kendoGrid");
    }

    function populateKendoChart() {
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
        populateGridKendo(gridHR, urlHR);
        populateGridKendo(gridField, urlFld);
        populateGridKendo(gridGovt, urlGovt);
        populateGridKendo(gridDonor, urlDnr);
        populateGridKendo(gridNP, urlNp);
        populateGridKendo(gridCssp, urlCssp);
        return false;
    }

    function setPreviousMonth() {
        var month = $('#month').val();
        var str = moment(month, 'MMMM YYYY').subtract(1, 'months').format('MMMM YYYY');
        $('#month').val(str);
        populateKendoChart();
    }
    function setNextMonth() {
        var month = $('#month').val();
        var str = moment(month, 'MMMM YYYY').add(1, 'months').format('MMMM YYYY');
        $('#month').val(str);
        populateKendoChart();
    }
    function formatIssue(FOLLOWUP_MONTH, ISSUE) {
        return '<font color="#8b0000">First issued at ' + FOLLOWUP_MONTH + '</font> <br/>' + ISSUE;
    }
    function omitRepeated(SERVICE_ID, SERVICE) {
        if (tmp1 == SERVICE_ID) { return '' }
        tmp1 = SERVICE_ID;
        return SERVICE;
    }
</script>
