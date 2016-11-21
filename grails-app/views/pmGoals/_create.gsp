<div class="container-fluid">
    <div class="row">
        <div id="application_top_panel" class="panel panel-primary">
            <div class="panel-heading">
                <div class="panel-title">
                    Create Goals
                </div>
            </div>

            <g:form name='goalForm' id='goalForm' class="form-horizontal form-widgets" role="form">
                <div class="panel-body">
                    <input type="hidden" name="id" id="id" data-bind="value: goal.id"/>
                    <input type="hidden" name="version" id="version" data-bind="value: goal.version"/>

                    <div class="form-group">
                        <label class="col-md-2 control-label label-required"
                               for="serviceId">Central Service/Sector:</label>

                        <div class="col-md-6">
                            <app:dropDownService
                                    class="kendo-drop-down"
                                    required="true" validationMessage="Required"
                                    id="serviceId" name="serviceId" tabindex="1"
                                    data-bind="value: goal.serviceId"
                                    data_model_name="dropDownService">
                            </app:dropDownService>
                        </div>

                        <div class="col-md-3 pull-left">
                            <span class="k-invalid-msg" data-for="serviceId"></span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col-md-2 control-label label-required" for="goal">Goals:</label>

                        <div class="col-md-6">
                            <textarea id="goal" name="goal" cols="4" rows="5"
                                      tabindex="2" class="form-control"
                                      data-bind="value: goal.goal"
                                      required validationMessage="Required"
                                      placeholder="Project Goal" class="kendo-drop-down"></textarea>
                        </div>

                        <div class="col-md-3 pull-left">
                            <span class="k-invalid-msg" data-for="goal"></span>
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
        <div id="gridGoal"></div>
    </div>
</div>