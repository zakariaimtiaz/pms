<div class="container-fluid">
    <div class="row">
        <div class="panel panel-primary">
            <div class="panel-heading" style="height: 30px;">
                <div class="panel-title text-center">
                    Ed's Dashboard Summary
%{--                    <button id="downloadSP" name="downloadSP" type="button" data-role="button"
                            class="k-button k-button-icontext pull-right" role="button"
                            aria-disabled="false" onclick='downloadDashboardReport();'><span
                            class="fa fa-file-pdf-o"></span>&nbsp;Download
                    </button>--}%
                </div>
            </div>

            <div class="panel-body" style="padding: 0px;!important;height: 65px;!important;">
                    <ul class="pager">
                        <li><a onclick="setPreviousMonth();">Previous</a></li>
                        <li><a><input type='text' class="kendo-date-picker" id="month" name="month"
                                   placeholder="Month" validationMessage="Required"/></a>
                        </li>
                        <li><a onclick="setNextMonth();">Next</a></li>
                    </ul>
            </div>
        </div>
    </div>
    <div class="row">
        <ul class="nav nav-tabs">
            <li><a data-toggle="tab" href="#menu1"><span id="spanHR">HR Issue (0)</span></a></li>
            <li><a data-toggle="tab" href="#menu2"><span id="spanFld">Field Issue (0)</span></a></li>
            <li><a data-toggle="tab" href="#menu3"><span id="spanGvt">Government Issue (0)</span></a></li>
            <li><a data-toggle="tab" href="#menu4"><span id="spanDnr">Donor Issue (0)</span></a></li>
            <li><a data-toggle="tab" href="#menu5"><span id="spanNP">New Project Issue (0)</span></a></li>
            <li><a data-toggle="tab" href="#menu6"><span id="spanSP">CSU/Sector Specific Issue (0)</span></a></li>
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
                    <div id="gridSP"></div>
                </div>
            </div>
        </div>
    </div>
</div>