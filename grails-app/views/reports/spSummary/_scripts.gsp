<script language="javascript">
    var dropDownService,gridSpSummary;
    $(document).ready(function () {
        onLoadInfoPage();
        initGridHR();
        populateSummaryGrid();
    });
    function onLoadInfoPage() {
        var str = moment().format('YYYY');
        $('#year').kendoDatePicker({
            format: "yyyy",
            parseFormats: ["yyyy-MM-dd"],
            start: "decade",
            depth: "decade"
        }).data("kendoDatePicker");
        $('#year').val(str);

        if(!${isSysAdmin} && !${isTopMan} && !${isSpAdmin}){
            dropDownService.value(${serviceId});
            dropDownService.readonly(true);
        }
        defaultPageTile("SP Summary", '/reports/showSpSummary');
    }

    function initGridHR() {
        $("#gridSpSummary").kendoGrid({
            dataSource: {
                transport: {
                    read: {
                        url: false,
                        dataType: "json",
                        type: "post"
                    }
                },
                schema: {
                    type: 'json',
                    data: "list",
                    parse: function (data) {
                        return data;
                    }
                },
                serverPaging: true,
                serverSorting: true
            },
            autoBind: false,
            height: getGridHeightKendo() - 140,
            selectable: true,
            sortable: false,
            pageable: false,
            columns: [
                {field: "service", title: "Service", width: 100, sortable: false, filterable: true},
                {field: "year", title: "Year", width: 50, sortable: false, filterable: false},
                {field: "summary", title: "Summary",width: 400, sortable: false, filterable: false,
                    template: "#=htmlDecode(summary)#"}
            ]
        });
        gridSpSummary = $("#gridSpSummary").data("kendoGrid");
    }
    function htmlDecode(value) {
        return value.replaceHtmlEntites();
    }
    function populateSummaryGrid() {
        var serviceId = $('#serviceId').val();
        if(serviceId==''){ serviceId = 0;}
        var year = $('#year').val();
        var url   = "${createLink(controller: 'reports', action: 'listSpSummary')}?year=" + year + "&serviceId=" + serviceId;
        populateGridKendo(gridSpSummary, url);
        return false;
    }

    function setPreviousYear() {
        var year = $('#year').val();
        var str = moment(year, 'YYYY').subtract(1, 'years').format('YYYY');
        $('#year').val(str);
        populateSummaryGrid();
    }
    function setNextYear() {
        var year = $('#year').val();
        var str = moment(year, 'YYYY').add(1, 'years').format('YYYY');
        $('#year').val(str);
        populateSummaryGrid();
    }
</script>
