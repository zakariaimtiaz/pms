<script type="text/x-kendo-template" id="gridToolbar">
<ul id="menuGrid" class="kendoGridMenu">
    <sec:access url="/appMail/create">
        <li onclick="addAppMail();"><i class="fa fa-plus-square"></i>Add</li>
    </sec:access>
    <sec:access url="/appMail/update">
        <li onclick="editAppMail();"><i class="fa fa-edit"></i>Edit</li>
    </sec:access>
    <sec:access url="/appMail/testAppMail">
        <li onclick="testAppMail();"><i class="fa fa-envelope-o"></i>Send Mail</li>
    </sec:access>
</ul>
</script>

<script language="javascript" type="text/javascript">

    var appMailGrid, appMailDataSource, appMailModel, pluginId;

    $(document).ready(function () {
        onLoadAppMailPage();
        initAppMailGrid();
        initObservable();
    });

    function onLoadAppMailPage() {
        $("#rowMailTmpl").hide();
        initializeForm($("#appMailForm"), onSubmitAppMailForm);
        $(document).attr('title', "AppMail Template");
    }

    function executePreCondition() {
        if (!validateForm($("#appMailForm"))) {
            return false;
        }
        return true;
    }

    function onSubmitAppMailForm() {
        if (executePreCondition() == false) {
            return false;
        }
        setButtonDisabled($('#create'), true);
        showLoadingSpinner(true);
        var actionUrl = null;
        if ($('#id').val().isEmpty()) {
            actionUrl = "${createLink(controller:'appMail', action: 'create')}";
        } else {
            actionUrl = "${createLink(controller:'appMail', action: 'update')}";
        }
        jQuery.ajax({
            type: 'post',
            data: jQuery("#appMailForm").serialize(),
            url: actionUrl,
            success: function (data, textStatus) {
                executePostCondition(data);
                setButtonDisabled($('#create'), false);
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                afterAjaxError(XMLHttpRequest, textStatus)
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
            var newEntry = result.appMail;
            var selectedRow = appMailGrid.select();
            var allItems = appMailGrid.items();
            var selectedIndex = allItems.index(selectedRow);
            appMailGrid.removeRow(selectedRow);
            appMailGrid.dataSource.insert(selectedIndex, newEntry);
            resetForm();
            showSuccess(result.message);
        }
    }

    function initDataSource() {
        appMailDataSource = new kendo.data.DataSource({
            transport: {
                read: {
                    url: "${createLink(controller: 'appMail', action: 'list')}",
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
                        subject: {type: "string"},
                        body: {type: "string"},
                        transactionCode: {type: "string"},
                        isManualSend: {type: "boolean"},
                        controllerName: {type: "string"},
                        actionName: {type: "string"},
                        isRequiredRoleIds: {type: "boolean"},
                        roleIds: {type: "string"},
                        isRequiredRecipients: {type: "boolean"},
                        recipients: {type: "string"},
                        isActive: {type: "boolean"}
                    }
                },
                parse: function (data) {
                    checkIsErrorGridKendo(data);
                    return data;
                }
            },
            sort: {field: 'id', dir: 'desc'},
            pageSize: 2,
            serverPaging: true,
            serverFiltering: true,
            serverSorting: true
        });
    }

    function initAppMailGrid() {
        initDataSource();
        $("#gridAppMail").kendoGrid({
            dataSource: appMailDataSource,
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
                {field: "transactionCode", title: "Transaction Code", width: 150, sortable: false, filterable: false},
                {field: "subject", title: "Subject", width: 100, sortable: false, filterable: false},
                {field: "body", title: "Mail Body", width: 200, sortable: false, filterable: false,
                template:"#=body#"},
                {field: "recipients", title: "Roles/Recipients", width: 80, sortable: false, filterable: false,
                template:"#=roleIds?roleIds:recipients#"},
                {
                    field: "isActive", title: "Active", width: 40, sortable: false, filterable: false,
                    template: "#= isActive?'YES':'NO'#"
                },
                {
                    field: "isManualSend", title: "Manual", width: 40, sortable: false, filterable: false,
                    template: "#= isManualSend?'YES':'NO'#"
                }
            ],
            filterable: {
                mode: "row"
            },
            toolbar: kendo.template($("#gridToolbar").html())
        });
        appMailGrid = $("#gridAppMail").data("kendoGrid");
        $("#menuGrid").kendoMenu();
    }

    function initObservable() {
        appMailModel = kendo.observable(
                {
                    appMail: {
                        id: "",
                        version: "",
                        subject: "",
                        body: "",
                        transactionCode: "",
                        roleIds: "",
                        isActive: false,
                        isManualSend: "",
                        controllerName: "",
                        actionName: "",
                        recipients: ""
                    }
                }
        );
        kendo.bind($("#application_top_panel"), appMailModel);
    }

    function resetForm() {
        clearForm($("#appMailForm"), $("#transactionCode"));
        initObservable();
        $("#rowMailTmpl").hide();
        $("#create").html("<span class='k-icon k-i-plus'></span>Save");
    }

    function addAppMail() {
        $("#rowMailTmpl").show();
    }
    function editAppMail() {
        if (executeCommonPreConditionForSelectKendo(appMailGrid, 'mail') == false) {
            return;
        }
        $("#rowMailTmpl").show();
        var appMailObj = getSelectedObjectFromGridKendo(appMailGrid);
        showAppMail(appMailObj);
    }

    function showAppMail(appMailObj) {
        appMailModel.set('appMail', appMailObj);
        $("#create").html("<span class='k-icon k-i-plus'></span>Update");
    }

    function testAppMail(){
        if (executeCommonPreConditionForSelectKendo(appMailGrid, 'mail') == false) {
            return;
        }
        var isManualSend = getSelectedValueFromGridKendo(appMailGrid, 'isManualSend');
        if (!isManualSend) {
            showError('The selected mail can not be send manually');
            return false;
        }
        var transactionCode = getSelectedValueFromGridKendo(appMailGrid, 'transactionCode');

        if (!confirm('Are you sure you want to send this mail now?')) {
            return false;
        }
        showLoadingSpinner(true);

        $.ajax({
            url: "${createLink(controller: 'appMail', action: 'testAppMail')}?transactionCode="+transactionCode,
            success: function (result, textStatus) {
                if (result.isError) {
                    showError(result.message);
                } else {
                    showSuccess(result.message);
                }            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                afterAjaxError(XMLHttpRequest, textStatus);
            },
            complete: function (XMLHttpRequest, textStatus) {
                showLoadingSpinner(false);
            },
            dataType: 'json',
            type: 'post'
        });
    }

</script>