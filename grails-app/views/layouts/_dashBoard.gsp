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

<sec:isDashboardForUser>
    <div id="example">
        <div class="centered">
            <div id="chartUser"></div>
        </div>
    </div>
</sec:isDashboardForUser>
<sec:isDashboardForManagement>
    <div id="example">
        <div class="full">
            <div id="chartManagement"></div>
        </div>
    </div>
</sec:isDashboardForManagement>

<script language="javascript">
    $(document).ready(function () {
        createUserChart();
        createManagementChart();
        $(document).bind("kendo:skinChange", createUserChart);
        $(document).bind("kendo:skinChange", createManagementChart);
    });
    function createUserChart() {
        $('#chartUser').kendoChart({
            title: {
                text: "Goal Wise Action Completion Status"+" ("+moment(new Date()).format("MMMM")+")"
            },
            dataSource: {
                transport: {
                    read: {
                        url: "${createLink(controller: 'login', action: 'lstUserDashboard')}",
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
                template: "#= dataItem.goal# <br/><strong> Completed: #= dataItem.a_pert# % </strong>"
            }
        });
    }
    function createManagementChart() {
        $('#chartManagement').kendoChart({
            title: {
                text: "CSU/Sector Wise Action Completion Status"+" ("+moment(new Date()).format("MMMM")+")"
            },
            dataSource: {
                transport: {
                    read: {
                        url: "${createLink(controller: 'login', action: 'lstManagementDashboard')}",
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
                field: 'short_name',
                labels: {
                    rotation: -45
                }

            },
            tooltip: {
                visible: true,
                format: "{0}",
                width: 400,
                height: 200,
                template: "#= dataItem.service # <br/> <strong> Completed: #= dataItem.a_pert# % </strong>"
            }
        });
    }
</script>
