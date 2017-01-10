<div class="container-fluid">
    <div class="row" id="rowEdDashboard">
        <div id="application_top_panel" class="panel panel-primary">
            <div class="panel-heading">
                <div class="panel-title">
                    Create Ed Dashboard
                </div>
            </div>

            <g:form name='edDashboardForm' id='edDashboardForm' class="form-horizontal form-widgets" role="form">
                <div class="panel-body">
                    <input type="hidden" name="id" id="id" data-bind="value: edDashboard.id"/>
                    <input type="hidden" name="version" id="version" data-bind="value: edDashboard.version"/>

                    <div class="form-group">
                        <label class="col-md-1 control-label label-optional"
                               for="serviceId">Sector/CSU:</label>

                        <div class="col-md-6">
                            <app:dropDownService
                                    class="kendo-drop-down" readonly="true"
                                    required="true" validationMessage="Required"
                                    id="serviceId" name="serviceId" tabindex="1"
                                    data-bind="value: edDashboard.serviceId"
                                    data_model_name="dropDownService">
                            </app:dropDownService>
                        </div>

                        <div class="col-md-3 pull-left">
                            <span class="k-invalid-msg" data-for="serviceId"></span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col-md-1 control-label label-required" for="month">Month:</label>
                        <input type="text" id="month" name="month" tabindex="3"
                               data-bind="value: edDashboard.monthFor" placeholder="Select month">
                    </div>
                </div>
                <div class="form-group" >
                    <button id="view" name="view" type="submit" data-role="button"
                            class="k-button k-button-icontext"
                            role="button" tabindex="3"
                            aria-disabled="false"><span class="k-icon k-i-search"></span>View
                    </button>
                </div>
                <div class="row">
                    <div id="gridEdDashboard"></div>
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


</div>