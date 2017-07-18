<script language="javascript">
    var gridMeeting, dataSource;
    var $=jQuery;
    $(document).ready(function() {
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
                        MEETING_TYPE: { type: "string" },
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
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                    template: "#=formatDate(MEETING_TYPE,SERVICE_ID,JANUARY)#"
                },
                {field: "FEBRUARY", title: "February", width: 80, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                    template: "#=formatDate(MEETING_TYPE,SERVICE_ID,FEBRUARY)#"
                },
                {field: "MARCH", title: "March", width: 80, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                    template: "#=formatDate(MEETING_TYPE,SERVICE_ID,MARCH)#"
                },
                {field: "APRIL", title: "April", width: 80, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                    template: "#=formatDate(MEETING_TYPE,SERVICE_ID,APRIL)#"
                },
                {field: "MAY", title: "May", width: 80, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                    template: "#=formatDate(MEETING_TYPE,SERVICE_ID,MAY)#"
                },
                {field: "JUNE", title: "June", width: 80, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                    template: "#=formatDate(MEETING_TYPE,SERVICE_ID,JUNE)#"
                },
                {field: "JULY", title: "July", width: 80, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                    template: "#=formatDate(MEETING_TYPE,SERVICE_ID,JULY)#"
                },
                {field: "AUGUST", title: "August", width: 80, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                    template: "#=formatDate(MEETING_TYPE,SERVICE_ID,AUGUST)#"
                },
                {field: "SEPTEMBER", title: "September", width: 80, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                    template: "#=formatDate(MEETING_TYPE,SERVICE_ID,SEPTEMBER)#"
                },
                {field: "OCTOBER", title: "October", width: 80, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                    template: "#=formatDate(MEETING_TYPE,SERVICE_ID,OCTOBER)#"
                },
                {field: "NOVEMBER", title: "November", width: 80, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                    template: "#=formatDate(MEETING_TYPE,SERVICE_ID,NOVEMBER)#"
                },
                {field: "DECEMBER", title: "December", width: 80, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()},
                    template: "#=formatDate(MEETING_TYPE,SERVICE_ID,DECEMBER)#"
                }
            ],
            filterable: {
                mode: "row"
            }
        });
        gridMeeting = $("#gridMeeting").data("kendoGrid");
    }
    function formatDate(meetingType,serviceId,dateStr){
        var result = ''
        var temp = new Array();
        var temp2 = new Array();
        temp = dateStr.split(",");

        var isSysAdmin = ${isSysAdmin},
            userServiceId = ${userServiceId};
        if(!isSysAdmin && userServiceId!=serviceId && meetingType=='Weekly'){
            for (a in temp) {
                if(temp[a]!= ''){
                    temp2 = temp[a].split("&");
                    result += '<span style="cursor:pointer;">'+ temp2[1]+ '</span><br/>';
                }
            }
        }else{
            for (a in temp) {
                if(temp[a]!= ''){
                    temp2 = temp[a].split("&");
                    result += '<a><span style="cursor:pointer;" onclick="loadPage(' + temp2[0] + ',' + ${meetingTypeId} +');">' + temp2[1] + '</span></a><br/>';
                }
            }
        }
        return result;
    }
    function loadPage(id, meetingTypeId) {
        var url = "${createLink(controller: 'meetingLog', action: 'detailsLog')}?id=" + id + "&meetingTypeId=" + meetingTypeId;
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
