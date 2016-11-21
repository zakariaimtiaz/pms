<div class="container-fluid">
    <div class="row">
        <div id="application_top_panel" class="panel panel-primary">
            <div class="panel-heading">
                <div class="panel-title">
                    Central Service & Sector
                </div>
            </div>

            <g:form name='serviceForm' id='serviceForm' class="form-horizontal form-widgets" role="form">
                <div class="panel-body">
                    <input type="hidden" name="id" id="id" data-bind="value: service.id"/>
                    <input type="hidden" name="version" id="version" data-bind="value: service.version"/>

                    <div class="form-group">
                        <div class="col-md-7">
                            <div class="form-group">
                                <label class="col-md-3 control-label label-required"
                                       for="categoryId">Category:</label>

                                <div class="col-md-6">
                                    <app:dropDownServiceCategory
                                            class="kendo-drop-down"
                                            required="true" validationMessage="Required"
                                            id="categoryId"
                                            name="categoryId" tabindex="1"
                                            data-bind="value: service.categoryId"
                                            data_model_name="dropDownServiceCategory">
                                    </app:dropDownServiceCategory>
                                </div>

                                <div class="col-md-3 pull-left">
                                    <span class="k-invalid-msg" data-for="categoryId"></span>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="col-md-3 control-label label-required" for="name">Name:</label>

                                <div class="col-md-6">
                                    <input type="text" class="form-control" id="name" name="name"
                                           placeholder="Department Name" required validationMessage="Required"
                                           tabindex="2"
                                           data-bind="value: service.name"/>
                                </div>

                                <div class="col-md-3 pull-left">
                                    <span class="k-invalid-msg" data-for="name"></span>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-5">
                            <div class="form-group">
                                <label class="col-md-3 control-label label-required" for="shortName">Short Name:</label>

                                <div class="col-md-6">
                                    <input type="text" class="form-control" id="shortName" name="shortName"
                                           placeholder="Short Name" required validationMessage="Req" tabindex="3"
                                           data-bind="value: service.shortName"/>
                                </div>

                                <div class="col-md-3 pull-left">
                                    <span class="k-invalid-msg" data-for="shortName"></span>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-3 control-label label-required" for="sequence">Sequence:</label>

                                <div class="col-md-6">
                                    <input type="text" class="form-control" id="sequence" name="sequence"
                                           placeholder="Sequence" required validationMessage="Req"
                                           tabindex="4" data-bind="value: service.sequence"/>
                                </div>

                                <div class="col-md-3 pull-left">
                                    <span class="k-invalid-msg" data-for="sequence"></span>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>

                <div class="panel-footer">
                    <button id="create" name="create" type="submit" data-role="button"
                            class="k-button k-button-icontext"
                            role="button" tabindex="5"
                            aria-disabled="false"><span class="k-icon k-i-plus"></span>Create
                    </button>

                    <button id="clearFormButton" name="clearFormButton" type="button" data-role="button"
                            class="k-button k-button-icontext" role="button" tabindex="6"
                            aria-disabled="false" onclick='resetForm();'><span
                            class="k-icon k-i-close"></span>Cancel
                    </button>
                </div>
            </g:form>
        </div>
    </div>

    <div class="row">
        <div id="gridService"></div>
    </div>
</div>