<script language="javascript">
    var serviceId,dataSource,gridYearlySP;
    var tmp1='',tmp2='',tmp3='',tmp4='',tmp5='',tmp6='',tmp7='',tmp8='';

    $(document).ready(function () {
        onLoadInfoPage();
        initGrid();
        if(!${isSysAdmin} && !${isTopMan} && !${isSpAdmin} && !${isMultiDept}){
            onSubmitForm();
        }
    });
    function onLoadInfoPage() {
        var data = [];
        if(!${isSysAdmin} && !${isTopMan} && !${isSpAdmin} && !${isMultiDept}){
            dropDownService.value(${serviceId});
//            dropDownService.readonly(true);
            data = ["All Indicator", "Action Indicator"];
        }else{
            data = ["All Indicator", "Action Indicator", "Without Achievement"];
        }
        var str = moment().format('YYYY');
        $('#year').kendoDatePicker({
            format: "yyyy",
            parseFormats: ["yyyy-MM-dd"],
            start: "decade",
            depth: "decade"
        }).data("kendoDatePicker");
        $('#year').val(str);

        $('#indicatorType').kendoDropDownList({
            dataSource: {
                data: data
            }
        });
        dropDownIndicatorType = $("#indicatorType").data("kendoDropDownList");

        initializeForm($("#detailsForm"), onSubmitForm);
        defaultPageTile("Strategic Action Plan", 'reports/showYearlySP');
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
                    template: "#=omitRepeated4(sequence,formatExtendedDateStrike(kendo.toString(kendo.parseDate(end, 'yyyy-MM-dd'), 'MMMM'),extendedEnd))#"

                },
                {field: "indicator", title: "Indicator", width: 150, sortable: false, filterable: false},
                {field: "tot_tar", title: "Target", width: 80, sortable: false, filterable: false,
                    headerAttributes: {style: setAlignCenter()},attributes: {style: setAlignCenter()},
                    template:"#=formatIndicator(indicator_type,tot_tar)#"
                },
                {
                    field: "tot_acv", title: "Achievement",
                    width: 90, sortable: false, filterable: false,
                    headerAttributes: {style: setAlignRight()},
                    attributes: {style: setAlignRight()},
                    template: "#=formatIndicator(indicator_type,tot_acv)#"
                },
                {
                    field: "total_acv", title: "Variance",
                    width: 90, sortable: false, filterable: false,
                    headerAttributes: {style: setAlignRight()},
                    attributes: {style: setAlignRight()},
                    template: "#=calculateVariance(tot_tar,tot_acv)#"
                },
                {
                    field: "remarks", title: "Action Remarks",
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
        gridYearlySP = $("#gridYearlySP").data("kendoGrid");
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
    function onSubmitForm() {
        tmp1='',tmp2='',tmp3='',tmp4='',tmp5='',tmp6='',tmp7='',tmp8='';
        var year = $('#year').val();
        var serviceId = dropDownService.value();
        var indicatorType = dropDownIndicatorType.value();
        if(serviceId==''){
            showError('Please select any service');
            return false;
        }
        if(indicatorType=='Without Achievement') {
            gridYearlySP.hideColumn(6);
            gridYearlySP.hideColumn(7);
        }else {
            gridYearlySP.showColumn(6);
            gridYearlySP.showColumn(7);
        }
        var params = "?serviceId=" +serviceId+"&year="+year+"&indicatorType="+indicatorType;
        var url ="${createLink(controller: 'reports', action: 'listYearlySP')}" + params;
        populateGridKendo(gridYearlySP, url);
        return false;
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
        filter: "td:nth-child(9)",
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
        filter: "td:nth-child(11)",
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
        filter: "td:nth-child(12)",
        width: 300,
        position: "top",
        content: function(e){
            var dataItem = $("#gridYearlySP").data("kendoGrid").dataItem(e.target.closest("tr"));
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

    function downloadYearlySpReport() {
        var checked = document.querySelector('input[name="downloadType"]:checked').value;
        var year = $('#year').val();
        var serviceId = dropDownService.value();
        var indicatorType = dropDownIndicatorType.value();
        if(serviceId==''){
            showError('Please select any service');
            return false;
        }
        showLoadingSpinner(true);
        var msg = 'Do you want to download the yearly SAP report now?',
            params = "?serviceId=" +serviceId+"&year="+year+"&indicatorType="+indicatorType+"&checked="+checked,
            url = "${createLink(controller: 'reports', action:  'downloadYearlySP')}" + params;
        confirmDownload(msg, url);
        return false;
    }
</script>
