<script type="text/x-kendo-template" id="gridToolbar">
<ul id="menuGrid2" class="kendoGridMenu">
    <sec:access url="/pmMcrsLog/show">
        <li onclick="mcrsEditable();"><i class="fa fa-edit"></i>Editable</li>
    </sec:access>
</ul>
</script>
<script language="javascript">
    var gridMcrsSubmission, dataSource2, serviceId,isAdmin;

    $(document).ready(function () {
        serviceId = ${serviceId};
        isAdmin=${isAdmin};
        onLoadEdDashboardPage();
        initMcrsLogGrid();
        if(isAdmin){
            $('#btnView').show();
            $('#divBtnCreate').hide();
            $('#divMonth').hide();
        }
        else{
            $('#btnView').hide();
            $('#divBtnCreate').show();
            $('#divMonth').show();

        }
    });
    function onLoadEdDashboardPage() {
        serviceId = ${serviceId};

        var str = moment().format('MMMM YYYY');
        var months = $('#month').kendoDatePicker({
            format: "MMMM yyyy",
            parseFormats: ["yyyy-MM-dd"],
            start: "year",
            depth: "year",
            max:new Date()
        }).data("kendoDatePicker");
        $('#month').val(str);

        initializeForm($("#mcrsLogForm"), onSubmitMcrsLog);
        defaultPageTile("Management Control Report System(MCRS) Submission",'/pmMcrsLog/show');
        dropDownService.value(serviceId);
    }
    function executePreCondition() {
        if (!validateForm($("#mcrsLogForm"))) {
            return false;
        }
        return true;
    }

    function onSubmitMcrsLog() {
        if (executePreCondition() == false) {
            return false;
        }
        showLoadingSpinner(true);

        jQuery.ajax({
            type: 'post',
            data: jQuery("#mcrsLogForm").serialize(),
            url: "${createLink(controller:'pmMcrsLog', action: 'create')}",
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

                emptyForm();
                showSuccess(result.message);
            } catch (e) {
                // Do Nothing
            }
        }
    }
    function emptyForm() {
        initMcrsLogGrid();
        clearForm($("#mcrsLogForm"), $('#serviceId'));
        dropDownService.value(serviceId);
        var str = moment().format('MMMM YYYY');
        $('#month').val(str);
    }

    function initDataSource() {
        serviceId=$('#serviceId').val();
        dataSource2 = new kendo.data.DataSource({
            transport: {
                read: {
                    url: "${createLink(controller: 'pmMcrsLog', action: 'list')}?serviceId="+ serviceId,
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
                        year: {type: "number"},
                        month: {type: "number"},
                        monthStr: {type: "string"},
                        serviceId: {type: "number"},
                        service: {type: "string"},
                        submissionDate: {type: "date"},
                        isSubmitted: {type: "boolean"},
                        isEditable: {type: "boolean"}
                    }
                },
                parse: function (data) {
                    checkIsErrorGridKendo(data);
                    return data;
                }
            },
            sort: {field: 'id', dir: 'desc'},
            pageSize: getDefaultPageSize(),
            serverPaging: true,
            serverFiltering: true,
            serverSorting: true
        });
    }

    function initMcrsLogGrid() {
        initDataSource();
        $("#gridMcrsSubmission").kendoGrid({
            dataSource: dataSource2,
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
                {
                    field: "year", title: "Year", width: 50, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()}
                },{
                    field: "monthStr", title: "Month", width: 50, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()}
                },
                {
                    field: "isSubmitted", title: "Submitted", width: 50, sortable: false,
                    filterable: false, attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                    template: "#=isSubmitted?'YES':'NO'#"
                },
                {
                    field: "submissionDate",title: "Submit Date",
                    width: 50, sortable: false,filterable: false,
                    template: "#=isSubmitted?kendo.toString(kendo.parseDate(submissionDate, 'yyyy-MM-dd'), 'dd-MM-yyyy'):''#",
                    attributes: {style: setAlignCenter()},
                    headerAttributes: {style: setAlignCenter()}
                },
                {
                    field: "isEditable", title: "Editable", width: 50, sortable: false,
                    filterable: false,attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                    template: "#=isEditable?'YES':'NO'#"
                }
            ],
            filterable: {
                mode: "row"
            },
            toolbar: isAdmin==true?kendo.template($("#gridToolbar").html()):''
        });
        gridMcrsSubmission = $("#gridMcrsSubmission").data("kendoGrid");
        $("#menuGrid2").kendoMenu();
    }

    function mcrsEditable() {
        if (executeCommonPreConditionForSelectKendo(gridMcrsSubmission, 'mcrsLog') == false) {
            return;
        }
        var msg = 'Are you sure you want to make editable the selected MCRS?',
                url = "${createLink(controller: 'pmMcrsLog', action:  'update')}";
        confirmActionForEdit(msg, url, gridMcrsSubmission);
    }

</script>