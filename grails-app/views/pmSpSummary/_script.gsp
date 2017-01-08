<script type="text/x-kendo-template" id="gridToolbar">
<ul id="menuGrid" class="kendoGridMenu">
    <sec:access url="/pmSpSummary/create">
        <li onclick="showForm();"><i class="fa fa-plus-square-o"></i>New</li>
    </sec:access>
    <sec:access url="/pmSpSummary/update">
        <li onclick="editForm();"><i class="fa fa-edit"></i>Edit</li>
    </sec:access>
    <sec:access url="/pmSpSummary/delete">
        <li onclick="deleteForm();"><i class="fa fa-trash-o"></i>Delete</li>
    </sec:access>
</ul>
</script>

<script language="javascript">
    var gridPmSpSummary, dataSource, pmSpSummaryModel,str;

    $(document).ready(function () {
        onLoadPmSpSummaryPage();
        initPmSpSummaryGrid();
        initObservable();
    });

    function onLoadPmSpSummaryPage() {
        $("#spSummaryRow").hide();

        str = moment().format('YYYY');
        $('#year').kendoDatePicker({
            format: "yyyy",
            parseFormats: ["yyyy-MM-dd"],
            start: "decade",
            depth: "decade"
        }).data("kendoDatePicker");
        $('#year').val(str);

        $("#summary").kendoEditor({
            resizable: {
                content: false,
                toolbar: true
            }
        });

        initializeForm($("#spSummaryForm"), onSubmitPmSpSummary);
        defaultPageTile("Create Summary",null);
    }

    function showForm() {
        $("#spSummaryRow").show();
    }
    function executePreCondition() {
        if (!validateForm($("#spSummaryForm"))) {
            return false;
        }
        return true;
    }

    function onSubmitPmSpSummary() {
        if (executePreCondition() == false) {
            return false;
        }

        setButtonDisabled($('#create'), true);
        showLoadingSpinner(true);
        var actionUrl = null;
        if ($('#id').val().isEmpty()) {
            actionUrl = "${createLink(controller:'pmSpSummary', action: 'create')}";
        } else {
            actionUrl = "${createLink(controller:'pmSpSummary', action: 'update')}";
        }

        jQuery.ajax({
            type: 'post',
            data: jQuery("#spSummaryForm").serialize(),
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
            showSuccess(result.message);
            resetForm();
            $('#year').val(str);
        }
    }

    function resetForm() {
        $("#gridPmSpSummary").data("kendoGrid").dataSource.read();
        clearForm($("#spSummaryForm"), $('#summary'));
        initObservable();
        $('#create').html("<span class='k-icon k-i-plus'></span>Create");
        $("#spSummaryRow").hide();
    }

    function initDataSource() {
        dataSource = new kendo.data.DataSource({
            transport: {
                read: {
                    url: "${createLink(controller: 'pmSpSummary', action: 'list')}",
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
                        service: { type: "string" },
                        summary: { type: "string" },
                        year: { type: "string" }
                    }
                },
                parse: function (data) {
                    checkIsErrorGridKendo(data);
                    return data;
                }
            },
            pageSize: 50,
            serverPaging: true,
            serverFiltering: true,
            serverSorting: true
        });
    }
    function htmlDecode(value) {
        return value.replace(/&lt;/g, "<").replace(/&gt;/g, ">");
    }
    function initPmSpSummaryGrid() {
        initDataSource();
        $("#gridPmSpSummary").kendoGrid({
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
                {field: "year", title: "Year", width: 50, sortable: false, filterable: false},
                {field: "summary", title: "Summary",width: 400, sortable: false, filterable: false,
                template: "#=htmlDecode(summary)#"}
            ],
            filterable: {
                mode: "row"
            },
            toolbar: kendo.template($("#gridToolbar").html())
        });
        gridPmSpSummary = $("#gridPmSpSummary").data("kendoGrid");
        $("#menuGrid").kendoMenu();
    }

    function initObservable() {
        pmSpSummaryModel = kendo.observable(
                {
                    spSummary: {
                        id: "",
                        version: "",
                        serviceId: "",
                        year: "",
                        summary: ""
                    }
                }
        );
        kendo.bind($("#application_top_panel"), pmSpSummaryModel);
    }

    function deleteForm() {
        if (executeCommonPreConditionForSelectKendo(gridPmSpSummary, 'Summary') == false) {
            return;
        }
        var msg = 'Are you sure you want to delete the selected Summary?',
                url = "${createLink(controller: 'pmSpSummary', action:  'delete')}";
        confirmDelete(msg, url, gridPmSpSummary);
    }

    function editForm() {
        if (executeCommonPreConditionForSelectKendo(gridPmSpSummary, 'Summary') == false) {
            return;
        }
        $("#spSummaryRow").show();
        var spSummary = getSelectedObjectFromGridKendo(gridPmSpSummary);
        showPmSpSummary(spSummary);
    }

    function showPmSpSummary(spSummary) {
        $('html,body').scrollTop(0);
        pmSpSummaryModel.set('spSummary', spSummary);
        var editor = $("#summary").data("kendoEditor");
        editor.value(htmlDecode(spSummary.summary));
        $('#create').html("<span class='k-icon k-i-plus'></span>Update");
    }

</script>
