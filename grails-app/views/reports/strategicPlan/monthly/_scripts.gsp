<script type="text/x-kendo-tmpl" id="template1">
    <tr>
        <td width='100%'>#:mission#</td>
    </tr>
</script>
<script language="javascript">
    var month,dropDownService,listViewMission,gridMission,isApplicable = false;

    $(document).ready(function () {
        onLoadInfoPage();
        initListView();
        initGrid();
    });
    function onLoadInfoPage() {
        var str = moment().format('MMMM YYYY');
        $('#month').kendoDatePicker({
            format: "MMMM yyyy",
            parseFormats: ["yyyy-MM-dd"],
            start: "year",
            depth: "year"
        }).data("kendoDatePicker");
        $('#month').val(str);

        initializeForm($("#detailsForm"), onSubmitForm);
        defaultPageTile("Strategic Plan", 'reports/showSpMonthlyPlan');
    }
    function initListView() {
        $("#lstMission").kendoListView({
            autoBind: false,
            dataSource: {
                transport: {
                    read: {
                        url: false, dataType: "json", type: "post"
                    }
                },schema: {
                    type: 'json', data: "mission"
                }
            },
            template: kendo.template($("#template1").html())
        });
        listViewMission = $("#lstMission").data("kendoListView");
    }
    function initGrid(){
        $("#grid").kendoGrid({
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
                    data: "list"
                },
                serverPaging: true,
                serverSorting: true
            },
            autoBind: false,
            height: getGridHeightKendo(),
            sortable: false,
            pageable: false,
            detailInit: objectiveInit,
            dataBound: function() {
                this.expandRow(this.tbody.find("tr.k-master-row").first());
            },
            columns: [
                {
                    field: "sequence",
                    title: "#ID",width:"50px"
                },
                {
                    field: "goal",
                    title: "Goal"
                }
            ]
        });
        gridMission = $("#grid").data("kendoGrid");
    }
    function objectiveInit(e) {
        $("<div/>").appendTo(e.detailCell).kendoGrid({
            dataSource: {
                transport: {
                    read: {
                        url: "${createLink(controller: 'reports', action: 'listSpMonthlyPlan')}?serviceId="+ e.data.serviceId+"&month="+month+"&type=Objectives",
                        dataType: "json",
                        type: "post"
                    }
                },
                schema: {
                    type: 'json',
                    data: "list"
                },
                serverPaging: true,
                serverSorting: true,
                serverFiltering: true,
                pageSize: 10,
                filter: { field: "goalId", operator: "eq", value: e.data.id }
            },
            scrollable: false,
            sortable: false,
            pageable: false,
            detailInit: actionsInit,
            columns: [
                { field: "sequence",title: "#ID", width: "50px" },
                { field: "objective", title:"Objectives" }
            ]
        });
    }
    function actionsInit(e) {
        $("<div/>").appendTo(e.detailCell).kendoGrid({
            dataSource: {
                transport: {
                    read: {
                        url: "${createLink(controller: 'reports', action: 'listSpMonthlyPlan')}?serviceId="+ e.data.serviceId+"&goalId="+
                        e.data.goalId+"&month="+month+"&type=Actions",
                        dataType: "json",
                        type: "post"
                    }
                },
                schema: {
                    type: 'json',
                    data: "list"
                },
                serverPaging: true,
                serverSorting: true,
                serverFiltering: true,
                pageSize: 10,
                filter: { field: "objectiveId", operator: "eq", value: e.data.id }
            },
            scrollable: false,
            sortable: false,
            pageable: false,
            detailInit: sprintsInit,
            columns: [
                { field: "sequence",title: "#ID", width: "50px" },
                { field: "actions", title:"Actions" },
                { field: "meaIndicator", title:"Indicator" },
                { field: "target", title:"Target" },
                { field: "resPerson", title:"Responsible Person" },
                { field: "start", title:"Start Date",
                    template:"#=kendo.toString(kendo.parseDate(start, 'yyyy-MM-dd'), 'MMMM')#"},
                { field: "end", title:"End Date",
                    template:"#=kendo.toString(kendo.parseDate(end, 'yyyy-MM-dd'), 'MMMM')#"},
                { field: "supportDepartment", title:"Support Department" }
            ]
        });
    }
    function sprintsInit(e) {
        $("<div/>").appendTo(e.detailCell).kendoGrid({
            dataSource: {
                transport: {
                    read: {
                        url: "${createLink(controller: 'reports', action: 'listSpMonthlyPlan')}?serviceId="+ e.data.serviceId+
                        "&goalId="+e.data.goalId+"&objectiveId="+e.data.objectiveId+"&month="+month+"&type=Sprints",
                        dataType: "json",
                        type: "post"
                    }
                },
                schema: {
                    type: 'json',
                    data: "list"
                },
                serverPaging: true,
                serverSorting: true,
                serverFiltering: true,
                pageSize: 10,
                filter: { field: "actionsId", operator: "eq", value: e.data.id }
            },
            scrollable: false,
            sortable: false,
            pageable: false,
            columns: [
                { field: "sequence",title: "#ID", width: "70px" },
                { field: "sprints", title:"Sprints" },
                { field: "target", title:"Target" },
                { field: "startDate", title:"Start Date",
                    template:"#=kendo.toString(kendo.parseDate(startDate, 'yyyy-MM-dd'), 'dd-MM-yy')#"},
                { field: "endDate", title:"End Date",
                    template:"#=kendo.toString(kendo.parseDate(endDate, 'yyyy-MM-dd'), 'dd-MM-yy')#"},
                { field: "resPerson", title:"Responsible Person" }
            ]
        });
    }
    function onSubmitForm() {
        month = $('#month').val();
        var serviceId = dropDownService.value();
        if(serviceId==''){
            showError('Please select any service');
            return false;
        }
        var urlMission ="${createLink(controller: 'reports', action: 'listSpMonthlyPlan')}?serviceId=" + serviceId+"&month="+month+"&type=Mission";
        var url ="${createLink(controller: 'reports', action: 'listSpMonthlyPlan')}?serviceId=" + serviceId+"&month="+month+"&type=Goals";
        populateGridKendo(listViewMission,urlMission);
        populateGridKendo(gridMission, url);
        return false;
    }
</script>