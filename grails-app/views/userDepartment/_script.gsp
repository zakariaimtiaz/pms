<script type="text/x-kendo-template" id="gridToolbar">
<ul id="menuGrid" class="kendoGridMenu">
    <sec:access url="/userDepartment/delete">
        <li onclick="deleteService();"><i class="fa fa-trash-o"></i>Delete</li>
    </sec:access>
</ul>
</script>

<script language="javascript">
    var gridUserDepartment, dataSource, userId,dropDownService;

    $(document).ready(function () {
        onLoadServicePage();
        initServiceGrid();
    });

    function onLoadServicePage() {
        userId = ${userId};
        $('#userId').val(userId);
        // initialize form with kendo validator & bind onSubmit event
        initializeForm($("#userDepartmentForm"), onSubmitService);
        // update page title
        defaultPageTile("User department mapping", "secUser/show");
    }

    function executePreCondition() {
        if (!$('#serviceId').val()) {
            showError('Please select Department');
            return false;
        }
        return true;
    }

    function onSubmitService() {
        if (executePreCondition() == false) {
            return false;
        }
        setButtonDisabled($('#create'), true);
        showLoadingSpinner(true);
        var actionUrl = null;
        if ($('#id').val().isEmpty()) {
            actionUrl = "${createLink(controller:'userDepartment', action: 'create')}";
        } else {
            actionUrl = "${createLink(controller:'userDepartment', action: 'update')}";
        }

        jQuery.ajax({
            type: 'post',
            data: jQuery("#userDepartmentForm").serialize(),
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
                var newEntry = result.userDepartment;
                if ($('#id').val().isEmpty() && newEntry != null) { // newly created
                    var gridData = gridUserDepartment.dataSource.data();
                    gridData.unshift(newEntry);
                } else if (newEntry != null) { // updated existing
                    var selectedRow = gridUserDepartment.select();
                    var allItems = gridUserDepartment.items();
                    var selectedIndex = allItems.index(selectedRow);
                    gridUserDepartment.removeRow(selectedRow);
                    gridUserDepartment.dataSource.insert(selectedIndex, newEntry);
                }
                resetForm();
                showSuccess(result.message);
                $('#serviceId').reloadMe();
            } catch (e) {
                // Do Nothing
            }
        }
    }

    function resetForm() {
        clearForm($("#userDepartmentForm"), $('#serviceId'));
        $('#userId').val(userId);
        $('#serviceId').attr('default_value', '');
        $('#serviceId').reloadMe();
        $('#create').html("<span class='k-icon k-i-plus'></span>Assign");
    }

    function initDataSource() {
        dataSource = new kendo.data.DataSource({
            transport: {
                read: {
                    url: "${createLink(controller: 'userDepartment', action: 'list')}",
                    data: { userId: userId},
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
                        serviceId: { type: "number" },
                        userId: { type: "number" },
                        serviceName: { type: "string" },
                        serviceShortName: { type: "string" },
                        sequence: { type: "number" }
                    }
                },
                parse: function (data) {
                    checkIsErrorGridKendo(data);
                    return data;
                }
            },
            pageSize: 10,
            sort: {field: 'sequence', dir: 'asc'},
            serverPaging: true,
            serverFiltering: true,
            serverSorting: true
        });
    }

    function initServiceGrid() {
        initDataSource();
        $("#gridUserDepartment").kendoGrid({
            dataSource: dataSource,
            height: getGridHeightKendo(),
            selectable: true,
            sortable: true,
            resizable: true,
            reorderable: true,
            pageable: {
                refresh: true,
                pageSizes: [10, 15, 20],
                buttonCount: 4
            },
            columns: [
                {field: "serviceName", title: "Department", width: 100, sortable: false, filterable: kendoCommonFilterable(96)},
                {field: "serviceShortName", title: "Short Name", width: 100, sortable: false, filterable: kendoCommonFilterable(96)}
            ],
            filterable: {
                mode: "row"
            },
            toolbar: kendo.template($("#gridToolbar").html())
        });
        gridUserDepartment = $("#gridUserDepartment").data("kendoGrid");
        $("#menuGrid").kendoMenu();
    }

    function deleteService() {
        if (executePreConditionForDelete() == false) {
            return;
        }
        showLoadingSpinner(true);
        var id = getSelectedIdFromGridKendo(gridUserDepartment);
        $.ajax({
            url: "${createLink(controller: 'userDepartment', action:  'delete')}?id="+id,
            success: executePostConditionForDelete,
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                afterAjaxError(XMLHttpRequest, textStatus)
            },
            complete: function (XMLHttpRequest, textStatus) {
                showLoadingSpinner(false);
            },
            dataType: 'json',
            type: 'post'
        });
    }

    function executePreConditionForDelete() {
        if (executeCommonPreConditionForSelectKendo(gridUserDepartment, 'department') == false) {
            return false;
        }
        if (!confirm('Are you sure you want to delete the selected Department?')) {
            return false;
        }
        return true;
    }

    <%-- removing selected row and clean input form --%>
    function executePostConditionForDelete(data) {
        if (data.isError){
            showError(data.message);
            return false;
        }
        var row = gridUserDepartment.select();
        row.each(function () {
            gridUserDepartment.removeRow($(this));
        });
        resetForm();
        showSuccess(data.message);
        $('#serviceId').reloadMe();
    }

</script>
