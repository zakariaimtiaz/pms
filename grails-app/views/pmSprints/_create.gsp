<div class="container-fluid">
    <div class="row" id="rowSprint">
        <div id="application_top_panel" class="panel panel-primary">
            <div class="panel-heading">
                <div class="panel-title">
                    Create Steps Plan
                </div>
            </div>

            <g:form name='sprintsForm' id='sprintsForm' class="form-horizontal form-widgets" role="form">
                <div class="panel-body">
                    <input type="hidden" name="id" id="id" data-bind="value: sprints.id"/>
                    <input type="hidden" name="version" id="version" data-bind="value: sprints.version"/>

                    <div class="form-group">
                        <div class="col-md-5">
                            <div class="form-group">
                                <label class="col-md-2 control-label label-required"
                                       for="serviceId">Service:</label>

                                <div class="col-md-10">
                                    <app:dropDownService
                                            class="kendo-drop-down"
                                            onchange="javascript:populateGoals();"
                                            id="serviceId" name="serviceId" tabindex="1"
                                            data-bind="value: sprints.serviceId"
                                            data_model_name="dropDownService">
                                    </app:dropDownService>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="col-md-2 control-label label-required" for="goalId">Goals:</label>

                                <div class="col-md-10">
                                    <select class="kendo-drop-down" id="goalId" name="goalId"
                                            onchange="javascript:populateActions();"
                                            placeholder="Select Goal"
                                            tabindex="2" data-bind="value: sprints.goalId"></select>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 control-label label-required"
                                       for="actionsId">Action:</label>

                                <div class="col-md-10">
                                    <select class="kendo-drop-down" id="actionsId" name="actionsId"
                                            placeholder="Select Action"
                                            onchange="javascript:populateStartAndEndDate();"
                                            tabindex="3" data-bind="value: sprints.actionsId"></select>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="col-md-2 control-label label-required" for="start">Date:</label>

                                <div class="col-md-10">
                                    <input type="text" id="start" name="start" tabindex="3"
                                           data-bind="value: sprints.startDate" placeholder="Start date">&nbsp;To&nbsp;
                                    <input type="text" id="end" name="end" tabindex="4"
                                           data-bind="value: sprints.endDate" placeholder="End date">
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="col-md-2 control-label label-optional" for="target">Target:</label>

                                <div class="col-md-10">
                                    <input type="text" class="form-control" id="target" name="target"
                                           placeholder="Target"
                                           tabindex="3" data-bind="value: sprints.target"/>
                                </div>
                            </div>

                        </div>

                        <div class="col-md-7">
                            <div class="form-group">
                                <label class="col-md-2 control-label label-required" for="sprints">Steps:</label>

                                <div class="col-md-10">
                                    <textarea id="sprints" name="sprints" cols="4" rows="4"
                                              tabindex="4" class="form-control"
                                              data-bind="value: sprints.sprints"
                                              placeholder="Steps" class="kendo-drop-down"></textarea>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 control-label label-required"
                                       for="weight">Weight:</label>

                                <div class="col-md-10">
                                    <input type="text" class="form-control"
                                           id="weight" name="weight" tabindex="3"
                                           data-bind="value: sprints.weight"/>
                                </div>

                                <div class="col-md-3 pull-left">
                                    <span class="k-invalid-msg" data-for="weight"></span>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="col-md-2 control-label label-optional"
                                       for="resPersonId">Responsible:</label>

                                <div class="col-md-10">
                                    <app:dropDownEmployee
                                            data_model_name="dropDownEmployee"
                                            required="false" class="kendo-drop-down"
                                            sort_by_department="false" tabindex="3"
                                            id="resPersonId" name="resPersonId"
                                            data-bind="value: sprints.resPersonId">
                                    </app:dropDownEmployee>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="col-md-2 control-label label-optional" for="remarks">Remarks:</label>

                                <div class="col-md-10">
                                    <input type="text" class="form-control" id="remarks" name="remarks"
                                           placeholder="Remarks"
                                           tabindex="3" data-bind="value: sprints.remarks"/>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>

                <div class="panel-footer">
                    <button id="create" name="create" type="submit" data-role="button"
                            class="k-button k-button-icontext" role="button" tabindex="5"
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
        <div id="gridSprints"></div>
    </div>
</div>