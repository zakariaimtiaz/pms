<div class="container-fluid">
    <div class="row">
        <div class="panel panel-primary">
            <div class="panel-heading" style="height: 30px;">
                <div class="panel-title text-center">
                    SP Summary
                </div>
            </div>

            <div class="panel-body" style="padding: 0px;!important;height: 65px;!important;">
                <div class="form-group">
                    <label class="col-md-1 control-label label-optional pager"
                           for="serviceId">Service:</label>

                    <div class="col-md-3 pager">
                        <app:dropDownService
                                class="kendo-drop-down" is_in_sp="true" hints_text="ALL CSU/Sector"
                                id="serviceId" name="serviceId" tabindex="1" onchange="populateSummaryGrid();"
                                data_model_name="dropDownService">
                        </app:dropDownService>
                    </div>

                    <div class="col-md-5">
                        <ul class="pager">
                            <li style="cursor: pointer;"><a onclick="setPreviousYear();" style="width: 80px;">Previous</a></li>
                            <li><a><input type='text' class="kendo-date-picker" id="year" name="year"
                                          placeholder="Year" validationMessage="Required"/></a>
                            </li>
                            <li style="cursor: pointer;"><a onclick="setNextYear();" style="width: 80px;">Next</a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div id="gridSpSummary"></div>
    </div>
</div>