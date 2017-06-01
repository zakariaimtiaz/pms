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

#myCalModal .modal-dialog  {
    width:20%;
    left: 20%;
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
<!-- Create SP deadline model -->
<div class="modal fade" id="createSPModal" tabindex="-1" role="dialog" aria-labelledby="createSPModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">Set SP Dead Line</h4>
            </div>

            <div class="modal-body">
                <form class="form-horizontal form-widgets" id="createSPModalForm" name="createSPModalForm">
                    <div class="form-group">
                        <label class="col-md-1 control-label label-optional" for="modalSPYear">Year:</label>

                        <div class="col-md-3">
                            <input type='text' tabindex="1" required="required" onkeydown="return false;"
                                   class="kendo-date-picker" id="modalSPYear" name="modalSPYear"
                                   placeholder="Year" validationMessage="Required"/>
                        </div>
                        <label class="col-md-2 control-label label-optional" for="modalSPDeadLine">Dead Line:</label>

                        <div class="col-md-3">
                            <input type='text' tabindex="2" required="required" onkeydown="return false;"
                                   class="kendo-date-picker" id="modalSPDeadLine" name="modalSPDeadLine"
                                   placeholder="Dead Line" validationMessage="Required"/>
                        </div>
                    </div>
                </form>
            </div>

            <div class="modal-footer">
                <input class="btn btn-primary" type="button" value="Save" onclick="onClickSPModal();">
                <button class="btn btn-primary" data-dismiss="modal" aria-hidden="true">Close</button>
            </div>
        </div>
    </div>
</div>
<!-- Create MCRS deadline model -->
<div class="modal fade" id="createMCRSModal" tabindex="-1" role="dialog" aria-labelledby="createMCRSMModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">Set MCRS Dead Line</h4>
            </div>

            <div class="modal-body">
                <form class="form-horizontal form-widgets" id="createMCRSMModalForm" name="createMCRSMModalForm">
                    <div class="form-group">
                        <label class="col-md-1 control-label label-optional" for="modalMCRSMonth">Month:</label>

                        <div class="col-md-3">
                            <input type='text' tabindex="1" required="required" onkeydown="return false;"
                                   class="kendo-date-picker" id="modalMCRSMonth" name="modalMCRSMonth"
                                   placeholder="Month" validationMessage="Required"/>
                        </div>
                        <label class="col-md-2 control-label label-optional" for="modalMCRSMonth">Dead Line:</label>

                        <div class="col-md-3">
                            <input type='text' tabindex="2" required="required" onkeydown="return false;"
                                   class="kendo-date-picker" id="modalMCRSDeadLine" name="modalMCRSDeadLine"
                                   placeholder="Dead Line" validationMessage="Required"/>
                        </div>
                    </div>
                </form>
            </div>

            <div class="modal-footer">
                <input class="btn btn-primary" type="button" value="Save" onclick="onClickMCRSModal();">
                <button class="btn btn-primary" data-dismiss="modal" aria-hidden="true">Close</button>
            </div>
        </div>
    </div>
