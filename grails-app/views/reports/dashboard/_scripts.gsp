<script language="javascript">
    var gridHR,gridField,gridGovt,gridDonor,gridNP,gridSP,tmp1='';
    $(document).ready(function () {
        onLoadInfoPage();
        initGridHR();
        initGridField();
        initGridGovt();
        initGridDonor();
        initGridNP();
        initGridSP();
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
        defaultPageTile("Ed's Dashboard", '/reports/showEdDashBoard');
    }
    function activaTab(tab){
        $('.nav-tabs a[href="#' + tab + '"]').tab('show');
    };
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
                        $("#spanHR").html('HR Issue ('+data.hrCount+')');
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
                    field: "SERVICE", title: "CSU/Sector", width: 180, sortable: false, filterable: false,
                    template:"<b>#=SERVICE#</b>"
                },
                {
                    title: "<b>HR Issue</b>", headerAttributes: {style: setAlignCenter()},
                    columns: [
                        {
                            field: "HR_ISSUE", title: "Issues & Crisis", width: 250, sortable: false, filterable: false,
                            template:"#=HR_IS_FOLLOWUP?formatIssue(HR_FOLLOWUP_MONTH,HR_ISSUE):HR_ISSUE#"
                        },
                        {
                            field: "HR_REMARKS", title: "Remarks", width: 250, sortable: false, filterable: false
                        },
                        {
                            field: "HR_ADVICE", title: "Ed's Advice", width: 250, sortable: false, filterable: false
                        }
                    ]
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
                        $("#spanFld").html('Field Issue ('+data.fldCount+')');
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
                    field: "SERVICE", title: "CSU/Sector", width: 180, sortable: false, filterable: false,
                    template:"<b>#=SERVICE#</b>"
                },
                {
                    title: "<b>Field Issue</b>", headerAttributes: {style: setAlignCenter()},
                    columns: [
                        {
                            field: "FIELD_ISSUE", title: "Issues & Crisis", width: 300, sortable: false, filterable: false,
                            template:"#=FIELD_IS_FOLLOWUP?formatIssue(FIELD_FOLLOWUP_MONTH,FIELD_ISSUE):FIELD_ISSUE#"
                        },
                        {
                            field: "FIELD_REMARKS", title: "Remarks", width: 200, sortable: false, filterable: false
                        },
                        {
                            field: "FIELD_ADVICE", title: "Ed's Advice", width: 250, sortable: false, filterable: false
                        }
                    ]
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
                        $("#spanGvt").html('Government Issue ('+data.govtCount+')');
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
                    field: "SERVICE", title: "CSU/Sector", width: 180, sortable: false, filterable: false,
                    template:"<b>#=SERVICE#</b>"
                },
                {
                    title: "<b>Government Issue</b>", headerAttributes: {style: setAlignCenter()},
                    columns: [
                        {
                            field: "GOVERNMENT_ISSUE", title: "Issues & Crisis", width: 300, sortable: false, filterable: false,
                            template:"#=GOVERNMENT_IS_FOLLOWUP?formatIssue(GOVERNMENT_FOLLOWUP_MONTH,GOVERNMENT_ISSUE):GOVERNMENT_ISSUE#"
                        },
                        {
                            field: "GOVERNMENT_REMARKS", title: "Remarks", width: 200, sortable: false, filterable: false
                        },
                        {
                            field: "GOVERNMENT_ADVICE", title: "Ed's Advice", width: 250, sortable: false, filterable: false
                        }
                    ]
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
                        $("#spanDnr").html('Donor Issue ('+data.dnrCount+')');
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
                    field: "SERVICE", title: "CSU/Sector", width: 180, sortable: false, filterable: false,
                    template:"<b>#=SERVICE#</b>"
                },
                {
                    title: "<b>Donor Issue</b>", headerAttributes: {style: setAlignCenter()},
                    columns: [
                        {
                            field: "DONOR_ISSUE", title: "Issues & Crisis", width: 300, sortable: false, filterable: false,
                            template:"#=DONOR_IS_FOLLOWUP?formatIssue(DONOR_FOLLOWUP_MONTH,DONOR_ISSUE):DONOR_ISSUE#"
                        },
                        {
                            field: "DONOR_REMARKS", title: "Remarks", width: 200, sortable: false, filterable: false
                        },
                        {
                            field: "DONOR_ADVICE", title: "Ed's Advice", width: 250, sortable: false, filterable: false
                        }
                    ]
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
                        $("#spanNP").html('New Project Issue ('+data.npCount+')');
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
                    field: "SERVICE", title: "CSU/Sector", width: 180, sortable: false, filterable: false,
                    template:"<b>#=SERVICE#</b>"
                },
                {
                    title: "<b>New Project Issue</b>", headerAttributes: {style: setAlignCenter()},
                    columns: [
                        {
                            field: "NEW_PROJECT_ISSUE", title: "Issues & Crisis", width: 300, sortable: false, filterable: false,
                            template:"#=NP_IS_FOLLOWUP?formatIssue(NP_FOLLOWUP_MONTH,NEW_PROJECT_ISSUE):NEW_PROJECT_ISSUE#"
                        },
                        {
                            field: "NEW_PROJECT_REMARKS", title: "Remarks", width: 200, sortable: false, filterable: false
                        },
                        {
                            field: "NEW_PROJECT_ADVICE", title: "Ed's Advice", width: 250, sortable: false, filterable: false
                        }
                    ]
                }
            ]
        });
        gridNP = $("#gridNP").data("kendoGrid");
    }
    function initGridSP() {
        $("#gridSP").kendoGrid({
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
                        $("#spanCssp").html('CSU/Sector Specific Issue ('+data.csspCount+')');
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
                    field: "SERVICE", title: "CSU/Sector", width: 180, sortable: false, filterable: false,
                    template:"<b>#=omitRepeated(SERVICE_ID,SERVICE)#</b>"
                },
                {
                    title: "<b>CSU/Sector Specific Issue</b>", headerAttributes: {style: setAlignCenter()},
                    columns: [
                        {
                            field: "ISSUE", title: "Issues & Crisis", width: 300, sortable: false, filterable: false,
                            template:"#=IS_FOLLOWUP?formatIssue(FOLLOWUP_MONTH,ISSUE):ISSUE#"
                        },
                        {
                            field: "REMARKS", title: "Remarks", width: 200, sortable: false, filterable: false
                        },
                        {
                            field: "ADVICE", title: "Ed's Advice", width: 250, sortable: false, filterable: false
                        }
                    ]
                }
            ]
        });
        gridSP = $("#gridSP").data("kendoGrid");
    }
    function formatIssue(FOLLOWUP_MONTH,ISSUE){
        return '<font color="#8b0000">First issued at ' + FOLLOWUP_MONTH +'</font> <br/>'+ ISSUE;
    }
    function omitRepeated(SEC_ID,VAL){
        if(tmp1==SEC_ID){return ''}
        tmp1 = SEC_ID;
        return VAL;
    }
    function populateKendoChart() {
        var month = $('#month').val();
        var urlHR ="${createLink(controller: 'reports', action: 'listEdDashBoard')}?month="+month+"&hr=true";
        var urlFld ="${createLink(controller: 'reports', action: 'listEdDashBoard')}?month="+month+"&fld=true";
        var urlGovt ="${createLink(controller: 'reports', action: 'listEdDashBoard')}?month="+month+"&govt=true";
        var urlDnr ="${createLink(controller: 'reports', action: 'listEdDashBoard')}?month="+month+"&dnr=true";
        var urlNp ="${createLink(controller: 'reports', action: 'listEdDashBoard')}?month="+month+"&np=true";
        var urlCssp ="${createLink(controller: 'reports', action: 'listEdDashBoard')}?month="+month+"&cssp=true";
        populateGridKendo(gridHR, urlHR);
        populateGridKendo(gridField, urlFld);
        populateGridKendo(gridGovt, urlGovt);
        populateGridKendo(gridDonor, urlDnr);
        populateGridKendo(gridNP, urlNp);
        populateGridKendo(gridSP, urlCssp);
        return false;
    }

    function downloadDashboardReport() {
        var month = $('#month').val();
        showLoadingSpinner(true);
        var msg = 'Do you want to download the ED\'S Dashboard report now?',
            params = "?month=" +month,
            url = "${createLink(controller: 'reports', action:  'downloadEdDashBoard')}" + params;
        confirmDownload(msg, url);
        return false;
    }

    function setPreviousMonth(){
        var month = $('#month').val();
        var str = moment(month,'MMMM YYYY').subtract(1, 'months').format('MMMM YYYY');
        $('#month').val(str);
        populateKendoChart();
    }
    function setNextMonth(){
        var month = $('#month').val();
        var str = moment(month,'MMMM YYYY').add(1, 'months').format('MMMM YYYY');
        $('#month').val(str);
        populateKendoChart();
    }
</script>
