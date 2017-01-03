<script language="javascript">
    var data;
    $(document).ready(function () {
        data = ${lst};
        createChart();
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
                field: 'count'
            }],
            categoryAxis: {
                field: 'short_name'
            },
            tooltip: {
                visible: true,
                format: "{0}",
                template: "#= dataItem.name # : #= value # "
            }
        });
    }
</script>