</div>
<!-- Create Ed Dashboard Modal for Followup Crisis & remarks -->
<div class="modal fade" id="createEdFollowupModal" role="dialog" tabindex="-1"
     aria-labelledby="createEdFollowupLabel">
    <div class="modal-dialog" role="document" style=" width:70%;">
        <div class="modal-content">
            <div class="modal-header "style=" background:#81ecef;border-top-left-radius: 5px;
                 border-top-right-radius: 5px; height: 30px; padding-top: 5px;">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"
                        onclick="hideFollowupDashboardModal();"><span
                        aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="headingLabel"></h4>
            </div>

            <div class="modal-body" style="padding-top: 5px;padding-bottom: 5px;">
                <form class="form-horizontal form-widgets" id="createEdFollowupForm" name="createEdFollowupForm">
                    <input type="hidden" id="hfClickingRowNo" name="hfClickingRowNo" value=""/>
                    <input type="hidden" id="hfServiceIdModal" name="hfServiceIdModal" value=""/>
                    <input type="hidden" id="hfMonthModal" name="hfMonthModal" value=""/>
                    <input type="hidden" id="type" name="type" value="Followup"/>

                    <div class="form-group">
                        <div class="col-md-4" style="padding-right: 0px;">
                            <strong class="label-optional">Issued Month:</strong>
                            <strong class="label-optional" id="issuedMonth"></strong>
                            </div>
                        <div class="col-md-3" style="padding-right: 0px;">
                            <strong class="label-required">Status:</strong>
                        <input type="radio" name="selection" id="selectionResolve"
                               onchange="loadFollowupMonth();" value="Resolve"><label>Resolve</label>&nbsp;&nbsp;
                        <input type="radio" name="selection" id="selectionFollowup"
                               onchange="loadFollowupMonth();" value="Followup"><label>Follow-up</label>
                        </div>

                        <div id="divfollowupMonth" style="display: none;" class="col-md-5">
                            <div class="col-md-2">
                                <label class="control-label label-required"> <strong>Month:</strong></label></div>
                            <div class="col-md-9">
                            <input type="text" id="followupMonth" name="followupMonth"
                                   placeholder="Select month"></div>
                        </div>
                    </div>

                    <div class="form-group">
                        <div align="left" style=" padding-left: 15px;">
                            <label class="control-label label-required" style="padding-top: 0px;" for="description" ><strong>Crisis and Highlights:</strong></label>
                        </div>
                        <div class="col-md-12">
                                <textarea id="description" name="description" rows="5" class="form-control" readonly></textarea>
                            </div>
                        </div>
                    <div class="form-group">
                        <div align="left" style=" padding-left: 15px;">
                            <label class="control-label label-optional" style="padding-top: 0px;" for="remarks" ><strong>Previous Remarks and Recommendations:</strong></label>
                        </div>
                        <div class="col-md-12">
                            <div id="oldRemarks" name="oldRemarks" class="form-control"  style="padding: 0 0 0 0 ! important;
                            background-color: #eee; height: 110px;width: 100%; overflow: auto;font-size: inherit;" contentEditable='false'
                                 unselectable='true'>
                            </div>
                        </div>

                    </div>
                    <div class="form-group" id="divRemarks" style="display: none;">
                        <div align="left" style=" padding-left: 15px;">
                            <label class="control-label label-required" style="padding-top: 0px;" for="remarks" ><strong>Remarks and Recommendations:</strong></label>
                        </div>
                        <div class="col-md-12">
                            <textarea id="remarks" name="remarks" rows="5"
                                      style="padding: 0 0 0 0 ! important;"
                                      class="form-control" ></textarea>
                        </div>

                    </div>
                </form>
            </div>

            <div class="modal-footer">
                <input class="btn btn-primary" type="button" value="Save" onclick="onSubmitFollowupDashboard();"
                       tabindex="2">
                <input class="btn btn-default" type="button" value="Close" onclick="hideFollowupDashboardModal();"
                       data-dismiss="modal" tabindex="3">
            </div>
        </div>
    </div>
</div>

<!-- Create Ed Dashboard Modal for New Entry -->
<div class="modal fade" id="createEdDashboardModal" role="dialog" tabindex="-1"
     aria-labelledby="createEdDashboardLabel">
    <div class="modal-dialog" role="document" style=" width:70%;">
        <div class="modal-content">
            <div class="modal-header "style=" background:#81ecef;border-top-left-radius: 5px;
            border-top-right-radius: 5px; height: 30px; padding-top: 5px;">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"
                        onclick="hideEdDashboardModal();"><span
                        aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="headingLabelNew"></h4>
            </div>

            <div class="modal-body" style="padding-top: 5px;padding-bottom: 5px;">
                <form class="form-horizontal form-widgets" id="createEdDashboardForm" name="createEdDashboardForm">
                    <input type="hidden" id="hfServiceIdNewModal" name="hfServiceIdModal" value=""/>
                    <input type="hidden" id="hfMonthNewModal" name="hfMonthModal" value=""/>
                    <input type="hidden" id="hfId" name="hfId" value=""/>

                    <div class="form-group">

                        <div class="col-md-1" style="padding-right: 0px;">
                            <strong class="label-required">Issue :</strong>
                        </div>
                        <div class="col-md-6" style="padding-left: 0px;">
                            <div id="divIssueIdDDL">
                            <select id="issueIdDDL" name="issueIdDDL" class="kendo-drop-down"></select>
                            </div>
                            <strong class="control-label" id="issueName" style="display: none"></strong>
                        </div>
                    </div>
                    <div align="left">
                        <label class="control-label label-required" style="padding-top: 0px;" for="description" ><strong>Crisis and Highlights:</strong></label>
                    </div>
                    <div class="form-group">
                        <div class="col-md-12" id="divDescriptionTextAreaNew">
                            <textarea id="descriptionNew" name="description" rows="5"
                                      style="padding: 0 0 0 0 ! important;"
                                      class="form-control" ></textarea>
                        </div>
                    </div>
                    <div align="left">
                        <label class="control-label label-optional" style="padding-top: 0px;" for="remarks" ><strong>Remarks and Recommendations:</strong></label>
                    </div>
                    <div class="form-group">

                        <div class="col-md-12">
                            <textarea id="remarksNew" name="remarks" rows="5"
                                      style="padding: 0 0 0 0 ! important;"
                                      class="form-control" ></textarea>


                        </div>

                    </div>
                </form>
            </div>

            <div class="modal-footer">
                <input class="btn btn-primary" type="button" value="Save" onclick="onSubmitEdDashboard();"
                       tabindex="2">
                <input class="btn btn-default" type="button" value="Close" onclick="hideEdDashboardModal();"
                       data-dismiss="modal" tabindex="3">
            </div>
        </div>
    </div>
</div>



