<div class="container-fluid">
    <div class="row">
        <div id="application_top_panel" class="panel panel-primary">
            <div class="panel-heading">
                <div class="panel-title">
                    Create Objectives
                </div>
            </div>

            <g:form name='objectiveForm' id='objectiveForm' class="form-horizontal form-widgets" role="form">
                <div class="panel-body">
                    <input type="hidden" name="id" id="id" data-bind="value: objectives.id"/>
                    <input type="hidden" name="version" id="version" data-bind="value: objectives.version"/>

                    <div class="form-group">
                        <div class="col-md-5">
                            <div class="form-group">
                                <label class="col-md-2 control-label label-required"
                                       for="serviceId">Service:</label>

                                <div class="col-md-10">
                                    <app:dropDownService
                                            class="kendo-drop-down"
                                            required="true" validationMessage="Required"
                                            onchange="javascript:populateGoals();"
                                            id="serviceId" name="serviceId" tabindex="1"
                                            data-bind="value: objectives.serviceId"
                                            data_model_name="dropDownService">
                                    </app:dropDownService>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="col-md-2 control-label label-required" for="goalId">Goals:</label>

                                <div class="col-md-10">
                                    <select class="kendo-drop-down" id="goalId" name="goalId"
                                           placeholder="Select Goal" required validationMessage="Required"
                                           tabindex="2" data-bind="value: objectives.goalId"></select>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-7">
                            <div class="form-group">
                                <label class="col-md-2 control-label label-required" for="objective">Objectives:</label>

                                <div class="col-md-10">
                                    <textarea id="objective" name="objective" cols="4" rows="5"
                                              tabindex="3" class="form-control"
                                              data-bind="value: objectives.objective"
                                              required validationMessage="Required"
                                              placeholder="Objectives" class="kendo-drop-down"></textarea>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>

                <div class="panel-footer">
                    <button id="create" name="create" type="submit" data-role="button"
                            class="k-button k-button-icontext"
                            role="button" tabindex="4"
                            aria-disabled="false"><span class="k-icon k-i-plus"></span>Create
                    </button>

                    <button id="clearFormButton" name="clearFormButton" type="button" data-role="button"
                            class="k-button k-button-icontext" role="button" tabindex="5"
                            aria-disabled="false" onclick='resetForm();'><span
                            class="k-icon k-i-close"></span>Cancel
                    </button>
                </div>
            </g:form>
        </div>
    </div>

    <div class="row">
        <div id="gridObjectives"></div>
    </div>
</div>