<div class="container-fluid">
    <div class="row">
        <div id="application_top_panel" class="panel panel-primary">
            <div class="panel-heading">
                <div class="panel-title">
                    Create Time Schedule
                </div>
            </div>

            <g:form name='timeScheduleForm' id='timeScheduleForm' class="form-horizontal form-widgets" role="form">
                <div class="panel-body">
                    <input type="hidden" name="id" id="id" data-bind="value: spTimeSchedule.id"/>
                    <input type="hidden" name="version" id="version" data-bind="value: spTimeSchedule.version"/>

                    <div class="form-group">
                        <label class="col-md-2 control-label label-required" for="from">From:</label>

                        <div class="col-md-2">
                            <input type='text' tabindex="1" required="required" onkeydown="return false;"
                                   class="kendo-date-picker" id="from" name="from"
                                   data-bind="value: spTimeSchedule.fromDate"
                                   placeholder="Year" validationMessage="Required"/>
                        </div>
                        <label class="col-md-2 control-label label-required" for="to">To:</label>

                        <div class="col-md-2">
                            <input type='text' tabindex="2" required="required" onkeydown="return false;"
                                   class="kendo-date-picker" id="to" name="to"
                                   data-bind="value: spTimeSchedule.toDate"
                                   placeholder="Year" validationMessage="Required"/>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col-md-2 control-label" for="description">Description:</label>

                        <div class="col-md-6">
                            <textarea id="description" name="description" cols="4" rows="5"
                                      tabindex="2" class="form-control"
                                      data-bind="value: spTimeSchedule.description"
                                      placeholder="Description"></textarea>
                        </div>


                    </div>
                </div>

                <div class="panel-footer">
                    <button id="create" name="create" type="submit" data-role="button"
                            class="k-button k-button-icontext"
                            role="button" tabindex="3"
                            aria-disabled="false"><span class="k-icon k-i-plus"></span>Create
                    </button>

                    <button id="clearFormButton" name="clearFormButton" type="button" data-role="button"
                            class="k-button k-button-icontext" role="button" tabindex="4"
                            aria-disabled="false" onclick='resetForm();'><span
                            class="k-icon k-i-close"></span>Cancel
                    </button>
                </div>
            </g:form>
        </div>
    </div>

    <div class="row">
        <div id="gridTimeSchedule"></div>
    </div>
</div>