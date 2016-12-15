<script type="text/x-kendo-template" id="gridToolbar">
<ul id="menuGrid" class="kendoGridMenu">
<sec:access url="/pmMissions/create">
    <li onclick="addService();"><i class="fa fa-plus-square"></i>Add</li>
</sec:access>
<sec:access url="/pmMissions/update">
    <li onclick="editService();"><i class="fa fa-edit"></i>Edit</li>
</sec:access>
<sec:access url="/pmMissions/delete">
    <li onclick="deleteService();"><i class="fa fa-trash-o"></i>Delete</li>
</sec:access>
</ul>
</script>

<script language="javascript">
    var gridMission, dataSource, missionModel,dropDownService, serviceId;

    $(document).ready(function () {
        onLoadMissionPage();
        initMissionGrid();
        initObservable();
    });

    function onLoadMissionPage() {
        $("#rowMissions").hide();
        serviceId = ${serviceId};
        initializeForm($("#missionForm"), onSubmitMission);
        defaultPageTile("Create Mission",null);
    }

    function executePreCondition() {
        if (!validateForm($("#missionForm"))) {
            return false;
        }
        return true;
    }

    function onSubmitMission() {
        if (executePreCondition() == false) {
            return false;
        }

        setButtonDisabled($('#create'), true);
        showLoadingSpinner(true);
        var actionUrl = null;
        if ($('#id').val().isEmpty()) {
            actionUrl = "${createLink(controller:'pmMissions', action: 'create')}";
        } else {
            actionUrl = "${createLink(controller:'pmMissions', action: 'update')}";
        }

        jQuery.ajax({
            type: 'post',
            data: jQuery("#missionForm").serialize(),
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
                var newEntry = result.pmMission;
                if ($('#id').val().isEmpty() && newEntry != null) { // newly created
                    var gridData = gridMission.dataSource.data();
                    gridData.unshift(newEntry);
                } else if (newEntry != null) { // updated existing
                    var selectedRow = gridMission.select();
                    var allItems = gridMission.items();
                    var selectedIndex = allItems.index(selectedRow);
                    gridMission.removeRow(selectedRow);
                    gridMission.dataSource.insert(selectedIndex, newEntry);
                }
                emptyForm();
                showSuccess(result.message);
            } catch (e) {
                // Do Nothing
            }
        }
    }
    function emptyForm() {
        clearForm($("#missionForm"), $('#serviceId'));
        initObservable();
        dropDownService.value(serviceId);
        $('#create').html("<span class='k-icon k-i-plus'></span>Create");
    }
    function resetForm() {
        clearForm($("#missionForm"), $('#serviceId'));
        initObservable();
        dropDownService.value(serviceId);
        $('#rowMissions').hide();
    }

    function initDataSource() {
        dataSource = new kendo.data.DataSource({
            transport: {
                read: {
                    url: "${createLink(controller: 'pmMissions', action: 'list')}",
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
                        mission: { type: "string" },
                        serviceId: { type: "number" },
                        service: { type: "string" },
                        sequence: { type: "number" }
                    }
                },
                parse: function (data) {
                    checkIsErrorGridKendo(data);
                    return data;
                }
            },
            sort: {field: 'sequence', dir: 'asc'},
            pageSize: getDefaultPageSize(),
            serverPaging: true,
            serverFiltering: true,
            serverSorting: true
        });
    }

    function initMissionGrid() {
        initDataSource();
        $("#gridMission").kendoGrid({
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
                {field: "service", title: "Sector/CSU", width: 100, sortable: false, filterable: kendoCommonFilterable(97)},
                {field: "mission", title: "Mission Statement", width: 200, sortable: false, filterable: false}
            ],
            filterable: {
                mode: "row"
            },
            toolbar: kendo.template($("#gridToolbar").html())
        });
        gridMission = $("#gridMission").data("kendoGrid");
        $("#menuGrid").kendoMenu();
    }

    function initObservable() {
        missionModel = kendo.observable(
                {
                    mission: {
                        id: "",
                        version: "",
                        mission: "",
                        serviceId: ""
                    }
                }
        );
        kendo.bind($("#application_top_panel"), missionModel);
    }

    function deleteService() {
        if (executeCommonPreConditionForSelectKendo(gridMission, 'mission') == false) {
            return;
        }
        var msg = 'Are you sure you want to delete the selected record?',
                url = "${createLink(controller: 'pmMissions', action:  'delete')}";
        confirmDelete(msg, url, gridMission);
    }
    function addService() {
        $('#rowMissions').show();
        dropDownService.value(serviceId);
    }
    function editService() {
        if (executeCommonPreConditionForSelectKendo(gridMission, 'mission') == false) {
            return;
        }
        $('#rowMissions').show();
        var mission = getSelectedObjectFromGridKendo(gridMission);
        showService(mission);
    }

    function showService(mission) {
        missionModel.set('mission', mission);
        $('#create').html("<span class='k-icon k-i-plus'></span>Update");
    }

</script>
