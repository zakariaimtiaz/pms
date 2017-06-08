<div class="container-fluid">
    <div class="row">
        <div class="panel panel-primary">
            <div class="panel-heading" style="height: 30px;">
                <div class="panel-title text-center">
                    ED's Dashboard
                </div>
            </div>

            <div class="panel-body" style="padding: 0px;!important;height: 65px;!important;">
                <div class="form-group">
                    <label class="col-md-1 control-label label-optional pager"
                           for="serviceId">Service:</label>

                    <div class="col-md-3 pager">
                        <app:dropDownService
                                class="kendo-drop-down" is_in_sp="true" hints_text="ALL CSU/Sector"
                                id="serviceId" name="serviceId" tabindex="1" onchange="populateKendoChart();"
                                data_model_name="dropDownService">
                        </app:dropDownService>
                    </div>

                    <div class="col-md-5">
                        <ul class="pager">
                            <li style="cursor: pointer;"><a onclick="setPreviousMonth();" style="width: 80px;">Previous</a></li>
                            <li><a><input type='text' class="kendo-date-picker" id="month" name="month"
                                          placeholder="Month" validationMessage="Required"/></a>
                            </li>
                            <li style="cursor: pointer;"><a onclick="setNextMonth();" style="width: 80px;">Next</a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <ul class="nav nav-tabs">
            <li><a data-toggle="tab" href="#menu1"><span id="spanHR">HR Issues (0)</span></a></li>
            <li><a data-toggle="tab" href="#menu2"><span id="spanFld">Field Issues (0)</span></a></li>
            <li><a data-toggle="tab" href="#menu3"><span id="spanGvt">Government Issues (0)</span></a></li>
            <li><a data-toggle="tab" href="#menu4"><span id="spanDnr">Donor Issues (0)</span></a></li>
            <li><a data-toggle="tab" href="#menu5"><span id="spanNP">New Project Issues (0)</span></a></li>
            <li><a data-toggle="tab" href="#menu6"><span id="spanCssp">CSU/Sector Specific Issues (0)</span></a></li>
            <li><a data-toggle="tab" href="#menu7"><span id="spanNoIssue" style="color: darkred">CSU/Sector Without Issue (0)</span></a></li>
        </ul>

        <div class="tab-content">
            <div id="menu1" class="tab-pane fade in active">
                <div class="panel-primary">
                    <div id="gridHR"></div>
                </div>
            </div>
            <div id="menu2" class="tab-pane fade in active">
                <div class="panel-primary">
                    <div id="gridField"></div>
                </div>
            </div>
            <div id="menu3" class="tab-pane fade in active">
                <div class="panel-primary">
                    <div id="gridGovt"></div>
                </div>
            </div>
            <div id="menu4" class="tab-pane fade in active">
                <div class="panel-primary">
                    <div id="gridDonor"></div>
                </div>
            </div>
            <div id="menu5" class="tab-pane fade in active">
                <div class="panel-primary">
                    <div id="gridNP"></div>
                </div>
            </div>
            <div id="menu6" class="tab-pane fade in active">
                <div class="panel-primary">
                    <div id="gridCssp"></div>
                </div>
            </div>
            <div id="menu7" class="tab-pane fade in active">
                <div class="panel-primary">
                    <div id="gridNoIssue"></div>
                </div>
            </div>
        </div>
    </div>
</div>