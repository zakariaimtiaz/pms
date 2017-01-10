<script language="javascript">
    var serviceId,dataSource,gridAction,isApplicable = false;
    var tmp1='',tmp2='',tmp3='',tmp4='',tmp5='',tmp6='',tmp7='',tmp8='';

    $(document).ready(function () {
        onLoadInfoPage();
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
        defaultPageTile("Strategic Plan", 'reports/showSpPlan');
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
            height: getGridHeightKendo() - 50,
            sortable: false,
            pageable: false,
            columns: [
                {
                    field: "sequence", title: "ID#", width: 40, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                    template:"#=omitRepeated1(sequence,sequence)#"
                },
                {field: "actions", title: "Action", width: 250, sortable: false, filterable: false,
                    template:"#=omitRepeated2(sequence,actions)#"
                },
                {
                    field: "start", title: "Start Date", width: 80, sortable: false, filterable: false,
                    template: "#=omitRepeated3(sequence,kendo.toString(kendo.parseDate(start, 'yyyy-MM-dd'), 'MMMM'))#"
                },
                {
                    field: "end", title: "End Date", width: 80, sortable: false, filterable: false,
                    template: "#=omitRepeated4(sequence,kendo.toString(kendo.parseDate(end, 'yyyy-MM-dd'), 'MMMM'))#"
                },
                {field: "indicator", title: "Indicator", width: 150, sortable: false, filterable: false},
                {field: "tot_tar", title: "Total<br/>Target", width: 80, sortable: false, filterable: false,
                    headerAttributes: {style: setAlignCenter()},attributes: {style: setAlignCenter()},
                    template:"#=formatIndicator(indicator_type,tot_tar)#"
                },
                {
                    title: "Monthly", headerAttributes: {style: setAlignCenter()},
                    columns: [
                        {
                            field: "mon_tar", title: "Target",
                            width: 70, sortable: false, filterable: false,
                            headerAttributes: {style: setAlignRight()},
                            attributes: {style: setAlignRight()},
                            template: "#=formatIndicator(indicator_type,mon_tar,'mon')#"
                        },
                        {
                            field: "mon_acv", title: "Achievement",
                            width: 90, sortable: false, filterable: false,
                            headerAttributes: {style: setAlignRight()},
                            attributes: {style: setAlignRight()},
                            template: "#=formatIndicator(indicator_type,mon_acv,'mon')#"
                        },
                        {
                            field: "mon_acv", title: "Variance",
                            width: 70, sortable: false, filterable: false,
                            headerAttributes: {style: setAlignRight()},
                            attributes: {style: setAlignRight()},
                            template: "#=calculateVariance(mon_tar,mon_acv)#"
                        }
                    ]
                },
                {
                    title: "Cumulative", headerAttributes: {style: setAlignCenter()},
                    columns: [
                        {
                            field: "cum_tar", title: "Target",
                            width: 70, sortable: false, filterable: false,
                            headerAttributes: {style: setAlignRight()},
                            attributes: {style: setAlignRight()},
                            template: "#=formatIndicator(indicator_type,cum_tar,'cum')#"
                        },
                        {
                            field: "cum_acv", title: "Achievement",
                            width: 90, sortable: false, filterable: false,
                            headerAttributes: {style: setAlignRight()},
                            attributes: {style: setAlignRight()},
                            template: "#=formatIndicator(indicator_type,cum_acv,'cum')#"
                        },
                        {
                            field: "cum_acv", title: "Variance",
                            width: 70, sortable: false, filterable: false,
                            headerAttributes: {style: setAlignRight()},
                            attributes: {style: setAlignRight()},
                            template: "#=calculateVariance(cum_tar,cum_acv)#"
                        }
                    ]
                },
                {
                    field: "remarks", title: "Remarks",
                    template: "#=trimTextForKendo(omitRepeated8(sequence,remarks),70)#",
                    width: 200, sortable: false,filterable: false
                },
                {field: "responsiblePerson", title: "Responsible Person", width: 200, sortable: false, filterable: false,
                    template:"#=omitRepeated5(sequence,responsiblePerson)#"
                },
                {
                    field: "supportDepartment", title: "Support Department", width: 150,
                    sortable: false, filterable: false,template:"#=trimTextForKendo(omitRepeated6(sequence,supportDepartment),50)#"
                },
                {field: "project", title: "Project", width: 150, sortable: false, filterable: false,
                    template:"#=trimTextForKendo(omitRepeated7(sequence,project),50)#"
                }
            ]
        });
        gridAction = $("#grid").data("kendoGrid");
    }

    function calculateVariance(tar,ach){
        var perc="";
        if(isNaN(tar) || isNaN(ach) || tar == 0){
            perc="N/A";
        }else{
            perc = (((ach/tar) * 100).toFixed(1)-100);
            if(perc < 0) {
                return '<span style="color: #ff0000" >'+ perc + ' %' + '</span>';
            }else{
                return perc + ' %';
            }
        }
        return perc;
    }
    function formatIndicator(indicatorType,target,type){
        if(type=='cum') {
            if(!target) return ''
            if(indicatorType.match('%')){
                return target + ' % ';
            }
            return target
        }else{
            if(indicatorType.match('%')){
                return target + ' % ';
            }
            return target
        }
    }
    function onSubmitForm() {
        tmp1='',tmp2='',tmp3='',tmp4='',tmp5='',tmp6='',tmp7='',tmp8='';
        var month = $('#month').val();
        var serviceId = dropDownService.value();
        if(serviceId==''){
            showError('Please select any service');
            return false;
        }
        var url ="${createLink(controller: 'reports', action: 'listCompiledSP')}?serviceId=" + serviceId+"&month="+month;
        populateGridKendo(gridAction, url);
        return false;
    }
    $("#grid").kendoTooltip({
        filter: "td:nth-child(1)",
        width: 300,
        position: "top",
        content: function(e){
            var dataItem = $("#grid").data("kendoGrid").dataItem(e.target.closest("tr"));
            return dataItem.goal;
        }
    }).data("kendoTooltip");
    $("#grid").kendoTooltip({
        show: function(e){
            if(this.content.text().length > 3){
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
            var dataItem = $("#grid").data("kendoGrid").dataItem(e.target.closest("tr"));
            return dataItem.ind_remarks;
        }
    }).data("kendoTooltip");
    $("#grid").kendoTooltip({
        show: function(e){
            if(this.content.text().length > 70){
                this.content.parent().css("visibility", "visible");
            }
        },
        hide:function(e){
            this.content.parent().css("visibility", "hidden");
        },
        filter: "td:nth-child(13)",
        width: 300,
        position: "top",
        content: function(e){
            var dataItem = $("#grid").data("kendoGrid").dataItem(e.target.closest("tr"));
            return dataItem.remarks;
        }
    }).data("kendoTooltip");

    $("#grid").kendoTooltip({
        show: function(e){
            if(this.content.text().length > 50){
                this.content.parent().css("visibility", "visible");
            }
        },
        hide:function(e){
            this.content.parent().css("visibility", "hidden");
        },
        filter: "td:nth-child(15)",
        width: 300,
        position: "top",
        content: function(e){
            var dataItem = $("#grid").data("kendoGrid").dataItem(e.target.closest("tr"));
            return dataItem.supportDepartment;
        }
    }).data("kendoTooltip");
    $("#grid").kendoTooltip({
        show: function(e){
            if(this.content.text().length > 50){
                this.content.parent().css("visibility", "visible");
            }
        },
        hide:function(e){
            this.content.parent().css("visibility", "hidden");
        },
        filter: "td:nth-child(16)",
        width: 300,
        position: "top",
        content: function(e){
            var dataItem = $("#grid").data("kendoGrid").dataItem(e.target.closest("tr"));
            return dataItem.project;
        }
    }).data("kendoTooltip");
    function omitRepeated1(seq,val){
        if(tmp1==seq){return ''}
        tmp1 = seq;
        return val;
    }
    function omitRepeated2(seq,val){
        if(tmp2==seq){return ''}
        tmp2 = seq;
        return val;
    }
    function omitRepeated3(seq,val){
        if(tmp3==seq){return ''}
        tmp3 = seq;
        return val;
    }
    function omitRepeated4(seq,val){
        if(tmp4==seq){return ''}
        tmp4 = seq;
        return val;
    }
    function omitRepeated5(seq,val){
        if(tmp5==seq || val== null){return ''}
        tmp5 = seq;
        return val;
    }
    function omitRepeated6(seq,val){
        if(tmp6==seq || val== null){return ''}
        tmp6 = seq;
        return val;
    }
    function omitRepeated7(seq,val){
        if(tmp7==seq || val== null){return ''}
        tmp7 = seq;
        return val;
    }
    function omitRepeated8(seq,val){
        if(tmp8==seq || val== null){return ''}
        tmp8 = seq;
        return val;
    }

    function downloadALlIndicatorReport() {
        showLoadingSpinner(true);
        var msg = 'Do you want to download the SP report now?',
                url = "${createLink(controller: 'reports', action:  'downloadCompiledSP')}";
        confirmDownload(msg, url);
        return false;
    }
</script>
