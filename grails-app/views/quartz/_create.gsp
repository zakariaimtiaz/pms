<div class="container-fluid">
    <div class="row" id="quartzRow">
        <div id="application_top_panel" class="panel panel-primary">
            <div class="panel-heading">
                <div class="panel-title">
                    Create Trigger
                </div>
            </div>

            <g:form name='quartzForm' id='quartzForm' class="form-horizontal form-widgets" role="form">
                <div class="panel-body">
                    <input type="hidden" name="id" id="id" data-bind="value: quartz.id"/>
                    <input type="hidden" name="version" id="version" data-bind="value: quartz.version"/>

                    <div class="form-group">
                        <div class="col-md-8">

                            <div class="form-group">
                                <label class="col-md-2 control-label label-required" for="triggerName">Trigger:</label>

                                <div class="col-md-6">
                                    <input type="text" class="form-control" id="triggerName" name="triggerName"
                                           placeholder="Trigger Name" required validationMessage="Required" tabindex="1"
                                           data-bind="value: quartz.triggerName"/>
                                </div>

                                <div class="col-md-3 pull-left">
                                    <span class="k-invalid-msg" data-for="jobName"></span>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 control-label label-required" for="jobName">Job Name:</label>

                                <div class="col-md-6">
                                    <input type="text" class="form-control" id="jobName" name="jobName"
                                           placeholder="Job Name" required validationMessage="Required" tabindex="2"
                                           data-bind="value: quartz.jobName"/>
                                </div>

                                <div class="col-md-3 pull-left">
                                    <span class="k-invalid-msg" data-for="jobName"></span>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 control-label label-required" for="cronExpression">Expression:</label>

                                <div class="col-md-6">
                                    <input type="text" class="form-control" id="cronExpression" name="cronExpression"
                                           placeholder="Cron Expression" required validationMessage="Required" tabindex="3"
                                           data-bind="value: quartz.cronExpression"/>
                                </div>

                                <div class="col-md-3 pull-left">
                                    <span class="k-invalid-msg" data-for="cronExpression"></span>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="col-md-2 control-label label-required" for="description">Description:</label>

                                <div class="col-md-6">
                                    <textarea id="description" name="description" cols="4" rows="5"
                                              tabindex="4" class="form-control"
                                              data-bind="value: quartz.description"
                                              required validationMessage="Required"
                                              placeholder="Short description" class="kendo-drop-down"></textarea>
                                </div>

                                <div class="col-md-3 pull-left">
                                    <span class="k-invalid-msg" data-for="password"></span>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-4">
                            <div class="form-group">
                                <label class="col-md-6 control-label label-optional"
                                       for="isActive">IS Active:</label>

                                <div class="col-md-3">
                                    <g:checkBox class="form-control-static" name="isActive" tabindex="5"
                                                data-bind="checked: quartz.isActive"/>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="col-md-6 control-label label-optional"
                                       for="isRunning">IS Running:</label>

                                <div class="col-md-3">
                                    <g:checkBox class="form-control-static" name="isRunning" tabindex="6"
                                                data-bind="checked: quartz.isRunning"/>
                                </div>
                            </div>
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
        <div id="gridQuartz"></div>
    </div>
</div>