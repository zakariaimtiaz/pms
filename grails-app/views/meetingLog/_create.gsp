<div class="container-fluid">
    <div class="row" id="rowMeetingLog">
        <div id="application_top_panel" class="panel panel-primary">
            <div class="panel-heading">
                <div class="panel-title">
                    Create ${meetingType} Meeting Log
                </div>
            </div>

            <g:form name='meetingLogForm' id='meetingLogForm' class="form-horizontal form-widgets" role="form">
                <div class="panel-body">
                    <input type="hidden" name="id" id="id" data-bind="value: meetingLog.id"/>
                    <input type="hidden" name="version" id="version" data-bind="value: meetingLog.version"/>
                    <input type="hidden" name="meetingTypeId" id="meetingTypeId" data-bind="value: meetingLog.meetingTypeId"/>

                    <div class="form-group">
                        <div class="col-md-5">
                            <div class="form-group">
                                <label class="col-md-2 control-label label-required" for="serviceId">Sector/CSU:</label>

                                <div class="col-md-9">
                                    <app:dropDownService
                                            class="kendo-drop-down"
                                            id="serviceId" name="serviceId" tabindex="1"
                                            data-bind="value: meetingLog.serviceId"
                                            data_model_name="dropDownService">
                                    </app:dropDownService>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 control-label label-required" for="heldOn">Date:</label>

                                <div class="col-md-9">
                                    <app:dateControl name="heldOn"
                                                     tabindex="2" class="kendo-date-picker"
                                                     data-bind="value: meetingLog.heldOn" placeholder="Held On">
                                    </app:dateControl>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 control-label label-required"
                                       for="attendees">Attendees:</label>

                                <div class="col-md-9">
                                    <select id="attendees" name="attendees"
                                            data-placeholder="Select ..." tabindex="3"
                                            data-bind="value: meetingLog.attendees">
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 control-label label-required" for="issues">Agenda:</label>

                                <div class="col-md-9">
                                    <textarea id="issues" name="issues"
                                              style="height:50px;!important;"
                                              class="form-control" tabindex="4"
                                              data-bind="value: meetingLog.issues"
                                              placeholder="Issues"></textarea>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-7">
                            <div class="form-group">
                                <label class="col-md-2 control-label label-required" for="logStr">Action Log:</label>

                                <div class="col-md-10">
                                    <textarea id="logStr" name="logStr" style="height:315px;"
                                              class="form-control" tabindex="5"
                                              data-bind="value: meetingLog.logStr"
                                              placeholder="Summary"></textarea>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="panel-footer">
                    <button id="create" name="create" type="submit" data-role="button"
                            class="k-button k-button-icontext"
                            role="button" tabindex="6"
                            aria-disabled="false"><span class="k-icon k-i-plus"></span>Save
                    </button>

                    <button id="clearFormButton" name="clearFormButton" type="button" data-role="button"
                            class="k-button k-button-icontext" role="button" tabindex="7"
                            aria-disabled="false" onclick='resetForm();'><span
                            class="k-icon k-i-close"></span>Cancel
                    </button>
                </div>
            </g:form>
        </div>
    </div>

    <div class="row">
        <div id="gridMeetingLog"></div>
    </div>
</div>