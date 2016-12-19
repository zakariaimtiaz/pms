<script type="text/x-kendo-tmpl" id="template1">
    <tr>
        <td width='5%'>#:sequence#</td>
        <td width='90%'>#:goal#</td>
    </tr>
</script>

<script language="javascript">
    var year,serviceId,listViewGoal,gridAction,isApplicable = false;

    $(document).ready(function () {
        onLoadInfoPage();
        initListView();
        initGrid();
    });
    function onLoadInfoPage() {
        serviceId = ${serviceId};
        dropDownService.value(serviceId);
        var str = moment().format('YYYY');

        $('#year').kendoDatePicker({
            format: "yyyy",
            parseFormats: ["yyyy-MM-dd"],
            start: "decade",
            depth: "decade"
        }).data("kendoDatePicker");
        $('#year').val(str);

        initializeForm($("#detailsForm"), onSubmitForm);
        defaultPageTile("Strategic Plan", 'reports/showSpPlan');
    }
    function initListView() {
        $("#lstGoal").kendoListView({
            autoBind: false,
            dataSource: {
                transport: {
                    read: {
                        url: false, dataType: "json", type: "post"
                    }
                },schema: {
                    type: 'json', data: "list"
                }
            },
            template: kendo.template($("#template1").html())
        });
        listViewGoal = $("#lstGoal").data("kendoListView");
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
            height: getGridHeightKendo()-50,
            sortable: false,
            pageable: false,
            detailInit: actionsIndicator,
            columns: [
                {
                    field: "sequence", title: "ID#", width: 40, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()}
                },
                {field: "actions", title: "Action", width: 200, sortable: false, filterable: false},
                {
                    field: "start", title: "Start Date", width: 50, sortable: false, filterable: false,
                    template: "#=kendo.toString(kendo.parseDate(start, 'yyyy-MM-dd'), 'MMMM')#"
                },
                {
                    field: "end", title: "End Date", width: 50, sortable: false, filterable: false,
                    template: "#=kendo.toString(kendo.parseDate(end, 'yyyy-MM-dd'), 'MMMM')#"
                },
                {field: "resPerson", title: "Responsible Person", width: 90, sortable: false, filterable: false},
                {
                    field: "supportDepartmentStr", title: "Support Department", width: 90,
                    sortable: false, filterable: false
                },
                {field: "sourceOfFundStr", title: "Project", width: 80, sortable: false, filterable: false},
                {field: "note", title: "Remarks",template:"#=trimTextForKendo(note,100)#", width: 120, sortable: false, filterable: false}
            ]
        });
        gridAction = $("#grid").data("kendoGrid");
    }

    function actionsIndicator(e) {
        $("<div/>").appendTo(e.detailCell).kendoGrid({
            dataSource: {
                transport: {
                    read: {
                        url: "${createLink(controller: 'reports', action: 'listSpPlan')}?serviceId="+ e.data.serviceId
                        +"&year="+year+"&type=Details",
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
                batch: true,
                pageSize: 50,
                filter: { field: "actionsId", operator: "eq", value: e.data.id }
            },
            selectable: true,
            sortable: false,
            resizable: false,
            reorderable: false,
            filterable: false,
            pageable: false,
            editable: false,
            detailInit: initDetails,
            columns: [
                { field: "indicator",title: "Indicator", width: "220px"},
                { field: "target", title:"Target", width: "100px",attributes: {style: setAlignCenter()},
                    headerAttributes: {style: setAlignCenter()} },
                { field: "total_achievement", title:"Achievement", width: "100px",
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()} }
            ]
        });
    }
    function initDetails(e) {
        $("<div/>").appendTo(e.detailCell).kendoGrid({
            dataSource: {
                transport: {
                    read: {
                        url: "${createLink(controller: 'pmActions', action: 'listDetailsByIndicator')}?actionsId="+ e.data.id,
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
                filter: { field: "indicatorId", operator: "eq", value: e.data.ind_id }
            },
            scrollable: false,
            sortable: false,
            pageable: false,
            columns: [
                { field: "monthName",title: "Month" },
                { field: "target", title:"Monthly Target" },
                { field: "achievement", title:"Monthly Achievement" },
                { field: "remarks", title:"Remarks" }
            ]
        });
    }
    function indicatorDetails(e) {
        $("<div/>").appendTo(e.detailCell).kendoGrid({
            dataSource: {
                transport: {
                    read: {
                        url: "${createLink(controller: 'reports', action: 'listSpPlan')}?serviceId="+ e.data.serviceId+"&actionsId="+e.data.serviceId+
                        "&year="+year+"&type=IndicatorDetails",
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
                filter: { field: "indicatorId", operator: "eq", value: e.data.id }
            },
            scrollable: false,
            sortable: false,
            pageable: false,
            columns: [
                { field: "monthName",title: "Month", width: "50px" },
                { field: "target", title:"Target" },
                { field: "achievement", title:"Achievement" },
                { field: "remarks", title:"Remarks" }
            ]
        });
    }

    function onSubmitForm() {
        year = $('#year').val();
        var serviceId = dropDownService.value();
        if(serviceId==''){
            showError('Please select any service');
            return false;
        }
        var urlGoal ="${createLink(controller: 'reports', action: 'listSpPlan')}?serviceId=" + serviceId+"&year="+year+"&type=Goals";
        var url ="${createLink(controller: 'reports', action: 'listSpPlan')}?serviceId=" + serviceId+"&year="+year+"&type=Actions";
        populateGridKendo(listViewGoal,urlGoal);
        populateGridKendo(gridAction, url);
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
