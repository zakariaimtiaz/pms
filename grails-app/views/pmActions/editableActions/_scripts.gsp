<script language="javascript">
    var dropDownService,serviceId,gridSAP;

    $(document).ready(function () {
        onLoadInfoPage();
        initGrid();
    });
    function onLoadInfoPage() {
        serviceId = ${serviceId}
        defaultPageTile("SAP", 'pmSpLog/show');
    }

    function initGrid() {
        $("#gridSAP").kendoGrid({
            dataSource: {
                transport: {
                    read: {
                        url: "${createLink(controller: 'pmActions', action: 'listEditableActions')}?serviceId="+ serviceId,
                        dataType: "json",
                        type: "post"
                    }
                },
                schema: {
                    type: 'json',
                    data: "list",
                    model: {
                        id: "id",    // have to set id otherwise remove row by clicking cancel
                        fields: {
                            id: {editable: false, type: "number"},
                            serviceId: {editable: false, type: "number"},
                            action_id: {editable: false, type: "number"},
                            indicator_id: {editable: false, type: "number"},
                            sequence: {editable: false,type: "string"},
                            actions: {editable: false,type: "string"},
                            start: {editable: false,type: "date"},
                            end: {editable: false,type: "date"},
                            is_editable: {editable: true,type: "boolean"},
                            remarks: {editable: false, type: "string"}
                        }
                    }
                },
                serverPaging: true,
                serverSorting: true
            },
            height: getGridHeightKendo() - 50,
            sortable: false,
            pageable: false,
            columns: [
                {
                    field: "sequence", title: "ID#", width: 40, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()}
                },
                {
                    field: "is_editable",title: " ",width: 30,
                    headerTemplate: '<input type="checkbox" id="chkbxall"> </input>',
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                    template:'<input type="checkbox" class="chkbx" #= is_editable ? "checked=checked" : "" #></input>'
                },
                {field: "actions", title: "Action", width: 250, sortable: false, filterable: false
                },
                {
                    field: "start", title: "Date Range", width: 120, sortable: false, filterable: false,
                    headerAttributes: {style: setAlignCenter()},attributes: {style: setAlignCenter()},
                    template: "#=formatDateRange(kendo.toString(kendo.parseDate(start, 'yyyy-MM-dd'), 'MMMM yyyy'),kendo.toString(kendo.parseDate(end, 'yyyy-MM-dd'), 'MMMM yyyy'))#"
                }
            ],
            editable: "inline"
        });
        gridSAP = $("#gridSAP").data("kendoGrid");
    }

    function formatDateRange(start,end){
        return start + ' ~ ' + end;
    }
    $('#chkbxall').change(function() {
        var state = $(this).is(":checked");
        $('.chkbx').prop('checked', state);
        var param = "?serviceId="+serviceId+"&state="+ state;
        updateActionStatus(param);
        return false;
    });

    $("#gridSAP .k-grid-content").on("change", "input.chkbx", function(e) {
        var grid = $("#gridSAP").data("kendoGrid"),
        dataItem = grid.dataItem($(e.target).closest("tr"));
        dataItem.set("is_editable", this.checked);
        var param = "?actionId="+dataItem.id+"&state="+ dataItem.is_editable;
        updateActionStatus(param);
        return false;
    });
    function updateActionStatus(param){
        jQuery.ajax({
            type: 'post',
            url: "${createLink(controller: 'pmActions', action: 'updateEditableActions')}" + param,
            success: function (data, textStatus) {
                if(data.isError=='true'){
                    showError(data.message);
                }else{
                    showSuccess(data.message);
                }
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
            },
            complete: function (XMLHttpRequest, textStatus) {
                showLoadingSpinner(false);
            },
            dataType: 'json'
        });
    }
</script>
