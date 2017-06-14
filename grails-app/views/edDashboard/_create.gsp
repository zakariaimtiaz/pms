<div class="container-fluid">
    <div class="row" id="rowEdDashboard">
        <div id="application_top_panel" class="panel panel-primary">
            <div class="panel-heading">
                <div class="panel-title">
                    ED's Dashboard
                </div>
            </div>

            <g:form name='edDashboardForm' id='edDashboardForm' class="form-horizontal form-widgets" role="form">
                <div class="panel-body">
                    <div class="form-group">
                        <input type="hidden" id="hfSubmissionDate" name="hfSubmissionDate" value=""/>
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

                        <div class="col-md-2">
                            <button id="view" name="view" type="button" data-role="button"
                                    class="k-button k-button-icontext" onclick="loadData();"
                                    role="button" tabindex="3"
                                    aria-disabled="false"><span class="k-icon k-i-search"></span>View
                            </button>
                        </div>
                    </div>
                </div>
            </g:form>
        </div>
    </div>

    <div class="row">
        <ul class="nav nav-tabs">
            <li><a data-toggle="tab" href="#menu1"><span id="spanHR">Current Issues</span></a></li>
            <li><a data-toggle="tab" href="#menu2"><span id="spanFld">Resolved Issues</span></a></li>
            <li><a data-toggle="tab" href="#menu3"><span id="spanGvt">Upcoming Issues</span></a></li>
        </ul>

        <div class="tab-content">
            <div id="menu1" class="tab-pane fade in active">
                <div class="panel-primary">
                    <div class="panel-body">
                        <div class="row">
                            <div id="gridIssues"></div>

                            <div class="form-group" id="tableData">
                                &nbsp;
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div id="menu2" class="tab-pane fade in active">
                <div class="panel-primary">
                    <div id="gridResolvedIssues"></div>
                </div>
            </div>

            <div id="menu3" class="tab-pane fade in active">
                <div class="panel-primary">
                    <div id="gridUpcomingIssues"></div>
                </div>
            </div>
        </div>
    </div>
</div>