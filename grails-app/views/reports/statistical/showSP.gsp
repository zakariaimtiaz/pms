<g:render template='/reports/statistical/scriptsSP'/>


<div class="container-fluid">
    <div class="row centered">
        <div class="panel panel-primary">
            <div class="panel-body">
                <div class="form-group">
                    <label class="col-md-1 control-label label-optional"
                           for="year">Year:</label>

                    <div class="col-md-2">
                        <input type='text' tabindex="1" required="required" onkeydown="return false;"
                               class="kendo-date-picker" id="year" name="year"
                               placeholder="Month" validationMessage="Required"/>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <div>
            <div class="demo-section k-content wide">
                <div id="chartSP"></div>
            </div>
        </div>
    </div>
</div>