<div class="container-fluid">
    <div class="row" id="rowProjects">
        <div id="application_top_panel" class="panel panel-primary">
            <div class="panel-heading">
                <div class="panel-title">
                    Create Projects
                </div>
            </div>

            <g:form name='projectForm' id='projectForm' class="form-horizontal form-widgets" role="form">
                <div class="panel-body">
                    <input type="hidden" name="id" id="id" data-bind="value: project.id"/>
                    <input type="hidden" name="version" id="version" data-bind="value: project.version"/>
                    <div class="form-group">
                        <label class="col-md-1 control-label label-required"
                               for="serviceId">Service:</label>

                        <div class="col-md-3">
                            <app:dropDownService
                                    class="kendo-drop-down"
                                    required="true" validationMessage="Required"
                                    id="serviceId" name="serviceId" tabindex="1"
                                    data-bind="value: project.serviceId"
                                    data_model_name="dropDownService">
                            </app:dropDownService>
                        </div>

                        <div class="col-md-2 pull-left">
                            <span class="k-invalid-msg" data-for="serviceId"></span>
                        </div>
                        <label class="col-md-1 control-label label-required"
                               for="code">Code:</label>

                        <div class="col-md-3">
                            <input type="text" class="form-control"
                                   id="code" name="code" tabindex="2"
                                   data-bind="value: project.code"/>
                        </div>

                        <div class="col-md-2 pull-left">
                            <span class="k-invalid-msg" data-for="code"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-md-1 control-label label-required"
                               for="name">Name:</label>

                        <div class="col-md-3">
                            <input type="text" class="form-control"
                                   id="name" name="name" tabindex="3"
                                   data-bind="value: project.name"/>
                        </div>

                        <div class="col-md-2 pull-left">
                            <span class="k-invalid-msg" data-for="name"></span>
                        </div>
                        <label class="col-md-1 control-label label-required"
                               for="shortName">Short Name:</label>

                        <div class="col-md-3">
                            <input type="text" class="form-control"
                                   id="shortName" name="shortName" tabindex="4"
                                   data-bind="value: project.shortName"/>
                        </div>

                        <div class="col-md-2 pull-left">
                            <span class="k-invalid-msg" data-for="shortName"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-md-1 control-label label-required"
                               for="typeId">Type:</label>

                        <div class="col-md-3">
                            <app:dropDownProjectsType
                                    class="kendo-drop-down"
                                    required="true" validationMessage="Required"
                                    id="typeId" name="typeId" tabindex="1"
                                    data-bind="value: project.typeId"
                                    data_model_name="dropDownProjectsType">
                            </app:dropDownProjectsType>
                        </div>

                        <div class="col-md-2 pull-left">
                            <span class="k-invalid-msg" data-for="typeId"></span>
                        </div>
                        <label class="col-md-1 control-label label-required"
                               for="donor">Donor:</label>

                        <div class="col-md-3">
                            <input type="text" class="form-control"
                                   id="donor" name="donor" tabindex="4"
                                   data-bind="value: project.donor"/>
                        </div>

                        <div class="col-md-2 pull-left">
                            <span class="k-invalid-msg" data-for="donor"></span>
                        </div>
                    </div>
                <div class="form-group">
                    <label class="col-md-1 control-label label-required" for="startDate">Date:</label>

                    <div class="col-md-10">
                        <input type="text" id="startDate" name="startDate" tabindex="3"
                               data-bind="value: project.startDate" placeholder="Start date">
                        <input type="text" id="endDate" name="endDate" tabindex="4"
                               data-bind="value: project.endDate" placeholder="End date">
                    </div>
</div>

                    <div class="form-group">
                        <label class="col-md-1 control-label" for="description">Description:</label>

                        <div class="col-md-3">
                            <textarea id="description" name="description" cols="4" rows="3"
                                      tabindex="5" class="form-control"
                                      data-bind="value: project.description"
                                      placeholder="Project description" ></textarea>
                        </div>


                    </div>
                </div>

                <div class="panel-footer">
                    <button id="create" name="create" type="submit" data-role="button"
                            class="k-button k-button-icontext"
                            role="button" tabindex="6"
                            aria-disabled="false"><span class="k-icon k-i-plus"></span>Create
                    </button>

                    <button id="clearFormButton" name="clearFormButton" type="button" data-role="button"
                            class="k-button k-button-icontext" role="button" tabindex="7"
                            aria-disabled="false" onclick='resetForm();'><span
                            class="k-icon k-i-close"></span>Cancel
                    </button>
                </div>
            </g:form>
        </div>
    </div>

    <div class="row">
        <div id="gridProjects"></div>
    </div>
</div>