<script language="javascript">
    var chartSP;
    $(document).ready(function () {
        var str = moment().format('YYYY');
        $('#year').kendoDatePicker({
            format: "yyyy",
            parseFormats: ["yyyy-MM-dd"],
            start: "decade",
            depth: "decade",
            change: populateKendoChart
        }).data("kendoDatePicker");
        $('#year').val(str);

        createChart();
        populateKendoChart();
        $(document).bind("kendo:skinChange", createChart);
    });

    function populateKendoChart() {
        var year = $('#year').val();
        var url = "${createLink(controller: 'reports', action: 'listSpStatus')}?year=" + year;
        chartSP.dataSource.transport.options.read.url = url;
        chartSP.dataSource.read();
    }

    function createChart() {
        $('#chartSP').kendoChart({
            title: {
                text: "CSU & Sectors SP Submission Status"
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
            },{
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
        chartSP = $("#chartSP").data("kendoChart");
    }
</script>