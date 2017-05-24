<div id="application_top_panel" class="panel panel-primary">
    <div class="panel-body">
            <div id="gridMCRSSubmission"></div>
    </div>
</div>
<style type="text/css">
    .panel-body {
        padding: 0px;
    }
</style>
<script type="text/x-kendo-template" id="gridToolbar">
<ul id="menuGrid2" class="kendoGridMenu">
    <sec:access url="/pmMcrsLog/submissionMRP">
        <li onclick="mrpSubmission();"><i class="fa fa-gavel"></i>MRP Submit</li>
    </sec:access>
    <sec:access url="/pmMcrsLog/submissionDashBoard">
        <li onclick="dashboardSubmission();"><i class="fa fa-gavel"></i>ED's Dashboard Submit</li>
    </sec:access>
</ul>
</script>
<script language="javascript">
    var gridMCRSSubmission, dataSource2, serviceId;

    $(document).ready(function () {
        serviceId = ${serviceId};
        initMcrsLogGrid();
    });

    function initDataSource() {
        dataSource2 = new kendo.data.DataSource({
            transport: {
                read: {
                    url: "${createLink(controller: 'pmMcrsLog', action: 'list')}?serviceId="+ serviceId,
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
                        service: {type: "string"},
                        shortName: {type: "string"},
                        submissionDate: {type: "date"},
                        submissionDateDb: {type: "date"},
                        isSubmitted: {type: "boolean"},
                        isSubmittedDb: {type: "boolean"},
                        isEditable: {type: "boolean"},
                        isEditableDb: {type: "boolean"},
                        year: {type: "number"},
                        monthStr: {type: "string"},
                        month: {type: "number"},
                        issueCount: {type: "number"}
                    }
                },
                parse: function (data) {
                    checkIsErrorGridKendo(data);
                    return data;
                }
            },
            sort: {field: 'month', dir: 'asc'},
            pageSize: getDefaultPageSize(),
            serverPaging: true,
            serverFiltering: true,
            serverSorting: true
        });
    }

    function initMcrsLogGrid() {
        initDataSource();
        $("#gridMCRSSubmission").kendoGrid({
            dataSource: dataSource2,
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
                {
                    field: "monthStr", title: "Month", width: 30, sortable: false, filterable: false
                },
                {
                    title: "Submitted", headerAttributes: {style: setAlignCenter()},filterable: false,
                    columns: [
                        {
                            field: "isSubmitted", title: "MRP",
                            width: 30, sortable: false, filterable: false,
                            headerAttributes: {style: setAlignCenter()},
                            attributes: {style: setAlignCenter()},
                            template: "#=isSubmitted?'YES':'NO'#"
                        },
                        {
                            field: "isSubmittedDb", title: "ED's Dashboard",
                            width: 40, sortable: false, filterable: false,
                            headerAttributes: {style: setAlignCenter()},
                            attributes: {style: setAlignCenter()},
                            template: "#=isSubmittedDb?'YES':'NO'#"
                        }
                    ]
                },
                {
                    title: "Submission Date", headerAttributes: {style: setAlignCenter()},filterable: false,
                    columns: [
                        {
                            field: "submissionDate", title: "MRP",
                            width: 30, sortable: false, filterable: false,
                            headerAttributes: {style: setAlignCenter()},
                            attributes: {style: setAlignCenter()},
                            template: "#=isSubmitted?kendo.toString(kendo.parseDate(submissionDate, 'yyyy-MM-dd'), 'dd-MM-yyyy'):''#"
                        },
                        {
                            field: "submissionDateDb", title: "ED's Dashboard",
                            width: 40, sortable: false, filterable: false,
                            headerAttributes: {style: setAlignCenter()},
                            attributes: {style: setAlignCenter()},
                            template: "#=submissionDateDb?kendo.toString(kendo.parseDate(submissionDateDb, 'yyyy-MM-dd'), 'dd-MM-yyyy'):''#"
                        }
                    ]
                },
                {
                    title: "Editable", headerAttributes: {style: setAlignCenter()},filterable: false,
                    columns: [
                        {
                            field: "isEditable", title: "MRP",
                            width: 30, sortable: false, filterable: false,
                            headerAttributes: {style: setAlignCenter()},
                            attributes: {style: setAlignCenter()},
                            template: "#=isEditable?'YES':'NO'#"
                        },
                        {
                            field: "isEditableDb", title: "ED's Dashboard",
                            width: 40, sortable: false, filterable: false,
                            headerAttributes: {style: setAlignCenter()},
                            attributes: {style: setAlignCenter()},
                            template: "#=isEditableDb?'YES':'NO'#"
                        }
                    ]
                }
            ],
            filterable: {
                mode: "row"
            },
            toolbar: kendo.template($("#gridToolbar").html())
        });
        gridMCRSSubmission = $("#gridMCRSSubmission").data("kendoGrid");
        $("#menuGrid2").kendoMenu();
    }

    function mrpSubmission() {
        if (executeCommonPreConditionForSelectKendo(gridMCRSSubmission, 'month') == false) {
            return;
        }
        var isSubmitted = getSelectedValueFromGridKendo(gridMCRSSubmission, 'isSubmitted');
        if(isSubmitted){
            showInfo('MRP already submitted');
            return false;
        }
        var msg = 'Are you sure you want to submit the selected MRP?',
                url = "${createLink(controller: 'pmMcrsLog', action:  'submissionMRP')}";
        confirmActionForEdit(msg, url, gridMCRSSubmission);
    }
    function dashboardSubmission() {
        if (executeCommonPreConditionForSelectKendo(gridMCRSSubmission, 'month') == false) {
            return;
        }
        var isSubmitted = getSelectedValueFromGridKendo(gridMCRSSubmission, 'isSubmittedDb');
        if(isSubmitted){
            showInfo('Dashboard already submitted');
            return false;
        }
        var msg = 'Are you sure you have no issue reporting to ED and want to submit the ED Dashboard?';
        if(getSelectedValueFromGridKendo(gridMCRSSubmission, 'issueCount')>0)
            msg = 'Are you sure you want to submit the ED Dashboard?';
        var url = "${createLink(controller: 'pmMcrsLog', action:  'submissionDashBoard')}";
        confirmActionForEdit(msg, url, gridMCRSSubmission);
    }

</script>
