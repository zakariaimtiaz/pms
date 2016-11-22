
<script language="javascript">
    var start, end;

    $(document).ready(function () {
        onLoadInfoPage();
        //loadDetailsValue();
    });

    function onLoadInfoPage() {
        var currentDate = moment().format('MMMM YYYY');

        start = $('#from').kendoDatePicker({
            format: "MMMM yyyy",
            parseFormats: ["yyyy-MM-dd"],
            change: startChange,
            start: "year",
            depth: "year"
        }).data("kendoDatePicker");

        start.value(currentDate);

        end = $('#to').kendoDatePicker({
            format: "MMMM yyyy",
            parseFormats: ["yyyy-MM-dd"],
            start: "year",
            depth: "year"
        }).data("kendoDatePicker");

        end.value(currentDate);
        end.min(start.value());

        initializeForm($("#detailsForm"), onSubmitForm);
        // update page title
        defaultPageTile("Strategic Plan", 'reports/showStrategicPlan');
    }
    function startChange() {
        var startDate = start.value();
        if (startDate) {
            startDate = new Date(startDate);
            startDate.setDate(startDate.getDate() + 1);
            end.min(startDate);
        }
    }

    function executePreCondition() {
        if (!validateForm($("#detailsForm"))) {
            return false;
        }
        return true;
    }

    function onSubmitForm() {
        if (executePreCondition() == false) {
            return false;
        }
        return false;
    }

    function resetForm() {
        clearForm($("#detailsForm"), $('#from'));
    }

    function downloadDetails() {
        if (isApplicable) {
            showLoadingSpinner(true);
            var from = $('#from').val();
            var to = $('#to').val();
            var hospitalCode = dropDownHospitalCode.value();
            var params = "?from=" + from + "&to=" + to + "&hospitalCode=" + hospitalCode;
            var  msg = 'Do you want to download the report now?',
                    url = "${createLink(controller: 'reports', action: 'downloadMonthlyPathologySummary')}" + params;

            confirmDownload(msg, url);
        } else {
            showError('No record to download');
        }
        return false;
    }
</script>
