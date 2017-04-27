<div class="container-fluid" xmlns="http://www.w3.org/1999/html">
    <div class="row" id="rowEdDashboard">
        <div id="application_top_panel" class="panel panel-primary">
            <div class="panel-heading">
                <div class="panel-title">
                    ED's Dashboard
                </div>
            </div>

            <g:form name='edDashboardForm' id='edDashboardForm' class="form-horizontal form-widgets" role="form">
                <div class="panel-body">
                    <input type="hidden" name="id" id="id" data-bind="value: edDashboard.id"/>
                    <input type="hidden" name="version" id="version" data-bind="value: edDashboard.version"/>

                    <div class="form-group">
                        <label class="col-md-1 control-label label-optional"
                               for="serviceId">Sector/CSU:</label>

                        <div class="col-md-5">
                            <app:dropDownService
                                    class="kendo-drop-down" is_in_sp="true"
                                    id="serviceId" name="serviceId" tabindex="1"
                                    data-bind="value: edDashboard.serviceId"
                                    data_model_name="dropDownService">
                            </app:dropDownService>
                        </div>
                        <label class="col-md-1 control-label label-required" for="month">Month:</label>
                <div class="col-md-1">
                        <input type="text" id="month" name="month" tabindex="3"
                               data-bind="value: edDashboard.monthFor"
                               placeholder="Select month">
                </div>
                    </div>
                    <div class="form-group">
                        <label class="col-md-1 control-label label-required"
                               for="issueId">Issues:</label>

                        <div class="col-md-5">
                            <app:dropDownEdDashboardIssues
                                    class="kendo-drop-down"
                                    id="issueId" name="issueId" tabindex="3"
                                onchange="loadFollowupMonthDesc();"
                                    data-bind="value: edDashboard.issueId"
                                    data_model_name="dropDownEdDashboardIssues">
                            </app:dropDownEdDashboardIssues>
                        </div>
                            <label class="col-md-1 control-label label-optional"
                                   for="isFollowup">Followup:</label>

                            <div class="col-md-3">
                                <div class="col-md-3">
                                <g:checkBox class="form-control-static" name="isFollowup" id="isFollowup" tabindex="4"
                                            onchange="loadFollowupMonth(this);"
                                            data-bind="checked: edDashboard.isFollowup"/>
                                </div>
                                <div id="divfollowupMonth" style="display: none;"  class="col-md-9">
                                    <input type="text" id="followupMonth" name="followupMonth"
                                           data-bind="value: edDashboard.followupMonthFor"
                                           placeholder="Select month" style="width: 100%;">
                                </div>
                            </div>

                    </div>
                    <div class="form-group">
                        <label class="col-md-1 control-label label-required" for="description">Crisis & Highlights:</label>

                        <div class="col-md-5" id="divDescriptionTextArea">
                            <textarea id="description" name="description" cols="4" rows="5"
                                      tabindex="5" class="form-control"
                                      data-bind="value: edDashboard.description"
                                      required validationMessage="Required"
                                      placeholder="Specific Issues Crisis & Highlights" ></textarea>

                            <span class="k-invalid-msg" data-for="description"></span>
                        </div>
                        <div class="col-md-5" id="divDescFollowupMonthDDL" style="display: none;">
                            <select
                                    id="descFollowupMonthDDL" name="descFollowupMonthDDL"
                                    class="kendo-drop-down" onchange="loadRemarksAndEdAdvice(this);">
                            </select>
                        </div>

                            <label class="col-md-1 control-label label-required"
                                   for="remarks">Remarks:</label>

                            <div class="col-md-5">
                                <textarea id="remarks" name="remarks" col="4" rows="5"
                                          tabindex="6" class="form-control"
                                          data-bind="value: edDashboard.remarks"
                                          required validationMessage="Required"
                                          placeholder="Specific Issues Remarks" ></textarea>
                                <span class="k-invalid-msg" data-for="remarks"></span>
                            </div>
                    </div>
                </div>
                <div class="panel-footer">
                    <button id="create" name="create" type="submit" data-role="button"
                            class="k-button k-button-icontext"
                            role="button" tabindex="7"
                            aria-disabled="false"><span class="k-icon k-i-plus"></span>Save
                    </button>

                    <button id="clearFormButton" name="clearFormButton" type="button" data-role="button"
                            class="k-button k-button-icontext" role="button" tabindex="8"
                            aria-disabled="false" onclick='resetForm();'><span
                            class="k-icon k-i-close"></span>Cancel
                    </button>
                </div>
            </g:form>
        </div>
    </div>
    <div class="row">
        <div id="gridEdDashboard"></div>
    </div>
</div>