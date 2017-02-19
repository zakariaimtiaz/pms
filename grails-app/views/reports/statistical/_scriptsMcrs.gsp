<script language="javascript">
    var gridMCRS, dataSource;

    $(document).ready(function () {
        onLoadMCRSPage();
        initMCRSGrid();
        populateMCRSGrid();
    });

    function onLoadMCRSPage() {
        var str = moment().format('YYYY');
        $('#year').kendoDatePicker({
            format: "yyyy",
            parseFormats: ["yyyy-MM-dd"],
            start: "decade",
            depth: "decade",
            change: populateMCRSGrid
        }).data("kendoDatePicker");
        $('#year').val(str);
        defaultPageTile("MCRS Submission",null);
    }

    function populateMCRSGrid(){
        var year = $('#year').val();
        if(year==''){
            showError('Please select year');
            return false;
        }
        var params = "?year="+year;
        var url ="${createLink(controller: 'reports', action: 'listMcrsStatus')}" + params;
        populateGridKendo(gridMCRS, url);
        return false;
    }

    function initDataSource() {
        dataSource = new kendo.data.DataSource({
            transport: {
                read: {
                    url: false,
                    dataType: "json",
                    type: "post"
                }
            },
            schema: {
                type: 'json',
                model: {
                    fields: {
                        service: { type: "string" },
                        January: { type: "date" },
                        JanuaryD: { type: "date" },
                        February: { type: "date" },
                        FebruaryD: { type: "date" },
                        March: { type: "date" },
                        MarchD: { type: "date" },
                        April: { type: "date" },
                        AprilD: { type: "date" },
                        May: { type: "date" },
                        MayD: { type: "date" },
                        June: { type: "date" },
                        JuneD: { type: "date" },
                        July: { type: "date" },
                        JulyD: { type: "date" },
                        August: { type: "date" },
                        AugustD: { type: "date" },
                        September: { type: "date" },
                        SeptemberD: { type: "date" },
                        October: { type: "date" },
                        OctoberD: { type: "date" },
                        November: { type: "date" },
                        NovemberD: { type: "date" },
                        December: { type: "date" },
                        DecemberD: { type: "date" }
                    }
                },
                parse: function (data) {
                    checkIsErrorGridKendo(data);
                    return data;
                }
            },
            pageSize: 50,
            serverPaging: true,
            serverFiltering: true,
            serverSorting: true
        });
    }

    function initMCRSGrid() {
        initDataSource();
        $("#gridMCRS").kendoGrid({
            autoBind: false,
            dataSource: dataSource,
            height: getGridHeightKendo(),
            selectable: true,
            sortable: true,
            resizable: true,
            reorderable: true,
            pageable: false,
            columns: [
                {field: "service", title: "CSU/Sector", width: 150, sortable: false, filterable: false},
                {field: "January", title: "January", width: 80, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                    template:"#=checkDeadLine(January,JanuaryD)#"
                },
                {field: "February", title: "February", width: 80, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                    template:"#=checkDeadLine(February,FebruaryD)#"
                },
                {field: "March", title: "March", width: 80, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                    template:"#=checkDeadLine(March,MarchD)#"
                },
                {field: "April", title: "April", width: 80, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                    template:"#=checkDeadLine(April,AprilD)#"
                },
                {field: "May", title: "May", width: 80, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                    template:"#=checkDeadLine(May,MayD)#"
                },
                {field: "June", title: "June", width: 80, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                    template:"#=checkDeadLine(June,JuneD)#"
                },
                {field: "July", title: "July", width: 80, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                    template:"#=checkDeadLine(July,JulyD)#"
                },
                {field: "August", title: "August", width: 80, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                    template:"#=checkDeadLine(August,AugustD)#"
                },
                {field: "September", title: "September", width: 80, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                    template:"#=checkDeadLine(September,SeptemberD)#"
                },
                {field: "October", title: "October", width: 80, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                    template:"#=checkDeadLine(October,OctoberD)#"
                },
                {field: "November", title: "November", width: 80, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                    template:"#=checkDeadLine(November,NovemberD)#"
                },
                {field: "December", title: "December", width: 80, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                    template:"#=checkDeadLine(December,DecemberD)#"
                }
            ],
            filterable: {
                mode: "row"
            }
        });
        gridMCRS = $("#gridMCRS").data("kendoGrid");
        $("#menuGrid").kendoMenu();
    }

    function checkDeadLine(submit, deadLine){
        var d1 = new Date(submit);
        var d2 = new Date(deadLine);
        if(d1.getTime()== 0){
            return "";
        }
        if(d1.getTime() > d2.getTime()){
            return "<b style='color: orange'>"+convertDate(submit)+"</b>";
        }
        return  convertDate(submit);
    }

    $("#gridMCRS").kendoTooltip({
        filter: "td:nth-child(2)",
        width: 200,
        position: "top",
        content: function(e){
            var dataItem = $("#gridMCRS").data("kendoGrid").dataItem(e.target.closest("tr"));
            var formatted = "Not declared yet";
            if(dataItem.JanuaryD){
                formatted = moment(dataItem.JanuaryD, 'YYYY-MM-DD').format('D MMMM YYYY');
            }
            return "Dead Line : " + formatted;
        }
    }).data("kendoTooltip");
    $("#gridMCRS").kendoTooltip({
        filter: "td:nth-child(3)",
        width: 200,
        position: "top",
        content: function(e){
            var dataItem = $("#gridMCRS").data("kendoGrid").dataItem(e.target.closest("tr"));
            var formatted = "Not declared yet";
            if(dataItem.FebruaryD){
                formatted = moment(dataItem.FebruaryD, 'YYYY-MM-DD').format('D MMMM YYYY');
            }
            return "Dead Line : " + formatted;
        }
    }).data("kendoTooltip");
    $("#gridMCRS").kendoTooltip({
        filter: "td:nth-child(4)",
        width: 200,
        position: "top",
        content: function(e){
            var dataItem = $("#gridMCRS").data("kendoGrid").dataItem(e.target.closest("tr"));
            var formatted = "Not declared yet";
            if(dataItem.MarchD){
                formatted = moment(dataItem.MarchD, 'YYYY-MM-DD').format('D MMMM YYYY');
            }
            return "Dead Line : " + formatted;
        }
    }).data("kendoTooltip");
    $("#gridMCRS").kendoTooltip({
        filter: "td:nth-child(5)",
        width: 200,
        position: "top",
        content: function(e){
            var dataItem = $("#gridMCRS").data("kendoGrid").dataItem(e.target.closest("tr"));
            var formatted = "Not declared yet";
            if(dataItem.AprilD){
                formatted = moment(dataItem.AprilD, 'YYYY-MM-DD').format('D MMMM YYYY');
            }
            return "Dead Line : " + formatted;
        }
    }).data("kendoTooltip");
    $("#gridMCRS").kendoTooltip({
        filter: "td:nth-child(6)",
        width: 200,
        position: "top",
        content: function(e){
            var dataItem = $("#gridMCRS").data("kendoGrid").dataItem(e.target.closest("tr"));
            var formatted = "Not declared yet";
            if(dataItem.MayD){
                formatted = moment(dataItem.MayD, 'YYYY-MM-DD').format('D MMMM YYYY');
            }
            return "Dead Line : " + formatted;
        }
    }).data("kendoTooltip");
    $("#gridMCRS").kendoTooltip({
        filter: "td:nth-child(7)",
        width: 200,
        position: "top",
        content: function(e){
            var dataItem = $("#gridMCRS").data("kendoGrid").dataItem(e.target.closest("tr"));
            var formatted = "Not declared yet";
            if(dataItem.JuneD){
                formatted = moment(dataItem.JuneD, 'YYYY-MM-DD').format('D MMMM YYYY');
            }
            return "Dead Line : " + formatted;
        }
    }).data("kendoTooltip");
    $("#gridMCRS").kendoTooltip({
        filter: "td:nth-child(8)",
        width: 200,
        position: "top",
        content: function(e){
            var dataItem = $("#gridMCRS").data("kendoGrid").dataItem(e.target.closest("tr"));
            var formatted = "Not declared yet";
            if(dataItem.JulyD){
                formatted = moment(dataItem.JulyD, 'YYYY-MM-DD').format('D MMMM YYYY');
            }
            return "Dead Line : " + formatted;
        }
    }).data("kendoTooltip");
    $("#gridMCRS").kendoTooltip({
        filter: "td:nth-child(9)",
        width: 200,
        position: "top",
        content: function(e){
            var dataItem = $("#gridMCRS").data("kendoGrid").dataItem(e.target.closest("tr"));
            var formatted = "Not declared yet";
            if(dataItem.AugustD){
                formatted = moment(dataItem.AugustD, 'YYYY-MM-DD').format('D MMMM YYYY');
            }
            return "Dead Line : " + formatted;
        }
    }).data("kendoTooltip");
    $("#gridMCRS").kendoTooltip({
        filter: "td:nth-child(10)",
        width: 200,
        position: "top",
        content: function(e){
            var dataItem = $("#gridMCRS").data("kendoGrid").dataItem(e.target.closest("tr"));
            var formatted = "Not declared yet";
            if(dataItem.SeptemberD){
                formatted = moment(dataItem.SeptemberD, 'YYYY-MM-DD').format('D MMMM YYYY');
            }
            return "Dead Line : " + formatted;
        }
    }).data("kendoTooltip");
    $("#gridMCRS").kendoTooltip({
        filter: "td:nth-child(11)",
        width: 200,
        position: "top",
        content: function(e){
            var dataItem = $("#gridMCRS").data("kendoGrid").dataItem(e.target.closest("tr"));
            var formatted = "Not declared yet";
            if(dataItem.OctoberD){
                formatted = moment(dataItem.OctoberD, 'YYYY-MM-DD').format('D MMMM YYYY');
            }
            return "Dead Line : " + formatted;
        }
    }).data("kendoTooltip");
    $("#gridMCRS").kendoTooltip({
        filter: "td:nth-child(12)",
        width: 200,
        position: "top",
        content: function(e){
            var dataItem = $("#gridMCRS").data("kendoGrid").dataItem(e.target.closest("tr"));
            var formatted = "Not declared yet";
            if(dataItem.NovemberD){
                formatted = moment(dataItem.NovemberD, 'YYYY-MM-DD').format('D MMMM YYYY');
            }
            return "Dead Line : " + formatted;
        }
    }).data("kendoTooltip");
    $("#gridMCRS").kendoTooltip({
        filter: "td:nth-child(13)",
        width: 200,
        position: "top",
        content: function(e){
            var dataItem = $("#gridMCRS").data("kendoGrid").dataItem(e.target.closest("tr"));
            var formatted = "Not declared yet";
            if(dataItem.DecemberD){
                formatted = moment(dataItem.DecemberD, 'YYYY-MM-DD').format('D MMMM YYYY');
            }
            return "Dead Line : " + formatted;
        }
    }).data("kendoTooltip");
</script>
