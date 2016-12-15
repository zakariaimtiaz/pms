<style type="text/css">
.k-notification-error.k-group {
    opacity: 0.92 !important;
}

.notification {
    padding: 14px 14px 14px 4px;
    width: 260px;
    display: table;
}

.notf-icon {
    vertical-align: middle;
}

.notf-message {
    display: table-cell;
    padding-left: 5px;
}
</style>
<script id="tmplKendoSuccess" type="text/x-kendo-template">
<div class="alert-success notification">
    <i class="glyphicon glyphicon-ok-circle fa-2x notf-icon"></i>
    <span class="notf-message">#= message #</span>
</div>
</script>
<script id="tmplKendoError" type="text/x-kendo-template">
<div class="alert-danger notification">
    <i class="glyphicon glyphicon-remove-circle fa-2x notf-icon"></i>
    <span class="notf-message">#= message #</span>
</div>
</script>
<script id="tmplKendoInfo" type="text/x-kendo-template">
<div class="alert-info notification">
    <i class="glyphicon glyphicon-exclamation-sign fa-2x notf-icon"></i>
    <span class="notf-message">#= message #</span>
</div>
</script>



<!-- Create Indicator Modal -->
<div class="modal fade" id="createIndicatorModal" tabindex="-1" role="dialog"
     aria-labelledby="createIndicatorModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"
                        onclick="hideCreateIndicatorModal();"><span
                        aria-hidden="true">&times;</span></button>
                <h5 class="modal-title" id="createIndicatorModalLabel">Split Indicator target into monthly basis</h5>
            </div>

            <div class="modal-body">
                <form class="form-horizontal form-widgets" id="createIndicatorForm" name="createIndicatorForm">
                    <input type="hidden" id="indicatorIdModal" name="indicatorIdModal" value=""/>
                    <input type="hidden" id="tempTargetNameModal" name="tempTargetNameModal" value=""/>
                    <input type="hidden" id="tempCountModal" name="tempCountModal" value=""/>

                    <div class="form-group">
                        <label class="col-md-1" style="padding-right: 0px !important;"><b>Indicator:</b></label>
                        <span class="col-md-7" id="indicatorModalIndicatorLbl" style="padding-left: 25px  !important;"></span>

                        <label class="col-md-1 label-optional"><b>Target:</b></label>
                        <span class="col-md-2" id="indicatorModalTargetLbl"></span>

                        <div class="col-md-2">
                            <span class="control-label" id=""></span>
                        </div>
                    </div>

                    <div class="form-group">
                        <div class="col-md-10">
                            <table class="table table-bordered table-hover" id="i_logic">
                                <tbody>
                                <tr id='iddr0'>
                                    <td width="60%"></td>
                                    <td width="40%"></td>
                                </tr>
                                <tr id='iddr1'></tr>
                                </tbody>
                            </table></div>
                    </div>

                </form>
            </div>

            <div class="modal-footer">
                <input class="btn btn-primary" type="button" value="Split" onclick="onClickCreateIndicatorModal();"
                       tabindex="5">
                <input class="btn btn-default" type="button" value="Close" onclick="hideCreateIndicatorModal();"
                       data-dismiss="modal" tabindex="5">
            </div>
        </div>
    </div>
</div>


