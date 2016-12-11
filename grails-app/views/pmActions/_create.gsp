<div class="container-fluid">
    <div class="row" id="rowAction">
        <div id="application_top_panel" class="panel panel-primary">
            <div class="panel-heading">
                <div class="panel-title">
                    Create Action Plan
                </div>
            </div>

            <g:form name='actionForm' id='actionForm' class="form-horizontal form-widgets" role="form">
                <div class="panel-body">
                    <input type="hidden" name="id" id="id" data-bind="value: actions.id"/>
                    <input type="hidden" name="version" id="version" data-bind="value: actions.version"/>

                    <div class="form-group">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="col-md-2 control-label label-required"
                                       for="serviceId">Service:</label>

                                <div class="col-md-10">
                                    <app:dropDownService
                                            class="kendo-drop-down"
                                            onchange="javascript:populateGoals();"
                                            id="serviceId" name="serviceId" tabindex="1"
                                            data-bind="value: actions.serviceId"
                                            data_model_name="dropDownService">
                                    </app:dropDownService>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="col-md-2 control-label label-required" for="goalId">Goals:</label>

                                <div class="col-md-10">
                                    <select class="kendo-drop-down" id="goalId" name="goalId"
                                            placeholder="Select Goal"
                                            tabindex="2" data-bind="value: actions.goalId"></select>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 control-label label-required" for="actions">Actions:</label>

                                <div class="col-md-10">
                                    <textarea id="actions" name="actions" cols="4" rows="3"
                                              tabindex="3" class="form-control"
                                              data-bind="value: actions.actions"
                                              placeholder="Actions" class="kendo-drop-down"></textarea>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 control-label label-required" style="padding-left: 0px; text-align: right;"
                                       for="resPersonId">Responsible:</label>

                                <div class="col-md-10">
                                    <app:dropDownEmployee
                                            data_model_name="dropDownEmployee"
                                            required="false" class="kendo-drop-down"
                                            sort_by_department="true" tabindex="4"
                                            id="resPersonId" name="resPersonId"
                                            data-bind="value: actions.resPersonId">
                                    </app:dropDownEmployee>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="col-md-2 control-label label-optional" style="padding-left: 0px; text-align: right;"
                                       for="sourceOfFund">Fund Source:</label>

                                <div class="col-md-10">
                                    <select id="sourceOfFund" name="sourceOfFund"
                                            tabindex="5" data-placeholder="Select Source of Fund Projects..."
                                            data-bind="value: actions.sourceOfFund">
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 control-label label-optional"
                                       for="budget">Budget:</label>

                                <div class="col-md-10">
                                   <input type="number" id="budget" name="budget" class="form-control"
                                          data-bind="value: actions.budget" tabindex="6">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 control-label label-optional"
                                       for="supportDepartment">Support:</label>

                                <div class="col-md-10">
                                    <select id="supportDepartment" name="supportDepartment"
                                            tabindex="7" data-placeholder="Select Support Department..."
                                            data-bind="value: actions.supportDepartment">
                                    </select>
                                </div>
                            </div>




                        </div>

                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="col-md-2 control-label label-required" for="start">Date:</label>

                                <div class="col-md-10">
                                    <input type="text" id="start" name="start" tabindex="8"
                                           data-bind="value: actions.start" placeholder="Start date">
                                    <input type="text" id="end" name="end" tabindex="9"
                                           data-bind="value: actions.end" placeholder="End date">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 control-label label-required">Indicator:</label>

                                <div class="col-md-10">
                                    <table class="table table-bordered table-hover" id="tab_logic">
                                        <tbody>
                                        <tr id='addr0'>
                                            <td width="80%">
                                                <input type="text" name='indicator0' placeholder='Indicator'
                                                       readonly="true"  class="form-control"/>
                                            </td>
                                            <td width="20%">
                                                <input type="text" onkeypress='validate(event)' name='target0'
                                                       placeholder='Target' onblur ="getName(this.name,this.value)"
                                                       readonly="true"  class="form-control"/>
                                                <input type="hidden" name="monthlyIndicatorId0" value=""/>
                                            </td>
                                        </tr>
                                        <tr id='addr1'></tr>
                                        </tbody>
                                    </table>
                                    <a id="add_row" class="btn btn-default pull-left">Add</a>
                                    <a id='delete_row' class="pull-right btn btn-default">Delete</a>
                                    <input type="hidden" id="rowCount" name="rowCount" value=""/>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 control-label" for="remarks">Remarks:</label>

                                <div class="col-md-10">
                                    <textarea id="remarks" name="remarks" cols="4" rows="3"
                                              tabindex="10" class="form-control"
                                              data-bind="value: actions.remarks"
                                              placeholder="Remarks" class="kendo-drop-down"></textarea>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>

                <div class="panel-footer">
                    <button id="create" name="create" type="submit" data-role="button"
                            class="k-button k-button-icontext" role="button" tabindex="14"
                            aria-disabled="false"><span class="k-icon k-i-plus"></span>Create
                    </button>

                    <button id="clearFormButton" name="clearFormButton" type="button" data-role="button"
                            class="k-button k-button-icontext" role="button" tabindex="15"
                            aria-disabled="false" onclick='resetForm();'><span
                            class="k-icon k-i-close"></span>Cancel
                    </button>
                </div>
            </g:form>
        </div>
    </div>

    <div class="row">
        <div id="gridActions"></div>
    </div>
</div>