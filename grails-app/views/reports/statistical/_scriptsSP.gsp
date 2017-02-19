<script language="javascript">
    var gridSP, dataSource;

    $(document).ready(function () {
        onLoadSPPage();
        initSPGrid();
        populateSPGrid();
    });

    function onLoadSPPage() {
        var str = moment().format('YYYY');
        $('#year').kendoDatePicker({
            format: "yyyy",
            parseFormats: ["yyyy-MM-dd"],
            start: "decade",
            depth: "decade",
            change: populateSPGrid
        }).data("kendoDatePicker");
        $('#year').val(str);
        defaultPageTile("SP Submission",null);
    }

    function populateSPGrid(){
        var year = $('#year').val();
        if(year==''){
            showError('Please select year');
            return false;
        }
        var params = "?year="+year;
        var url ="${createLink(controller: 'reports', action: 'listSpStatus')}" + params;
        populateGridKendo(gridSP, url);
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
                        'YEAR_2017': { type: "string" },
                        'YEAR_2017D': { type: "string" },
                        'YEAR_2018': { type: "string" },
                        'YEAR_2018D': { type: "string" },
                        'YEAR_2019': { type: "string" },
                        'YEAR_2019D': { type: "string" },
                        'YEAR_2020': { type: "string" },
                        'YEAR_2020D': { type: "string" },
                        'YEAR_2021': { type: "string" },
                        'YEAR_2021D': { type: "string" },
                        'YEAR_2022': { type: "string" },
                        'YEAR_2022D': { type: "string" },
                        'YEAR_2023': { type: "string" },
                        'YEAR_2023D': { type: "string" },
                        'YEAR_2024': { type: "string" },
                        'YEAR_2024D': { type: "string" },
                        'YEAR_2025': { type: "string" },
                        'YEAR_2025D': { type: "string" },
                        'YEAR_2026': { type: "string" },
                        'YEAR_2026D': { type: "string" },
                        'YEAR_2027': { type: "string" },
                        'YEAR_2027D': { type: "string" }
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

    function initSPGrid() {
        initDataSource();
        $("#gridSP").kendoGrid({
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
                {field: "YEAR_2017", title: "2017", width: 80, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                    template:"#=checkDeadLine(YEAR_2017,YEAR_2017D)#"
                },
                {field: "YEAR_2018", title: "2018", width: 80, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                    template:"#=checkDeadLine(YEAR_2018,YEAR_2018D)#"
                },
                {field: "YEAR_2019", title: "2019", width: 80, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                    template:"#=checkDeadLine(YEAR_2019,YEAR_2019D)#"
                },
                {field: "YEAR_2020", title: "2020", width: 80, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                    template:"#=checkDeadLine(YEAR_2020,YEAR_2020D)#"
                },
                {field: "YEAR_2021", title: "2021", width: 80, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                    template:"#=checkDeadLine(YEAR_2021,YEAR_2021D)#"
                },
                {field: "YEAR_2022", title: "2022", width: 80, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                    template:"#=checkDeadLine(YEAR_2022,YEAR_2022D)#"
                },
                {field: "YEAR_2023", title: "2023", width: 80, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                    template:"#=checkDeadLine(YEAR_2023,YEAR_2023D)#"
                },
                {field: "YEAR_2024", title: "2024", width: 80, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                    template:"#=checkDeadLine(YEAR_2024,YEAR_2024D)#"
                },
                {field: "YEAR_2025", title: "2025", width: 80, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                    template:"#=checkDeadLine(YEAR_2025,YEAR_2025D)#"
                },
                {field: "YEAR_2026", title: "2026", width: 80, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                    template:"#=checkDeadLine(YEAR_2026,YEAR_2026D)#"
                },
                {field: "YEAR_2027", title: "2027", width: 80, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                    template:"#=checkDeadLine(YEAR_2027,YEAR_2027D)#"
                },
            ],
            filterable: {
                mode: "row"
            }
        });
        gridSP = $("#gridSP").data("kendoGrid");
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

    $("#gridSP").kendoTooltip({
        filter: "td:nth-child(2)",
        width: 200,
        position: "top",
        content: function(e){
            var dataItem = $("#gridSP").data("kendoGrid").dataItem(e.target.closest("tr"));
            var formatted = "Not declared yet";
            if(dataItem.YEAR_2017D){
                formatted = moment(dataItem.YEAR_2017D, 'YYYY-MM-DD').format('D MMMM YYYY');
            }
            return "Dead Line : " + formatted;
        }
    }).data("kendoTooltip");
    $("#gridSP").kendoTooltip({
        filter: "td:nth-child(3)",
        width: 200,
        position: "top",
        content: function(e){
            var dataItem = $("#gridSP").data("kendoGrid").dataItem(e.target.closest("tr"));
            var formatted = "Not declared yet";
            if(dataItem.YEAR_2018D){
                formatted = moment(dataItem.YEAR_2018D, 'YYYY-MM-DD').format('D MMMM YYYY');
            }
            return "Dead Line : " + formatted;
        }
    }).data("kendoTooltip");
    $("#gridSP").kendoTooltip({
        filter: "td:nth-child(4)",
        width: 200,
        position: "top",
        content: function(e){
            var dataItem = $("#gridSP").data("kendoGrid").dataItem(e.target.closest("tr"));
            var formatted = "Not declared yet";
            if(dataItem.YEAR_2019D){
                formatted = moment(dataItem.YEAR_2019D, 'YYYY-MM-DD').format('D MMMM YYYY');
            }
            return "Dead Line : " + formatted;
        }
    }).data("kendoTooltip");
    $("#gridSP").kendoTooltip({
        filter: "td:nth-child(5)",
        width: 200,
        position: "top",
        content: function(e){
            var dataItem = $("#gridSP").data("kendoGrid").dataItem(e.target.closest("tr"));
            var formatted = "Not declared yet";
            if(dataItem.YEAR_2020D){
                formatted = moment(dataItem.YEAR_2020D, 'YYYY-MM-DD').format('D MMMM YYYY');
            }
            return "Dead Line : " + formatted;
        }
    }).data("kendoTooltip");
    $("#gridSP").kendoTooltip({
        filter: "td:nth-child(6)",
        width: 200,
        position: "top",
        content: function(e){
            var dataItem = $("#gridSP").data("kendoGrid").dataItem(e.target.closest("tr"));
            var formatted = "Not declared yet";
            if(dataItem.YEAR_2021D){
                formatted = moment(dataItem.YEAR_2021D, 'YYYY-MM-DD').format('D MMMM YYYY');
            }
            return "Dead Line : " + formatted;
        }
    }).data("kendoTooltip");
    $("#gridSP").kendoTooltip({
        filter: "td:nth-child(7)",
        width: 200,
        position: "top",
        content: function(e){
            var dataItem = $("#gridSP").data("kendoGrid").dataItem(e.target.closest("tr"));
            var formatted = "Not declared yet";
            if(dataItem.YEAR_2022D){
                formatted = moment(dataItem.YEAR_2022D, 'YYYY-MM-DD').format('D MMMM YYYY');
            }
            return "Dead Line : " + formatted;
        }
    }).data("kendoTooltip");
    $("#gridSP").kendoTooltip({
        filter: "td:nth-child(8)",
        width: 200,
        position: "top",
        content: function(e){
            var dataItem = $("#gridSP").data("kendoGrid").dataItem(e.target.closest("tr"));
            var formatted = "Not declared yet";
            if(dataItem.YEAR_2023D){
                formatted = moment(dataItem.YEAR_2023D, 'YYYY-MM-DD').format('D MMMM YYYY');
            }
            return "Dead Line : " + formatted;
        }
    }).data("kendoTooltip");
    $("#gridSP").kendoTooltip({
        filter: "td:nth-child(9)",
        width: 200,
        position: "top",
        content: function(e){
            var dataItem = $("#gridSP").data("kendoGrid").dataItem(e.target.closest("tr"));
            var formatted = "Not declared yet";
            if(dataItem.YEAR_2024D){
                formatted = moment(dataItem.YEAR_2024D, 'YYYY-MM-DD').format('D MMMM YYYY');
            }
            return "Dead Line : " + formatted;
        }
    }).data("kendoTooltip");
    $("#gridSP").kendoTooltip({
        filter: "td:nth-child(10)",
        width: 200,
        position: "top",
        content: function(e){
            var dataItem = $("#gridSP").data("kendoGrid").dataItem(e.target.closest("tr"));
            var formatted = "Not declared yet";
            if(dataItem.YEAR_2025D){
                formatted = moment(dataItem.YEAR_2025D, 'YYYY-MM-DD').format('D MMMM YYYY');
            }
            return "Dead Line : " + formatted;
        }
    }).data("kendoTooltip");
    $("#gridSP").kendoTooltip({
        filter: "td:nth-child(11)",
        width: 200,
        position: "top",
        content: function(e){
            var dataItem = $("#gridSP").data("kendoGrid").dataItem(e.target.closest("tr"));
            var formatted = "Not declared yet";
            if(dataItem.YEAR_2026D){
                formatted = moment(dataItem.YEAR_2026D, 'YYYY-MM-DD').format('D MMMM YYYY');
            }
            return "Dead Line : " + formatted;
        }
    }).data("kendoTooltip");
    $("#gridSP").kendoTooltip({
        filter: "td:nth-child(12)",
        width: 200,
        position: "top",
        content: function(e){
            var dataItem = $("#gridSP").data("kendoGrid").dataItem(e.target.closest("tr"));
            var formatted = "Not declared yet";
            if(dataItem.YEAR_2027D){
                formatted = moment(dataItem.YEAR_2027D, 'YYYY-MM-DD').format('D MMMM YYYY');
            }
            return "Dead Line : " + formatted;
        }
    }).data("kendoTooltip");
</script>
