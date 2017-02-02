<div id="application_top_panel" class="panel panel-primary">
    <div class="panel-heading">
        <div class="panel-title">
            MCRS Submission
        </div>
    </div>

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
    <sec:access url="/pmMcrsLog/submission">
        <li onclick="mcrsSubmission();"><i class="fa fa-edit"></i>Submit</li>
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
                        isSubmitted: {type: "boolean"},
                        isEditable: {type: "boolean"},
                        year: {type: "number"},
                        monthStr: {type: "string"},
                        month: {type: "number"}
                    }
                },
                parse: function (data) {
                    checkIsErrorGridKendo(data);
                    return data;
                }
            },
            sort: {field: 'id', dir: 'asc'},
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
                    field: "monthStr", title: "Month", width: 50, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()}
                },
                {
                    field: "isSubmitted", title: "Submitted", width: 50, sortable: false,
                    filterable: false, attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                    template: "#=isSubmitted?'YES':'NO'#"
                },
                {
                    field: "submissionDate",title: "Submission Date",
                    width: 50, sortable: false,filterable: false,
                    template: "#=isSubmitted?kendo.toString(kendo.parseDate(submissionDate, 'yyyy-MM-dd'), 'dd-MM-yyyy'):''#",
                    attributes: {style: setAlignCenter()},
                    headerAttributes: {style: setAlignCenter()}
                },
                {
                    field: "isEditable", title: "Editable", width: 50, sortable: false,
                    filterable: false,attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                    template: "#=isEditable?'YES':'NO'#"
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

    function mcrsSubmission() {
        if (executeCommonPreConditionForSelectKendo(gridMCRSSubmission, 'mcrs') == false) {
            return;
        }
        var isSubmitted = getSelectedValueFromGridKendo(gridMCRSSubmission, 'isSubmitted');
        if(isSubmitted){
            showInfo('MCRS already submitted');
            return false;
        }
        var msg = 'Are you sure you want to submit the selected MCRS?',
                url = "${createLink(controller: 'pmMcrsLog', action:  'submission')}";
        confirmActionForEdit(msg, url, gridMCRSSubmission);
    }

</script>
