<script type="text/x-kendo-template" id="gridToolbar">
<ul id="menuGrid" class="kendoGridMenu">
    <sec:access url="/pmActions/create">
        <li onclick="addService();"><i class="fa fa-plus-square"></i>Add</li>
    </sec:access>
    <sec:access url="/pmActions/update">
        <li onclick="editService();"><i class="fa fa-edit"></i>Edit</li>
    </sec:access>
    <sec:access url="/pmActions/delete">
        <li onclick="deleteService();"><i class="fa fa-trash-o"></i>Delete</li>
    </sec:access>
</ul>
</script>

<script language="javascript">
    var gridActions, dataSource, actionsModel, dropDownService, dropDownGoals, supportDepartment, dropDownEmployee;

    $(document).ready(function () {
        onLoadActionPage();
        initActionsGrid();
        initObservable();
        dynamicIndicator();
    });
    function validate(evt) {
        var theEvent = evt || window.event;
        var key = theEvent.keyCode || theEvent.which;
        key = String.fromCharCode(key);
        var regex = /[0-9]|\./;
        if (!regex.test(key)) {
            theEvent.returnValue = false;
            if (theEvent.preventDefault) theEvent.preventDefault();
        }
    }
    function getName(name, target) {
        var index = name.slice(-1);
        var tmp = 'input[name=indicator' + index + ']';
        var indicator = $(tmp).val();
        var start = $('#start').val();
        var end = $('#end').val();
        var count = monthDifference(start, end);
        var list = monthNamesFromRange(start, end);
        if (count > 1 && target > 0 && indicator != '') showIndicatorModal(indicator, target, count, list);
    }

    function dynamicIndicator() {
        var i = 1;
        $("#add_row").click(function () {
            var end = $('#end').val();
            if (end != '') {
                $('#addr' + i).html("<td width='60%'><input name='indicator" + i + "' type='text'  placeholder='Indicator' class='form-control'/></td>" +
                "<td width='40%'><input  name='target" + i + "' type='text' onkeypress='validate(event)' placeholder='Target' class='form-control'  onblur ='getName(this.name,this.value)'></td>");
            } else {
                $('#addr' + i).html("<td width='60%'><input name='indicator" + i + "' type='text' readonly='true' placeholder='Indicator' class='form-control'/></td>" +
                "<td width='40%'><input  name='target" + i + "' type='text' onkeypress='validate(event)' placeholder='Target' readonly='true' class='form-control'  onblur ='getName(this.name,this.value)'></td>");
            }
            $('#tab_logic').append('<tr id="addr' + (i + 1) + '"></tr>');
            i++;
        });
        $("#delete_row").click(function () {
            if (i > 1) {
                $("#addr" + (i - 1)).html('');
                i--;
            }
        });
    }
    function onLoadActionPage() {
        $("#rowAction").hide();
        $("#weight").kendoNumericTextBox({
            decimals: 0,
            format: "### \\%",
            min: 1,
            max: 100
        });
        $('#start').kendoDatePicker({
            format: "MMMM yyyy",
            parseFormats: ["yyyy-MM-dd"],
            start: "year",
            depth: "year",
            change: function () {
                var value = this.value();
                if (value == '' || value == null) {
                    $('#end').val('');
                }
            }
        });
        $('#end').kendoDatePicker({
            format: "MMMM yyyy",
            parseFormats: ["yyyy-MM-dd"],
            start: "year",
            depth: "year",
            change: function () {
                var value = this.value();
                var start = $('#start').val();
                if (start == '') {
                    $('#end').val('');
                    $('#start').focus();
                    return false;
                }
                if (value != '' || value != null) {
                    $(':input').prop('readonly', false);
                }
            }
        });
        dropDownGoals = initKendoDropdown($('#goalId'), null, null, null);

        $("#supportDepartment").kendoMultiSelect({
            dataTextField: "name",
            dataValueField: "id",
            filter: "contains",
            suggest: true,
            dataSource: getBlankDataSource
        });
        supportDepartment = $("#supportDepartment").data("kendoMultiSelect");
        supportDepartment.setDataSource(${lstService});
        initializeForm($("#actionForm"), onSubmitAction);
        defaultPageTile("Create Actions", null);
    }

    function executePreCondition() {
        if ($("#serviceId").val() == '') {
            showError('Please select any service.');
            return false;
        } else if ($("#goalId").val() == '') {
            showError('Please select any goal.');
            return false;
        } else if ($("#start").val() == '') {
            showError('Please select start date.');
            return false;
        } else if ($("#end").val() == '') {
            showError('Please select end date.');
            return false;
        } else if ($("#actions").val() == '') {
            showError('Please insert actions.');
            return false;
        } else if ($("#weight").val() == '') {
            showError('Please insert weight.');
            return false;
        } else if ($("#resPersonId").val() == '') {
            showError('Please select responsible person.');
            return false;
        }
        return true;
    }

    function onSubmitAction() {
        if (executePreCondition() == false) {
            return false;
        }
//        setButtonDisabled($('#create'), true);
//        showLoadingSpinner(true);
        var actionUrl = null;
        if ($('#id').val().isEmpty()) {
            actionUrl = "${createLink(controller:'pmActions', action: 'create')}";
        } else {
            actionUrl = "${createLink(controller:'pmActions', action: 'update')}";
        }
        var resPerson = $("#resPersonId").data("kendoDropDownList").text();
        console.log(jQuery("#actionForm").serialize());
        /*        jQuery.ajax({
         type: 'post',
         data: jQuery("#actionForm").serialize()+ '&resPerson=' + resPerson,
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
         });*/
        return false;
    }

    function executePostCondition(result) {
        if (result.isError) {
            showError(result.message);
            showLoadingSpinner(false);
        } else {
            try {
                var newEntry = result.pmAction;
                if ($('#id').val().isEmpty() && newEntry != null) { // newly created
                    var gridData = gridActions.dataSource.data();
                    gridData.unshift(newEntry);
                } else if (newEntry != null) { // updated existing
                    var selectedRow = gridActions.select();
                    var allItems = gridActions.items();
                    var selectedIndex = allItems.index(selectedRow);
                    gridActions.removeRow(selectedRow);
                    gridActions.dataSource.insert(selectedIndex, newEntry);
                }
                emptyForm();
                showSuccess(result.message);
            } catch (e) {
                // Do Nothing
            }
        }
    }

    function emptyForm() {
        clearForm($("#actionForm"), null);
        initObservable();
        dropDownService.value('');
        dropDownGoals.value('');
    }
    function resetForm() {
        clearForm($("#actionForm"), null);
        initObservable();
        dropDownService.value('');
        dropDownGoals.value('');
        $("#rowAction").hide();
        $('#create').html("<span class='k-icon k-i-plus'></span>Create");
    }

    function initDataSource() {
        dataSource = new kendo.data.DataSource({
            transport: {
                read: {
                    url: "${createLink(controller: 'pmActions', action: 'list')}",
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
                        actions: {type: "string"},
                        weight: {type: "number"},
                        goalId: {type: "number"},
                        resPersonId: {type: "number"},
                        goal: {type: "string"},
                        service: {type: "string"},
                        serShortName: {type: "string"},
                        serviceId: {type: "number"},
                        sequence: {type: "string"},
                        meaIndicator: {type: "string"},
                        target: {type: "string"},
                        resPerson: {type: "string"},
                        strategyMapRef: {type: "string"},
                        supportDepartment: {type: "string"},
                        supportDepartmentStr: {type: "string"},
                        sourceOfFund: {type: "string"},
                        remarks: {type: "string"},
                        start: {type: "date"},
                        end: {type: "date"}
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

    function initActionsGrid() {
        initDataSource();
        $("#gridActions").kendoGrid({
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
                {field: "serShortName", title: "Service", width: 60, sortable: false, filterable: false},
                {
                    field: "sequence", title: "ID#", width: 60, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()}
                },
                {
                    field: "weight",
                    title: "Weight",
                    width: 60,
                    sortable: false,
                    filterable: false,
                    template: "#=weight # %",
                    attributes: {style: setAlignCenter()},
                    headerAttributes: {style: setAlignCenter()}
                },
                {field: "actions", title: "Action", width: 120, sortable: false, filterable: false},
                {
                    field: "start", title: "Start", width: 80, sortable: false, filterable: false,
                    template: "#=kendo.toString(kendo.parseDate(start, 'yyyy-MM-dd'), 'MMMM-yy')#"
                },
                {
                    field: "end", title: "End", width: 80, sortable: false, filterable: false,
                    template: "#=kendo.toString(kendo.parseDate(end, 'yyyy-MM-dd'), 'MMMM-yy')#"
                },
                {field: "meaIndicator", title: "Measurement Indicator", width: 120, sortable: false, filterable: false},
                {field: "target", title: "Target", width: 80, sortable: false, filterable: false},
                {
                    field: "supportDepartmentStr",
                    title: "Support Department",
                    width: 120,
                    sortable: false,
                    filterable: false
                },
                {field: "resPerson", title: "Responsible Person", width: 120, sortable: false, filterable: false}
            ],
            filterable: {
                mode: "row"
            },
            toolbar: kendo.template($("#gridToolbar").html())
        });
        gridActions = $("#gridActions").data("kendoGrid");
        $("#menuGrid").kendoMenu();
    }

    function initObservable() {
        actionsModel = kendo.observable(
                {
                    actions: {
                        id: "",
                        version: "",
                        sequence: "",
                        actions: "",
                        serviceId: "",
                        resPersonId: "",
                        goalId: "",
                        meaIndicator: "",
                        target: "",
                        weight: "",
                        resPerson: "",
                        strategyMapRef: "",
                        supportDepartment: "",
                        sourceOfFund: "",
                        start: "",
                        end: ""
                    }
                }
        );
        kendo.bind($("#application_top_panel"), actionsModel);
    }

    function deleteService() {
        if (executeCommonPreConditionForSelectKendo(gridActions, 'action') == false) {
            return;
        }
        var msg = 'Are you sure you want to delete the selected action?',
                url = "${createLink(controller: 'pmActions', action:  'delete')}";
        confirmDelete(msg, url, gridActions);
    }

    function addService() {
        $("#rowAction").show();
    }
    function editService() {
        if (executeCommonPreConditionForSelectKendo(gridActions, 'action') == false) {
            return;
        }
        addService();
        var actions = getSelectedObjectFromGridKendo(gridActions);
        showService(actions);
    }

    function showService(actions) {
        actionsModel.set('actions', actions);
        dropDownEmployee.value(actions.resPersonId);
        if (actions.supportDepartment) supportDepartment.value(actions.supportDepartment.split(","));
        populateGoals(actions.serviceId, actions.goalId);
        $('#create').html("<span class='k-icon k-i-plus'></span>Update");
    }

    // To populate Goals List
    function populateGoals(serId, goalId) {
        var serviceId = serId ? serId : dropDownService.value();
        if (serviceId == '') {
            dropDownGoals.setDataSource(getKendoEmptyDataSource(dropDownGoals, null));
            dropDownGoals.value('');
            return false;
        }
        showLoadingSpinner(true);
        $.ajax({
            url: "${createLink(controller: 'pmGoals', action: 'lstGoalsByServiceId')}?serviceId=" + serviceId,
            success: function (data) {
                if (data.isError) {
                    showError(data.message);
                    return false;
                }
                dropDownGoals.setDataSource(data.lstGoals);
                if (goalId) {
                    dropDownGoals.value(goalId);
                }
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                afterAjaxError(XMLHttpRequest, textStatus);
            },
            complete: function (XMLHttpRequest, textStatus) {
                showLoadingSpinner(false);
            },
            dataType: 'json',
            type: 'post'
        });
        return true;
    }

    function showIndicatorModal(indicator, target, count, list) {
        $("#createIndicatorModal").modal('show');
        $('#indicatorModalIndicatorLbl').text(indicator);
        $('#indicatorModalTargetLbl').text(target);
        $("#i_logic tr").remove();
        for (var i = 0; i < count+1; i++) {
            var a = list[i];
            $('#iddr' + i).html("<td width='60%'><input name='month" + i + "' value ='"+list[i-1]+"' type='text' readonly='true' class='form-control'/></td>" +
            "<td width='40%'><input  name='tempTr" + i + "' type='text' onkeypress='validate(event)' placeholder='Target' class='form-control'></td>");
            $('#i_logic').append('<tr id="iddr' + (i + 1) + '"></tr>');
        }
    }

    function hideIndicatorModal() {
        $("#createIndicatorModal").modal('hide');
    }

    function onClickCreateIndicatorModal() {

    }

    function hideCreateIndicatorModal() {
        hideIndicatorModal();
    }

</script>
