<script type="text/x-kendo-tmpl" id="template1">
    <tr>
        <td>#:mission#</td>
    </tr>
</script>
<script type="text/x-kendo-tmpl" id="template2">
    <tr>
        <td width='5%'>#:sequence#</td>
        <td width='90%'>#:goal#</td>
    </tr>
</script>

<script language="javascript">
    var year,serviceId,departmentName,dataSource,listViewMission,listViewGoal,gridAction,isApplicable = false,detailExportPromises=[],sheet;

    $(document).ready(function () {
        onLoadInfoPage();
        initListView();
        initGrid();
    });
    function onLoadInfoPage() {
        serviceId = ${serviceId};
        departmentName = '${serviceName}';
        dropDownService.value(serviceId);
        var str = moment().format('YYYY');

        $('#year').kendoDatePicker({
            format: "yyyy",
            parseFormats: ["yyyy-MM-dd"],
            start: "decade",
            depth: "decade"
        }).data("kendoDatePicker");
        $('#year').val(str);

        initializeForm($("#detailsForm"), onSubmitForm);
        defaultPageTile("Strategic Plan", 'reports/showSpPlan');
    }
    function initListView() {
        $("#lstMission").kendoListView({
            autoBind: false,
            dataSource: {
                transport: {
                    read: {
                        url: false, dataType: "json", type: "post"
                    }
                },schema: {
                    type: 'json', data: "mission"
                }
            },
            template: kendo.template($("#template1").html())
        });
        listViewMission = $("#lstMission").data("kendoListView");

        $("#lstGoal").kendoListView({
            autoBind: false,
            dataSource: {
                transport: {
                    read: {
                        url: false, dataType: "json", type: "post"
                    }
                },schema: {
                    type: 'json', data: "list"
                }
            },
            template: kendo.template($("#template2").html())
        });
        listViewGoal = $("#lstGoal").data("kendoListView");
    }
    function initGrid() {
        $("#grid").kendoGrid({
            toolbar: ["excel"],
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
            detailInit: actionsIndicator,
            excel: {
                allPages: true
            },
            dataBound: function () {
                detailExportPromises = [];
            },
            excelExport: function (e) {
                e.preventDefault();
                var rows = e.workbook.sheets[0].rows;
                rows.unshift({
                    cells: [{width: 150}, { value: "Annual Strategic Report "+ year + "\n"+
                    "Department :" +departmentName+ "\n"+ "Printed On : "+ moment(new Date()).format('DD-MM-YYYY'), background: "#d3d3d3",wrap:true  }]
                });
                var sheet = e.workbook.sheets[0];
                sheet.columns[0].width = 150;
                sheet.columns[1].width = 350;
                sheet.columns[2].width = 80;
                sheet.columns[3].width = 80;
                sheet.columns[4].width = 80;
                sheet.columns[5].width = 90;
                sheet.columns[6].width = 200;
                sheet.columns[7].width = 200;
                sheet.columns[8].width = 100;
                sheet.columns[9].width = 100;

                var workbook = e.workbook;
                detailExportPromises = [];
                var masterData = e.data;
                for (var rowIndex = 0; rowIndex < masterData.length; rowIndex++) {
                    exportChildData(masterData[rowIndex].id, rowIndex);
                }

                $.when.apply(null, detailExportPromises)
                        .then(function () {
                            // get the export results
                            var detailExports = $.makeArray(arguments);

                            // sort by masterRowIndex
                            detailExports.sort(function (a, b) {
                                return a.masterRowIndex - b.masterRowIndex;
                            });

                            // add an empty column
                            workbook.sheets[0].columns.unshift({
                                width: 30
                            });

                            // prepend an empty cell to each row
                            for (var i = 0; i < workbook.sheets[0].rows.length; i++) {
                                workbook.sheets[0].rows[i].cells.unshift({});
                            }

                            // merge the detail export sheet rows with the master sheet rows
                            // loop backwards so the masterRowIndex doesn't need to be updated
                            for (var i = detailExports.length - 1; i >= 0; i--) {
                                var masterRowIndex = detailExports[i].masterRowIndex + 1; // compensate for the header row

                                var sheet = detailExports[i].sheet;

                                // prepend an empty cell to each row
                                for (var ci = 0; ci < sheet.rows.length; ci++) {
                                    if (sheet.rows[ci].cells[0].value) {
                                        sheet.rows[ci].cells.unshift({});
                                    }
                                }

                                // insert the detail sheet rows after the master row
                                [].splice.apply(workbook.sheets[0].rows, [masterRowIndex + 1, 0].concat(sheet.rows));
                            }

                            // save the workbook
                            kendo.saveAs({
                                dataURI: new kendo.ooxml.Workbook(workbook).toDataURL(),
                                fileName: "SP_"+departmentName+"_"+year+".xlsx"
                            });

                        });
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
                {
                    field: "target", title: "target", width: 50, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()}
                },
                {
                    field: "achievement", title: "Achievement", width: 50, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()}
                },
                {
                    field: "note",
                    title: "Remarks",
                    template: "#=trimTextForKendo(note,70)#",
                    width: 120,
                    sortable: false,
                    filterable: false
                },
                {field: "resPerson", title: "Responsible Person", width: 90, sortable: false, filterable: false},
                {
                    field: "supportDepartmentStr", title: "Support Department", width: 90,
                    sortable: false, filterable: false
                },
                {field: "sourceOfFundStr", title: "Project", width: 80, sortable: false, filterable: false}
            ]
        });
        gridAction = $("#grid").data("kendoGrid");
    }

    function exportChildData(actionsId, rowIndex) {
        var deferred = $.Deferred();
        detailExportPromises.push(deferred);
        dataSource.filter({ field: "id", operator: "eq", value: actionsId});

        var exporter = new kendo.ExcelExporter({
            columns: [{
                field: "indicator",title:"Indicator",width: 200,wrapText:true
            }, {
                field: "unit_str",title:"Unit",width: 100
            }, {
                field: "target",title:"Target"
            }],
            dataSource: dataSource
        });

        exporter.workbook().then(function(book, data) {
            deferred.resolve({
                masterRowIndex: rowIndex+1,
                sheet: book.sheets[0]
            });
        });
    }


    function actionsIndicator(e) {
        $("<div/>").appendTo(e.detailCell).kendoGrid({
            dataSource: {
                transport: {
                    read: {
                        url: "${createLink(controller: 'reports', action: 'listSpPlan')}?serviceId="+ e.data.serviceId
                        +"&year="+year+"&type=Details",
                        dataType: "json",
                        type: "post"
                    }
                },
                schema: {
                    type: 'json',
                    data: "list"
                },
                serverPaging: true,
                serverSorting: true,
                serverFiltering: true,
                batch: true,
                pageSize: 50,
                filter: { field: "actionsId", operator: "eq", value: e.data.id }
            },
            excelExport: function (e) {
                e.preventDefault();
            },
            selectable: true,
            sortable: false,
            resizable: false,
            reorderable: false,
            filterable: false,
            pageable: false,
            editable: false,
            detailInit: initDetails,
            columns: [
                { field: "indicator",title: "Indicator", width: "220px"},
                {field: "unit_str", title: "Unit", width: "50px"},
                { field: "target", title:"Target", width: "100px",attributes: {style: setAlignCenter()},
                    headerAttributes: {style: setAlignCenter()},template:"#=formatIndicator(indicator_type,target)#" },
                { field: "total_achievement", title:"Achievement", width: "100px",
                    template:"#=formatIndicator(indicator_type,total_achievement)#",
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()} }
            ]
        });
    }
    function initDetails(e) {
        var indicator_type = e.data.indicator_type;
        $("<div/>").appendTo(e.detailCell).kendoGrid({
            dataSource: {
                transport: {
                    read: {
                        url: "${createLink(controller: 'pmActions', action: 'listDetailsByIndicator')}?actionsId="+ e.data.id,
                        dataType: "json",
                        type: "post"
                    }
                },
                schema: {
                    type: 'json',
                    data: "list"
                },
                serverPaging: true,
                serverSorting: true,
                serverFiltering: true,
                pageSize: 10,
                filter: { field: "indicatorId", operator: "eq", value: e.data.ind_id }
            },
            scrollable: false,
            sortable: false,
            pageable: false,
            columns: [
                { field: "month_name",title: "Month", width: "150px" },
                { field: "target", title:"Monthly Target", width: "100px",
                    attributes: {style: setAlignCenter()},headerAttributes: {style: setAlignCenter()}},
                { field: "achievement", title:"Monthly Achievement", width: "150px",
                    attributes: {style: setAlignCenter()},headerAttributes: {style: setAlignCenter()}},
                { field: "remarks", title:"Remarks" }
            ]
        });
    }

    function formatIndicator(indicatorType,target){
        if(!target) return ''
        if(indicatorType.match('%')){
            return target + ' % ';
        }
        return target
    }
    function onSubmitForm() {
        year = $('#year').val();
        var serviceId = dropDownService.value();
        if(serviceId==''){
            showError('Please select any service');
            return false;
        }
        var urlMission ="${createLink(controller: 'reports', action: 'listSpPlan')}?serviceId=" + serviceId+"&year="+year+"&type=Mission";
        var urlGoal ="${createLink(controller: 'reports', action: 'listSpPlan')}?serviceId=" + serviceId+"&year="+year+"&type=Goals";
        var url ="${createLink(controller: 'reports', action: 'listSpPlan')}?serviceId=" + serviceId+"&year="+year+"&type=Actions";
        populateGridKendo(listViewMission,urlMission);
        populateGridKendo(listViewGoal,urlGoal);
        populateGridKendo(gridAction, url);
        initChildDataSource(serviceId,year);
        return false;
    }
    function initChildDataSource(serviceId,year){
        dataSource = new kendo.data.DataSource({
            transport: {
                read: {
                    url: "${createLink(controller: 'reports', action: 'listSpPlan')}?serviceId="+ serviceId+"&year="+year+"&type=Details",
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
        });
    }
    function downloadDetails() {
        if (isApplicable) {
            showLoadingSpinner(true);
            var from = $('#from').val();
            var to = $('#to').val();
            var hospitalCode = dropDownHospitalCode.value();
            var params = "?from=" + from + "&to=" + to + "&hospitalCode=" + hospitalCode;
            var  msg = 'Do you want to download the report now?',
                    url = "${createLink(controller: 'reports', action: 'downloadMonthlyPathologySummary')}" + params;

            confirmDownload(msg, url);
        } else {
            showError('This feature is under development');
//            showError('No record to download');
        }
        return false;
    }
    $("#grid").kendoTooltip({
        filter: "td:nth-child(9)",
        width: 300,
        position: "top",
        content: function(e){
            var dataItem = $("#grid").data("kendoGrid").dataItem(e.target.closest("tr"));
            return dataItem.note;
        }
    }).data("kendoTooltip");
</script>
