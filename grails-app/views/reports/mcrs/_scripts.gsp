<style type="text/css">
.selected-value {
    display: inline-block;
    vertical-align: middle;
    width: 15px;
    height: 15px;
    background-size: 100%;
    margin-right: 5px;
    border-radius: 50%;
}
</style>
<script language="javascript">
    var serviceId,dataSource,gridMRP,gridMRPAddi,dropDownIndicatorType,dropDownIndicatorLight,isApplicable=false;
    var tmp1='',tmp2='',tmp3='',tmp4='',tmp5='',tmp6='',tmp7='',tmp8='';

    $(document).ready(function () {
        onLoadInfoPage();
        initGrid();
        initGridAdditional();
        activeTab('menu1');
    });
    function onLoadInfoPage() {
        if(!${isSysAdmin} && !${isTopMan} && !${isSpAdmin}){
            dropDownService.value(${serviceId});
            dropDownService.readonly(true);
        }
        if(${isTopMan} || ${isSysAdmin}){
            isApplicable = true;
        }
        var str = moment().subtract(1, 'months').format('MMMM YYYY');
        var submissionDate='${submissionDate}';
        $('#month').kendoDatePicker({
            format: "MMMM yyyy",
            parseFormats: ["yyyy-MM-dd"],
            start: "year",
            depth: "year"
        }).data("kendoDatePicker");
        if(submissionDate!='') {
            $('#month').val(moment(submissionDate).format('MMMM YYYY'));
        }else{
            $('#month').val(str);
        }
        $('#indicatorType').kendoDropDownList({
            dataSource: {
                data: ["All Indicator", "Action Indicator", "Preferred Indicator"]
            }
        });
        dropDownIndicatorType = $("#indicatorType").data("kendoDropDownList");

        $("#indicatorLight").kendoDropDownList({
            dataTextField: "text",
            dataValueField: "value",
            valueTemplate: '<img src="images/#:data.img#.ico" style="height: 15px;"><span>&nbsp;#: data.text #</span>',
            template: '<img src="images/#:data.img#.ico" style="height: 15px;"><span class="k-state-default">&nbsp;#: data.text #</span>',
            dataSource: {
                transport: {
                    read: {
                        dataType: "json",
                        url: "${createLink(controller: 'login', action: 'listIndicatorLight')}"
                    }
                },
                schema: {
                    type: 'json',
                    data: "data"
                }
            },
            dataBound: function() {
                this.select(0);
            }
        });
        dropDownIndicatorLight = $("#indicatorLight").data("kendoDropDownList");

        initializeForm($("#detailsForm"), null);
        defaultPageTile("Strategic Plan", 'reports/showMcrs');
    }
    function activeTab(tab){
        $('.nav-tabs a[href="#' + tab + '"]').tab('show');
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
        $("#gridMRP").kendoGrid({
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
                            serviceId: {editable: false, type: "number"},
                            indicator_id: {editable: false, type: "number"},
                            sequence: {editable: false,type: "string"},
                            actions: {editable: false,type: "string"},
                            start: {editable: false,type: "date"},
                            end: {editable: false,type: "date"},
                            is_preference: {editable: true,type: "boolean"},
                            goal: {editable: false, type: "string"},
                            indicator: {editable: false, type: "string"},
                            tot_tar: {editable: false, type: "number"},
                            mon_tar: {editable: false, type: "string"},
                            mon_acv: {editable: false, type: "string"},
                            mon_var: {editable: false, type: "string"},
                            cum_tar: {editable: false, type: "string"},
                            cum_acv: {editable: false, type: "string"},
                            remarks: {editable: false, type: "string"},
                            ind_remarks: {editable: false, type: "string"},
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
            dataBound   : dataBoundGrid,
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
                    field: "start", title: "Date<br/>Range", width: 80, sortable: false, filterable: false,
                    headerAttributes: {style: setAlignCenter()},attributes: {style: setAlignCenter()},
                    template: "#=omitRepeated3(sequence,formatDateRange(kendo.toString(kendo.parseDate(start, 'yyyy-MM-dd'), 'MMM'),kendo.toString(kendo.parseDate(end, 'yyyy-MM-dd'), 'MMM')))#"
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
                    title: "Cumulative", headerAttributes: {style: setAlignCenter()},
                    columns: [
                        {
                            field: "cum_tar", title: "Tar",
                            width: 60, sortable: false, filterable: false,
                            headerAttributes: {style: setAlignCenter()},
                            attributes: {style: setAlignCenter()},
                            template: "#=formatCumulativeIndicator(indicator_type,cum_tar)#"
                        },
                        {
                            field: "cum_acv", title: "Acv",
                            width: 60, sortable: false, filterable: false,
                            headerAttributes: {style: setAlignCenter()},
                            attributes: {style: setAlignCenter()},
                            template: "#=formatCumulativeIndicator(indicator_type,cum_acv)#"
                        },
                        {
                            field: "cum_acv", title: "Var",
                            width: 60, sortable: false, filterable: false,
                            headerAttributes: {style: setAlignCenter()},
                            attributes: {style: setAlignCenter()},
                            template: "#=calculateVariance(cum_tar,cum_acv)#"
                        }
                    ]
                },
                {
                    title: "Monthly", headerAttributes: {style: setAlignCenter()},
                    columns: [
                        {
                            field: "mon_tar", title: "Tar",
                            width: 60, sortable: false, filterable: false,
                            headerAttributes: {style: setAlignCenter()},
                            attributes: {style: setAlignCenter()},
                            template: "#=formatIndicator(indicator_type,mon_tar)#"
                        },
                        {
                            field: "mon_acv", title: "Acv",
                            width: 60, sortable: false, filterable: false,
                            headerAttributes: {style: setAlignCenter()},
                            attributes: {style: setAlignCenter()},
                            template: "#=formatIndicator(indicator_type,mon_acv)#"
                        },
                        {
                            field: "mon_var", title: "Var",
                            width: 60, sortable: false, filterable: false,
                            headerAttributes: {style: setAlignCenter()},
                            attributes: {style: setAlignCenter()},
                            template: "#=calculateVariance(mon_tar,mon_acv)#"
                        }
                    ]
                },
                {
                    field: "ind_remarks", title: "Indicator Remarks",
                    template: "#=trimTextForKendo(ind_remarks,70)#",
                    width: 200, sortable: false,filterable: false
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
            ],
            editable: "inline"
        });
        gridMRP = $("#gridMRP").data("kendoGrid");
    }
    function dataBoundGrid(e) {
        var grid = e.sender;
        var data = grid.dataSource.data();
        $.each(data, function (i, row) {
            if(row.is_preference){
                $('tr[data-uid="' + row.uid + '"] ').css("color", "#00994C");
            }
        });
    }
    function formatDateRange(start,end){
        return start + ' ~ ' + end;
    }
    function initGridAdditional() {
        $("#gridMRPAddi").kendoGrid({
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
                    data: "lstAddi",
                    model: {
                        fields: {
                            id: {type: "number"},
                            indicator_id: {type: "number"},
                            goal: {type: "string"},
                            sequence: {type: "string"},
                            actions: {type: "string"},
                            remarks: {type: "string"},
                            start: {type: "date"},
                            end: {type: "date"},
                            indicator: {type: "string"},
                            responsiblePerson: {type: "string"},
                            supportDepartment: {type: "string"},
                            project: {type: "string"}
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
                {field: "indicator", title: "Indicator", width: 200, sortable: false, filterable: false},
                {field: "target,", title: "Achievement", width: 100, sortable: false, filterable: false,
                    headerAttributes: {style: setAlignCenter()},attributes: {style: setAlignCenter()},
                    template:"#=formatIndicator(indicator_type,target)#"
                },
                {
                    field: "remarks", title: "Remarks",
                    template: "#=trimTextForKendo(omitRepeated3(sequence,remarks),70)#",
                    width: 200, sortable: false,filterable: false
                },
                {field: "responsiblePerson", title: "Responsible Person", width: 200, sortable: false, filterable: false,
                    template:"#=omitRepeated4(sequence,responsiblePerson)#"
                },
                {
                    field: "supportDepartment", title: "Support Department", width: 150,
                    sortable: false, filterable: false,template:"#=trimTextForKendo(omitRepeated5(sequence,supportDepartment),50)#"
                },
                {field: "project", title: "Project", width: 150, sortable: false, filterable: false,
                    template:"#=omitRepeated6(sequence,project)#"
                }
            ]
        });
        gridMRPAddi = $("#gridMRPAddi").data("kendoGrid");
    }

    $("#gridMRP .k-grid-content").on("change", "input.chkbx", function(e) {
        var grid = $("#gridMRP").data("kendoGrid"),
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
        if(isNaN(tar) || isNaN(ach) || tar == 0 || tar=='N/A'|| ach=='N/A'){
            perc="N/A";
        }else{
            perc = Math.round(((ach/tar) * 100).toFixed(1)-100);
            if (perc >= -100 && perc <= -50) {
                return '<span style="font-weight :bold;color: #ff0000" >'+ perc + ' %' + '</span>';
            }else if(perc >= -49 && perc <= -1){
                return '<span style="font-weight :bold;color: #ff8a00" >'+ perc + ' %' + '</span>';
            }else{
                return '<span style="font-weight :bold;color: #069302" >'+ perc + ' %' + '</span>';
            }
        }
        return perc;
    }
    function formatCumulativeIndicator(indicatorType,target){
        if(indicatorType.match('Repeatable')){
            return target + ' % ';
        }
        if(indicatorType.match('%')){
            return target + ' % ';
        }
        return target
    }
    function formatIndicator(indicatorType,target){
        if(indicatorType.match('%')){
            return target + ' % ';
        }
        return target
    }
    $("#create").click(onSubmitMCRSForm);
    $("#reset").click(onSubmitMCRSForm);
    function onSubmitMCRSForm(e) {
        var filterType = this.id;
        tmp1='',tmp2='',tmp3='',tmp4='',tmp5='',tmp6='',tmp7='', tmp8='';
        var month = $('#month').val();
        var serviceId = dropDownService.value();
        var indicatorType = dropDownIndicatorType.value();
        var indicatorLight = dropDownIndicatorLight.value();
        if(serviceId==''){
            showError('Please select any service');
            return false;
        }
        if(filterType=='reset' && indicatorType=='Preferred Indicator'){
            gridMRP.showColumn(3);
        }else{
            gridMRP.hideColumn(3);
        }
        var params = "?serviceId=" +serviceId+"&month="+month+"&indicatorType="+indicatorType+"&indicatorLight="+indicatorLight+"&filterType="+filterType;
        var url ="${createLink(controller: 'reports', action: 'listMcrs')}" + params;
        populateGridKendo(gridMRP, url);
        populateGridKendo(gridMRPAddi, url);

        /*
         var dashboard =" ${createLink(controller: 'edDashboard', action: 'list')}?serviceId=" + serviceId+
         "&month="+month+"&template=/reports/mcrs/ViewED";
         jQuery.ajax({
         type: 'post',
         url: dashboard,
         success: function (data, textStatus) {
         $('#tableData').html('');
         $('#tableData').html(data.tableHtml);
         },
         error: function (XMLHttpRequest, textStatus, errorThrown) {
         },
         complete: function (XMLHttpRequest, textStatus) {
         }

         });*/
        return false;
    };

    $("#gridMRPAddi").kendoTooltip({
        filter: "td:nth-child(1)",
        width: 300,
        position: "top",
        content: function(e){
            var dataItem = $("#gridMRPAddi").data("kendoGrid").dataItem(e.target.closest("tr"));
            return dataItem.goal;
        }
    }).data("kendoTooltip");
    $("#gridMRPAddi").kendoTooltip({
        show: function(e){
            if(this.content.text().length > 70){
                this.content.parent().css("visibility", "visible");
            }
        },
        hide:function(e){
            this.content.parent().css("visibility", "hidden");
        },
        filter: "td:nth-child(5)",
        width: 300,
        position: "top",
        content: function(e){
            var dataItem = $("#gridMRPAddi").data("kendoGrid").dataItem(e.target.closest("tr"));
            return dataItem.remarks;
        }
    }).data("kendoTooltip");

    $("#gridMRP").kendoTooltip({
        filter: "td:nth-child(1)",
        width: 300,
        position: "top",
        content: function(e){
            var dataItem = $("#gridMRP").data("kendoGrid").dataItem(e.target.closest("tr"));
            return dataItem.goal;
        }
    }).data("kendoTooltip");
    $("#gridMRP").kendoTooltip({
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
            var dataItem = $("#gridMRP").data("kendoGrid").dataItem(e.target.closest("tr"));
            return dataItem.ind_remarks;
        }
    }).data("kendoTooltip");
    $("#gridMRP").kendoTooltip({
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
            var dataItem = $("#gridMRP").data("kendoGrid").dataItem(e.target.closest("tr"));
            return dataItem.remarks;
        }
    }).data("kendoTooltip");

    $("#gridMRP").kendoTooltip({
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
            var dataItem = $("#gridMRP").data("kendoGrid").dataItem(e.target.closest("tr"));
            return dataItem.supportDepartment;
        }
    }).data("kendoTooltip");
    $("#gridMRP").kendoTooltip({
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
            var dataItem = $("#gridMRP").data("kendoGrid").dataItem(e.target.closest("tr"));
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

    function downloadMcrsReport() {
        var checked = document.querySelector('input[name="downloadType"]:checked').value;
        var month = $('#month').val();
        var serviceId = dropDownService.value();
        var indicatorType = dropDownIndicatorType.value();
        if(month==''||serviceId==''){
            showError('Please select month & service');
            return false;
        }
        showLoadingSpinner(true);
        var msg = 'Do you want to download the MCRS report now?',
                params = "?serviceId=" +serviceId+"&month="+month+"&indicatorType="+indicatorType+"&checked="+checked,
                url = "${createLink(controller: 'reports', action:  'downloadMcrs')}" + params;
        confirmDownload(msg, url);
        return false;
    }
</script>
