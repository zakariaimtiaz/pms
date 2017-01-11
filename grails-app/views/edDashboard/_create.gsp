<div class="container-fluid" xmlns="http://www.w3.org/1999/html">
    <div class="row" id="rowEdDashboard">
        <div id="application_top_panel" class="panel panel-primary">
            <div class="panel-heading">
                <div class="panel-title">
                    Create Ed Dashboard
                </div>
            </div>

            <g:form name='edDashboardForm' id='edDashboardForm' class="form-horizontal form-widgets" role="form">
                <div class="panel-body">

                    <div class="form-group">
                        <label class="col-md-1 control-label label-optional"
                               for="serviceId">Sector/CSU:</label>

                        <div class="col-md-4">
                            <app:dropDownService
                                    class="kendo-drop-down" is_in_sp="true"
                                    id="serviceId" name="serviceId" tabindex="1"
                                    data_model_name="dropDownService">
                            </app:dropDownService>
                        </div>
                        <label class="col-md-1 control-label label-required" for="month">Month:</label>
                <div class="col-md-2">
                        <input type="text" id="month" name="month" tabindex="3"
                               placeholder="Select month">
                </div>
                    <div class="col-md-2" >
                        <button id="view" name="view" type="button" data-role="button"
                                class="k-button k-button-icontext" onclick="loadTableData();"
                                role="button" tabindex="3"
                                aria-disabled="false"><span class="k-icon k-i-search"></span>View/Edit
                        </button>
                    </div>
                    </div>

                <div  class="form-group" style="display: none;">
                    <div id="gridEdDashboard"></div>
                </div>
                    <div class="form-group" id="tableData">
                    &nbsp;
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
</div>