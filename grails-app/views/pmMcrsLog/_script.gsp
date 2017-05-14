<script type="text/x-kendo-template" id="gridToolbar">
<ul id="menuGrid2" class="kendoGridMenu">
    <sec:access url="/pmMcrsLog/update">
        <li onclick="editMCRS();"><i class="fa fa-edit"></i>Edit</li>
    </sec:access>
    <sec:access url="/pmMcrsLog/updateDeadLine">
        <li onclick="showDeadLineModel();"><i class="fa fa-clock-o"></i>Dead Line</li>
    </sec:access>
</ul>
</script>
<script language="javascript">
    var gridMcrsLog,mcrsLogModel, dataSource,kendoDatePicker,currentDate,currentMonth,currentYear,serviceId;

    $(document).ready(function () {
        onLoadMcrsLogPage();
        initMcrsLogGrid();
        initObservable();
        serviceId = ${serviceId};
        dropDownService.value(serviceId);
        populateGrid();
    });
    function onLoadMcrsLogPage() {
        currentMonth = moment().format('MMMM YYYY');
        kendoDatePicker = $('#month').kendoDatePicker({
            format: "MMMM yyyy",
            parseFormats: ["yyyy-MM-dd"],
            start: "year",
            depth: "year"
        }).data("kendoDatePicker");
        $('#month').val(currentMonth);

        currentYear = moment().format('YYYY');
        $('#year').kendoDatePicker({
            format: "yyyy",
            parseFormats: ["yyyy"],
            depth: "decade",
            start: "decade",
            change: populateGrid
        });
        $('#year').val(currentYear);
        $(".k-datepicker input").prop("readonly", true);

        initializeForm($("#mcrsLogForm"), onSubmitMcrsLog);
        defaultPageTile("MCRS Log",'pmMcrsLog/show');
    }

    function populateGrid(){
        var serviceId = $('#serviceId').val(),
                year = $('#year').val(),
                params = "?serviceId=" + serviceId + "&year=" + year;
        if(serviceId==''){
            showError("Please select service");
            return false;
        }if(year==''){
            showError("Please select year");
            return false;
        }
        var url = "${createLink(controller: 'pmMcrsLog', action: 'list')}" + params;
        populateGridKendo(gridMcrsLog,url);
    }
    function executePreCondition() {
        if (!validateForm($("#mcrsLogForm"))) {
            return false;
        }
        return true;
    }

    function onSubmitMcrsLog() {
        if (executePreCondition() == false) {
            return false;
        }
        var actionUrl = null;
        if ($('#id').val().isEmpty()) {
            actionUrl = "${createLink(controller:'pmMcrsLog', action: 'create')}";
        } else {
            actionUrl = "${createLink(controller:'pmMcrsLog', action: 'update')}";
        }
        showLoadingSpinner(true);

        jQuery.ajax({
            type: 'post',
            data: jQuery("#mcrsLogForm").serialize(),
            url: actionUrl,
            success: function (data, textStatus) {
                executePostCondition(data);
                setButtonDisabled($('#create'), false);
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
            },
            complete: function (XMLHttpRequest, textStatus) {
                showLoadingSpinner(false);
            },
            dataType: 'json'
        });
        return false;
    }

    function executePostCondition(result) {
        if (result.isError) {
            showError(result.message);
            showLoadingSpinner(false);
        } else {
            try {
                var newEntry = result.pmMcrsLog;
                if ($('#id').val().isEmpty() && newEntry != null) { // newly created
                    var gridData = gridMcrsLog.dataSource.data();
                    gridData.unshift(newEntry);
                } else if (newEntry != null) { // updated existing
                    var selectedRow = gridMcrsLog.select();
                    var allItems = gridMcrsLog.items();
                    var selectedIndex = allItems.index(selectedRow);
                    gridMcrsLog.removeRow(selectedRow);
                    gridMcrsLog.dataSource.insert(selectedIndex, newEntry);
                }
                emptyForm();
                showSuccess(result.message);
            } catch (e) {
                // Do Nothing
            }
        }
    }
    function emptyForm() {
        clearForm($("#mcrsLogForm"), $('#serviceId'));
        $('#month').val(currentMonth);
        $('#year').val(currentYear);
        dropDownService.value(serviceId);
        dropDownService.readonly(false);
        kendoDatePicker.readonly(false);
        $('#create').html("<span class='k-icon k-i-plus'></span>Save");
    }
    function initObservable() {
        mcrsLogModel = kendo.observable(
                {
                    mcrsLog: {
                        id: "",
                        version: "",
                        serviceId: "",
                        month: currentMonth,
                        isEditable: "",
                        isEditableDb: ""
                    }
                }
        );
        kendo.bind($("#application_top_panel"), mcrsLogModel);
    }
    function initDataSource() {
        dataSource = new kendo.data.DataSource({
            transport: {
                read: {
                    url: false,
                    dataType: "json",
                    type: "post"
                }
            },
            schema: {
                type: 'json',
                data: "list", total: "count",
                model: {
                    fields: {
                        id: {type: "number"},
                        version: {type: "number"},
                        year: {type: "string"},
                        month: {type: "number"},
                        monthStr: {type: "string"},
                        serviceId: {type: "number"},
                        service: {type: "string"},
                        submissionDate: {type: "date"},
                        submissionDateDb: {type: "date"},
                        deadLine: {type: "date"},
                        isSubmitted: {type: "boolean"},
                        isSubmittedDb: {type: "boolean"},
                        isEditable: {type: "boolean"},
                        isEditableDb: {type: "boolean"}
                    }
                },
                parse: function (data) {
                    checkIsErrorGridKendo(data);
                    return data;
                }
            },
            sort: {field: 'month', dir: 'asc'},
            pageSize: getDefaultPageSize(),
            serverPaging: true,
            serverFiltering: true,
            serverSorting: true
        });
    }

    function initMcrsLogGrid() {
        initDataSource();
        $("#gridMcrsLog").kendoGrid({
            dataSource: dataSource,
            height: getGridHeightKendo(),
            selectable: true,
            sortable: true,
            resizable: true,
            reorderable: true,
            autoBind:false,
            pageable: {
                refresh: true,
                pageSizes: getDefaultPageSizes(),
                buttonCount: 4
            },
            columns: [
                {
                    field: "shortName", title: "CSU/Sector", width: 50, sortable: false, filterable: kendoCommonFilterable(),
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()}
                },
                {
                    field: "monthStr", title: "Month", width: 50, sortable: false, filterable: kendoCommonFilterable(),
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()}
                },
                {
                    field: "deadLine",title: "Dead Line",
                    width: 50, sortable: false,filterable: false,
                    template: "#=deadLine?kendo.toString(kendo.parseDate(deadLine, 'yyyy-MM-dd'), 'dd-MM-yyyy'):'Not set yet'#",
                    attributes: {style: setAlignCenter()},
                    headerAttributes: {style: setAlignCenter()}
                },
                {
                    title: "Submitted", headerAttributes: {style: setAlignCenter()},filterable: false,
                    columns: [
                        {
                            field: "isSubmitted", title: "MRP",
                            width: 30, sortable: false, filterable: false,
                            headerAttributes: {style: setAlignCenter()},
                            attributes: {style: setAlignCenter()},
                            template: "#=isSubmitted?'YES':'NO'#"
                        },
                        {
                            field: "isSubmittedDb", title: "ED's Dashboard",
                            width: 40, sortable: false, filterable: false,
                            headerAttributes: {style: setAlignCenter()},
                            attributes: {style: setAlignCenter()},
                            template: "#=isSubmittedDb?'YES':'NO'#"
                        }
                    ]
                },
                {
                    title: "Submission Date", headerAttributes: {style: setAlignCenter()},filterable: false,
                    columns: [
                        {
                            field: "submissionDate", title: "MRP",
                            width: 30, sortable: false, filterable: false,
                            headerAttributes: {style: setAlignCenter()},
                            attributes: {style: setAlignCenter()},
                            template: "#=isSubmitted?kendo.toString(kendo.parseDate(submissionDate, 'yyyy-MM-dd'), 'dd-MM-yyyy'):''#"
                        },
                        {
                            field: "submissionDateDb", title: "ED's Dashboard",
                            width: 40, sortable: false, filterable: false,
                            headerAttributes: {style: setAlignCenter()},
                            attributes: {style: setAlignCenter()},
                            template: "#=submissionDateDb?kendo.toString(kendo.parseDate(submissionDateDb, 'yyyy-MM-dd'), 'dd-MM-yyyy'):''#"
                        }
                    ]
                },
                {
                    title: "Editable", headerAttributes: {style: setAlignCenter()},filterable: false,
                    columns: [
                        {
                            field: "isEditable", title: "MRP",
                            width: 30, sortable: false, filterable: false,
                            headerAttributes: {style: setAlignCenter()},
                            attributes: {style: setAlignCenter()},
                            template: "#=isEditable?'YES':'NO'#"
                        },
                        {
                            field: "isEditableDb", title: "ED's Dashboard",
                            width: 40, sortable: false, filterable: false,
                            headerAttributes: {style: setAlignCenter()},
                            attributes: {style: setAlignCenter()},
                            template: "#=isEditableDb?'YES':'NO'#"
                        }
                    ]
                }
            ],
            filterable: {
                mode: "row"
            },
            toolbar: kendo.template($("#gridToolbar").html())
        });
        gridMcrsLog = $("#gridMcrsLog").data("kendoGrid");
        $("#menuGrid2").kendoMenu();
    }

    function editMCRS() {
        if (executeCommonPreConditionForSelectKendo(gridMcrsLog, 'mcrsLog') == false) {
            return;
        }
        var mcrs = getSelectedObjectFromGridKendo(gridMcrsLog);
        showMCRS(mcrs);
    }
    function showMCRS(mcrs) {
        mcrsLogModel.set('mcrsLog', mcrs);
        $('#month').val(moment(mcrs.year+'-'+mcrs.month+'-01').format('MMMM YYYY'));
        dropDownService.readonly(true);
        kendoDatePicker.readonly(true);
        $('#create').html("<span class='k-icon k-i-plus'></span>Update");
    }
    function showDeadLineModel() {
        $("#createMCRSModal").modal('show');
        currentMonth = moment().format('MMMM YYYY');
        $('#modalMCRSMonth').kendoDatePicker({
            format: "MMMM yyyy",
            parseFormats: ["yyyy-MM-dd"],
            start: "year",
            depth: "year"
        }).data("kendoDatePicker");
        $('#modalMCRSMonth').val(currentMonth);

        currentDate = moment().format('DD/MM/YYYY');
        $('#modalMCRSDeadLine').kendoDatePicker({
            format: "dd/MM/yyyy",
            parseFormats: ["yyyy-MM-dd"]
        }).data("kendoDatePicker");
        $('#modalMCRSDeadLine').val(currentDate);
    }
    function onClickMCRSModal() {
        jQuery.ajax({
            type: 'post',
            data: jQuery("#createMCRSMModalForm").serialize(),
            url: "${createLink(controller: 'pmMcrsLog', action: 'updateDeadLine')}",
            success: function (result, textStatus) {
                if (result.isError) {
                    showError(result.message);
                } else{
                    showSuccess(result.message);
                }
                populateGrid();
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
            },
            complete: function (XMLHttpRequest, textStatus) {
            },
            dataType: 'json'
        });
        $("#createMCRSModal").modal('hide');
    }

</script>