<div class="container-fluid">
    <div class="row">
        <div id="application_top_panel" class="panel panel-primary">
            <div class="panel-heading">
                <div class="panel-title">
                    Strategic Plan
                </div>
            </div>

            <g:form name='detailsForm' id='detailsForm' class="form-horizontal form-widgets" role="form">
                <div class="panel-body">
                    <div class="form-group">
                        <label class="col-md-1 control-label label-optional" for="from">From:</label>

                        <div class="col-md-2">
                            <input type='text' tabindex="1" required="required" onkeydown="return false;"
                                   class="kendo-date-picker" id="from" name="from"
                                   placeholder="Month" validationMessage="Required"/>
                        </div>
                        <label class="col-md-1 control-label label-optional" for="to">To:</label>

                        <div class="col-md-2">
                            <input type='text' tabindex="1" required="required" onkeydown="return false;"
                                   class="kendo-date-picker" id="to" name="to"
                                   placeholder="Month" validationMessage="Required"/>
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

                <div class="panel-footer">
                    <button id="download" name="download" type="button" data-role="button"
                            class="k-button k-button-icontext pull-right" role="button"
                            onclick="downloadDetails()"
                            aria-disabled="false"><span class="fa fa-file-pdf-o"></span> &nbsp;Download
                    </button>
                </div>
            </g:form>
        </div>
    </div>

    <div class="row">
        <table>
            <tr>
                <td>Sector/ Central Service</td>
                <td>:</td>
                <td></td>
            </tr>
        </table>
    </div>
</div>