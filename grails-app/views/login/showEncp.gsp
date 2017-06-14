<div class="container-fluid">
    <div class="row" id="rowGoals">
        <div id="application_top_panel" class="panel panel-primary">
            <div class="panel-heading">
                <div class="panel-title">
                    Encrypt & Decrypt String
                </div>
            </div>

            <g:form name='defaultForm' id='defaultForm' class="form-horizontal form-widgets" role="form">
                <div class="panel-body">
                    <div class="form-group">
                        <label class="col-md-1 control-label label-optional" for="input1">Input 1:</label>
                        <div class="col-md-3">
                            <input type="text" class="form-control" id="input1" name="input1"
                                   placeholder="Input String Here" tabindex="1"/>
                        </div>
                        <div class="col-md-3">
                            <input type="text" class="form-control" id="output1" name="output1" placeholder="Output"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-md-1 control-label label-optional" for="input2">Input 2:</label>
                        <div class="col-md-3">
                            <input type="text" class="form-control" id="input2" name="input2"
                                   placeholder="Input String Here" tabindex="2"/>
                        </div>
                        <div class="col-md-3">
                            <input type="text" class="form-control" id="output2" name="output2" placeholder="Output"/>
                        </div>
                    </div>
                </div>

                <div class="panel-footer">
                    <button id="encrypt" name="encrypt" value="encrypt" type="submit" data-role="button"
                            class="k-button k-button-icontext" role="button" tabindex="3"
                            aria-disabled="false"><span class="k-icon k-i-plus"></span>Encrypt
                    </button>
                    <button id="decrypt" name="decrypt" value="decrypt" type="submit" data-role="button"
                            class="k-button k-button-icontext" role="button" tabindex="4"
                            aria-disabled="false"><span class="k-icon k-i-plus"></span>Decrypt
                    </button>
                </div>
            </g:form>
        </div>
    </div>
</div>
<script language="javascript">

    $(document).ready(function () {
        initializeForm($("#defaultForm"), onSubmitForm);
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
            actionUrl = "${createLink(controller:'login', action: 'encryptTxt')}";
        } else {
            actionUrl = "${createLink(controller:'login', action: 'decryptTxt')}";
        }

        jQuery.ajax({
            type: 'post',
            data: jQuery("#defaultForm").serialize(),
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
