<div class="container-fluid">
    <div class="row" id="rowMcrsLog">
        <div id="application_top_panel" class="panel panel-primary">
            <div class="panel-heading">
                <div class="panel-title">
                    Create MCRS Log
                </div>
            </div>

            <g:form name='mcrsLogForm' id='mcrsLogForm' class="form-horizontal form-widgets" role="form">
                <div class="panel-body">
                    <input type="hidden" name="id" id="id" data-bind="value: mcrsLog.id"/>
                    <input type="hidden" name="version" id="version" data-bind="value: mcrsLog.version"/>

                    <div class="form-group">
                        <label class="col-md-1 control-label label-optional"
                               for="serviceId">Sector/CSU:</label>

                        <div class="col-md-3">
                            <app:dropDownService
                                    class="kendo-drop-down" onchange="populateGrid();"
                                    required="true" validationMessage="Required"
                                    id="serviceId" name="serviceId" tabindex="1"
                                    data-bind="value: mcrsLog.serviceId"
                                    data_model_name="dropDownService">
                            </app:dropDownService>
                        </div>
                        <label class="col-md-1 control-label label-optional" for="month">Month:</label>

                        <div class="col-md-2">
                            <input type='text' tabindex="2" required="required" onkeydown="return false;"
                                   class="kendo-date-picker" id="month" name="month"
                                   placeholder="Month" validationMessage="Required"/>
                        </div>
                        <label class="col-md-1 control-label label-optional"
                               for="isSubmitted">Submitted:</label>

                        <div class="col-md-1">

                            <g:checkBox class="form-control-static" id="isSubmitted" name="isSubmitted" tabindex="3"
                                        data-bind="checked: mcrsLog.isSubmitted" onchange="checkSubmitted();"/>
                        </div>
                        <label class="col-md-1 control-label label-optional"
                               for="isEditable">Editable:</label>

                        <div class="col-md-1">
                            <g:checkBox class="form-control-static" id="isEditable" name="isEditable" tabindex="4"
                                        onchange="checkEditable();" data-bind="checked: mcrsLog.isEditable"/>
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
                            aria-disabled="false" onclick='emptyForm();'><span
                            class="k-icon k-i-close"></span>Cancel
                    </button>
                    <div class="col-md-2 pull-right">
                        <input type="text" id="year" name="year">
                    </div>
                </div>
            </g:form>
        </div>
    </div>

    <div class="row">
        <div id="gridMcrsLog"></div>
    </div>
</div>