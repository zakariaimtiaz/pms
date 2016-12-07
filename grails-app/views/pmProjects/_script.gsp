<script type="text/x-kendo-template" id="gridToolbar">
<ul id="menuGrid" class="kendoGridMenu">
    <sec:access url="/pmProjects/create">
        <li onclick="addService();"><i class="fa fa-plus-square"></i>Add</li>
    </sec:access>
    <sec:access url="/pmProjects/update">
        <li onclick="editService();"><i class="fa fa-edit"></i>Edit</li>
    </sec:access>
    <sec:access url="/pmProjects/delete">
        <li onclick="deleteService();"><i class="fa fa-trash-o"></i>Inactive</li>
    </sec:access>
</ul>
</script>

<script language="javascript">
    var gridProjects, dataSource, projectsModel,dropDownService,dropDownProjectsType;

    $(document).ready(function () {
        onLoadProjectsPage();
        initProjectsGrid();
        initObservable();
    });

    function onLoadProjectsPage() {
        $("#rowProjects").hide();
        $("#weight").kendoNumericTextBox({
            decimals : 0,
            format   : "### \\%",
            min      : 1,
            max      : 100
        });
        var currentDate = moment().format('MMMM yyyy');

        start = $('#startDate').kendoDatePicker({
            format: "MMMM yyyy",
            parseFormats: ["yyyy-MM-dd"],
            change: startChange,
            start: "year",
            depth: "year"
        }).data("kendoDatePicker");

        start.value(currentDate);

        end = $('#endDate').kendoDatePicker({
            format: "MMMM yyyy",
            parseFormats: ["yyyy-MM-dd"],
            start: "year",
            depth: "year"
        }).data("kendoDatePicker");

        end.value(currentDate);
        end.min(start.value());
        initializeForm($("#projectForm"), onSubmitProjects);
        defaultPageTile("Create Projects","/pmProjects/show");
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
        if (!validateForm($("#projectForm"))) {
            return false;
        }
        return true;
    }

    function onSubmitProjects() {
        if (executePreCondition() == false) {
            return false;
        }

        setButtonDisabled($('#create'), true);
        showLoadingSpinner(true);
        var actionUrl = null;
        if ($('#id').val().isEmpty()) {
            actionUrl = "${createLink(controller:'pmProjects', action: 'create')}";
        } else {
            actionUrl = "${createLink(controller:'pmProjects', action: 'update')}";
        }

        jQuery.ajax({
            type: 'post',
            data: jQuery("#projectForm").serialize(),
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
                var newEntry = result.pmProjects;
                if ($('#id').val().isEmpty() && newEntry != null) { // newly created
                    var gridData = gridProjects.dataSource.data();
                    gridData.unshift(newEntry);
                } else if (newEntry != null) { // updated existing
                    var selectedRow = gridProjects.select();
                    var allItems = gridProjects.items();
                    var selectedIndex = allItems.index(selectedRow);
                    gridProjects.removeRow(selectedRow);
                    gridProjects.dataSource.insert(selectedIndex, newEntry);
                }
                emptyForm();
                showSuccess(result.message);
            } catch (e) {
                // Do Nothing
            }
        }
    }
    function executePostConditionDelete(result) {
        if (result.isError) {
            showError(result.message);
            showLoadingSpinner(false);
        } else {
            try {
                var newEntry = result.pmProjects;
                var selectedRow = gridProjects.select();
                    var allItems = gridProjects.items();
                    var selectedIndex = allItems.index(selectedRow);
                    gridProjects.removeRow(selectedRow);
                    gridProjects.dataSource.insert(selectedIndex, newEntry);

                showSuccess(result.message);
            } catch (e) {
                // Do Nothing
            }
        }
    }

    function emptyForm() {
        clearForm($("#projectForm"), $('#serviceId'));
        initObservable();
        dropDownService.value('');
        dropDownProjectsType.value('');
        $('#create').html("<span class='k-icon k-i-plus'></span>Create");
    }
    function resetForm() {
        initObservable();
        dropDownService.value('');
        dropDownProjectsType.value('');
        $('#rowProjects').hide();
    }

    function initDataSource() {
        dataSource = new kendo.data.DataSource({
            transport: {
                read: {
                    url: "${createLink(controller: 'pmProjects', action: 'list')}",
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
                        name: { type: "string" },
                        shortName: { type: "string" },
                        typeId: { type: "number" },
                        typeName: { type: "string" },
                        code: { type: "string" },
                        serviceId: { type: "number" },
                        service: { type: "string" },
                        donor: { type: "string" },
                        description: { type: "string" },
                        startDate: { type: "date" },
                        endDate: { type: "date" },
                        inActive:{type:"boolean"}
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

    function initProjectsGrid() {
        initDataSource();
        $("#gridProjects").kendoGrid({
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
                {field: "service", title: "Service", width: 100, sortable: false, filterable: false},
                {field: "code", title: "Code", width: 50, sortable: false, filterable: false},
                {field: "name", title: "Name", width: 120, sortable: false, filterable: false},
                {field: "shortName", title: "Short Name", width: 80, sortable: false, filterable: false},
                {field: "typeName", title: "Status", width: 50, sortable: false, filterable: false},
                {field: "donor", title: "donor", width: 120, sortable: false, filterable: false},
                {field: "startDate", title: "Start Date", width: 60, sortable: false, filterable: false,
                    template:"#=kendo.toString(kendo.parseDate(startDate, 'yyyy-MM-dd'), 'MMMM-yy')#"},
                {field: "endDate", title: "End Date", width: 60, sortable: false, filterable: false,
                    template:"#=kendo.toString(kendo.parseDate(endDate, 'yyyy-MM-dd'), 'MMMM-yy')#"},
                {field: "inActive", title: "Active", width: 60, sortable: false, filterable: false,
                    template:"#=inActive?'No':'Yes'#"}

            ],
            filterable: {
                mode: "row"
            },
            toolbar: kendo.template($("#gridToolbar").html())
        });
        gridProjects = $("#gridProjects").data("kendoGrid");
        $("#menuGrid").kendoMenu();
    }

    function initObservable() {
        projectsModel = kendo.observable(
                {
                    project: {
                        id: "",
                        version: "",
                        name: "",
                        shortName: "",
                        typeId: "",
                        typeName: "",
                        code: "",
                        serviceId: "",
                        service: "",
                        donor: "",
                        description: "",
                        startDate: "",
                        endDate: ""
                    }
                }
        );
        kendo.bind($("#application_top_panel"), projectsModel);
    }

    function deleteService() {
        if (executeCommonPreConditionForSelectKendo(gridProjects, 'project') == false) {
            return;
        }
        var msg = 'Are you sure you want to inactive the selected record?',
                url = "${createLink(controller: 'pmProjects', action:  'delete')}";
        bootbox.confirm(msg, function(result) {
            if(result){
                var id = getSelectedIdFromGridKendo(gridProjects);
                jQuery.ajax({
                    type: 'post',
                    url: url+ "?id=" + id,
                    success: function (data, textStatus) {
                        executePostConditionDelete(data);
                    },
                    error: function (XMLHttpRequest, textStatus, errorThrown) {
                    },
                    complete: function (XMLHttpRequest, textStatus) {
                        showLoadingSpinner(false);
                    },
                    dataType: 'json'
                });
            }
        }).find("div.modal-content").addClass("conf-delete");
    }
    function addService(){
        $("#rowProjects").show();
    }
    function editService() {
        if (executeCommonPreConditionForSelectKendo(gridProjects, 'project') == false) {
            return;
        }
        $("#rowProjects").show();
        var project = getSelectedObjectFromGridKendo(gridProjects);
        showService(project);
    }

    function showService(project) {
        projectsModel.set('project', project);
        $('#create').html("<span class='k-icon k-i-plus'></span>Update");
    }

</script>
