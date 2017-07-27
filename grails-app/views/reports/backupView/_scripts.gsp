<script language="javascript">
    var gridSAPBackup, dataSource,dropDownService;

    $(document).ready(function () {
        onLoadBackupViewPage();
        initBackupGrid();
        if(!${isSysAdmin} && !${isTopMan} && !${isSpAdmin} && !${isMultiDept}) {
            populateBackupGrid();
        }
    });

    function onLoadBackupViewPage() {
        if(!${isSysAdmin} && !${isTopMan} && !${isSpAdmin} && !${isMultiDept}){
            dropDownService.value(${serviceId});
            dropDownService.readonly(true);
        }
        var str = moment().format('YYYY');
        $('#year').kendoDatePicker({
            format: "yyyy",
            parseFormats: ["yyyy-MM-dd"],
            start: "decade",
            depth: "decade",
            change: populateBackupGrid
        }).data("kendoDatePicker");
        $('#year').val(str);
        defaultPageTile("SAP Backup","reports/showSapBackupView");
    }

    function populateBackupGrid(){

        var year = $('#year').val();
        var serviceId = dropDownService.value();
        if(year==''){
            showError('Please select year');
            return false;
        }
        if(serviceId==''){
            showError('Please select any service');
            return false;
        }

        var params = "?year="+year+"&serviceId=" + serviceId;
        var url ="${createLink(controller: 'reports', action: 'listSapBackupFiles')}" + params;
        populateGridKendo(gridSAPBackup, url);
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
                        serviceId: { type: "number" },
                        year: { type: "number" },
                        serviceName: { type: "string" },
                        createDate: { type: "date" },
                        fileName: { type: "string" }
                    }
                },
                parse: function (data) {
                    checkIsErrorGridKendo(data);
                    return data;
                }
            },
            sort: {field: 'createDate', dir: 'desc'},
            pageSize: getDefaultPageSize(),
            serverPaging: true,
            serverFiltering: true,
            serverSorting: true
        });
    }

    function initBackupGrid() {
        initDataSource();
        $("#gridSAPBackup").kendoGrid({
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
                {field: "serviceName", title: "Sector/ CSU", width: 200, sortable: false, filterable: false,
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()}
                },
                {field: "createDate", title: "Backup Date", width: 100, sortable: false, filterable: false,
                    template: "#=kendo.toString(kendo.parseDate(createDate, 'yyyy-MM-dd'), 'dd-MM-yyyy')#",
                    attributes: {style: setAlignCenter()}, headerAttributes: {style: setAlignCenter()}
                },
                {field: "fileName", title: "Download Attachment",sortable: false, filterable: false, width: 300
                    , template: "<a onclick=\"downloadSapBackupFile('#= id #')\" href='\\#'>#= fileName #</a>"
                }
            ],
            filterable: {
                mode: "row"
            }
        });
        gridSAPBackup = $("#gridSAPBackup").data("kendoGrid");
        $("#menuGrid").kendoMenu();
    }
    function downloadSapBackupFile(id) {
        showLoadingSpinner(true);
        var msg = 'Do you want to download the SAP backup file now?',
                params = "?id=" +id,
                url = "${createLink(controller: 'reports', action:  'downloadSapBackupFile')}" + params;
        confirmDownload(msg, url);
        return false;
    }


</script>
