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
<div class="modal fade" id="createIndicatorModal" tabindex="-1" aria-labelledby="createIndicatorModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"
                        onclick="hideCreateIndicatorModal();"><span
                        aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="createIndicatorModalLabel">Split Indicator target into monthly basis</h4>
            </div>

            <div class="modal-body">
                <form class="form-horizontal form-widgets" id="createIndicatorForm" name="createIndicatorForm">
                    <input type="hidden" id="indicatorIdModal" name="indicatorIdModal" value=""/>
                    <input type="hidden" id="indTypeIdModal" name="indTypeIdModal" value=""/>
                    <input type="hidden" id="tempTargetNameModal" name="tempTargetNameModal" value=""/>
                    <input type="hidden" id="hidTargetModal" name="hidTargetModal" value=""/>
                    <input type="hidden" id="hidSumModal" name="hidSumModal" value=""/>
                    <input type="hidden" id="tempCountModal" name="tempCountModal" value=""/>

                    <div class="form-group">
                        <label class="col-md-1" style="padding-right: 0px !important;"><b>Indicator:</b></label>
                        <span class="col-md-7" id="indicatorModalIndicatorLbl"
                              style="padding-left: 25px  !important;"></span>

                        <label class="col-md-1 label-optional"><b>Target:</b></label>
                        <span class="col-md-2" id="indicatorModalTargetLbl"></span>
                    </div>

                    <div class="form-group">
                        <div class="col-md-10">
                            <table class="table table-bordered table-hover" id="i_logic">
                                <tbody>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </form>
            </div>

            <div class="modal-footer">
                <input class="btn btn-primary" type="button" value="Split" onclick="onClickCreateIndicatorModal();">
                <input class="btn btn-default" type="button" value="Close" onclick="hideCreateIndicatorModal();"
                       data-dismiss="modal">
            </div>
        </div>
    </div>
</div>

<!-- Calendar Modal -->
<div class="modal fade" id="myCalModal" tabindex="-1" aria-labelledby="myCalModal">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">Select Year</h4>
            </div>

            <div class="modal-body">
                <form class="form-horizontal form-widgets" id="createCalModalForm" name="createCalModalForm">

                    <div class="form-group">
                        <label class="col-md-1"><b>Year:</b></label>
                        <div style="padding-left: 55px;width: 150px;!important;"><input id="modalCalYear" name="modalCalYear"></div>
                    </div>
                </form>
            </div>

            <div class="modal-footer">
                <input class="btn btn-primary" type="button" value="Select" onclick="onClickCalModal();">
                <button class="btn btn-primary" data-dismiss="modal" aria-hidden="true">Close</button>
            </div>
        </div>
    </div>
</div>


