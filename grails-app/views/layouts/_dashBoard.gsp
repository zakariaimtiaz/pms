<div class="container-fluid">
    <div class="row">
        <div id="gridMonthlySP"></div>
    </div>
</div>

<script language="javascript">
    var serviceId, dataSource, gridMonthlySP;
    var tmp1 = '', tmp2 = '';

    $(document).ready(function () {
        initGrid();
        defaultPageTile("Strategic Plan", null);
    });

    function initGrid() {
        $("#gridMonthlySP").kendoGrid({
            dataSource: {
                transport: {
                    read: {
                        url: "${createLink(controller: 'reports', action: 'listSpMonthlyPlan')}",
                        dataType: "json",
                        type: "post"
                    }
                },
                schema: {
                    type: 'json',
                    data: "list"
                },
                serverPaging: true,
                serverSorting: true
            },
            height: window.innerHeight-80,
            sortable: false,
            pageable: false,
            columns: [
                {
                    title: "Current month MRP status", headerAttributes: {style: setAlignCenter()},
                    columns: [
                        {
                            field: "sequence", title: "ID#", width: 40, sortable: false, filterable: false,
                            attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                            template: "#=omitRepeated1(sequence,sequence)#"
                        },
                        {
                            field: "actions", title: "Action", width: 250, sortable: false, filterable: false,
                            template: "#=omitRepeated2(sequence,actions)#"
                        },
                        {field: "indicator", title: "Indicator", width: 150, sortable: false, filterable: false},
                        {
                            field: "tot_tar", title: "Total<br/>Target", width: 80, sortable: false, filterable: false,
                            headerAttributes: {style: setAlignCenter()}, attributes: {style: setAlignCenter()},
                            template: "#=formatIndicator(indicator_type,tot_tar)#"
                        },
                        {
                            title: "Monthly", headerAttributes: {style: setAlignCenter()},
                            columns: [
                                {
                                    field: "mon_tar", title: "Target",
                                    width: 70, sortable: false, filterable: false,
                                    headerAttributes: {style: setAlignRight()},
                                    attributes: {style: setAlignRight()},
                                    template: "#=formatIndicator(indicator_type,mon_tar)#"
                                },
                                {
                                    field: "mon_acv", title: "Achievement",
                                    width: 90, sortable: false, filterable: false,
                                    headerAttributes: {style: setAlignRight()},
                                    attributes: {style: setAlignRight()},
                                    template: "#=formatIndicator(indicator_type,mon_acv)#"
                                },
                                {
                                    field: "mon_acv", title: "Variance",
                                    width: 70, sortable: false, filterable: false,
                                    headerAttributes: {style: setAlignRight()},
                                    attributes: {style: setAlignRight()},
                                    template: "#=calculateVariance(mon_tar,mon_acv)#"
                                }
                            ]
                        },
                        {
                            title: "Cumulative", headerAttributes: {style: setAlignCenter()},
                            columns: [
                                {
                                    field: "cum_tar", title: "Target",
                                    width: 70, sortable: false, filterable: false,
                                    headerAttributes: {style: setAlignRight()},
                                    attributes: {style: setAlignRight()},
                                    template: "#=formatIndicator(indicator_type,cum_tar)#"
                                },
                                {
                                    field: "cum_acv", title: "Achievement",
                                    width: 90, sortable: false, filterable: false,
                                    headerAttributes: {style: setAlignRight()},
                                    attributes: {style: setAlignRight()},
                                    template: "#=formatIndicator(indicator_type,cum_acv)#"
                                },
                                {
                                    field: "cum_acv", title: "Variance",
                                    width: 70, sortable: false, filterable: false,
                                    headerAttributes: {style: setAlignRight()},
                                    attributes: {style: setAlignRight()},
                                    template: "#=calculateVariance(cum_tar,cum_acv)#"
                                }
                            ]
                        }]
                }
            ]
        });
        gridMonthlySP = $("#gridMonthlySP").data("kendoGrid");
    }

    function calculateVariance(tar, ach) {
        var perc = "";
        if (isNaN(tar) || isNaN(ach) || tar == 0) {
            perc = "N/A";
        } else {
            perc = (((ach / tar) * 100).toFixed(1) - 100);
            if (perc < 0) {
                return '<span style="color: #ff0000" >' + perc + ' %' + '</span>';
            } else {
                return perc + ' %';
            }
        }
        return perc;
    }
    function formatIndicator(indicatorType, target) {
        if (indicatorType.match('%')) {
            return target + ' % ';
        }
        return target
    }

    function omitRepeated1(seq, val) {
        if (tmp1 == seq) {
            return ''
        }
        tmp1 = seq;
        return val;
    }
    function omitRepeated2(seq, val) {
        if (tmp2 == seq) {
            return ''
        }
        tmp2 = seq;
        return val;
    }

</script>
