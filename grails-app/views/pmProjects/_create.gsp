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
                               for="typeId">Type:</label>

                        <div class="col-md-4">
                            <app:dropDownProjectsType
                                    class="kendo-drop-down"
                                    required="true" validationMessage="Required"
                                    id="typeId" name="typeId" tabindex="1"
                                    data-bind="value: project.typeId"
                                    data_model_name="dropDownProjectsType">
                            </app:dropDownProjectsType>
                        </div>

                        <label class="col-md-1 control-label label-required"
                               for="code">Code:</label>

                        <div class="col-md-4">
                            <input type="text" class="form-control"
                                   id="code" name="code" tabindex="5"
                                   data-bind="value: project.code"/>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col-md-1 control-label label-required"
                               for="name">Name:</label>

                        <div class="col-md-4">
                            <input type="text" class="form-control"
                                   id="name" name="name" tabindex="2"
                                   data-bind="value: project.name"/>
                        </div>

                        <label class="col-md-1 control-label label-required" for="startDate">Date:</label>

                        <div class="col-md-6">
                            <input type="text" id="startDate" name="startDate" tabindex="6"
                                   data-bind="value: project.startDate" placeholder="Start date">
                            <input type="text" id="endDate" name="endDate" tabindex="7"
                                   data-bind="value: project.endDate" placeholder="End date">
                        </div>

                    </div>

                    <div class="form-group">
                        <label class="col-md-1 control-label label-required"
                               for="shortName">Short Name:</label>

                        <div class="col-md-4">
                            <input type="text" class="form-control"
                                   id="shortName" name="shortName" tabindex="3"
                                   data-bind="value: project.shortName"/>
                        </div>

                        <label class="col-md-1 control-label label-required"
                               for="donor">Donor:</label>

                        <div class="col-md-4">
                            <input type="text" class="form-control"
                                   id="donor" name="donor" tabindex="8"
                                   data-bind="value: project.donor"/>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col-md-1 control-label" for="description">Description:</label>

                        <div class="col-md-4">
                            <textarea id="description" name="description" cols="4" rows="3"
                                      tabindex="4" class="form-control"
                                      data-bind="value: project.description"
                                      placeholder="Project description"></textarea>
                        </div>
                    </div>

                </div>

                <div class="panel-footer">
                    <button id="create" name="create" type="submit" data-role="button"
                            class="k-button k-button-icontext"
                            role="button" tabindex="9"
                            aria-disabled="false"><span class="k-icon k-i-plus"></span>Create
                    </button>

                    <button id="clearFormButton" name="clearFormButton" type="button" data-role="button"
                            class="k-button k-button-icontext" role="button" tabindex="10"
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