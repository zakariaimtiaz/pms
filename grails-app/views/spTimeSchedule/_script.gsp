<script type="text/x-kendo-template" id="gridToolbar">
<ul id="menuGrid" class="kendoGridMenu">
    <sec:access url="/spTimeSchedule/update">
    <li onclick="editService();"><i class="fa fa-edit"></i>Edit</li>
</sec:access>
<sec:access url="/spTimeSchedule/delete">
    <li onclick="deleteService();"><i class="fa fa-trash-o"></i>Delete</li>
</sec:access>
</ul>
</script>

<script language="javascript">
    var gridTimeSchedule, dataSource, spTimeScheduleModel,dropDownService,start,end,active;

    $(document).ready(function () {
        onLoadPage();
        initTimeScheduleGrid();
        initObservable();
    });

    function onLoadPage() {
        var currentDate = moment().format('MMMM YYYY');

        start = $('#from').kendoDatePicker({
            format: "yyyy",
            parseFormats: ["yyyy-MM-dd"],
            change: startChange,
            start: "decade",
            depth: "decade"
        }).data("kendoDatePicker");

        start.value(currentDate);

        end = $('#to').kendoDatePicker({
            format: "yyyy",
            parseFormats: ["yyyy-MM-dd"],
            start: "decade",
            depth: "decade"
        }).data("kendoDatePicker");

        active = $('#activeYear').kendoDatePicker({
            format: "yyyy",
            parseFormats: ["yyyy-MM-dd"],
            start: "decade",
            depth: "decade"
        }).data("kendoDatePicker");

        end.value(currentDate);
        end.min(start.value());
        active.min(start.value());
        active.max(end.value());
        initializeForm($("#timeScheduleForm"), onSubmitTimeSchedule);
        defaultPageTile("SP Time Schedule",'/spTimeSchedule/show');
    }
    function startChange() {
        var startDate = start.value();
        if (startDate) {
            startDate = new Date(startDate);
            startDate.setDate(startDate.getDate() + 1);
            end.min(startDate);
        }
    }

    function executePreCondition() {
        if (!validateForm($("#timeScheduleForm"))) {
            return false;
        }
        return true;
    }

    function onSubmitTimeSchedule() {
        if (executePreCondition() == false) {
            return false;
        }

        setButtonDisabled($('#create'), true);
        showLoadingSpinner(true);
        var actionUrl = null;
        if ($('#id').val().isEmpty()) {
            actionUrl = "${createLink(controller:'spTimeSchedule', action: 'create')}";
        } else {
            actionUrl = "${createLink(controller:'spTimeSchedule', action: 'update')}";
        }

        jQuery.ajax({
            type: 'post',
            data: jQuery("#timeScheduleForm").serialize(),
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
                var newEntry = result.spTimeSchedule;
                if ($('#id').val().isEmpty() && newEntry != null) { // newly created
                    var gridData = gridTimeSchedule.dataSource.data();
                    gridData.unshift(newEntry);
                } else if (newEntry != null) { // updated existing
                    var selectedRow = gridTimeSchedule.select();
                    var allItems = gridTimeSchedule.items();
                    var selectedIndex = allItems.index(selectedRow);
                    gridTimeSchedule.removeRow(selectedRow);
                    gridTimeSchedule.dataSource.insert(selectedIndex, newEntry);
                }
                resetForm();
                showSuccess(result.message);
            } catch (e) {
                // Do Nothing
            }
        }
    }

    function resetForm() {
        clearForm($("#timeScheduleForm"));
        initObservable();
        $('#create').html("<span class='k-icon k-i-plus'></span>Create");
    }

    function initDataSource() {
        dataSource = new kendo.data.DataSource({
            transport: {
                read: {
                    url: "${createLink(controller: 'spTimeSchedule', action: 'list')}",
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
                        activeYear: { type: "String" },
                        fromDate: { type: "date" },
                        toDate: { type: "date" },
                        isActive: { type: "boolean" },
                        description: { type: "String" }
                    }
                },
                parse: function (data) {
                    checkIsErrorGridKendo(data);
                    return data;
                }
            },
            sort: {field: 'fromDate', dir: 'asc'},
            pageSize: getDefaultPageSize(),
            serverPaging: true,
            serverFiltering: true,
            serverSorting: true
        });
    }

    function initTimeScheduleGrid() {
        initDataSource();
        $("#gridTimeSchedule").kendoGrid({
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
                {field: "fromDate", title: "Strategic Plan", width: 80, sortable: false, filterable: false,
                    template:"#=kendo.toString(kendo.parseDate(fromDate, 'yyyy-MM-dd'), 'yyyy')# ~ #=kendo.toString(kendo.parseDate(toDate, 'yyyy-MM-dd'), 'yyyy')#"},
                {field: "activeYear", title: "Active Year", width: 50, sortable: false, filterable: false},
                {field: "isActive", title: "Active", width: 50, sortable: false, filterable: false,
                template: "#=isActive?'YES':'NO'#"},
                {field: "description", title: "Description", width: 200, sortable: false, filterable: false}
            ],
            filterable: {
                mode: "row"
            },
            toolbar: kendo.template($("#gridToolbar").html())
        });
        gridTimeSchedule = $("#gridTimeSchedule").data("kendoGrid");
        $("#menuGrid").kendoMenu();
    }

    function initObservable() {
        spTimeScheduleModel = kendo.observable(
                {
                    spTimeSchedule: {
                        id: "",
                        version: "",
                        activeYear: "",
                        fromDate: "",
                        toDate: "",
                        description: "",
                        isActive: ""
                    }
                }
        );
        kendo.bind($("#application_top_panel"), spTimeScheduleModel);
    }

    function deleteService() {
        if (executeCommonPreConditionForSelectKendo(gridTimeSchedule, 'spTimeSchedule') == false) {
            return;
        }
        var msg = 'Are you sure you want to delete the selected record?',
                url = "${createLink(controller: 'spTimeSchedule', action:  'delete')}";
        confirmDelete(msg, url, gridTimeSchedule);
    }

    function editService() {
        if (executeCommonPreConditionForSelectKendo(gridTimeSchedule, 'spTimeSchedule') == false) {
            return;
        }
        var spTimeSchedule = getSelectedObjectFromGridKendo(gridTimeSchedule);
        showService(spTimeSchedule);
    }

    function showService(spTimeSchedule) {
        spTimeScheduleModel.set('spTimeSchedule', spTimeSchedule);
        $('#create').html("<span class='k-icon k-i-plus'></span>Update");
    }

</script>
