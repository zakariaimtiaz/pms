<div class="container-fluid">
    <div class="row" id="rowCSU">
        <div id="application_top_panel" class="panel panel-primary">
            <div class="panel-heading">
                <div class="panel-title">
                    Central Service & Sector
                </div>
            </div>

            <g:form name='serviceForm' id='serviceForm' class="form-horizontal form-widgets" role="form">
                <div class="panel-body">
                    <input type="hidden" name="id" id="id" data-bind="value: service.id"/>
                    <input type="hidden" name="version" id="version" data-bind="value: service.version"/>

                    <div class="form-group">
                            <div class="form-group">
                                <label class="col-md-3 control-label label-optional" for="departmentHeadId">Department Head:</label>

                                <div class="col-md-6">
                                    <app:dropDownEmployee
                                            data_model_name="dropDownDepartmentHead"
                                            placeholder="Department Head" is_for_login="true"
                                            required="false" class="kendo-drop-down"
                                            sort_by_department="true" tabindex="1"
                                            id="departmentHeadId" name="departmentHeadId"
                                            data-bind="value: service.departmentHeadId">
                                    </app:dropDownEmployee>
                                </div>

                                <div class="col-md-3 pull-left">
                                    <span class="k-invalid-msg" data-for="departmentHeadId"></span>
                                </div>
                            </div>
                    </div>

                </div>

                <div class="panel-footer">
                    <button id="create" name="create" type="submit" data-role="button"
                            class="k-button k-button-icontext"
                            role="button" tabindex="2"
                            aria-disabled="false"><span class="k-icon k-i-plus"></span>Update
                    </button>

                    <button id="clearFormButton" name="clearFormButton" type="button" data-role="button"
                            class="k-button k-button-icontext" role="button" tabindex="3"
                            aria-disabled="false" onclick='resetForm();'><span
                            class="k-icon k-i-close"></span>Cancel
                    </button>
                </div>
            </g:form>
        </div>
    </div>

    <div class="row">
        <div id="gridService"></div>
    </div>
</div>