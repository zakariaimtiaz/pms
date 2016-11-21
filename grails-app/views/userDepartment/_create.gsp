<div class="container-fluid">
    <div class="row">
        <div id="application_top_panel" class="panel panel-primary">
            <div class="panel-heading">
                <div class="panel-title">
                    User-Department mapping
                </div>
            </div>

            <g:form name='userDepartmentForm' id='userDepartmentForm' class="form-horizontal form-widgets" role="form">
                <div class="panel-body">
                    <input type="hidden" name="id" id="id"/>
                    <input type="hidden" name="userId" id="userId"/>

                    <div class="form-group">
                        <label class="col-md-1 control-label label-required" for="serviceId">Department:</label>

                        <div class="col-md-3">
                            <app:dropDownService
                                    data_model_name="dropDownService"
                                    required="required"
                                    validationmessage="Required"
                                    url="${createLink(controller: 'userDepartment', action: 'reloadDropDown')}"
                                    class="kendo-drop-down"
                                    id="serviceId" name="serviceId">
                            </app:dropDownService>
                        </div>

                        <div class="col-md-2 pull-left">
                            <span class="k-invalid-msg" data-for="serviceId"></span>
                        </div>
                    </div>
                </div>

                <div class="panel-footer">
                    <button id="create" name="create" type="submit" data-role="button"
                            class="k-button k-button-icontext"
                            role="button" tabindex="2"
                            aria-disabled="false"><span class="k-icon k-i-plus"></span>Assign
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
        <div id="gridUserDepartment"></div>
    </div>
</div>