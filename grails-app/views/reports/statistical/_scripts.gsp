<script language="javascript">
    var data;
    $(document).ready(function () {
        data = ${lst};
        createChart();
        $(document).bind("kendo:skinChange", createChart);
    });
    function createChart() {
        $('#chart').kendoChart({
            title: {
                text: "CSU & Sectors SP Entry Status"
            },
            dataSource: {
                data: data
            },
            series: [{
                field: 'count',
                colorField: "col_color"
            }],
            categoryAxis: {
                field: 'short_name'
            },
            tooltip: {
                visible: true,
                format: "{0}",
                template: "#= dataItem.name # : #= dataItem.is_submitted? 'Submitted':'Not Submitted' # "
            }
        });
    }
</script>