<div class="container-fluid">
    <div class="row" id="spSummaryRow">
        <div id="application_top_panel" class="panel panel-primary">
            <div class="panel-heading">
                <div class="panel-title">
                    Create Sp Summary
                </div>
            </div>

            <g:form name='spSummaryForm' id='spSummaryForm' class="form-horizontal form-widgets" role="form">
                <div class="panel-body">
                    <input type="hidden" name="id" id="id" data-bind="value: spSummary.id"/>
                    <input type="hidden" name="version" id="version" data-bind="value: spSummary.version"/>
                    <input type="hidden" name="version" id="serviceId" data-bind="value: spSummary.serviceId"/>

                    <div class="form-group">
                        <label class="col-md-1 control-label label-required" for="year">Year:</label>

                        <div class="col-md-3">
                            <input type='text' tabindex="1" required="required" onkeydown="return false;"
                                   class="kendo-date-picker" id="year" name="year"
                                   data-bind="value: spSummary.year"
                                   placeholder="Year" validationMessage="Required"/>
                        </div>

                        <div class="col-md-2 pull-left">
                            <span class="k-invalid-msg" data-for="year"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-md-1 control-label label-required" for="summary">Summary:</label>

                        <div class="col-md-9">
                            <textarea id="summary" name="summary" cols="4" rows="8"
                                      class="form-control" tabindex="2"
                                      required="required" validationMessage="Required"
                                      data-bind="value: spSummary.summary"
                                      placeholder="Summary"></textarea>
                        </div>

                        <div class="col-md-2 pull-left">
                            <span class="k-invalid-msg" data-for="summary"></span>
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
        <div id="gridPmSpSummary"></div>
    </div>
</div>