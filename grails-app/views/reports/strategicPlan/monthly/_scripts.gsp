<script type="text/x-kendo-tmpl" id="template1">
    <tr>
        <td width='100%'>#:mission#</td>
    </tr>
</script>
<script type="text/x-kendo-tmpl" id="template2">
    <tr>
        <td width='5%'>#:sl#</td>
        <td width='95%'>#:goal#</td>
    </tr>
</script>
<script type="text/x-kendo-tmpl" id="template3">
    <tr>
        <td width='5%'>#:sl#</td>
        <td width='90%'>#:objective#</td>
        <td>#:weight#</td>
    </tr>
</script>
<script type="text/x-kendo-tmpl" id="template4">
    <tr>
        <td width='3%'>#:sl#</td>
        <td width='20%'>#:action#</td>
        <td>#:weight#</td>
        <td>#:meaIndicator#</td>
        <td>#:target#</td>
        <td>#:resPerson#</td>
        <td>#:startDate#</td>
        <td>#:endDate#</td>
        <td>#:supportDepartment#</td>
    </tr>
</script>
<script type="text/x-kendo-tmpl" id="template5">
    <tr>
        <td width='5%'>#:sl#</td>
        <td width='95%'>#:sprint#</td>
    </tr>
</script>
<script language="javascript">
    var month,dropDownService,isApplicable = false;
    var listViewMission,listViewGoal,listViewObjective,listViewAction,listViewSprint;

    $(document).ready(function () {
        onLoadInfoPage();
        initListView();
    });
    function onLoadInfoPage() {
        var str = moment().format('MMMM YYYY');
        month = $('#month').kendoDatePicker({
            format: "MMMM yyyy",
            parseFormats: ["yyyy-MM-dd"],
            start: "year",
            depth: "year"
        }).data("kendoDatePicker");
        month.value(str);

        initializeForm($("#detailsForm"), onSubmitForm);
        defaultPageTile("Strategic Plan", 'reports/showSpMonthlyPlan');
    }
    function initDataSource(){
        var ds = new kendo.data.DataSource({
            transport: {
                read: {
                    url: false, dataType: "json", type: "post"
                }
            },schema: {
                type: 'json', data: "list",
                parse: function (data) {
                    checkIsErrorGridKendo(data);
                    return data;
                }
            }
        });
        return ds;
    }
    function initListView(){
        $("#lstMission").kendoListView({
            autoBind: false,
            dataSource: initDataSource(),
            template: kendo.template($("#template1").html())
        });
        listViewMission = $("#lstMission").data("kendoListView");
        $("#lstGoal").kendoListView({
            autoBind: false,
            dataSource: initDataSource(),
            template: kendo.template($("#template2").html())
        });
        listViewGoal = $("#lstGoal").data("kendoListView");
        $("#lstObjective").kendoListView({
            autoBind: false,
            dataSource: initDataSource(),
            template: kendo.template($("#template3").html())
        });
        listViewObjective = $("#lstObjective").data("kendoListView");
        $("#lstAction").kendoListView({
            autoBind: false,
            dataSource: initDataSource(),
            template: kendo.template($("#template4").html())
        });
        listViewAction = $("#lstAction").data("kendoListView");
        $("#lstSprint").kendoListView({
            autoBind: false,
            dataSource: initDataSource(),
            template: kendo.template($("#template5").html())
        });
        listViewSprint = $("#lstSprint").data("kendoListView");
    }

    function onSubmitForm() {
        var month = $('#month').val();
        var serviceId = dropDownService.value();
        if(serviceId==''){
            showError('Please select any service');
            return false;
        }
        var url1 ="${createLink(controller: 'reports', action: 'listSpMonthlyPlan')}?serviceId=" + serviceId+"&month="+month+"&type=Mission";
        var url2 ="${createLink(controller: 'reports', action: 'listSpMonthlyPlan')}?serviceId=" + serviceId+"&month="+month+"&type=Goals";
        var url3 ="${createLink(controller: 'reports', action: 'listSpMonthlyPlan')}?serviceId=" + serviceId+"&month="+month+"&type=Objectives";
        var url4 ="${createLink(controller: 'reports', action: 'listSpMonthlyPlan')}?serviceId=" + serviceId+"&month="+month+"&type=Actions";
        var url5 ="${createLink(controller: 'reports', action: 'listSpMonthlyPlan')}?serviceId=" + serviceId+"&month="+month+"&type=Sprints";
        populateGridKendo(listViewMission,url1);
        populateGridKendo(listViewGoal,url2);
        populateGridKendo(listViewObjective,url3);
        populateGridKendo(listViewAction,url4);
        populateGridKendo(listViewSprint,url5);

        $('#collapseFour').collapse('show');
        return false;
    }
    function downloadDetails() {
        if (isApplicable) {
            showLoadingSpinner(true);
            var from = $('#from').val();
            var to = $('#to').val();
            var hospitalCode = dropDownHospitalCode.value();
            var params = "?from=" + from + "&to=" + to + "&hospitalCode=" + hospitalCode;
            var  msg = 'Do you want to download the report now?',
                    url = "${createLink(controller: 'reports', action: 'downloadMonthlyPathologySummary')}" + params;

            confirmDownload(msg, url);
        } else {
            showError('this feature is under development');
//            showError('No record to download');
        }
        return false;
    }
</script>
