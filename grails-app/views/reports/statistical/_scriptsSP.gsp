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
                        log_id: { type: "number" },
                        service: { type: "string" },
                        year: { type: "number" },
                        is_submitted: { type: "boolean" },
                        is_editable: { type: "boolean" },
                        submission_date: { type: "date" },
                        dead_line: { type: "date" }
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
                {field: "submission_date", title: "Last Submission Date", width: 80, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                    template:"#=checkDeadLine(log_id,dead_line,submission_date)#"
                },
                {field: "dead_line", title: "Dead Line", width: 80, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                    template:"#=convertDate(dead_line)#"
                }
            ],
            filterable: {
                mode: "row"
            }
        });
        gridSP = $("#gridSP").data("kendoGrid");
        $("#menuGrid").kendoMenu();
    }

    function checkDeadLine(logId, deadLine, submit){
        if(!submit){
            return  "<a style='cursor: pointer' onclick='javascript:showSpLogDetails("+logId+");'><b style='color: darkred'>"+"OPEN</b></a>";
        }
        var d1 = new Date(submit);
        var d2 = new Date(deadLine);
        if(d1.getTime()== 0){
            return "";
        }
        if(d1.getTime() > d2.getTime()){
            return "<a style='cursor: pointer' onclick='showSpLogDetails("+logId+");'><b style='color: orange'>"+convertDate(submit)+"</b></a>";
        }
        return  "<a style='cursor: pointer' onclick='javascript:showSpLogDetails("+logId+");'>"+convertDate(submit)+'</a>';
    }
    function showSpLogDetails(logId){
        var param = "?logId=" + logId;
        var url = "${createLink(controller: 'pmSpLog', action: 'logDetailsById')}"  + param;
        router.navigate(formatLink(url));
    }

</script>
