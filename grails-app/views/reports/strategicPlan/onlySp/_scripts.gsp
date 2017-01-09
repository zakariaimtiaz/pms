<script type="text/x-kendo-tmpl" id="template1">
    <tr>
        <td width='5%'>#:sequence#</td>
        <td width='90%'>#:goal#</td>
    </tr>
</script>

<script language="javascript">
    var year,serviceId,departmentName,dataSource,gridGoal,gridAction,isApplicable = false,detailExportPromises=[],sheet;

    $(document).ready(function () {
        onLoadInfoPage();
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
    function onSubmitForm() {
        year = $('#year').val();
        var serviceId = dropDownService.value();
        if(serviceId==''){
            showError('Please select any service');
            return false;
        }
        var urlGoal ="${createLink(controller: 'reports', action: 'listSpPlan')}?serviceId=" + serviceId+"&year="+year+"&type=Goals";
        populateGridKendo(gridGoal, urlGoal);
        return false;
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
            detailInit: actions,
            excel: {
                allPages: true
            },
            dataBound: function () {
                detailExportPromises = [];
            },
            excelExport: function (e) {
                // prevent saving the file because we will update the workbook
                e.preventDefault();
                var workbook = e.workbook;

                // Export all detail grids
                $("#grid [data-role=grid]").each(function() {
                    $(this).data("kendoGrid").saveAsExcel();
                });

                // wait for all detail grids to finish exporting
                $.when.apply(null, detailExportPromises).then(function() {
                    // get the export results
                    var detailExports = $.makeArray(arguments);

                    /*
                     need to recalculate the master row indexes of each export
                     everytime you click expand in the master grid, the master row indexes are recalculated by Kendo
                     e.g. you expand row 4 (which will display a grid with 6 rows), then you expand row 1 (which will display a grid with 12 rows)
                     when you do this, the index of "row 4" is updated with 4 + 12. So the new index of "row 4" is actually 16
                     */

                    // first we need to create a copy of the original values, otherwise every subsequent export will have the already updated rows and it will try to update again
                    for (var i = 0; i < detailExports.length; i++)
                        detailExports[i].newMasterRowIndex = detailExports[i].masterRowIndex;

                    for (var i = 1; i < detailExports.length; i++) {
                        if (!detailExports[i].isDetailGrid2) {
                            for (var j = 0; j < i; j++) {
                                if (detailExports[i].newMasterRowIndex <= detailExports[j].newMasterRowIndex) {
                                    detailExports[j].newMasterRowIndex = detailExports[j].newMasterRowIndex + detailExports[i].sheet.rows.length -1; // -1 to discount header
                                    if (detailExports[i].sheet.rows[detailExports[i].sheet.rows.length - 1].type == "footer")
                                        detailExports[j].newMasterRowIndex = detailExports[j].newMasterRowIndex - 1
                                }
                            }
                        }
                    }

                    // sort by masterRowIndex
                    detailExports.sort(function (a, b) {
                        return a.newMasterRowIndex - b.newMasterRowIndex;
                    });

                    // merge the detail export sheet rows with the master sheet rows
                    var rowCount = 0;
                    for (var i = 0; i < detailExports.length; i++) {
                        // we need to recalculate the masterRowIndex everytime because the detailGrid2 should be inserted "in the middle" of the detailGrid
                        // and not simply after it as you would normally do when you have only two grids
                        var masterRowIndex = rowCount + detailExports[i].newMasterRowIndex + 1; // +1 to compensate for the header row

                        var sheet = detailExports[i].sheet;

                        if (sheet.rows[sheet.rows.length - 1].type == "footer")
                            sheet.rows.splice(-1, 1); // don't export the footer

                        if (detailExports[i].isDetailGrid2) {
                            // prepend two empty cells to each row
                            for (var ci = 0; ci < sheet.rows.length; ci++) {
                                if (sheet.rows[ci].cells[0].value) {
                                    sheet.rows[ci].cells.unshift({});
                                    sheet.rows[ci].cells.unshift({});
                                }
                                for (var cellIndex = 2; cellIndex < sheet.rows[ci].cells.length; cellIndex++) {
                                    var colTitle = sheet.rows[ci].cells[cellIndex].value;
                                    sheet.rows[ci].cells[cellIndex].background = "#C7D4E9";
                                }
                            }
                            rowCount = rowCount + sheet.rows.length;
                        }
                        else {

                            // prepend an empty cell to each row
                            for (var ci = 0; ci < sheet.rows.length; ci++) {
                                if (sheet.rows[ci].cells[0].value) {
                                    sheet.rows[ci].cells.unshift({});
                                }
                                for (var cellIndex = 1; cellIndex < sheet.rows[ci].cells.length; cellIndex++) {
                                    var colTitle = sheet.rows[ci].cells[cellIndex].value;
                                    sheet.rows[ci].cells[cellIndex].background = "#CEE3F6";
                                }
                            }
                            rowCount = rowCount + 1;
                        }
                        // insert the detail sheet rows in the correct place
                        [].splice.apply(workbook.sheets[0].rows, [masterRowIndex + 1, 0].concat(sheet.rows));
                    }

                    // update the indexes of the rows so they are exported correctly
                    for (var i = 0; i < workbook.sheets[0].rows.length; i++) {
                        workbook.sheets[0].rows[i].index = i;
                    }

                    // save the workbook
                    kendo.saveAs({
                        dataURI: new kendo.ooxml.Workbook(workbook).toDataURL(),
                        fileName: "SP_"+departmentName+"_"+year+".xlsx"
                    })
                });
            },
            columns: [
                {
                    field: "sequence", title: "ID#", width: 40, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()}
                },
                {field: "goal", title: "Goal", sortable: false, filterable: false}
                ]
        });
        gridGoal = $("#grid").data("kendoGrid");
    }

    function actions(e) {
        // initiallize a new jQuery Deferred http://api.jquery.com/jQuery.Deferred/
        var deferred = $.Deferred();

        // get the index of the master row
        var masterRowIndex = e.masterRow.index(".k-master-row");

        // add the deferred to the list of promises
        detailExportPromises.push(deferred);
        $("<div/>").appendTo(e.detailCell).kendoGrid({
            dataSource: {
                transport: {
                    read: {
                        url: "${createLink(controller: 'reports', action: 'listSpPlan')}?serviceId="+ e.data.serviceId
                        +"&year="+year+"&type=Actions",
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
                filter: { field: "goalId", operator: "eq", value: e.data.id }
            },
            excelExport: function (e) {
                // prevent saving the file
                e.preventDefault();

                // resolve the deferred
                deferred.resolve({
                    masterRowIndex: masterRowIndex,
                    sheet: e.workbook.sheets[0]
                });
            },
            selectable: true,
            sortable: false,
            resizable: false,
            reorderable: false,
            filterable: false,
            pageable: false,
            editable: false,
            detailInit: actionsIndicator,
            columns: [
                {
                    field: "sequence", title: "ID#", width: 40, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()}
                },
                {field: "actions", title: "Action", width: 200, sortable: false, filterable: false},
                {
                    field: "start", title: "Start", width: 50, sortable: false, filterable: false,
                    template: "#=kendo.toString(kendo.parseDate(start, 'yyyy-MM-dd'), 'MMMM')#"
                },
                {
                    field: "end", title: "End", width: 50, sortable: false, filterable: false,
                    template: "#=kendo.toString(kendo.parseDate(end, 'yyyy-MM-dd'), 'MMMM')#"
                },
                {
                    field: "target", title: "target", width: 50, sortable: false, filterable: false,
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
                    sortable: false, filterable: false,template:"#=trimTextForKendo(supportDepartmentStr,50)#"
                },
                {field: "sourceOfFundStr", title: "Project",template:"#=trimTextForKendo(sourceOfFundStr,50)#",  width: 80, sortable: false, filterable: false}
            ]
        });
    }

    function actionsIndicator(e) {
        // initiallize a new jQuery Deferred http://api.jquery.com/jQuery.Deferred/
        var deferred = $.Deferred();

        // get the index of the master row
        var masterRowIndex = e.masterRow.index(".k-master-row");

        // add the deferred to the list of promises
        detailExportPromises.push(deferred);
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
                // prevent saving the file
                e.preventDefault();

                // resolve the deferred
                deferred.resolve({
                    masterRowIndex: masterRowIndex,
                    isDetailGrid2: true,
                    sheet: e.workbook.sheets[0]
                });
            },
            selectable: true,
            sortable: false,
            resizable: false,
            reorderable: false,
            filterable: false,
            pageable: false,
            editable: false,
            columns: [
                { field: "indicator",title: "Indicator", width: "220px"},
                {field: "unit_str", title: "Unit", width: "50px"},
                { field: "target", title:"Target", width: "100px",attributes: {style: setAlignCenter()},
                    headerAttributes: {style: setAlignCenter()},template:"#=formatIndicator(indicator_type,target)#" }
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

/*    $(".k-detail-row").kendoTooltip({
        show: function(e){
            if(this.content.text().length > 50){
                this.content.parent().css("visibility", "visible");
            }
        },
        hide:function(e){
            this.content.parent().css("visibility", "hidden");
        },
        filter: "td:nth-child(7)",
        width: 300,
        position: "top",
        content: function(e){
            var dataItem = $("#grid").data("kendoGrid").dataItem(e.target.closest("tr"));
            return dataItem.note;
        }
    }).data("kendoTooltip");
    $("#grid").kendoTooltip({
        show: function(e){
            if(this.content.text().length > 50){
                this.content.parent().css("visibility", "visible");
            }
        },
        hide:function(e){
            this.content.parent().css("visibility", "hidden");
        },
        filter: "td:nth-child(9)",
        width: 300,
        position: "top",
        content: function(e){
            var dataItem = $("#grid").data("kendoGrid").dataItem(e.target.closest("tr"));
            return dataItem.supportDepartmentStr;
        }
    }).data("kendoTooltip");
    $("#grid").kendoTooltip({
        show: function(e){
            if(this.content.text().length > 70){
                this.content.parent().css("visibility", "visible");
            }
        },
        hide:function(e){
            this.content.parent().css("visibility", "hidden");
        },
        filter: "td:nth-child(10)",
        width: 300,
        position: "top",
        content: function(e){
            var dataItem = $("#grid").data("kendoGrid").dataItem(e.target.closest("tr"));
            return dataItem.sourceOfFundStr;
        }
    }).data("kendoTooltip");*/
</script>
