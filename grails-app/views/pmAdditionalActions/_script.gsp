<script type="text/x-kendo-template" id="gridToolbar">
<ul id="menuGrid" class="kendoGridMenu">
    <sec:access url="/pmAdditionalActions/create">
        <li onclick="addService();"><i class="fa fa-plus-square"></i>Add</li>
    </sec:access>
    <sec:access url="/pmAdditionalActions/update">
        <li onclick="editService();"><i class="fa fa-edit"></i>Edit</li>
    </sec:access>
<sec:access url="/pmAdditionalActions/delete">
    <li onclick="deleteService();"><i class="fa fa-trash-o"></i>Delete</li>
</sec:access>
</ul>
</script>

<script language="javascript">
    var gridActions, dataSource,dataSourceUnit, actionsModel, dropDownService, serviceId, dropDownGoals, supportDepartment, sourceOfFund, dropDownEmployee, st ;
    var map = {};
    var indCount = 1;
    var deletedIndicatorIds = '';

    $(document).ready(function () {

        onLoadActionPage();
        initActionsGrid();
        initObservable();

    });

    function onLoadActionPage() {
        $("#rowAction").hide();
        makeKendoDropDownList('unitId1');
        var start = $('#start').kendoDatePicker({
            format: "MMMM yyyy",
            parseFormats: ["yyyy-MM-dd"],
            start: "year",
            depth: "year"
        }).data("kendoDatePicker");

        var value='${submissionDate}';
$('#hfSubmissionDate').val('${submissionDate}');
        if(value!='') {
            st = new Date(moment('${submissionDate}').endOf('year'));
            start.min('${submissionDate}');
        }
        else{
            st = new Date(moment(new Date()).endOf('year'));
            start.min(new Date(moment(new Date()).startOf('year')))
        }
        start.max(st);

        $("#supportDepartment").kendoMultiSelect({
            dataTextField: "name",
            dataValueField: "id",
            filter: "contains",
            dataSource: getBlankDataSource,
            value: [  ]
        });
        supportDepartment = $("#supportDepartment").data("kendoMultiSelect");
        supportDepartment.setDataSource(${lstService});

        $("#sourceOfFund").kendoMultiSelect({
            dataTextField: "name",
            dataValueField: "id",
            filter: "contains",
            dataSource: getBlankDataSource,
            value: [  ]
        });
        sourceOfFund = $("#sourceOfFund").data("kendoMultiSelect");
        sourceOfFund.setDataSource(${lstProject});
        serviceId = ${serviceId};
        $("#required").hide();
        initializeForm($("#actionForm"), onSubmitAction);
        defaultPageTile("Create Actions", null);
    }

    function makeKendoDropDownList(name){
        var modalName = "#"+name;
        $(modalName).kendoComboBox({
            dataTextField   : 'name',
            dataValueField  : 'id',
            filter          : 'contains',
            suggest         : true,
            dataSource: {
                type: "json",
                transport: {
                    read: "${createLink(controller:'systemEntity', action: 'unitsByType')}"
                }
            }
        }).data("kendoComboBox");
        $(modalName).data("kendoComboBox").input.attr("placeholder", "Unit");

    }

    function validateQty(event) {
        var key = window.event ? event.keyCode : event.which;
        if (event.keyCode == 8 || event.keyCode == 9 || event.keyCode == 46
                || event.keyCode == 37 || event.keyCode == 39) {
            return true;
        }
        else if (key < 48 || key > 57) {
            return false;
        }
        else return true;
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
        }  else if ($("#indicator1").val() == '') {
            showError('Please insert indicator.');
            return false;
        } else if ($("#target1").val() == '') {
            showError('Please insert target.');
            return false;
        } else if ($("#unitId1").val() == '') {
            showError('Please insert unit.');
            return false;
        } else if ($("#actions").val() == '') {
            showError('Please insert actions.');
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
        var count = $('#tab_logic tr').length;
        $("#indicatorCount").val(count);
        $("#indicatorMaxId").val(indCount);
        $("#deletedIndicatorIds").val(deletedIndicatorIds.slice(0,-1));

        setButtonDisabled($('#create'), true);
        showLoadingSpinner(true);
        var actionUrl = null;
        if ($('#id').val().isEmpty()) {
            actionUrl = "${createLink(controller:'pmAdditionalActions', action: 'create')}";
        } else {
            actionUrl = "${createLink(controller:'pmAdditionalActions', action: 'update')}";
        }
        var resPerson = $("#resPersonId").data("kendoDropDownList").text();
        jQuery.ajax({
            type: 'post',
            data: jQuery("#actionForm").serialize() + '&resPerson=' + resPerson,
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
                var newEntry = result.pmAdditionalAction;
                if ($('#id').val().isEmpty() && newEntry != null) { // newly created
                    var gridData = gridActions.dataSource.data();
                    gridData.unshift(newEntry);
                    emptyForm();
                } else if (newEntry != null) { // updated existing
                    var selectedRow = gridActions.select();
                    var allItems = gridActions.items();
                    var selectedIndex = allItems.index(selectedRow);
                    gridActions.removeRow(selectedRow);
                    gridActions.dataSource.insert(selectedIndex, newEntry);
                    emptyForm();
                    $("#rowAction").hide();
                }
                showSuccess(result.message);
            } catch (e) {
                // Do Nothing
            }
        }
    }

    function emptyForm() {
        clearForm($("#actionForm"), null);
        initObservable();
        dropDownService.value(serviceId);
        dropDownGoals.value('');
        map = {};
        deletedIndicatorIds = ''
        dropDownGoals.readonly(false);
        clearIndicatorTable();
        $('#create').html("<span class='k-icon k-i-plus'></span>Save");
    }
    function resetForm() {
        clearForm($("#actionForm"), null);
        initObservable();
        dropDownService.value(serviceId);
        dropDownGoals.value('');
        dropDownGoals.readonly(false);
        clearIndicatorTable();
        map = {};
        deletedIndicatorIds = ''
        $("#rowAction").hide();
        $('#create').html("<span class='k-icon k-i-plus'></span>Save");
    }

    function initDataSource() {
        dataSource = new kendo.data.DataSource({
            transport: {
                read: {
                    url: "${createLink(controller: 'pmAdditionalActions', action: 'list')}",
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
                        goalId: {type: "number"},
                        totalIndicator: {type: "number"},
                        resPersonId: {type: "number"},
                        goal: {type: "string"},
                        service: {type: "string"},
                        serShortName: {type: "string"},
                        serviceId: {type: "number"},
                        tmpSeq: {type: "number"},
                        sequence: {type: "string"},
                        resPerson: {type: "string"},
                        strategyMapRef: {type: "string"},
                        supportDepartment: {type: "string"},
                        supportDepartmentStr: {type: "string"},
                        sourceOfFund: {type: "string"},
                        sourceOfFundStr: {type: "string"},
                        note: {type: "string"},
                        indicator: {type: "string"},
                        start: {type: "date"},
                        end: {type: "date"}
                    }
                },
                parse: function (data) {
                    checkIsErrorGridKendo(data);
                    return data;
                }
            },
            sort: [{field:'serviceId', dir: 'asc'},
                {field:'start', dir: 'asc',format: "{0:yyyy}"},
                {field:'goalId', dir: 'asc'},
                {field:'tmpSeq', dir: 'asc'},
            ],
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
            detailInit: initIndicator,
            dataBound: function () {
                this.expandRow(this.tbody.find("tr.k-master-row"));
            },
            pageable: {
                refresh: true,
                pageSizes: getDefaultPageSizes(),
                buttonCount: 4
            },
            columns: [
                {
                    field: "sequence", title: "ID#", width: 40, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()}
                },
                {field: "actions", title: "Action", width: 200, sortable: false, filterable: false},
                {
                    field: "start", title: "Start Date", width: 60, sortable: false, filterable: false,
                    template: "#=kendo.toString(kendo.parseDate(start, 'yyyy-MM-dd'), 'MMMM-yy')#"
                },
                {
                    field: "end", title: "End Date", width: 60, sortable: false, filterable: false,
                    template: "#=kendo.toString(kendo.parseDate(end, 'yyyy-MM-dd'), 'MMMM-yy')#"
                },
                {field: "resPerson", title: "Responsible Person", width: 90, sortable: false, filterable: false},
                {
                    field: "supportDepartmentStr", title: "Support Department", width: 90,
                    sortable: false, filterable: false
                },
                {field: "sourceOfFundStr", title: "Project", width: 80, sortable: false, filterable: false},
                {
                    field: "note",
                    title: "Remarks",
                    template: "#=trimTextForKendo(note,70)#",
                    width: 120,
                    sortable: false,
                    filterable: false
                }
            ],
            filterable: {
                mode: "row"
            },
            toolbar:  kendo.template($("#gridToolbar").html())
        });
        gridActions = $("#gridActions").data("kendoGrid");
        $("#menuGrid").kendoMenu();
    }
    $("#gridActions").kendoTooltip({
        filter: "td:nth-child(9)",
        width: 300,
        position: "top",
        content: function (e) {
            var dataItem = $("#gridActions").data("kendoGrid").dataItem(e.target.closest("tr"));
            return dataItem.note;
        }
    }).data("kendoTooltip");

    function initIndicator(e) {
        $("<div/>").appendTo(e.detailCell).kendoGrid({
            dataSource: {
                transport: {
                    read: {
                        url: "${createLink(controller: 'pmAdditionalActions', action: 'listIndicatorByActions')}?",
                        dataType: "json",
                        type: "post"
                    }
                },
                schema: {
                    type: 'json',
                    data: "list"
                },
                serverPaging: true,
                serverSorting: true,
                serverFiltering: true,
                pageSize: 50,
                filter: {field: "actionsId", operator: "eq", value: e.data.id}
            },
            scrollable: false,
            sortable: false,
            pageable: false,
            columns: [
                {field: "indicator", title: "Indicator"},
                {field: "target", title: "Target",template:"#=formatIndicator(indicatorType,target)#"},
                {field: "unitStr", title: "Unit"}
            ]
        });
    }
    function formatIndicator(indicatorType,target){
        if(indicatorType.match('%')){
            return target + ' % ';
        }
        return target
    }

    function returnUnit(unitStr){
        return unitStr;
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
                        resPerson: "",
                        strategyMapRef: "",
                        supportDepartment: "",
                        sourceOfFund: "",
                        note: "",
                        indicator: "",
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

        var actions = getSelectedObjectFromGridKendo(gridActions);
        var value=$('#hfSubmissionDate').val();
        if(actions.start.getMonth()<new Date(value).getMonth() && actions.start.getYear() <= new Date(value).getYear()){
            showError("This additional MRP already submitted.");
            return;
        }

            var msg = 'Are you sure you want to delete the selected action?',
                url = "${createLink(controller: 'pmAdditionalActions', action:  'delete')}";
        confirmDelete(msg, url, gridActions);
    }

    function addService() {
        $("#rowAction").show();
        dropDownService.value(serviceId);
    }
    function editService() {
        if (executeCommonPreConditionForSelectKendo(gridActions, 'action') == false) {
            return;
        }
        var actions = getSelectedObjectFromGridKendo(gridActions);

        var value=$('#hfSubmissionDate').val();
        if(actions.start.getMonth()<new Date(value).getMonth() && actions.start.getYear() <= new Date(value).getYear()){
            showError("This additional MRP already submitted.");
            return;
        }

        clearIndicatorTable();
        addService();


        showService(actions);
        $('html,body').scrollTop(0);
        $.ajax({
            url: "${createLink(controller: 'pmAdditionalActions', action: 'listIndicatorByActions')}?actionsId=" + actions.id,
            success: function (data) {
                clearIndicatorTable();
                $(':input').prop('readonly', false);
                $('#indicatorId1').val(data.list[0].id);
                $('input[name=indicator1]').val(data.list[0].indicator);
                $('#indType1').val(data.list[0].indicatorType);
                var myComboBox = $('#unitId1').data('kendoComboBox');
                myComboBox.text(data.list[0].unitStr);
                myComboBox.trigger("select");
                $('input[name=target1]').val(data.list[0].target);

                for (var i = 1; i < data.count; i++) {
                    var trCount = $('#tab_logic tr').length;
                    var trIdNo = trCount + 1;
                    var trId = 'addr' + trIdNo;
                    var trData = "<tr id='" + trId + "'><td width='50%'>" +
                            "<input id='indicatorId" + trIdNo + "' name='indicatorId" + trIdNo + "' value='" + data.list[i].id + "' type='hidden'/>" +
                            "<input id='indicator" + trIdNo + "' name='indicator" + trIdNo + "' value='" + data.list[i].indicator + "' type='text'  placeholder='Indicator' class='form-control'/>" +
                            "</td>" +
                            "<td width='17%'>" +
                            "<select class='form-control' id='indType" + trIdNo + "' name='indType" + trIdNo + "' value='" + data.list[i].indicatorType + "' onchange='resetData("+trIdNo+")'>" +
                            "<option value='Dividable'>Dividable</option>" +
                            "<option value='Dividable%'>Dividable(%)</option>" +
                            "<option value='Repeatable'>Repeatable</option>" +
                            "<option value='Repeatable%'>Repeatable(%)</option>" +
                            "<option value='Repeatable++'>Repeatable(+/-)</option>" +
                            "<option value='Repeatable%++'>Repeatable(%)(+/-)</option>" +
                            "</select> " +
                            "<td width='20%'>" +
                            "<select class='form-control' id='unitId" + trIdNo + "' name='unitId" + trIdNo + "' type='2'></select>" +
                            "</td>" +
                            "<td width='13%'>" +
                            "<input  id='target" + trIdNo + "' name='target" + trIdNo + "'  value='" + data.list[i].target + "'  type='text' onkeypress='return validateQty(event);' placeholder='Target' class='form-control' >" +
                            "</td>" +
                            "<td>" +
                            "<a class='addbtn' onclick='add_row(" + trIdNo + ")'><i class='fa fa-plus'></i></a>" +
                            "</td>" +
                            "<td>" +
                            "<a class='delbtn' onclick='del_row(" + trIdNo + ")'><i class='fa fa-remove'></i></a>" +
                            "</td>" +
                            "</tr>";

                    $('#tab_logic').append(trData);
                    $("#indType" + trIdNo).val(data.list[i].indicatorType);
                    if($('#indicator').val()!=''){
                        indCount = actions.totalIndicator;
                    }
                    makeKendoDropDownList('unitId'+ trIdNo);
                    var mBox = $("#unitId" + trIdNo).data('kendoComboBox');
                    mBox.text(data.list[i].unitStr);
                    mBox.trigger("select");
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
    }

    function clearIndicatorTable() {
        $('input[name=indicator1]').val('');
        $('input[name=target1]').val('');
        $("#tab_logic tr").remove();
        var trData = "<tr id='addr1'><td width='50%'>" +
                "<input id='indicatorId1' name='indicatorId1' value='' type='hidden'/>" +
                "<input id='indicator1' name='indicator1' type='text' placeholder='Indicator' class='form-control' readonly='true'/>" +
                "</td>" +
                "<td width='15%'>" +
                "<select class='form-control' id='indType1' name='indType1' onchange='resetData(1)'>" +
                "<option value='Dividable'>Dividable</option>" +
                "<option value='Dividable%'>Dividable(%)</option>" +
                "<option value='Repeatable'>Repeatable</option>" +
                "<option value='Repeatable%'>Repeatable(%)</option>" +
                "<option value='Repeatable++'>Repeatable(+/-)</option>" +
                "<option value='Repeatable%++'>Repeatable(%)(+/-)</option>" +
                "</select> " +
                "<td width='20%'>" +
                "<select class='form-control' id='unitId1' name='unitId1' type='2'></select>" +
                "</td>" +
                "<td width='15%'>" +
                "<input id='target1' name='target1' type='text' onkeypress='return validateQty(event);' readonly='true' placeholder='Target' class='form-control'>" +
                "</td>" +
                "<td>" +
                "<a class='addbtn' onclick='add_row(1)'><i class='fa fa-plus'></i></a>" +
                "</td>" +
                "<td>" +
                "<a class='delbtn' onclick='del_row(1)'><i class='fa fa-remove'></i></a>" +
                "</td>" +
                "</tr>";
        $('#tab_logic').append(trData);
        indCount = 1;
        deletedIndicatorIds = ''
        makeKendoDropDownList('unitId1');
    }

    function showService(actions) {
        dropDownGoals.readonly(true);
        actionsModel.set('actions', actions);
        dropDownEmployee.value(actions.resPersonId);
        if (actions.sourceOfFund) sourceOfFund.value(actions.sourceOfFund.split(","));
        if (actions.supportDepartment) supportDepartment.value(actions.supportDepartment.split(","));
        if($('#indicator').val()!=''){
            map = JSON.parse($('#indicator').val());
        }
        $('#create').html("<span class='k-icon k-i-plus'></span>Update");
    }


    function add_row(tmpId) {
        var indic = "#indicator" + tmpId;
        var targ = "#target" + tmpId;
        var indicator = $(indic).val();
        var target = $(targ).val();
        if (indicator == '' || indicator == undefined || target == '' || target == undefined) {
            showError('Please insert current indicator & target');
            return false;
        }
        var trIdNo = indCount + 1;
        var trId = 'addr' + trIdNo;
        var trData = "<tr id='" + trId + "'><td width='50%'>" +
                "<input id='indicatorId" + trIdNo + "' name='indicatorId" + trIdNo + "' value='' type='hidden'/>" +
                "<input id='indicator" + trIdNo + "' name='indicator" + trIdNo + "' type='text'  placeholder='Indicator' class='form-control'/>" +
                "</td>" +
                "<td width='15%'>" +
                "<select class='form-control' id='indType" + trIdNo + "' name='indType" + trIdNo + "' onchange='resetData("+trIdNo+")'>" +
                "<option value='Dividable'>Dividable</option>" +
                "<option value='Dividable%'>Dividable(%)</option>" +
                "<option value='Repeatable'>Repeatable</option>" +
                "<option value='Repeatable%'>Repeatable(%)</option>" +
                "<option value='Repeatable++'>Repeatable(+/-)</option>" +
                "<option value='Repeatable%++'>Repeatable(%)(+/-)</option>" +
                "</select> " +
                "<td width='20%'>" +
                "<select class='form-control' id='unitId" + trIdNo + "' name='unitId" + trIdNo + "' type='2'></select>" +
                "</td>" +
                "<td width='15%'>" +
                "<input  id='target" + trIdNo + "' name='target" + trIdNo + "' type='text' onkeypress='return validateQty(event);' placeholder='Target' class='form-control' >" +
                "</td>" +
                "<td>" +
                "<a class='addbtn' onclick='add_row(" + trIdNo + ")'><i class='fa fa-plus'></i></a>" +
                "</td>" +
                "<td>" +
                "<a class='delbtn' onclick='del_row(" + trIdNo + ")'><i class='fa fa-remove'></i></a>" +
                "</td>" +
                "</tr>";
        $('#tab_logic').append(trData);
        makeKendoDropDownList('unitId'+trIdNo);
        indCount++;
    }
    function del_row(trIdNo) {
        var trCount = $('#tab_logic tr').length;
        if (trCount > 1) {
            if (!$('#id').val().isEmpty()) {
                var tt = $("#indicatorId"+trIdNo).val();
                deletedIndicatorIds+=tt+',';
            }
            var trId = '#addr' + trIdNo;
            $(trId).remove();
            delete map["indicator"+trIdNo];
        }
    }
    function resetData(index){
        var type = "#indType"+index;
        var indName = "indicator"+index;
        var tar = "#target"+index;
        $(tar).val('');
        delete map[indName];
    }

</script>
