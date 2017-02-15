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
                template:"#=checkDeadLine(January,JanuaryD)#"},
                {field: "February", title: "February", width: 80, sortable: false, filterable: false},
                {field: "March", title: "March", width: 80, sortable: false, filterable: false},
                {field: "April", title: "April", width: 80, sortable: false, filterable: false},
                {field: "May", title: "May", width: 80, sortable: false, filterable: false},
                {field: "June", title: "June", width: 80, sortable: false, filterable: false},
                {field: "July", title: "July", width: 80, sortable: false, filterable: false},
                {field: "August", title: "August", width: 80, sortable: false, filterable: false},
                {field: "September", title: "September", width: 80, sortable: false, filterable: false},
                {field: "October", title: "October", width: 80, sortable: false, filterable: false},
                {field: "November", title: "November", width: 80, sortable: false, filterable: false},
                {field: "December", title: "December", width: 80, sortable: false, filterable: false}
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
</script>
