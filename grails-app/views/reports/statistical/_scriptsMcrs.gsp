<script language="javascript">
    var chart;
    $(document).ready(function () {
        var str = moment().subtract(1,'months').format('MMMM YYYY');

        $('#month').kendoDatePicker({
            format: "MMMM yyyy",
            parseFormats: ["yyyy-MM-dd"],
            start: "year",
            depth: "year",
            change: populateKendoChart
        }).data("kendoDatePicker");
        $('#month').val(str);

        createChart();
        populateKendoChart();
        $(document).bind("kendo:skinChange", createChart);
    });
    function populateKendoChart() {
        var month = $('#month').val();
        var url = "${createLink(controller: 'reports', action: 'listMcrsStatus')}?month=" + month;
        chart.dataSource.transport.options.read.url = url;
        chart.dataSource.read();
    }
    function createChart() {
        $('#chart').kendoChart({
            title: {
                text: "CSU & Sectors MCRS Submission Status"
            },
            autoBind: false,
            dataSource: {
                transport: {
                    read: {
                        url: false,
                        dataType: "json"
                    }
                }
            },
            seriesColors: ["#FF6666", "#00FF00"],
            series: [{
                name: 'Not Submitted',
                field: 'count',
                colorField: "col_color"
            }, {
                name: 'Submitted'
            }],
            categoryAxis: {
                field: 'short_name'
            },
            tooltip: {
                visible: true,
                format: "{0}",
                template: "#= dataItem.name # #= dataItem.is_submitted? ' >> ' : '' # #= dataItem.submission_date # "
            }
        });
        chart = $("#chart").data("kendoChart");
    }
</script>