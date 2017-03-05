<script type="text/x-kendo-tmpl" id="template1">
    <tr>
        <td width='5%'>#:sequence#</td>
        <td width='90%'>#:goal#</td>
    </tr>
</script>

<script language="javascript">
    var month, serviceId, dropDownService,listViewGoal, gridAction, isApplicable = false;

    $(document).ready(function () {
        onLoadInfoPage();
        initListView();
        initGrid();
    });
    function onLoadInfoPage() {
        serviceId = ${serviceId};
        dropDownService.value(serviceId);
        var str = moment().format('MMMM YYYY');
        var start = $('#month').kendoDatePicker({
            format: "MMMM yyyy",
            parseFormats: ["yyyy-MM-dd"],
            start: "year",
            depth: "year"
        }).data("kendoDatePicker");
        var value='${submissionDate}';

        if(value!='') {
            start.min(value);
            $('#month').val(moment(value).format('MMMM YYYY'));
        }
        else{
            start.min(new Date(moment(new Date()).startOf('year')))
            $('#month').val(str);
        }
        initializeForm($("#detailsForm"), onSubmitForm);
        defaultPageTile("Strategic Plan", 'reports/showSpMonthlyPlan');
    }
    function initListView() {
        $("#lstGoal").kendoListView({
            autoBind: false,
            dataSource: {
                transport: {
                    read: {
                        url: false, dataType: "json", type: "post"
                    }
                }, schema: {
                    type: 'json', data: "list"
                }
            },
            template: kendo.template($("#template1").html())
        });
        listViewGoal = $("#lstGoal").data("kendoListView");
    }
    function initGrid() {
        $("#grid").kendoGrid({
            dataSource: {
                transport: {
                    read: {
                        url: false,
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
            autoBind: false,
            height: getGridHeightKendo() - 50,
            sortable: false,
            pageable: false,
            detailInit: actionsDetails,
            dataBound: function () {
                this.expandRow(this.tbody.find("tr.k-master-row"));
            },
            columns: [
                {
                    field: "sequence", title: "ID#", width: 40, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()}
                },
                {field: "actions", title: "Action", width: 200, sortable: false, filterable: false},
                {
                    field: "start", title: "Start Date", width: 50, sortable: false, filterable: false,
                    template: "#=kendo.toString(kendo.parseDate(start, 'yyyy-MM-dd'), 'MMMM')#"
                },
                {
                    field: "end", title: "End Date", width: 50, sortable: false, filterable: false,
                    template: "#=kendo.toString(kendo.parseDate(end, 'yyyy-MM-dd'), 'MMMM')#"
                },
                {field: "resPerson", title: "Responsible Person", width: 90, sortable: false, filterable: false},
                {
                    field: "supportDepartmentStr", title: "Support Department", width: 90,
                    sortable: false, filterable: false
                },
                {field: "sourceOfFundStr", title: "Project", width: 80, sortable: false, filterable: false},
                {
                    field: "note",
                    title: "Remarks",
                    template: "#=trimTextForKendo(note,70)#",
                    width: 120,
                    sortable: false,
                    filterable: false
                }
            ]
        });
        gridAction = $("#grid").data("kendoGrid");
    }
    $("#grid").kendoTooltip({
        filter: "td:nth-child(9)",
        width: 300,
        position: "top",
        content: function (e) {
            var dataItem = $("#grid").data("kendoGrid").dataItem(e.target.closest("tr"));
            return dataItem.note;
        }
    }).data("kendoTooltip");

    function actionsDetails(e) {
        $("<div/>").appendTo(e.detailCell).kendoGrid({
            dataSource: {
                transport: {
                    read: {
                        url: "${createLink(controller: 'pmActions', action: 'listAchievement')}?serviceId=" + e.data.serviceId
                        + "&month=" + month + "&type=Details",
                        dataType: "json",
                        type: "post"
                    },
                    update: {
                        url: "${createLink(controller: 'pmActions', action: 'updateAchievement')}",
                        dataType: "json",
                        type: "post"
                    }
                },
                requestEnd: function (e) {
                    var response = e.response;
                    if (e.type == 'update') {
                        var isError = response["isError"];
                        var message = response["message"];
                        if (isError) {
                            showError(message);
                        }
                        var grid = $("#grid").data("kendoGrid");
                        var data = grid.dataSource;
                        data.read();
                    }
                },
                schema: {
                    type: 'json',
                    data: "list",
                    model: {
                        id: "ind_details_id",    // have to set id otherwise remove row by clicking cancel
                        fields: {
                            id: {type: "number"},
                            ind_details_id: {type: "number"},
                            indicator: {editable: false, type: "string"},
                            unit_id: {editable: false, type: "number"},
                            unit_str: {editable: false, type: "string"},
                            indicator_type: {editable: false, type: "string"},
                            target: {editable: false, type: "string"},
                            total_achievement: {editable: false, type: "string"},
                            monthly_target: {editable: false, type: "number"},
                            achievement: {type: "number"},
                            remarks: {type: "string"}
                        }
                    }
                },
                serverPaging: true,
                serverSorting: true,
                serverFiltering: true,
                batch: true,
                pageSize: 50,
                filter: {field: "actionsId", operator: "eq", value: e.data.id}
            },
            selectable: true,
            sortable: false,
            resizable: false,
            reorderable: false,
            filterable: false,
            pageable: false,
            editable: "inline",
            columns: [
                {field: "indicator", title: "Indicator", width: "220px"},
                {
                    field: "target", title: "Total Target", width: "100px", attributes: {style: setAlignCenter()},
                    headerAttributes: {style: setAlignCenter()}, template: "#=formatIndicator(indicator_type,target)#"
                },
                {
                    field: "total_achievement", title: "Total</br> Achievement", width: "80px",
                    template: "#=formatIndicator(indicator_type,total_achievement)#",
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()}
                },
                {
                    field: "monthly_target", title: "Target</br> (This month)", width: "80px",
                    template: "#=formatIndicator(indicator_type,monthly_target)#",
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()}
                },
                {
                    field: "achievement", title: "Achievement</br> (This month)", width: "100px", format: "{0:n0}",
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()}
                },
                {field: "remarks", title: "Remarks", width: "280px",editor: textEditorInitialize },
                {command: [{name:"edit",text:{edit: "Achievement",	update: "Save",	cancel: "Cancel"}}], title: "&nbsp;", width: "100px"}
            ]
        });
    }

    var textEditorInitialize = function(container, options) {
        $('<textarea name="' + options.field + '" style="width: ' + container.width() + 'px;height:' + container.height() + 'px" />')
                .appendTo(container);
    };

    function formatIndicator(indicatorType, target) {
        if (!target) return '0'
        if (indicatorType.match('%')) {
            return target + ' % ';
        }
        return target
    }
    function onSubmitForm() {
        month = $('#month').val();
        var serviceId = dropDownService.value();
        if (serviceId == '') {
            showError('Please select any service');
            return false;
        }
        var urlGoal = "${createLink(controller: 'pmActions', action: 'listAchievement')}?serviceId=" + serviceId + "&month=" + month + "&type=Goals";
        var url = "${createLink(controller: 'pmActions', action: 'listAchievement')}?serviceId=" + serviceId + "&month=" + month + "&type=Actions";
        populateGridKendo(listViewGoal, urlGoal);
        populateGridKendo(gridAction, url);
        return false;
    }
</script>