<div id="dialog"></div>

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
        defaultPageTile("MCRS Submission","reports/showMcrsStatus");
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
                        JanuaryID: { type: "number" },     January: { type: "date" },     JanuaryDsb: { type: "date" },      JanuaryD: { type: "date" },
                        FebruaryID: { type: "number" },    February: { type: "date" },    FebruaryDsb: { type: "date" },     FebruaryD: { type: "date" },
                        MarchID: { type: "number" },       March: { type: "date" },       MarchDsb: { type: "date" },        MarchD: { type: "date" },
                        AprilID: { type: "number" },       April: { type: "date" },       AprilDsb: { type: "date" },        AprilD: { type: "date" },
                        MayID: { type: "number" },         May: { type: "date" },         MayDsb: { type: "date" },          MayD: { type: "date" },
                        JuneID: { type: "number" },        June: { type: "date" },        JuneDsb: { type: "date" },         JuneD: { type: "date" },
                        JulyID: { type: "number" },        July: { type: "date" },        JulyDsb: { type: "date" },         JulyD: { type: "date" },
                        AugustID: { type: "number" },      August: { type: "date" },      AugustDsb: { type: "date" },       AugustD: { type: "date" },
                        SeptemberID: { type: "number" },   September: { type: "date" },   SeptemberDsb: { type: "date" },    SeptemberD: { type: "date" },
                        OctoberID: { type: "number" },     October: { type: "date" },     OctoberDsb: { type: "date" },      OctoberD: { type: "date" },
                        NovemberID: { type: "number" },    November: { type: "date" },    NovemberDsb: { type: "date" },     NovemberD: { type: "date" },
                        DecemberID: { type: "number" },    December: { type: "date" },    DecemberDsb: { type: "date" },     DecemberD: { type: "date" }
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
            selectable: false,
            sortable: true,
            resizable: true,
            reorderable: true,
            pageable: false,
            columns: [
                {field: "service", title: "CSU/Sector", width: 150, sortable: false, filterable: false},
                {
                    title: "January", headerAttributes: {style: setAlignCenter()},filterable: false,
                    columns: [
                        {field: "January", title: "MRP", width: 80, sortable: false, filterable: false,
                            attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                            template:"#=checkDeadLine(JanuaryID,1,January,JanuaryD)#"
                        },
                        {field: "JanuaryDsb", title: "Dashboard", width: 80, sortable: false, filterable: false,
                            attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                            template:"#=checkDeadLine(JanuaryID,2,JanuaryDsb,JanuaryD)#"
                        }
                    ]
                },
                {
                    title: "February", headerAttributes: {style: setAlignCenter()},filterable: false,
                    columns: [
                        {field: "February", title: "MRP", width: 80, sortable: false, filterable: false,
                            attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                            template:"#=checkDeadLine(FebruaryID,1,February,FebruaryD)#"
                        },
                        {field: "FebruaryDsb", title: "Dashboard", width: 80, sortable: false, filterable: false,
                            attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                            template:"#=checkDeadLine(FebruaryID,2,FebruaryDsb,FebruaryD)#"
                        }
                    ]
                },
                {
                    title: "March", headerAttributes: {style: setAlignCenter()},filterable: false,
                    columns: [
                        {field: "March", title: "MRP", width: 80, sortable: false, filterable: false,
                            attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                            template:"#=checkDeadLine(MarchID,1,March,MarchD)#"
                        },
                        {field: "MarchDsb", title: "Dashboard", width: 80, sortable: false, filterable: false,
                            attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                            template:"#=checkDeadLine(MarchID,2,MarchDsb,MarchD)#"
                        }
                    ]
                },
                {
                    title: "April", headerAttributes: {style: setAlignCenter()},filterable: false,
                    columns: [
                        {field: "April", title: "MRP", width: 80, sortable: false, filterable: false,
                            attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                            template:"#=checkDeadLine(AprilID,1,April,AprilD)#"
                        },
                        {field: "AprilDsb", title: "Dashboard", width: 80, sortable: false, filterable: false,
                            attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                            template:"#=checkDeadLine(AprilID,2,AprilDsb,AprilD)#"
                        }
                    ]
                },
                {
                    title: "May", headerAttributes: {style: setAlignCenter()},filterable: false,
                    columns: [
                        {field: "May", title: "MRP", width: 80, sortable: false, filterable: false,
                            attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                            template:"#=checkDeadLine(MayID,1,May,MayD)#"
                        },
                        {field: "MayDsb", title: "Dashboard", width: 80, sortable: false, filterable: false,
                            attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                            template:"#=checkDeadLine(MayID,2,MayDsb,MayD)#"
                        }
                    ]
                },
                {
                    title: "June", headerAttributes: {style: setAlignCenter()},filterable: false,
                    columns: [
                        {field: "June", title: "MRP", width: 80, sortable: false, filterable: false,
                            attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                            template:"#=checkDeadLine(JuneID,1,June,JuneD)#"
                        },
                        {field: "JuneDsb", title: "Dashboard", width: 80, sortable: false, filterable: false,
                            attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                            template:"#=checkDeadLine(JuneID,2,JuneDsb,JuneD)#"
                        }
                    ]
                },
                {
                    title: "July", headerAttributes: {style: setAlignCenter()},filterable: false,
                    columns: [
                        {field: "July", title: "MRP", width: 80, sortable: false, filterable: false,
                            attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                            template:"#=checkDeadLine(JulyID,1,July,JulyD)#"
                        },
                        {field: "JulyDsb", title: "Dashboard", width: 80, sortable: false, filterable: false,
                            attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                            template:"#=checkDeadLine(JulyID,2,JulyDsb,JulyD)#"
                        }
                    ]
                },
                {
                    title: "August", headerAttributes: {style: setAlignCenter()},filterable: false,
                    columns: [
                        {field: "August", title: "MRP", width: 80, sortable: false, filterable: false,
                            attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                            template:"#=checkDeadLine(AugustID,1,August,AugustD)#"
                        },
                        {field: "AugustDsb", title: "Dashboard", width: 80, sortable: false, filterable: false,
                            attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                            template:"#=checkDeadLine(AugustID,2,AugustDsb,AugustD)#"
                        }
                    ]
                },
                {
                    title: "September", headerAttributes: {style: setAlignCenter()},filterable: false,
                    columns: [
                        {field: "September", title: "MRP", width: 80, sortable: false, filterable: false,
                            attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                            template:"#=checkDeadLine(SeptemberID,1,September,SeptemberD)#"
                        },
                        {field: "SeptemberDsb", title: "Dashboard", width: 80, sortable: false, filterable: false,
                            attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                            template:"#=checkDeadLine(SeptemberID,2,SeptemberDsb,SeptemberD)#"
                        }
                    ]
                },
                {
                    title: "October", headerAttributes: {style: setAlignCenter()},filterable: false,
                    columns: [
                        {field: "October", title: "MRP", width: 80, sortable: false, filterable: false,
                            attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                            template:"#=checkDeadLine(OctoberID,1,October,OctoberD)#"
                        },
                        {field: "OctoberDsb", title: "Dashboard", width: 80, sortable: false, filterable: false,
                            attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                            template:"#=checkDeadLine(OctoberID,2,OctoberDsb,OctoberD)#"
                        }
                    ]
                },
                {
                    title: "November", headerAttributes: {style: setAlignCenter()},filterable: false,
                    columns: [
                        {field: "November", title: "MRP", width: 80, sortable: false, filterable: false,
                            attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                            template:"#=checkDeadLine(NovemberID,1,November,NovemberD)#"
                        },
                        {field: "NovemberDsb", title: "Dashboard", width: 80, sortable: false, filterable: false,
                            attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                            template:"#=checkDeadLine(NovemberID,2,NovemberDsb,NovemberD)#"
                        }
                    ]
                },
                {
                    title: "December", headerAttributes: {style: setAlignCenter()},filterable: false,
                    columns: [
                        {field: "December", title: "MRP", width: 80, sortable: false, filterable: false,
                            attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                            template:"#=checkDeadLine(DecemberID,1,December,DecemberD)#"
                        },
                        {field: "DecemberDsb", title: "Dashboard", width: 80, sortable: false, filterable: false,
                            attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                            template:"#=checkDeadLine(DecemberID,2,DecemberDsb,DecemberD)#"
                        }
                    ]
                }
            ],
            filterable: {
                mode: "row"
            }
        });
        gridMCRS = $("#gridMCRS").data("kendoGrid");
        $("#menuGrid").kendoMenu();
    }

    function checkDeadLine(logId,typeId,submitOn, deadLine){
        var d1 = new Date(submitOn);
        var d2 = new Date(deadLine);
        if(d1.getTime()== 0){
            return "";
        }
        if(d1.getTime() > d2.getTime()){
            return "<a style='cursor: pointer' onclick='showMcrsLogDetails("+logId+","+typeId+");'><b style='color: orange'>"+convertDate(submitOn)+"</b></a>";
        }
        return  "<a style='cursor: pointer' onclick='javascript:showMcrsLogDetails("+logId+","+typeId+");'>"+convertDate(submitOn)+'</a>';
    }

    function showMcrsLogDetails(logId,typeId){
        var param = "?logId=" + logId + "&typeId=" + typeId;

        var url = "${createLink(controller: 'pmMcrsLog', action: 'logDetailsById')}"  + param;
        router.navigate(formatLink(url));
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
