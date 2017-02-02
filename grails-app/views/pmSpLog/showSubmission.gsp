<div id="application_top_panel" class="panel panel-primary">
    <div class="panel-heading">
        <div class="panel-title">
            SP Submission
        </div>
    </div>

    <div class="panel-body">
            <div id="gridSpSubmission"></div>
    </div>
</div>
<style type="text/css">
    .panel-body {
        padding: 0px;
    }
</style>
<script type="text/x-kendo-template" id="gridToolbar">
<ul id="menuGrid2" class="kendoGridMenu">
    <sec:access url="/pmSpLog/submission">
        <li onclick="spSubmission();"><i class="fa fa-edit"></i>Submit</li>
    </sec:access>
</ul>
</script>
<script language="javascript">
    var gridSpSubmission, dataSource2, serviceId;

    $(document).ready(function () {
        serviceId = ${serviceId};
        initSpLogGrid();
    });

    function initDataSource() {
        dataSource2 = new kendo.data.DataSource({
            transport: {
                read: {
                    url: "${createLink(controller: 'pmSpLog', action: 'list')}?serviceId="+ serviceId,
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
                        year: {type: "number"},
                        serviceId: {type: "number"},
                        service: {type: "string"},
                        submissionDate: {type: "date"},
                        isSubmitted: {type: "boolean"},
                        isEditable: {type: "boolean"},
                        editTypeIds: {type: "string"},
                        editTypeIdStr: {type: "string"},
                        editableActionIds: {type: "string"}
                    }
                },
                parse: function (data) {
                    checkIsErrorGridKendo(data);
                    return data;
                }
            },
            sort: {field: 'year', dir: 'asc'},
            pageSize: getDefaultPageSize(),
            serverPaging: true,
            serverFiltering: true,
            serverSorting: true
        });
    }

    function initSpLogGrid() {
        initDataSource();
        $("#gridSpSubmission").kendoGrid({
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
                    field: "year", title: "SP Year", width: 50, sortable: false, filterable: false,
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
        gridSpSubmission = $("#gridSpSubmission").data("kendoGrid");
        $("#menuGrid2").kendoMenu();
    }

    function spSubmission() {
        if (executeCommonPreConditionForSelectKendo(gridSpSubmission, 'spLog') == false) {
            return;
        }
        var isSubmitted = getSelectedValueFromGridKendo(gridSpSubmission, 'isSubmitted');
        if(isSubmitted){
            showInfo('SP already submitted');
            return false;
        }
        var msg = 'Are you sure you want to submit the selected SP?',
                url = "${createLink(controller: 'pmSpLog', action:  'submission')}";
        confirmActionForEdit(msg, url, gridSpSubmission);
    }

</script>
