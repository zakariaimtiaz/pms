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
                        <div class="col-md-8">
                            <div class="form-group">
                                <label class="col-md-3 control-label label-required"
                                       for="categoryId">Service Category:</label>

                                <div class="col-md-6">
                                    <app:dropDownServiceCategory
                                            class="kendo-drop-down"
                                            required="true" validationMessage="Required"
                                            id="categoryId"
                                            name="categoryId" tabindex="1"
                                            data-bind="value: service.categoryId"
                                            data_model_name="dropDownServiceCategory">
                                    </app:dropDownServiceCategory>
                                </div>

                                <div class="col-md-3 pull-left">
                                    <span class="k-invalid-msg" data-for="categoryId"></span>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="col-md-3 control-label label-required" for="name">Name:</label>

                                <div class="col-md-6">
                                    <input type="text" class="form-control" id="name" name="name"
                                           placeholder="Department Name" required validationMessage="Required"
                                           tabindex="2" data-bind="value: service.name"/>
                                </div>

                                <div class="col-md-3 pull-left">
                                    <span class="k-invalid-msg" data-for="name"></span>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-3 control-label label-required" for="shortName">Short Name:</label>

                                <div class="col-md-6">
                                    <input type="text" class="form-control" id="shortName" name="shortName"
                                           placeholder="Short Name" required validationMessage="Required" tabindex="3"
                                           data-bind="value: service.shortName"/>
                                </div>

                                <div class="col-md-3 pull-left">
                                    <span class="k-invalid-msg" data-for="shortName"></span>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-3 control-label label-optional" for="departmentHeadId">Department Head:</label>

                                <div class="col-md-6">
                                    <app:dropDownEmployee
                                            data_model_name="dropDownDepartmentHead"
                                            placeholder="Department Head" is_for_login="true"
                                            required="false" class="kendo-drop-down"
                                            sort_by_department="true" tabindex="4"
                                            id="departmentHeadId" name="departmentHeadId"
                                            data-bind="value: service.departmentHeadId">
                                    </app:dropDownEmployee>
                                </div>

                                <div class="col-md-3 pull-left">
                                    <span class="k-invalid-msg" data-for="departmentHeadId"></span>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-4">
                            <div class="form-group">
                                <label class="col-md-3 control-label label-required" for="sequence">Sequence:</label>

                                <div class="col-md-5">
                                    <input type="text" class="form-control" id="sequence" name="sequence"
                                           placeholder="Sequence" required validationMessage="Required"
                                           tabindex="5" data-bind="value: service.sequence"/>
                                </div>

                                <div class="col-md-3 pull-left">
                                    <span class="k-invalid-msg" data-for="sequence"></span>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-3 control-label label-optional"
                                       for="isDisplayble">Displayable:</label>

                                <div class="col-md-5">
                                    <g:checkBox class="form-control-static" name="isDisplayble" tabindex="6"
                                                data-bind="checked: service.isDisplayble"/>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="col-md-3 control-label label-optional"
                                       for="isInSp">SP Report:</label>

                                <div class="col-md-5">
                                    <g:checkBox class="form-control-static" name="isInSp" tabindex="7"
                                                data-bind="checked: service.isInSp"/>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="col-md-3 control-label label-optional"
                                       for="isActive">Active:</label>

                                <div class="col-md-5">
                                    <g:checkBox class="form-control-static" name="isActive" tabindex="8"
                                                data-bind="checked: service.isActive"/>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>

                <div class="panel-footer">
                    <button id="create" name="create" type="submit" data-role="button"
                            class="k-button k-button-icontext"
                            role="button" tabindex="9"
                            aria-disabled="false"><span class="k-icon k-i-plus"></span>Create
                    </button>

                    <button id="clearFormButton" name="clearFormButton" type="button" data-role="button"
                            class="k-button k-button-icontext" role="button" tabindex="10"
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