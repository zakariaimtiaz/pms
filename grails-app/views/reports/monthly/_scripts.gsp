<script language="javascript">
    var serviceId,dataSource,gridMonthlySP,dropDownIndicatorType,isApplicable=false;
    var tmp1='',tmp2='',tmp3='',tmp4='',tmp5='',tmp6='',tmp7='',tmp8='';

    $(document).ready(function () {
        onLoadInfoPage();
        initGrid();
        $("#gridMonthlySP .k-grid-toolbar").hide();
    });
    function onLoadInfoPage() {
        if(!${isSysAdmin} && !${isTopMan} && !${isSpAdmin}){
            dropDownService.value(${serviceId});
            dropDownService.readonly(true);
        }
        if(${isHOD}){
            isApplicable = true;
        }
        var str = moment().format('MMMM YYYY');

        $('#month').kendoDatePicker({
            format: "MMMM yyyy",
            parseFormats: ["yyyy-MM-dd"],
            start: "year",
            depth: "year"
        }).data("kendoDatePicker");
        $('#month').val(str);

        $('#indicatorType').kendoDropDownList({
            dataSource: {
                data: ["All Indicator", "Action Indicator", "Preferred Indicator"]
            }
        });
        dropDownIndicatorType = $("#indicatorType").data("kendoDropDownList");

        initializeForm($("#detailsForm"), null);
        defaultPageTile("Strategic Plan", 'reports/showSpMonthlyPlan');
    }
    function showResetPreference(){
        var indicatorType = dropDownIndicatorType.value();
        if(indicatorType=='Preferred Indicator' && isApplicable){
            $("#reset").show();
        }else{
            $("#reset").hide();
        }
    }

    function initGrid() {
        $("#gridMonthlySP").kendoGrid({
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
                    data: "list",
                    model: {
                        id: "indicator_id",    // have to set id otherwise remove row by clicking cancel
                        fields: {
                            id: {editable: false, type: "number"},
                            indicator_id: {editable: false, type: "number"},
                            sequence: {editable: false,type: "string"},
                            actions: {editable: false,type: "string"},
                            start: {editable: false,type: "date"},
                            end: {editable: false,type: "date"},
                            is_preference: {editable: true,type: "boolean"},
                            indicator: {editable: false, type: "string"},
                            tot_tar: {editable: false, type: "number"},
                            mon_tar: {editable: false, type: "string"},
                            mon_acv: {editable: false, type: "string"},
                            cum_tar: {editable: false, type: "string"},
                            cum_acv: {editable: false, type: "string"},
                            remarks: {editable: false, type: "string"},
                            responsiblePerson: {editable: false, type: "string"},
                            supportDepartment: {editable: false, type: "string"},
                            project: {editable: false, type: "string"}
                        }
                    }
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
                {
                    field: "is_preference",title: " ",width: 30,
                    template: '<input type="checkbox" class="chkbx" #= is_preference ? "checked=checked" : "" #></input>'
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
                            template: "#=formatIndicator(indicator_type,mon_tar)#"
                        },
                        {
                            field: "mon_acv", title: "Achievement",
                            width: 90, sortable: false, filterable: false,
                            headerAttributes: {style: setAlignRight()},
                            attributes: {style: setAlignRight()},
                            template: "#=formatIndicator(indicator_type,mon_acv)#"
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
                            template: "#=formatIndicator(indicator_type,cum_tar)#"
                        },
                        {
                            field: "cum_acv", title: "Achievement",
                            width: 90, sortable: false, filterable: false,
                            headerAttributes: {style: setAlignRight()},
                            attributes: {style: setAlignRight()},
                            template: "#=formatIndicator(indicator_type,cum_acv)#"
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
            ],
            editable: "inline"
        });
        gridMonthlySP = $("#gridMonthlySP").data("kendoGrid");
    }
    $("#gridMonthlySP .k-grid-content").on("change", "input.chkbx", function(e) {
        var grid = $("#gridMonthlySP").data("kendoGrid"),
        dataItem = grid.dataItem($(e.target).closest("tr"));
        dataItem.set("is_preference", this.checked);
        var param = "?indicatorId="+dataItem.indicator_id+"&isPreference="+dataItem.is_preference;
        jQuery.ajax({
            type: 'post',
            url: "${createLink(controller: 'pmActions', action: 'updatePreference')}" + param,
            success: function (data, textStatus) {
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
            },
            complete: function (XMLHttpRequest, textStatus) {
                showLoadingSpinner(false);
            },
            dataType: 'json'
        });
        return false;
    });
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
    $("#create").click(onSubmitMonForm);
    $("#reset").click(onSubmitMonForm);
    function onSubmitMonForm(e) {
        var filterType = this.id;
        tmp1='',tmp2='',tmp3='',tmp4='',tmp5='',tmp6='',tmp7='',tmp8='';
        var month = $('#month').val();
        var serviceId = dropDownService.value();
        var indicatorType = dropDownIndicatorType.value();
        if(serviceId==''){
            showError('Please select any service');
            return false;
        }
        if(filterType=='reset' && indicatorType=='Preferred Indicator'){
            gridMonthlySP.showColumn(4);
        }else{
            gridMonthlySP.hideColumn(4);
        }
        var params = "?serviceId=" +serviceId+"&month="+month+"&indicatorType="+indicatorType+"&filterType="+filterType;
        var url ="${createLink(controller: 'reports', action: 'listSpMonthlyPlan')}" + params;
        populateGridKendo(gridMonthlySP, url);
        return false;
    };

    $("#gridMonthlySP").kendoTooltip({
        filter: "td:nth-child(1)",
        width: 300,
        position: "top",
        content: function(e){
            var dataItem = $("#gridMonthlySP").data("kendoGrid").dataItem(e.target.closest("tr"));
            return dataItem.goal;
        }
    }).data("kendoTooltip");
    $("#gridMonthlySP").kendoTooltip({
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
            var dataItem = $("#gridMonthlySP").data("kendoGrid").dataItem(e.target.closest("tr"));
            return dataItem.ind_remarks;
        }
    }).data("kendoTooltip");
    $("#gridMonthlySP").kendoTooltip({
        show: function(e){
            if(this.content.text().length > 70){
                this.content.parent().css("visibility", "visible");
            }
        },
        hide:function(e){
            this.content.parent().css("visibility", "hidden");
        },
        filter: "td:nth-child(14)",
        width: 300,
        position: "top",
        content: function(e){
            var dataItem = $("#gridMonthlySP").data("kendoGrid").dataItem(e.target.closest("tr"));
            return dataItem.remarks;
        }
    }).data("kendoTooltip");

    $("#gridMonthlySP").kendoTooltip({
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
            var dataItem = $("#gridMonthlySP").data("kendoGrid").dataItem(e.target.closest("tr"));
            return dataItem.supportDepartment;
        }
    }).data("kendoTooltip");
    $("#gridMonthlySP").kendoTooltip({
        show: function(e){
            if(this.content.text().length > 50){
                this.content.parent().css("visibility", "visible");
            }
        },
        hide:function(e){
            this.content.parent().css("visibility", "hidden");
        },
        filter: "td:nth-child(17)",
        width: 300,
        position: "top",
        content: function(e){
            var dataItem = $("#gridMonthlySP").data("kendoGrid").dataItem(e.target.closest("tr"));
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

    function downloadMonthlySPReport() {
        var checked = document.querySelector('input[name="downloadType"]:checked').value;
        var month = $('#month').val();
        var serviceId = dropDownService.value();
        var indicatorType = dropDownIndicatorType.value();
        if(month==''||serviceId==''){
            showError('Please select month & service');
            return false;
        }
        showLoadingSpinner(true);
        var msg = 'Do you want to download the Monthly SP report now?',
            params = "?serviceId=" +serviceId+"&month="+month+"&indicatorType="+indicatorType+"&checked="+checked,
            url = "${createLink(controller: 'reports', action:  'downloadMonthlySP')}" + params;
        confirmDownload(msg, url);
        return false;
    }
</script>
