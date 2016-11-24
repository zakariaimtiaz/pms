<div class="container-fluid">
    <div class="row" id="rowGoals">
        <div id="application_top_panel" class="panel panel-primary">
            <div class="panel-heading">
                <div class="panel-title">
                    Yearly Strategic Plan
                </div>
            </div>

            <g:form name='detailsForm' id='detailsForm' class="form-horizontal form-widgets" role="form">
                <div class="panel-body">
                    <div class="form-group">
                        <label class="col-md-1 control-label label-optional" for="year">Year:</label>

                        <div class="col-md-2">
                            <input type='text' tabindex="1" required="required" onkeydown="return false;"
                                   class="kendo-date-picker" id="year" name="year"
                                   placeholder="Year" validationMessage="Required"/>
                        </div>
                        <label class="col-md-1 control-label label-optional"
                               for="serviceId">Service:</label>

                        <div class="col-md-3">
                            <app:dropDownService
                                    class="kendo-drop-down"
                                    id="serviceId" name="serviceId" tabindex="2"
                                    data_model_name="dropDownService">
                            </app:dropDownService>
                        </div>
                        <div class="col-md-2">
                            <button id="create" name="create" type="submit" data-role="button"
                                    class="k-button k-button-icontext"
                                    role="button" tabindex="3"
                                    aria-disabled="false"><span class="k-icon k-i-search"></span>View Result
                            </button>
                        </div>

                    </div>
                </div>
                <div class="panel-footer" style="height: 33px;">
                    <button id="clearFormButton" name="clearFormButton" type="button" data-role="button"
                            class="k-button k-button-icontext pull-right" role="button" tabindex="4"
                            aria-disabled="false" onclick='downloadDetails();'><span
                            class="fa fa-file-pdf-o"></span>&nbsp;Download
                    </button>
                </div>
            </g:form>
        </div>
    </div>

    <div class="row">
        <g:render template='/reports/strategicPlan/yearly/tempSP'/>
    </div>
</div>