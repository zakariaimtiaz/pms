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
                        JanuaryID: { type: "number" },     January: { type: "date" },     JanuaryDsb: { type: "date" },      JanuaryD: { type: "date" },editedMRPJan:{type:"boolean"},editedDsbJan:{type:"boolean"},
                        FebruaryID: { type: "number" },    February: { type: "date" },    FebruaryDsb: { type: "date" },     FebruaryD: { type: "date" },editedMRPFeb:{type:"boolean"},editedDsbFeb:{type:"boolean"},
                        MarchID: { type: "number" },       March: { type: "date" },       MarchDsb: { type: "date" },        MarchD: { type: "date" },editedMRPMar:{type:"boolean"},editedDsbMar:{type:"boolean"},
                        AprilID: { type: "number" },       April: { type: "date" },       AprilDsb: { type: "date" },        AprilD: { type: "date" },editedMRPApr:{type:"boolean"},editedDsbApr:{type:"boolean"},
                        MayID: { type: "number" },         May: { type: "date" },         MayDsb: { type: "date" },          MayD: { type: "date" },editedMRPMay:{type:"boolean"},editedDsbMay:{type:"boolean"},
                        JuneID: { type: "number" },        June: { type: "date" },        JuneDsb: { type: "date" },         JuneD: { type: "date" },editedMRPJune:{type:"boolean"},editedDsbJune:{type:"boolean"},
                        JulyID: { type: "number" },        July: { type: "date" },        JulyDsb: { type: "date" },         JulyD: { type: "date" },editedMRPJuly:{type:"boolean"},editedDsbJuly:{type:"boolean"},
                        AugustID: { type: "number" },      August: { type: "date" },      AugustDsb: { type: "date" },       AugustD: { type: "date" },editedMRPAug:{type:"boolean"},editedDsbAug:{type:"boolean"},
                        SeptemberID: { type: "number" },   September: { type: "date" },   SeptemberDsb: { type: "date" },    SeptemberD: { type: "date" },editedMRPSep:{type:"boolean"},editedDsbSep:{type:"boolean"},
                        OctoberID: { type: "number" },     October: { type: "date" },     OctoberDsb: { type: "date" },      OctoberD: { type: "date" },editedMRPOct:{type:"boolean"},editedDsbOct:{type:"boolean"},
                        NovemberID: { type: "number" },    November: { type: "date" },    NovemberDsb: { type: "date" },     NovemberD: { type: "date" },editedMRPNov:{type:"boolean"},editedDsbNov:{type:"boolean"},
                        DecemberID: { type: "number" },    December: { type: "date" },    DecemberDsb: { type: "date" },     DecemberD: { type: "date" },editedMRPDec:{type:"boolean"},editedDsbDec:{type:"boolean"}
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
                            template:"#=checkDeadLine(JanuaryID,1,January,JanuaryD,editedMRPJan)#"
                        },
                        {field: "JanuaryDsb", title: "Dashboard", width: 80, sortable: false, filterable: false,
                            attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                            template:"#=checkDeadLine(JanuaryID,2,JanuaryDsb,JanuaryD,editedDsbJan)#"
                        }
                    ]
                },
                {
                    title: "February", headerAttributes: {style: setAlignCenter()},filterable: false,
                    columns: [
                        {field: "February", title: "MRP", width: 80, sortable: false, filterable: false,
                            attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                            template:"#=checkDeadLine(FebruaryID,1,February,FebruaryD,editedMRPFeb)#"
                        },
                        {field: "FebruaryDsb", title: "Dashboard", width: 80, sortable: false, filterable: false,
                            attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                            template:"#=checkDeadLine(FebruaryID,2,FebruaryDsb,FebruaryD,editedDsbFeb)#"
                        }
                    ]
                },
                {
                    title: "March", headerAttributes: {style: setAlignCenter()},filterable: false,
                    columns: [
                        {field: "March", title: "MRP", width: 80, sortable: false, filterable: false,
                            attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                            template:"#=checkDeadLine(MarchID,1,March,MarchD,editedMRPMar)#"
                        },
                        {field: "MarchDsb", title: "Dashboard", width: 80, sortable: false, filterable: false,
                            attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                            template:"#=checkDeadLine(MarchID,2,MarchDsb,MarchD,editedDsbMar)#"
                        }
                    ]
                },
                {
                    title: "April", headerAttributes: {style: setAlignCenter()},filterable: false,
                    columns: [
                        {field: "April", title: "MRP", width: 80, sortable: false, filterable: false,
                            attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                            template:"#=checkDeadLine(AprilID,1,April,AprilD,editedMRPApr)#"
                        },
                        {field: "AprilDsb", title: "Dashboard", width: 80, sortable: false, filterable: false,
                            attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                            template:"#=checkDeadLine(AprilID,2,AprilDsb,AprilD,editedDsbApr)#"
                        }
                    ]
                },
                {
                    title: "May", headerAttributes: {style: setAlignCenter()},filterable: false,
                    columns: [
                        {field: "May", title: "MRP", width: 80, sortable: false, filterable: false,
                            attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                            template:"#=checkDeadLine(MayID,1,May,MayD,editedMRPMay)#"
                        },
                        {field: "MayDsb", title: "Dashboard", width: 80, sortable: false, filterable: false,
                            attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                            template:"#=checkDeadLine(MayID,2,MayDsb,MayD,editedDsbMay)#"
                        }
                    ]
                },
                {
                    title: "June", headerAttributes: {style: setAlignCenter()},filterable: false,
                    columns: [
                        {field: "June", title: "MRP", width: 80, sortable: false, filterable: false,
                            attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                            template:"#=checkDeadLine(JuneID,1,June,JuneD,editedMRPJune)#"
                        },
                        {field: "JuneDsb", title: "Dashboard", width: 80, sortable: false, filterable: false,
                            attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                            template:"#=checkDeadLine(JuneID,2,JuneDsb,JuneD,editedDsbJune)#"
                        }
                    ]
                },
                {
                    title: "July", headerAttributes: {style: setAlignCenter()},filterable: false,
                    columns: [
                        {field: "July", title: "MRP", width: 80, sortable: false, filterable: false,
                            attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                            template:"#=checkDeadLine(JulyID,1,July,JulyD,editedMRPJuly)#"
                        },
                        {field: "JulyDsb", title: "Dashboard", width: 80, sortable: false, filterable: false,
                            attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                            template:"#=checkDeadLine(JulyID,2,JulyDsb,JulyD,editedDsbJuly)#"
                        }
                    ]
                },
                {
                    title: "August", headerAttributes: {style: setAlignCenter()},filterable: false,
                    columns: [
                        {field: "August", title: "MRP", width: 80, sortable: false, filterable: false,
                            attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                            template:"#=checkDeadLine(AugustID,1,August,AugustD,editedMRPAug)#"
                        },
                        {field: "AugustDsb", title: "Dashboard", width: 80, sortable: false, filterable: false,
                            attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                            template:"#=checkDeadLine(AugustID,2,AugustDsb,AugustD,editedDsbAug)#"
                        }
                    ]
                },
                {
                    title: "September", headerAttributes: {style: setAlignCenter()},filterable: false,
                    columns: [
                        {field: "September", title: "MRP", width: 80, sortable: false, filterable: false,
                            attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                            template:"#=checkDeadLine(SeptemberID,1,September,SeptemberD,editedMRPSep)#"
                        },
                        {field: "SeptemberDsb", title: "Dashboard", width: 80, sortable: false, filterable: false,
                            attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                            template:"#=checkDeadLine(SeptemberID,2,SeptemberDsb,SeptemberD,editedDsbSep)#"
                        }
                    ]
                },
                {
                    title: "October", headerAttributes: {style: setAlignCenter()},filterable: false,
                    columns: [
                        {field: "October", title: "MRP", width: 80, sortable: false, filterable: false,
                            attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                            template:"#=checkDeadLine(OctoberID,1,October,OctoberD,editedMRPOct)#"
                        },
                        {field: "OctoberDsb", title: "Dashboard", width: 80, sortable: false, filterable: false,
                            attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                            template:"#=checkDeadLine(OctoberID,2,OctoberDsb,OctoberD,editedDsbOct)#"
                        }
                    ]
                },
                {
                    title: "November", headerAttributes: {style: setAlignCenter()},filterable: false,
                    columns: [
                        {field: "November", title: "MRP", width: 80, sortable: false, filterable: false,
                            attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                            template:"#=checkDeadLine(NovemberID,1,November,NovemberD,editedMRPNov)#"
                        },
                        {field: "NovemberDsb", title: "Dashboard", width: 80, sortable: false, filterable: false,
                            attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                            template:"#=checkDeadLine(NovemberID,2,NovemberDsb,NovemberD,editedDsbNov)#"
                        }
                    ]
                },
                {
                    title: "December", headerAttributes: {style: setAlignCenter()},filterable: false,
                    columns: [
                        {field: "December", title: "MRP", width: 80, sortable: false, filterable: false,
                            attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                            template:"#=checkDeadLine(DecemberID,1,December,DecemberD,editedMRPDec)#"
                        },
                        {field: "DecemberDsb", title: "Dashboard", width: 80, sortable: false, filterable: false,
                            attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                            template:"#=checkDeadLine(DecemberID,2,DecemberDsb,DecemberD,editedDsbDec)#"
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

    function checkDeadLine(logId,typeId,submitOn, deadLine,isEdited) {

        var d1 = new Date(submitOn);
        var d2 = new Date(deadLine);
        if (d1.getTime() == 0) {
            return "";
        }
        if (isEdited) {
            if (d1.getTime() > d2.getTime()) {
                return "<a style='cursor: pointer' onclick='showMcrsLogDetails(" + logId + "," + typeId + ");'><b style='color: orange'>" + convertDate(submitOn) + "</b></a>";
            }
            return "<a style='cursor: pointer' onclick='javascript:showMcrsLogDetails(" + logId + "," + typeId + ");'><b>" + convertDate(submitOn) + '</b></a>';
        }
        else{
            if (d1.getTime() > d2.getTime()) {
                return "<span style='color: orange'>" + convertDate(submitOn) + "</span>";
            }
            return  convertDate(submitOn);
        }
    }

    function showMcrsLogDetails(logId,typeId){
        var param = "?logId=" + logId + "&typeId=" + typeId;

        var url = "${createLink(controller: 'pmMcrsLog', action: 'logDetailsById')}"  + param;
        router.navigate(formatLink(url));
    }

    $("#gridMCRS").kendoTooltip({
        filter: "td:nth-child(2),td:nth-child(3)",
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
        filter: "td:nth-child(4),td:nth-child(5)",
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
        filter: "td:nth-child(6),td:nth-child(7)",
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
        filter: "td:nth-child(8),td:nth-child(9)",
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
        filter: "td:nth-child(10),td:nth-child(11)",
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
        filter: "td:nth-child(12),td:nth-child(13)",
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
        filter: "td:nth-child(14),td:nth-child(15)",
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
        filter: "td:nth-child(16),td:nth-child(17)",
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
        filter: "td:nth-child(18),td:nth-child(19)",
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
        filter: "td:nth-child(20),td:nth-child(21)",
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
        filter: "td:nth-child(22),td:nth-child(23)",
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
        filter: "td:nth-child(24),td:nth-child(25)",
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
