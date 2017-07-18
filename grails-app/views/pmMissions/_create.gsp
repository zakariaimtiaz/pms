<div class="container-fluid">
    <div class="row" id="rowMissions">
        <div id="application_top_panel" class="panel panel-primary">
            <div class="panel-heading">
                <div class="panel-title">
                    Create Mission
                </div>
            </div>

            <g:form name='missionForm' id='missionForm' class="form-horizontal form-widgets" role="form">
                <div class="panel-body">
                    <input type="hidden" name="id" id="id" data-bind="value: mission.id"/>
                    <input type="hidden" name="version" id="version" data-bind="value: mission.version"/>

                    <div class="form-group">
                        <label class="col-md-1 control-label label-optional"
                               for="serviceId">Sector/CSU:</label>

                        <div class="col-md-6">
                            <app:dropDownService
                                    class="kendo-drop-down"  readonly="true"
                                    required="true" validationMessage="Required"
                                    id="serviceId" name="serviceId" tabindex="1"
                                    data-bind="value: mission.serviceId"
                                    data_model_name="dropDownService">
                            </app:dropDownService>
                        </div>

                        <div class="col-md-3 pull-left">
                            <span class="k-invalid-msg" data-for="serviceId"></span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col-md-1 control-label label-required" for="mission">Statement:</label>

                        <div class="col-md-6">
                            <textarea id="mission" name="mission" cols="4" rows="5"
                                      tabindex="2" class="form-control"
                                      data-bind="value: mission.mission"
                                      required validationMessage="Required"
                                      placeholder="Mission Statement" class="kendo-drop-down"></textarea>
                        </div>

                        <div class="col-md-3 pull-left">
                            <span class="k-invalid-msg" data-for="mission"></span>
                        </div>
                    </div>
                </div>

                <div class="panel-footer">
                    <button id="create" name="create" type="submit" data-role="button"
                            class="k-button k-button-icontext"
                            role="button" tabindex="3"
                            aria-disabled="false"><span class="k-icon k-i-plus"></span>Save
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
        <div id="gridMission"></div>
    </div>
</div>