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
    <div class="container-fluid">
        <div class="row centered">
            <div class="panel panel-primary">
                <div class="panel-body">
                    <div class="form-group">
                        <label class="col-md-1 control-label label-optional"
                               for="month">Month:</label>

                        <div class="col-md-5">
                            <input type='text' tabindex="1" required="required" onkeydown="return false;"
                                   class="kendo-date-picker" id="month" name="month"
                                   placeholder="Month" validationMessage="Required"/>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="row">
            <div id="divUser">
                <div class="centered">
                    <div id="chartUser"></div>
                </div>
            </div>
        </div>
    </div>
</sec:isDashboardForUser>
<sec:isDashboardForManagement>
    <div class="container-fluid">
        <div class="row" style="padding-left: 16px;padding-right: 16px;">
            <div class="panel panel-primary">
                <div class="panel-body">
                    <div class="form-group">
                        <label class="col-md-1 control-label label-optional"
                               for="month">Month:</label>

                        <div class="col-md-2">
                            <input type='text' tabindex="1" required="required" onkeydown="return false;"
                                   class="kendo-date-picker" id="month" name="month"
                                   placeholder="Month" validationMessage="Required"/>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div id="divManagement">
            <div class="full">
                <div id="chartManagement"></div>
            </div>
        </div>
    </div>
</sec:isDashboardForManagement>



<script language="javascript">
    var dropDownService, chartUser, chartManagement;
    $(document).ready(function () {
        var str = moment().format('MMMM YYYY');

        $('#month').kendoDatePicker({
            format: "MMMM yyyy",
            parseFormats: ["yyyy-MM-dd"],
            start: "year",
            depth: "year",
            change: populateKendoChart
        }).data("kendoDatePicker");
        $('#month').val(str);

        createUserChart();
        createManagementChart();
        populateKendoChart();
    });
    function populateKendoChart() {
        var month = $('#month').val();
        if (!document.getElementById("divUser")) {
            var management = "${createLink(controller: 'login', action: 'lstManagementDashboard')}?month=" + month;
            chartManagement.dataSource.transport.options.read.url = management;
            chartManagement.dataSource.read();
        } else {
            var user = "${createLink(controller: 'login', action: 'lstUserDashboard')}?month=" + month;
            chartUser.dataSource.transport.options.read.url = user;
            chartUser.dataSource.read();
        }
    }
    function createUserChart() {
        $('#chartUser').kendoChart({
            title: {
                text: "Goal Wise Action Completion Status"
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
        chartUser = $("#chartUser").data("kendoChart");
    }
    function createManagementChart() {
        $('#chartManagement').kendoChart({
            title: {
                text: "CSU/Sector Wise Action Completion Status"
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
        chartManagement = $("#chartManagement").data("kendoChart");
    }
</script>
