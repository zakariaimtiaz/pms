<script language="javascript">
    var gridMeeting, dataSource;

    $(document).ready(function () {
        onLoadMeetingPage();
        initMeetingGrid();
        populateMeetingGrid();
    });

    function onLoadMeetingPage() {
        var str = moment().format('YYYY');
        $('#year').kendoDatePicker({
            format: "yyyy",
            parseFormats: ["yyyy-MM-dd"],
            start: "decade",
            depth: "decade",
            change: populateMeetingGrid
        }).data("kendoDatePicker");
        $('#year').val(str);
        defaultPageTile("${meetingType} meeting","reports/showMeetingStatus?type=${meetingType}");
    }

    function populateMeetingGrid(){
        var year = $('#year').val();
        if(year==''){
            showError('Please select year');
            return false;
        }
        var params = "?year="+year+"&meetingTypeId=" + ${meetingTypeId};
        var url ="${createLink(controller: 'reports', action: 'listMeetingStatus')}" + params;
        populateGridKendo(gridMeeting, url);
        return false;
    }

    function initDataSource() {
        dataSource = new kendo.data.DataSource({
            transport: {
                read: {
                    url:false,
                    dataType: "json",
                    type: "post"
                }
            },
            schema: {
                model: {
                    fields: {
                        id: { type: "number" },
                        version: { type: "number" },
                        meetingType: { type: "string" },
                        heldOn: { type: "date" },
                        endDate: { type: "date" },
                        descStr: { type: "string" },
                        fileName: { type: "string" }
                    }
                },
                parse: function (data) {
                    checkIsErrorGridKendo(data);
                    return data;
                }
            },
            sort: {field: 'heldOn', dir: 'desc'},
            pageSize: getDefaultPageSize(),
            serverPaging: true,
            serverFiltering: true,
            serverSorting: true
        });
    }

    function initMeetingGrid() {
        initDataSource();
        $("#gridMeeting").kendoGrid({
            autoBind:false,
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
                {field: "heldOn", title: "Start Date", width: 80, sortable: false, filterable: false,
                    template: "#=kendo.toString(kendo.parseDate(heldOn, 'yyyy-MM-dd'), 'dd-MM-yyyy')#",
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()}
                },
                {field: "endDate", title: "End Date", width: 80, sortable: false, filterable: false,
                    template: "#=kendo.toString(kendo.parseDate(endDate, 'yyyy-MM-dd'), 'dd-MM-yyyy')#",
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()}
                },
                {field: "descStr", title: "Description",sortable: false, filterable: false,
                    template: "#=trimTextForKendo(htmlDecode(descStr),800)#"
                },
                {field: "fileName", title: "Download Attachment",sortable: false, filterable: false, width: 150
                    , template: "<a onclick=\"downloadMeetingFile('#= id #')\" href='\\#'>#= fileName #</a>"
                }
            ],
            filterable: {
                mode: "row"
            }
        });
        gridMeeting = $("#gridMeeting").data("kendoGrid");
        $("#menuGrid").kendoMenu();
    }
    function htmlDecode(value) {
        return value.replaceHtmlEntites();
    }
    $("#gridMeeting").kendoTooltip({
        show: function(e){
            if(this.content.text().length > 200){
                this.content.parent().css("visibility", "visible");
            }
        },
        hide:function(e){
            this.content.parent().css("visibility", "hidden");
        },
        filter: "td:nth-child(3)",
        width: 450,
        position: "top",
        content: function (e) {
            var dataItem = $("#gridMeeting").data("kendoGrid").dataItem(e.target.closest("tr"));
            return dataItem.descStr;
        }
    }).data("kendoTooltip");
    function downloadMeetingFile(id) {
        showLoadingSpinner(true);
        var msg = 'Do you want to download the ED\'s Dashboard now?',
                params = "?id=" +id,
                url = "${createLink(controller: 'meetingLog', action:  'downloadFile')}" + params;
        confirmDownload(msg, url);
        return false;
    }


</script>
