<div class="container-fluid">
    <div class="row" id="rowMeetingLog">
        <div id="application_top_panel" class="panel panel-primary">
            <div class="panel-heading">
                <div class="panel-title">
                    Create ${meetingType} Meeting Log
                </div>
            </div>

            <g:form name='meetingLogFormAQ' id='meetingLogFormAQ' class="form-horizontal form-widgets" role="form" >
                <div class="panel-body">
                    <input type="hidden" name="id" id="id" data-bind="value: meetingLog.id"/>
                    <input type="hidden" name="version" id="version" data-bind="value: meetingLog.version"/>
                    <input type="hidden" name="meetingTypeId" id="meetingTypeId" data-bind="value: meetingLog.meetingTypeId"/>
                    <input type="hidden" name="serviceId" id="serviceId" data-bind="value: meetingLog.serviceId"/>

                    <div class="form-group">
                        <div class="form-group">
                            <label class="col-md-2 control-label label-required">Date:</label>

                            <div class="col-md-9">
                                    <input type="text" id="heldOn" name="heldOn" tabindex="1"
                                           data-bind="value: meetingLog.heldOn" placeholder="Start date">
                                    <input type="text" id="endDate" name="endDate" tabindex="2"
                                           data-bind="value: meetingLog.endDate" placeholder="End date">
                            </div>
                        </div>
                            <div class="form-group">
                                <label class="col-md-2 control-label label-required" for="descStr">Description:</label>

                                <div class="col-md-10">
                                    <textarea id="descStr" name="descStr" style="height:350px;"
                                              class="form-control" tabindex="3"
                                              data-bind="value: meetingLog.descStr"
                                              placeholder="Description"></textarea>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 control-label label-optional" for="fileName">Upload File:</label>
                                <div class="col-md-10">

                                    <input type="file" id="fileName" name="fileName" tabindex="4"/>

                                </div>
                            </div>

                    </div>
                </div>

                <div class="panel-footer">
                    <button id="create" name="create" type="submit" data-role="button"
                            class="k-button k-button-icontext"
                            role="button" tabindex="5"
                            aria-disabled="false"><span class="k-icon k-i-plus"></span>Save
                    </button>

                    <button id="clearFormButton" name="clearFormButton" type="button" data-role="button"
                            class="k-button k-button-icontext" role="button" tabindex="6"
                            aria-disabled="false" onclick='resetForm();'><span
                            class="k-icon k-i-close"></span>Cancel
                    </button>
                </div>
            </g:form>
        </div>
    </div>

    <div class="row">
        <div id="gridMeetingLogAQ"></div>
    </div>
</div>