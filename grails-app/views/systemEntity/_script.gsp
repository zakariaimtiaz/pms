<script type="text/x-kendo-template" id="gridToolbar">
<ul id="menuGrid" class="kendoGridMenu">
    <sec:access url="/systemEntity/update">
        <li onclick="editEntity();"><i class="fa fa-edit"></i>Edit</li>
    </sec:access>
    <sec:access url="/systemEntity/delete">
        <li onclick="deleteEntity();"><i class="fa fa-trash-o"></i>Delete</li>
    </sec:access>
</ul>
</script>

<script language="javascript">
    var gridSystemEntity, dataSource, SystemEntityModel,dropDownSystemEntityType;

    $(document).ready(function () {
        onLoadSystemEntityPage();
        initSystemEntityGrid();
        initObservable();
    });

    function onLoadSystemEntityPage() {
        // initialize form with kendo validator & bind onSubmit event
        initializeForm($("#systemEntityForm"), onSubmitSystemEntity);
        // update page title
        defaultPageTile("Create System Entity",null);
    }

    function executePreCondition() {
        if (!validateForm($("#systemEntityForm"))) {
            return false;
        }
        return true;
    }

    function onSubmitSystemEntity() {
        if (executePreCondition() == false) {
            return false;
        }

        setButtonDisabled($('#create'), true);
        showLoadingSpinner(true);
        var actionUrl = null;
        if ($('#id').val().isEmpty()) {
            actionUrl = "${createLink(controller:'systemEntity', action: 'create')}";
        } else {
            actionUrl = "${createLink(controller:'systemEntity', action: 'update')}";
        }

        jQuery.ajax({
            type: 'post',
            data: jQuery("#systemEntityForm").serialize(),
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
                var newEntry = result.systemEntity;
                if ($('#id').val().isEmpty() && newEntry != null) { // newly created
                    var gridData = gridSystemEntity.dataSource.data();
                    gridData.unshift(newEntry);
                } else if (newEntry != null) { // updated existing
                    var selectedRow = gridSystemEntity.select();
                    var allItems = gridSystemEntity.items();
                    var selectedIndex = allItems.index(selectedRow);
                    gridSystemEntity.removeRow(selectedRow);
                    gridSystemEntity.dataSource.insert(selectedIndex, newEntry);
                }
                resetForm();
                showSuccess(result.message);
            } catch (e) {
                // Do Nothing
            }
        }
    }

    function resetForm() {
        clearForm($("#systemEntityForm"), $('#typeId'));
        initObservable();
        $('#create').html("<span class='k-icon k-i-plus'></span>Create");
    }

    function initDataSource() {
        dataSource = new kendo.data.DataSource({
            transport: {
                read: {
                    url: "${createLink(controller: 'systemEntity', action: 'list')}",
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
                        typeId: { type: "number" },
                        typeName: { type: "string" },
                        name: { type: "string" }
                    }
                },
                parse: function (data) {
                    checkIsErrorGridKendo(data);
                    return data;
                }
            },
            sort: {field: 'typeName', dir: 'asc'},
            pageSize: getDefaultPageSize(),
            serverPaging: true,
            serverFiltering: true,
            serverSorting: true
        });
    }

    function initSystemEntityGrid() {
        initDataSource();
        $("#gridSystemEntity").kendoGrid({
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
                {field: "typeName", title: "Type", width: 100, sortable: false, filterable: kendoCommonFilterable()},
                {field: "name", title: "System Entity", width: 200, sortable: false, filterable: kendoCommonFilterable(97)}            ],
            filterable: {
                mode: "row"
            },
            toolbar: kendo.template($("#gridToolbar").html())
        });
        gridSystemEntity = $("#gridSystemEntity").data("kendoGrid");
        $("#menuGrid").kendoMenu();
    }

    function initObservable() {
        SystemEntityModel = kendo.observable(
                {
                    systemEntity: {
                        id: "",
                        version: "",
                        typeId: "",
                        typeName: "",
                        name: ""
                    }
                }
        );
        kendo.bind($("#application_top_panel"), SystemEntityModel);
    }

    function deleteEntity() {
        if (executeCommonPreConditionForSelectKendo(gridSystemEntity, 'entity') == false) {
            return;
        }
        var msg = 'Are you sure you want to delete the selected Entity?',
                url = "${createLink(controller: 'systemEntity', action:  'delete')}";
        confirmDelete(msg, url, gridSystemEntity);
    }

    function editEntity() {
        if (executeCommonPreConditionForSelectKendo(gridSystemEntity, 'entity') == false) {
            return;
        }
        var entity = getSelectedObjectFromGridKendo(gridSystemEntity);
        showSystemEntity(entity);
    }

    function showSystemEntity(entity) {
        SystemEntityModel.set('systemEntity', entity);
        $('#create').html("<span class='k-icon k-i-plus'></span>Update");
    }

</script>
