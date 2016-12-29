<script type="text/x-kendo-template" id="gridToolbar">
<ul id="menuGrid" class="kendoGridMenu">
    <sec:access url="/pmSpLog/create">
        <li onclick="addService();"><i class="fa fa-plus-square"></i>Add</li>
    </sec:access>
    <sec:access url="/pmSpLog/update">
        <li onclick="editService();"><i class="fa fa-edit"></i>Edit</li>
    </sec:access>
%{--    <sec:access url="/pmSpLog/delete">
        <li onclick="deleteService();"><i class="fa fa-trash-o"></i>Delete</li>
    </sec:access>--}%
</ul>
</script>

<script language="javascript">
    var currentYear,gridSpLog, dataSource, SpLogModel,dropDownService,editTypeIds,editableActionIds;

    $(document).ready(function () {
        onLoadSpLogPage();
        initSpLogGrid();
        initObservable();
    });

    function onLoadSpLogPage() {
        currentYear = moment().format('YYYY');
        $('#year').kendoDatePicker({
            format: "yyyy",
            parseFormats: ["yyyy-MM-dd"],
            start: "decade",
            depth: "decade",
            change: populateActionIds
        }).data("kendoDatePicker");

        $("#editTypeIds").kendoMultiSelect({
            dataTextField: "name",
            dataValueField: "id",
            filter: "contains",
            suggest: true,
            dataSource: getBlankDataSource
        });
        editTypeIds = $("#editTypeIds").data("kendoMultiSelect");
        editTypeIds.setDataSource(${lstSpEditType});

        $("#editableActionIds").kendoMultiSelect({
            dataTextField: "name",
            dataValueField: "id",
            filter: "contains",
            suggest: true,
            dataSource: getBlankDataSource
        });
        editableActionIds = $("#editableActionIds").data("kendoMultiSelect");

        $("#rowSpLog").hide();
        initializeForm($("#spLogForm"), onSubmitSpLog);
        defaultPageTile("Create SP Log",null);
    }
    function showAndHideEditing(){
        editTypeIds.value('');
        editableActionIds.value('');
        var isEditable = $("#isEditable").is(":checked");
        if(isEditable){
            editTypeIds.readonly(false);
            editableActionIds.readonly(false);
        }else{
            editTypeIds.readonly(true);
            editableActionIds.readonly(true);
        }
    }
    function populateActionIds(){
        editableActionIds.setDataSource('');
        var serviceId = $('#serviceId').val();
        var year = $('#year').val();
        if(serviceId!='' && year!=''){
            $.ajax({
                url: "${createLink(controller: 'pmActions', action: 'lstActionsByServiceIdAndYear')}?serviceId=" + serviceId + "&year="+ year,
                success: function (data) {
                    editableActionIds.setDataSource(data.lstActions);
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    editableActionIds.setDataSource('');
                    afterAjaxError(XMLHttpRequest, textStatus);
                },
                complete: function (XMLHttpRequest, textStatus) {
                    showLoadingSpinner(false);
                },
                dataType: 'json',
                type: 'post'
            });
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
        editTypeIds.readonly(true);
        editableActionIds.readonly(true);
        $('#create').html("<span class='k-icon k-i-plus'></span>Create");
    }

    function resetForm() {
        initObservable();
        $('#year').val(currentYear);
        editTypeIds.readonly(true);
        editableActionIds.readonly(true);
        $('#rowSpLog').hide();
    }

    function initDataSource() {
        dataSource = new kendo.data.DataSource({
            transport: {
                read: {
                    url: "${createLink(controller: 'pmSpLog', action: 'list')}",
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
                        service: { type: "string" },
                        submissionDate: { type: "date" },
                        isSubmitted: { type: "boolean" },
                        isEditable: { type: "boolean" },
                        editTypeIds: { type: "string" },
                        editTypeIdStr: { type: "string" },
                        editableActionIds: { type: "string" }
                    }
                },
                parse: function (data) {
                    checkIsErrorGridKendo(data);
                    return data;
                }
            },
            sort: {field: 'id', dir: 'asc'},
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
            pageable: {
                refresh: true,
                pageSizes: getDefaultPageSizes(),
                buttonCount: 4
            },
            columns: [
                {field: "service", title: "Sector/CSU", width: 50, sortable: false, filterable: kendoCommonFilterable(98)},
                {field: "year", title: "SP Year", width: 50, sortable: false, filterable: {extra: false},
                    attributes: {style: setAlignCenter()},headerAttributes: {style: setAlignCenter()}
                },
                {field: "isSubmitted", title: "Submitted", width: 50, sortable: false,
                    filterable: { messages: { isTrue: "YES", isFalse: "NO" }},
                    attributes: {style: setAlignCenter()},headerAttributes: {style: setAlignCenter()},
                    template:"#=isSubmitted?'YES':'NO'#"
                },
                {field: "submissionDate", title: "Submission Date", width: 50, sortable: false,
                    filterable: false,template:"#=isSubmitted?kendo.toString(kendo.parseDate(submissionDate, 'yyyy-MM-dd'), 'dd-MM-yyyy'):''#",
                    attributes: {style: setAlignCenter()},headerAttributes: {style: setAlignCenter()}
                },
                {field: "isEditable", title: "Editable", width: 50, sortable: false,
                    filterable: { messages: { isTrue: "YES", isFalse: "NO" }, extra: false},
                    attributes: {style: setAlignCenter()},headerAttributes: {style: setAlignCenter()},
                    template:"#=isEditable?'YES':'NO'#"
                },
                {field: "editTypeIds", title: "Edit Type", width: 50, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()},headerAttributes: {style: setAlignCenter()},
                    template:"#=editTypeIdStr?editTypeIdStr:''#"
                },
                {field: "editableActionIds", title: "Editable Actions", width: 50, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()},headerAttributes: {style: setAlignCenter()},
                    template:"#=editableActionIds?editableActionIds:''#"
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
                        isEditable: "",
                        editTypeIds: "",
                        editableActionIds: ""
                    }
                }
        );
        kendo.bind($("#application_top_panel"), SpLogModel);
    }

    function addService(){
        $("#rowSpLog").show();
    }
    function editService(){
        if (executeCommonPreConditionForSelectKendo(gridSpLog, 'spLog') == false) {
            return;
        }
        $("#rowSpLog").show();
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

</script>
