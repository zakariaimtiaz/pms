<div id="example">
    <div class="centered">
        <div id="chart"></div>
    </div>
</div>
<style type="text/css">
.centered {
    margin: 0 auto;
    text-align: left;
    width: 600px;
}

.k-tooltip {
    width: 300px;
    height: auto;
    white-space: normal;
    color: #080808;
    background-color: #faebcc !important;
}
</style>

<script language="javascript">
    $(document).ready(function () {
        createChart();
        $(document).bind("kendo:skinChange", createChart);
    });
    function createChart() {
        $('#chart').kendoChart({
            title: {
                text: "Goal Wise Action Completion Status"
            },
            dataSource: {
                transport: {
                    read: {
                        url: "${createLink(controller: 'login', action: 'lstDataForDashboard')}",
                        dataType: "json"
                    }
                }
            },
            seriesDefaults: {
                type: "column",
                stack: true
            },
            seriesColors: ["#FF6666", "#00FF00"],
            series: [
                {
                    name: 'No. of Actions',
                    field: 'a_col',
                    colorField: "a_color"
                },
                {
                    name: 'Completed',
                    field: 't_col',
                    colorField: "t_color"
                }
            ],
            categoryAxis: {
                field: 'cat_axe'
            },
            tooltip: {
                visible: true,
                format: "{0}",
                width: 400,
                height: 200,
                template: "#= dataItem.goal#"
            }
        });
    }
</script>
