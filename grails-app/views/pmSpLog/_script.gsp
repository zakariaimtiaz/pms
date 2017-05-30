<script type="text/x-kendo-template" id="gridToolbar">
<ul id="menuGrid" class="kendoGridMenu">
    <sec:access url="/pmSpLog/update">
        <li onclick="editService();"><i class="fa fa-edit"></i>Edit</li>
    </sec:access>
    <sec:access url="/pmSpLog/updateDeadLine">
        <li onclick="showDeadLineModel();"><i class="fa fa-clock-o"></i>Dead Line</li>
    </sec:access>
    <sec:access url="/pmActions/showEditableActions">
        <li onclick="showEditableActions();"><i class="fa fa-th-list"></i>Set Editable Actions</li>
    </sec:access>
</ul>
</script>
<style type="text/css">
    .k-filtercell {
        text-align: center;
    }
    .k-filtercell label {
        padding-left: 5px;
    }
</style>
<script language="javascript">
    var currentDate,currentYear,gridSpLog, dataSource, SpLogModel;

    $(document).ready(function () {
        onLoadSpLogPage();
        initSpLogGrid();
        initObservable();
        populateGrid();
    });
    function populateGrid(){
        var year = $('#yearGrid').val();
        if(year==''){
            showError("Please select year from grid menu");
            return false;
        }
        var url = "${createLink(controller: 'pmSpLog', action: 'list')}?&year=" + year;
        populateGridKendo(gridSpLog,url);
    }
    function onLoadSpLogPage() {
        currentYear = moment().format('YYYY');
        $('#year').kendoDatePicker({
            format: "yyyy",
            parseFormats: ["yyyy-MM-dd"],
            start: "decade",
            depth: "decade"
        }).data("kendoDatePicker");

        $('#yearGrid').kendoDatePicker({
            format: "yyyy",
            parseFormats: ["yyyy-MM-dd"],
            start: "decade",
            depth: "decade",
            change: populateGrid
        }).data("kendoDatePicker");
        $('#yearGrid').val(currentYear);
        $(".k-datepicker input").prop("readonly", true);

        initializeForm($("#spLogForm"), onSubmitSpLog);
        defaultPageTile("Create SP Log",null);
    }
    function checkSubmitted(){

        if($("#isSubmitted").is(":checked")){
            $("#isEditable").prop("checked",false);
        }
    }
    function checkEditable(){

        if($("#isEditable").is(":checked")){
            $("#isSubmitted").prop("checked",false);
        }

    }

    function executePreCondition() {
        if (!validateForm($("#spLogForm"))) {
            return false;
        }
        return true;
    }

    function onSubmitSpLog() {
        if (executePreCondition() == false) {
            return false;
        }
        setButtonDisabled($('#create'), true);
        showLoadingSpinner(true);
        var actionUrl = null;
        if ($('#id').val().isEmpty()) {
            actionUrl = "${createLink(controller:'pmSpLog', action: 'create')}";
        } else {
            actionUrl = "${createLink(controller:'pmSpLog', action: 'update')}";
        }

        jQuery.ajax({
            type: 'post',
            data: jQuery("#spLogForm").serialize(),
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
                var newEntry = result.pmSpLog;
                if ($('#id').val().isEmpty() && newEntry != null) { // newly created
                    var gridData = gridSpLog.dataSource.data();
                    gridData.unshift(newEntry);
                } else if (newEntry != null) { // updated existing
                    var selectedRow = gridSpLog.select();
                    var allItems = gridSpLog.items();
                    var selectedIndex = allItems.index(selectedRow);
                    gridSpLog.removeRow(selectedRow);
                    gridSpLog.dataSource.insert(selectedIndex, newEntry);
                }
                emptyForm();
                showSuccess(result.message);
            } catch (e) {
                // Do Nothing
            }
        }
    }

    function emptyForm() {
        clearForm($("#spLogForm"), $('#serviceId'));
        initObservable();
        $('#year').val(currentYear);
        $('#yearGrid').val(currentYear);
        $('#create').html("<span class='k-icon k-i-plus'></span>Save");
    }

    function resetForm() {
        initObservable();
        $('#year').val(currentYear);
        $('#yearGrid').val(currentYear);
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
                        id: { type: "number" },
                        version: { type: "number" },
                        year: { type: "number" },
                        serviceId: { type: "number" },
                        serviceName: { type: "string" },
                        service: { type: "string" },
                        submissionDate: { type: "date" },
                        deadLine: { type: "date" },
                        isSubmitted: { type: "boolean" },
                        isEditable: { type: "boolean" }
                    }
                },
                parse: function (data) {
                    checkIsErrorGridKendo(data);
                    return data;
                }
            },
            sort: {field: 'service', dir: 'asc'},
            pageSize: getDefaultPageSize(),
            serverPaging: true,
            serverFiltering: true,
            serverSorting: true
        });
    }

    function initSpLogGrid() {
        initDataSource();
        $("#gridSpLog").kendoGrid({
            dataSource: dataSource,
            height: getGridHeightKendo(),
            selectable: true,
            sortable: true,
            resizable: true,
            reorderable: true,
            autoBind: false,
            pageable: {
                refresh: true,
                pageSizes: getDefaultPageSizes(),
                buttonCount: 4
            },
            columns: [
                {field: "service", title: "Sector/CSU", width: 50, sortable: false, filterable: kendoCommonFilterable(98)},
                {
                    field: "deadLine",title: "Dead Line",
                    width: 50, sortable: false,filterable: false,
                    template: "#=deadLine?kendo.toString(kendo.parseDate(deadLine, 'yyyy-MM-dd'), 'dd-MM-yyyy'):'Not set yet'#",
                    attributes: {style: setAlignCenter()},
                    headerAttributes: {style: setAlignCenter()}
                },
                {field: "isSubmitted", title: "Submitted", width: 50, sortable: false,
                    filterable: { messages: { isTrue: " YES ", isFalse: " NO " }},
                    attributes: {style: setAlignCenter()},headerAttributes: {style: setAlignCenter()},
                    template:"#=isSubmitted?'YES':'NO'#"
                },
                {field: "submissionDate", title: "Submission Date", width: 50, sortable: false,
                    filterable: false,template:"#=isSubmitted?kendo.toString(kendo.parseDate(submissionDate, 'yyyy-MM-dd'), 'dd-MM-yyyy'):''#",
                    attributes: {style: setAlignCenter()},headerAttributes: {style: setAlignCenter()}
                },
                {field: "isEditable", title: "Editable", width: 50, sortable: false,
                    filterable: { messages: { isTrue: " YES ", isFalse: " NO " }, extra: false},
                    attributes: {style: setAlignCenter()},headerAttributes: {style: setAlignCenter()},
                    template:"#=isEditable?'YES':'NO'#"
                }
            ],
            filterable: {
                mode: "row"
            },
            toolbar: kendo.template($("#gridToolbar").html())
        });
        gridSpLog = $("#gridSpLog").data("kendoGrid");
        $("#menuGrid").kendoMenu();
    }

    function initObservable() {
        SpLogModel = kendo.observable(
                {
                    spLog: {
                        id: "",
                        version: "",
                        serviceId: "",
                        year: currentYear,
                        isSubmitted: "",
                        isEditable: ""
                    }
                }
        );
        kendo.bind($("#application_top_panel"), SpLogModel);
    }

    function editService(){
        if (executeCommonPreConditionForSelectKendo(gridSpLog, 'spLog') == false) {
            return;
        }
        var spLog = getSelectedObjectFromGridKendo(gridSpLog);
        showService(spLog);
    }

    function showService(spLog) {
        SpLogModel.set('spLog', spLog);
        $('#year').val(spLog.year);
        $('#create').html("<span class='k-icon k-i-plus'></span>Update");
    }

    function deleteService() {
        if (executeCommonPreConditionForSelectKendo(gridSpLog, 'spLog') == false) {
            return;
        }
        var msg = 'Are you sure you want to delete the selected record?',
                url = "${createLink(controller: 'pmSpLog', action:  'delete')}";
        confirmDelete(msg, url, gridSpLog);
    }
    function showDeadLineModel() {
        $("#createSPModal").modal('show');
        $('#modalSPYear').kendoDatePicker({
            format: "yyyy",
            parseFormats: ["yyyy-MM-dd"],
            start: "decade",
            depth: "decade"
        }).data("kendoDatePicker");
        $('#modalSPYear').val(currentYear);

        currentDate = moment().format('DD/MM/YYYY');
        $('#modalSPDeadLine').kendoDatePicker({
            format: "dd/MM/yyyy",
            parseFormats: ["yyyy-MM-dd"]
        }).data("kendoDatePicker");
        $('#modalSPDeadLine').val(currentDate);
    }
    function onClickSPModal() {
        jQuery.ajax({
            type: 'post',
            data: jQuery("#createSPModalForm").serialize(),
            url: "${createLink(controller: 'pmSpLog', action: 'updateDeadLine')}",
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
        $("#createSPModal").modal('hide');
    }

    function showEditableActions(){
        if (executeCommonPreConditionForSelectKendo(gridSpLog, 'sector/csu') == false) {
            return;
        }
        var object = getSelectedObjectFromGridKendo(gridSpLog);
        if(!object.isEditable){
            showError('First make SP editable to make actions editable');
            return false;
        }
        showLoadingSpinner(true);
        var params = "?serviceId=" + object.serviceId + "&year=" + object.year + "&service=" + object.serviceName;
        var loc = "${createLink(controller: 'pmActions', action: 'showEditableActions')}" + params;
        router.navigate(formatLink(loc));
        return false;
    }
</script>
