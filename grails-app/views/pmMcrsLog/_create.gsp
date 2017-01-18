<div class="container-fluid">
    <div class="row" id="rowMcrsLog">
        <div id="application_top_panel" class="panel panel-primary">
            <div class="panel-heading">
                <div class="panel-title">
                   Management Change Report System(MCRS) Submission
                </div>
            </div>

            <g:form name='mcrsLogForm' id='mcrsLogForm' class="form-horizontal form-widgets" role="form">
                <div class="panel-body">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="col-md-2 control-label label-optional"
                                   for="serviceId">Sector/CSU:</label>

                            <div class="col-md-6">
                                <app:dropDownService
                                        class="kendo-drop-down" is_in_sp="true"
                                        required="true" validationMessage="Required"
                                        id="serviceId" name="serviceId" tabindex="1"
                                        data_model_name="dropDownService">
                                </app:dropDownService>
                            </div>

                            <div class="col-md-3 pull-left">
                                <span class="k-invalid-msg" data-for="serviceId"></span>
                            </div>
                        </div>
                        <div class="form-group"  id="divMonth">
                            <label class="col-md-2 control-label label-optional" for="month">Month:</label>

                            <div class="col-md-6">
                                <input type='text' tabindex="2" required="required" onkeydown="return false;"
                                       class="kendo-date-picker" id="month" name="month"
                                       placeholder="Year" validationMessage="Required"/>
                            </div>

                            <div class="col-md-3 pull-left">
                                <span class="k-invalid-msg" data-for="month"></span>
                            </div>
                        </div>
                        <div class="form-group" id="btnView">
                            <div class="col-md-6" align="center" >
                                <button id="view" name="view" type="button" data-role="button"
                                        class="k-button k-button-icontext" onclick="initMcrsLogGrid();"
                                        role="button" tabindex="3"
                                        aria-disabled="false"><span class="k-icon k-i-search"></span>View
                                </button>
                            </div>
                        </div>


                    </div>

                </div>

                <div class="panel-footer" id="divBtnCreate">
                    <button id="create" name="create" type="submit" data-role="button"
                            class="k-button k-button-icontext" role="button" tabindex="7"
                            aria-disabled="false"><span class="k-icon k-i-plus"></span>Submit
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
        <div id="gridMcrsSubmission"></div>
    </div>
</div>