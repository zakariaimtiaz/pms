<script language="javascript">
    var serviceId,dataSource,gridYearlySP,dropDownIndicatorType;
    var tmp1='',tmp2='',tmp3='',tmp4='',tmp5='',tmp6='',tmp7='',tmp8='';

    $(document).ready(function () {
        onLoadInfoPage();
        initGrid();
        if(!${isSysAdmin} && !${isTopMan} && !${isSpAdmin} && !${isMultiDept}) {
            onSubmitForm();
        }
    });
    function onLoadInfoPage() {
        var data = ["All Indicator", "Action Indicator"];
        if(!${isSysAdmin} && !${isTopMan} && !${isSpAdmin} && !${isMultiDept}){
            dropDownService.value(${serviceId});
            dropDownService.readonly(true);
        }
        var str = moment().format('YYYY');
        $('#year').kendoDatePicker({
            format: "yyyy",
            parseFormats: ["yyyy-MM-dd"],
            start: "decade",
            depth: "decade"
        }).data("kendoDatePicker");
        $('#year').val(str);

        initializeForm($("#detailsForm"), onSubmitForm);
        defaultPageTile("Strategic Action Plan", 'reports/showYearlySPDetails');
    }
    function onSubmitForm() {
        tmp1='',tmp2='',tmp3='',tmp4='',tmp5='',tmp6='',tmp7='',tmp8='';
        var year = $('#year').val();
        var serviceId = dropDownService.value();
        if(serviceId==''){
            showError('Please select any service');
            return false;
        }
        var params = "?serviceId=" +serviceId+"&year="+year;
        var url ="${createLink(controller: 'reports', action: 'listYearlySPDetails')}" + params;
        populateGridKendo(gridYearlySP, url);
        return false;
    }
    function initGrid() {
        $("#gridYearlySP").kendoGrid({
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
            height: getGridHeightKendo() - 50,
            sortable: false,
            pageable: false,
            detailInit: initIndicator,
            dataBound: function () {
                this.expandRow(this.tbody.find("tr.k-master-row"));
            },
            columns: [
                {
                    field: "sequence", title: "ID#", width: 40, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()}
                },
                {field: "actions", title: "Action", width: 250, sortable: false, filterable: false
                },
                {
                    field: "start", title: "Start Date", width: 80, sortable: false, filterable: false
                    ,template: "#=kendo.toString(kendo.parseDate(start, 'yyyy-MM-dd'), 'MMMM')#"
                },
                {
                    field: "end", title: "End Date", width: 80, sortable: false, filterable: false
                    ,template: "#=formatExtendedDateStrike(kendo.toString(kendo.parseDate(end, 'yyyy-MM-dd'), 'MMMM'),extendedEnd)#"
                },
                {
                    field: "remarks", title: "Action Remarks",
                    width: 200, sortable: false,filterable: false
                    ,template: "#=trimTextForKendo(remarks,70)#"

                },
                {field: "responsiblePerson", title: "Responsible Person", width: 200, sortable: false, filterable: false
                },
                {
                    field: "supportDepartment", title: "Support Department", width: 150,
                    sortable: false, filterable: false
                    ,template:"#=trimTextForKendo(supportDepartment,50)#"
                },
                {field: "project", title: "Project", width: 150, sortable: false, filterable: false
                    ,template:"#=trimTextForKendo(project,50)#"
                }
            ]
        });
        gridYearlySP = $("#gridYearlySP").data("kendoGrid");
    }
    function initIndicator(e) {
        $("<div/>").appendTo(e.detailCell).kendoGrid({
            dataSource: {
                transport: {
                    read: {
                        url: "${createLink(controller: 'pmActions', action: 'listIndicatorByActions')}?",
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
                pageSize: 50,
                filter: {field: "actionsId", operator: "eq", value: e.data.action_id}
            },
            scrollable: false,
            sortable: false,
            pageable: false,
            detailInit: initDetails,
            columns: [
                {field: "indicator", title: "Indicator",width: '35%'},
                {field: "target", title: "Target",template:"#=formatIndicator(indicatorType,target)#",width: '10%'},
                {field: "unitStr", title: "Unit",width: '15%'},
                {field: "indicatorType", title: "Indicator Type",width: '10%'},
                {field: "", title: "",width: '30%'}
            ]
        });
    }
    function initDetails(e) {
        var row = e.masterRow[0];
        var indicator = $(row).closest('tr').find('td').eq(1).text();
        var unitStr = e.data.unitStr;
        var target = e.data.target;
        $("<div/>").appendTo(e.detailCell).kendoGrid({
            dataSource: {
                transport: {
                    read: {
                        url: "${createLink(controller: 'pmActions', action: 'listDetailsByIndicator')}?actionsId=" + e.data.actionsId,
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
                filter: {field: "indicator_id", operator: "eq", value: e.data.id}
            },
            scrollable: false,
            sortable: false,
            pageable: false,
            columns: [
                {field: "month_name", title: "Month",width: '10%'},
                {field: "target", title: "Target",template:"#=formatIndicator(indicator_type,target)#",width: '10%'},
                {field: "achievement", title: "Achievement",template:"#=formatIndicatorAcv(month_name,indicator_type,achievement)#",width: '10%'},
                {field: "remarks", title: "Indicator Remarks",width: '70%', encoded: false}
            ]
        });
    }
    function formatIndicatorAcv(month,indicatorType,acv){
        var monthNo = moment().month(month).format("M");
        if(monthNo > moment().month()+1){
            return ''
        }
        if (!acv && (indicatorType.match('%'))){
            return '0 %'
        }else if(!acv && (indicatorType.match('%'))){
            return '0'
        }
        if (indicatorType.match('%')) {
            return acv + ' % ';
        }
        return acv
    }
    function calculateVariance(tar,ach){
        var perc="";
        if(isNaN(tar) || isNaN(ach) || tar == 0){
            perc="N/A";
        }else{
            perc = Math.round(((ach/tar) * 100).toFixed(1)-100);
            if(perc < 0) {
                return '<span style="color: #ff0000" >'+ perc + ' %' + '</span>';
            }else{
                return perc + ' %';
            }
        }
        return perc;
    }
    function formatIndicator(indicatorType,target){
        if(indicatorType.match('%')){
            return target + ' % ';
        }
        return target
    }

    $("#gridYearlySP").kendoTooltip({
        filter: "td:nth-child(1)",
        width: 300,
        position: "top",
        content: function(e){
            var dataItem = $("#gridYearlySP").data("kendoGrid").dataItem(e.target.closest("tr"));
            return dataItem.goal;
        }
    }).data("kendoTooltip");
    $("#gridYearlySP").kendoTooltip({
        show: function(e){
            if(this.content.text().length > 70){
                this.content.parent().css("visibility", "visible");
            }
        },
        hide:function(e){
            this.content.parent().css("visibility", "hidden");
        },
        filter: "td:nth-child(6)",
        width: 300,
        position: "top",
        content: function(e){
            var dataItem = $("#gridYearlySP").data("kendoGrid").dataItem(e.target.closest("tr"));
            return dataItem.remarks;
        }
    }).data("kendoTooltip");
    $("#gridYearlySP").kendoTooltip({
        show: function(e){
            if(this.content.text().length > 50){
                this.content.parent().css("visibility", "visible");
            }
        },
        hide:function(e){
            this.content.parent().css("visibility", "hidden");
        },
        filter: "td:nth-child(8)",
        width: 300,
        position: "top",
        content: function(e){
            var dataItem = $("#gridYearlySP").data("kendoGrid").dataItem(e.target.closest("tr"));
            return dataItem.supportDepartment;
        }
    }).data("kendoTooltip");
    $("#gridYearlySP").kendoTooltip({
        show: function(e){
            if(this.content.text().length > 50){
                this.content.parent().css("visibility", "visible");
            }
        },
        hide:function(e){
            this.content.parent().css("visibility", "hidden");
        },
        filter: "td:nth-child(9)",
        width: 300,
        position: "top",
        content: function(e){
            var dataItem = $("#gridYearlySP").data("kendoGrid").dataItem(e.target.closest("tr"));
            return dataItem.project;
        }
    }).data("kendoTooltip");

    function downloadYearlySpReport() {
        var year = $('#year').val();
        var serviceId = dropDownService.value();
        if(serviceId==''){
            showError('Please select any service');
            return false;
        }
        showLoadingSpinner(true);
        var msg = 'Do you want to download the yearly SAP details report now?',
            params = "?serviceId=" +serviceId+"&year="+year,
            url = "${createLink(controller: 'reports', action:  'downloadYearlySPDetails')}" + params;
        confirmDownload(msg, url);
        return false;
    }
</script>
