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
        defaultPageTile("Weekly meeting",null);
    }

    function populateMeetingGrid(){
        var year = $('#year').val();
        if(year==''){
            showError('Please select year');
            return false;
        }
        var params = "?year="+year;
        var url ="${createLink(controller: 'reports', action: 'listMeetingStatus')}" + params;
        populateGridKendo(gridMeeting, url);
        return false;
    }

    function initDataSource() {
        dataSource = new kendo.data.DataSource({
            transport: {
                read: {
                    url: false,
                    dataType: "json",
                    type: "post"
                }
            },
            schema: {
                type: 'json',
                model: {
                    fields: {
                        SERVICE_ID: { type: "number" },
                        SERVICE_NAME: { type: "string" },
                        SERVICE_STR: { type: "string" },
                        January: { type: "string" },
                        February: { type: "string" },
                        March: { type: "string" },
                        April: { type: "string" },
                        May: { type: "string" },
                        June: { type: "string" },
                        July: { type: "string" },
                        August: { type: "string" },
                        September: { type: "string" },
                        October: { type: "string" },
                        November: { type: "string" },
                        December: { type: "string" }
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

    function initMeetingGrid() {
        initDataSource();
        $("#gridMeeting").kendoGrid({
            autoBind: false,
            dataSource: dataSource,
            height: getGridHeightKendo(),
            selectable: false,
            sortable: true,
            resizable: true,
            reorderable: true,
            pageable: false,
            columns: [
                {field: "SERVICE_STR", title: "Sector/CSU", width: 150, sortable: false, filterable: false},
                {field: "JANUARY", title: "January", width: 80, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()}
                },
                {field: "FEBRUARY", title: "February", width: 80, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()}
                },
                {field: "MARCH", title: "March", width: 80, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()}
                },
                {field: "APRIL", title: "April", width: 80, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                    template: "#=formatDate(SERVICE_ID,APRIL)#"
                },
                {field: "MAY", title: "May", width: 80, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()}
                },
                {field: "JUNE", title: "June", width: 80, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()}
                },
                {field: "JULY", title: "July", width: 80, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()}
                },
                {field: "AUGUST", title: "August", width: 80, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()}
                },
                {field: "SEPTEMBER", title: "September", width: 80, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()}
                },
                {field: "OCTOBER", title: "October", width: 80, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()}
                },
                {field: "NOVEMBER", title: "November", width: 80, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()}
                },
                {field: "DECEMBER", title: "December", width: 80, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()}
                }
            ],
            filterable: {
                mode: "row"
            }
        });
        gridMeeting = $("#gridMeeting").data("kendoGrid");
    }
    function formatDate(serviceId,dateStr){
        var result = ''
        var temp = new Array();
        temp = dateStr.split(",");
        for (a in temp) {
            if(temp[a]!= ''){
                result += '<a><span style="cursor:pointer;" onclick="loadPage(' + serviceId + ',\'' + temp[a] + '\');">'+ temp[a]+ '</span></a><br/>';
            }
        }
        return result;
    }
    function loadPage(serviceId, date) {
        var url = "${createLink(controller: 'meetingLog', action: 'detailsLog')}?serviceId=" + serviceId + "&heldOn=" + date;
        router.navigate(formatLink(url));
    }

    $("#gridMeeting").kendoTooltip({
        filter: "td:nth-child(1)",
        width: 200,
        position: "top",
        content: function(e){
            var dataItem = $("#gridMeeting").data("kendoGrid").dataItem(e.target.closest("tr"));
            return dataItem.SERVICE_NAME;
        }
    }).data("kendoTooltip");

</script>
