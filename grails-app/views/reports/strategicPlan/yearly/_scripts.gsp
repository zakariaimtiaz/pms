<script type="text/x-kendo-tmpl" id="template1">
    <tr>
        <td>#:mission#</td>
    </tr>
</script>
<script type="text/x-kendo-tmpl" id="template2">
    <tr>
        <td width='5%'>#:sequence#</td>
        <td width='90%'>#:goal#</td>
    </tr>
</script>

<script language="javascript">
    var year,serviceId,departmentName,dataSource,listViewMission,listViewGoal,gridAction,isApplicable = false,detailExportPromises=[],sheet;

    $(document).ready(function () {
        onLoadInfoPage();
        initListView();
        initGrid();
    });
    function onLoadInfoPage() {
        serviceId = ${serviceId};
        departmentName = '${serviceName}';
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
            template: kendo.template($("#template2").html())
        });
        listViewGoal = $("#lstGoal").data("kendoListView");
    }
    function initGrid() {
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
            height: getGridHeightKendo() - 80,
            sortable: false,
            pageable: false,
            detailInit: actionsIndicator,
            columns: [
                {
                    field: "sequence", title: "ID#", width: 40, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()}
                },
                {field: "actions", title: "Action", width: 270, sortable: false, filterable: false},
                {
                    field: "start", title: "Start", width: 80, sortable: false, filterable: false,
                    template: "#=kendo.toString(kendo.parseDate(start, 'yyyy-MM-dd'), 'MMMM')#"
                },
                {
                    field: "end", title: "End", width: 80, sortable: false, filterable: false,
                    template: "#=kendo.toString(kendo.parseDate(end, 'yyyy-MM-dd'), 'MMMM')#"
                },
                {
                    field: "target", title: "target", width: 80, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()}
                },
                {
                    field: "achievement", title: "Achievement", width: 100, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()}
                },
                {
                    field: "note",
                    title: "Remarks",
                    template: "#=trimTextForKendo(note,70)#",
                    width: 190,
                    sortable: false,
                    filterable: false
                },
                {field: "resPerson", title: "Responsible Person", width: 150, sortable: false, filterable: false},
                {
                    field: "supportDepartmentStr", title: "Support Department", width: 150,
                    sortable: false, filterable: false
                },
                {field: "sourceOfFundStr", title: "Project", width: 150, sortable: false, filterable: false}
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
                { field: "indicator",title: "Indicator", width: "190px"},
                { field: "target", title:"Target", width: "100px",attributes: {style: setAlignCenter()},
                    headerAttributes: {style: setAlignCenter()},template:"#=formatIndicator(indicator_type,target)#" },
                { field: "total_achievement", title:"Achievement", width: "100px",
                    template:"#=formatIndicator(indicator_type,total_achievement)#",
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()} },
                {field: "unit_str", title: "Unit", width: "50px"}
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
                { field: "month_name",title: "Month", width: "150px" },
                { field: "target", title:"Monthly Target", width: "100px",
                    attributes: {style: setAlignCenter()},headerAttributes: {style: setAlignCenter()}},
                { field: "achievement", title:"Monthly Achievement", width: "150px",
                    attributes: {style: setAlignCenter()},headerAttributes: {style: setAlignCenter()}},
                { field: "remarks", title:"Remarks" }
            ]
        });
    }

    function formatIndicator(indicatorType,target){
        if(!target) return ''
        if(indicatorType.match('%')){
            return target + ' % ';
        }
        return target
    }
    function onSubmitForm() {
        year = $('#year').val();
        var serviceId = dropDownService.value();
        if(serviceId==''){
            showError('Please select any service');
            return false;
        }
        var urlMission ="${createLink(controller: 'reports', action: 'listSpPlan')}?serviceId=" + serviceId+"&year="+year+"&type=Mission";
        var urlGoal ="${createLink(controller: 'reports', action: 'listSpPlan')}?serviceId=" + serviceId+"&year="+year+"&type=Goals";
        var url ="${createLink(controller: 'reports', action: 'listSpPlan')}?serviceId=" + serviceId+"&year="+year+"&type=Actions";
        populateGridKendo(listViewMission,urlMission);
        populateGridKendo(listViewGoal,urlGoal);
        populateGridKendo(gridAction, url);
        initChildDataSource(serviceId,year);
        return false;
    }
    function initChildDataSource(serviceId,year){
        dataSource = new kendo.data.DataSource({
            transport: {
                read: {
                    url: "${createLink(controller: 'reports', action: 'listSpPlan')}?serviceId="+ serviceId+"&year="+year+"&type=Details",
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
        });
    }

    $("#grid").kendoTooltip({
        filter: "td:nth-child(8)",
        width: 300,
        position: "top",
        content: function(e){
            var dataItem = $("#grid").data("kendoGrid").dataItem(e.target.closest("tr"));
            return dataItem.note;
        }
    }).data("kendoTooltip");
</script>
