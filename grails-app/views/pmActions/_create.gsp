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
                    <input type="hidden" name="indicatorCount" id="indicatorCount" value="" data-bind="value: actions.totalIndicator"/>
                    <input type="hidden" name="indicatorMaxId" id="indicatorMaxId" value="" data-bind="value: actions.totalIndicator"/>
                    <input type="hidden" name="indicator" id="indicator" data-bind="value: actions.indicator"/>

                    <div class="form-group" style="display: none">
                        <label class="col-md-1 control-label label-optional"
                               for="serviceId">Sector/CSU:</label>

                        <div class="col-md-10">
                            <app:dropDownService
                                    class="kendo-drop-down" readonly="true"
                                    onchange="javascript:populateGoals();"
                                    id="serviceId" name="serviceId" tabindex="1"
                                    data-bind="value: actions.serviceId"
                                    data_model_name="dropDownService">
                            </app:dropDownService>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col-md-1 control-label label-required" for="goalId">Goals:</label>

                        <div class="col-md-10">
                            <select class="kendo-drop-down" id="goalId" name="goalId"
                                    placeholder="Select Goal"
                                    tabindex="2" data-bind="value: actions.goalId"></select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col-md-1 control-label label-required" for="actions">Actions:</label>

                        <div class="col-md-10">
                            <textarea id="actions" name="actions" cols="4" rows="3"
                                      tabindex="8" class="form-control"
                                      data-bind="value: actions.actions"
                                      placeholder="Actions" class="kendo-drop-down"></textarea>
                        </div>
                    </div>


                    <div class="form-group">
                        <label class="col-md-1 control-label label-required" for="start">Date:</label>

                        <div class="col-md-4">
                            <input type="text" id="start" name="start" tabindex="3"
                                   data-bind="value: actions.start" placeholder="Start date">
                            <input type="text" id="end" name="end" tabindex="4"
                                   data-bind="value: actions.end" placeholder="End date">
                        </div>

                        <label class="col-md-2 control-label label-required"
                               for="resPersonId">Responsible Person:</label>

                        <div class="col-md-4">
                            <app:dropDownEmployee
                                    data_model_name="dropDownEmployee"
                                    required="false" class="kendo-drop-down"
                                    sort_by_department="true" tabindex="11"
                                    id="resPersonId" name="resPersonId"
                                    data-bind="value: actions.resPersonId">
                            </app:dropDownEmployee>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col-md-1 control-label label-required">Indicator:</label>

                        <div class="col-md-10" style="padding-bottom: 0px;">
                            <table class="table table-bordered table-hover" id="tab_logic">
                                <tbody>
                                <tr id='addr1'>
                                    <td width="60%">
                                        <input type="text" name='indicator1' id="indicator1" placeholder='Indicator'
                                               class="form-control" readonly="true"/>
                                    </td>
                                    <td width="15%">
                                    <select class="form-control" id="indType1" name="indType1" onchange="resetData(1);">
                                        <option value="Dividable">Dividable</option>
                                        <option value="Repeatable">Repeatable</option>
                                    </select>
                                    </td>
                                    <td width="15%">
                                        <input type="text" onkeypress='return validateQty(event);' id='target1'
                                               name='target1' placeholder='Target' readonly="true"
                                               onfocus="getName(this.name, this.value)" class="form-control"/>
                                    </td>
                                    <td>
                                        <a class="addbtn" onclick="add_row(1)"><i class="fa fa-plus"></i></a>
                                    </td>
                                    <td>
                                        <a class="delbtn" onclick="del_row(1)"><i class="fa fa-remove"></i></a>
                                    </td>
                                </tr>
                                </tbody>
                            </table>

                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col-md-1 control-label label-optional"
                               for="sourceOfFund">Project:</label>

                        <div class="col-md-4">
                            <select id="sourceOfFund" name="sourceOfFund"
                                    tabindex="12" data-placeholder="Select ..."
                                    data-bind="value: actions.sourceOfFund">
                            </select>
                        </div>
                        <label class="col-md-2 control-label label-optional"
                               for="supportDepartment">Support Department:</label>

                        <div class="col-md-4">
                            <select id="supportDepartment" name="supportDepartment"
                                    tabindex="7" data-placeholder="Select ..."
                                    data-bind="value: actions.supportDepartment">
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col-md-1 control-label label-optional"
                               for="note">Remarks:</label>

                        <div class="col-md-10">
                            <textarea id="note" name="note" cols="4" rows="2"
                                      tabindex="8" class="form-control"
                                      data-bind="value: actions.note"
                                      placeholder="Remarks" class="kendo-drop-down"></textarea>
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

<style type="text/css">
.delbtn, .addbtn {
    -moz-user-select: none;
    border: 1px solid transparent;
    border-radius: 4px;
    cursor: pointer;
    display: inline-block;
    line-height: 1.42857;
    margin-bottom: 0;
    padding: 6px 12px;
    text-align: center;
    vertical-align: middle;
    white-space: nowrap;
    float: left;
    background-image: linear-gradient(to bottom, #fff 0px, #e0e0e0 100%);
    background-repeat: repeat-x;
    border-color: #ccc;
}
</style>