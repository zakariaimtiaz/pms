

<script language="javascript">

    $(document).ready(function () {
        initializeForm($("#cryptoUtilFrom"), onSubmitForm);
    });

    function onSubmitForm() {
        var btnName = $(document.activeElement).val();
        var txt1 = $("#input1").val();
        var txt2 = $("#input2").val();
        if (txt1 == '' && txt2 == '') {
            showError('No data found');
            return false;
        }
        showLoadingSpinner(true);
        var actionUrl = null;
        if (btnName=='encrypt') {
            actionUrl = "${createLink(controller:'cryptoUtil', action: 'encryptTxt')}";
        } else {
            actionUrl = "${createLink(controller:'cryptoUtil', action: 'decryptTxt')}";
        }

        jQuery.ajax({
            type: 'post',
            data: jQuery("#cryptoUtilFrom").serialize(),
            url: actionUrl,
            success: function (data, textStatus) {
                $("#output1").val(data.output1);
                $("#output2").val(data.output2);
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

</script>
