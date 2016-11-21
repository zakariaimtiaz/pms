<div id="example">
    <div class="demo-section k-content" style="width: 1100px;height: 580px;">
        <div id="chart"></div>
    </div>
    <script>
        function createChart() {
            $("#chart").kendoChart({
                title: {
                    position: "bottom",
                    text: "Friendship project status 2015-2016",
                    color: "black"
                },
                legend: {
                    visible: false
                },
                chartArea: {
                    background: "#9de219"
                },
                plotArea: {
                    background: "lightgreen"
                },
                seriesDefaults: {
                    labels: {
                        visible: true,
                        background: "transparent",
                        template: "#= category #: \n #= value#%"
                    }
                },
                series: [{
                    type: "pie",
                    startAngle: 150,
                    data: [{
                        category: "Establishing Community based Water Treatment Project",
                        value: 23.8,
                        color: "#9de219"
                    },{
                        category: "Community Manage Disaster Risk Reduction",
                        value: 26.1,
                        color: "#90cc38"
                    },{
                        category: "Cervical Cancer See & Treat (CCS & T)",
                        value: 11.3,
                        color: "#068c35"
                    },{
                        category: "Emirates Friendship Hospital",
                        value: 9.6,
                        color: "#006634"
                    },{
                        category: "Lifebuoy Friendship Hospital",
                        value: 15.2,
                        color: "#004d38"
                    },{
                        category: "Rongdhonu Friendship Hospital",
                        value: 13.6,
                        color: "#033939"
                    }]
                }],
                tooltip: {
                    visible: true,
                    format: "{0}%"
                }
            });
        }

        $(document).ready(createChart);
        $(document).bind("kendo:skinChange", createChart);
    </script>
</div>
