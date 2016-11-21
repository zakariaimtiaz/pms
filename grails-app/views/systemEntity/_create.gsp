<div class="container-fluid">
    <div class="row">
        <div id="application_top_panel" class="panel panel-primary">
            <div class="panel-heading">
                <div class="panel-title">
                    Create System Entity
                </div>
            </div>

            <g:form name='systemEntityForm' id='systemEntityForm' class="form-horizontal form-widgets" role="form">
                <div class="panel-body">
                    <input type="hidden" name="id" id="id" data-bind="value: systemEntity.id"/>
                    <input type="hidden" name="version" id="version" data-bind="value: systemEntity.version"/>

                    <div class="form-group">
                        <label class="col-md-1 control-label label-required" for="typeId">Type:</label>

                        <div class="col-md-3">
                            <app:dropDownSystemEntityType
                                    data_model_name="dropDownSystemEntityType"
                                    data-bind="value: systemEntity.typeId"
                                    required="true"
                                    validationmessage="Required"
                                    class="kendo-drop-down"
                                    id="typeId"
                                    name="typeId">
                            </app:dropDownSystemEntityType>
                        </div>

                        <div class="col-md-2 pull-left">
                            <span class="k-invalid-msg" data-for="typeId"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-md-1 control-label label-required" for="name">Name:</label>

                        <div class="col-md-3">
                            <input type="text" class="form-control" id="name" name="name"
                                   placeholder="System Entity Name" required validationMessage="Required" tabindex="1"
                                   data-bind="value: systemEntity.name"/>
                        </div>

                        <div class="col-md-2 pull-left">
                            <span class="k-invalid-msg" data-for="name"></span>
                        </div>
                    </div>
                </div>

                <div class="panel-footer">
                    <button id="create" name="create" type="submit" data-role="button"
                            class="k-button k-button-icontext"
                            role="button" tabindex="2"
                            aria-disabled="false"><span class="k-icon k-i-plus"></span>Create
                    </button>

                    <button id="clearFormButton" name="clearFormButton" type="button" data-role="button"
                            class="k-button k-button-icontext" role="button" tabindex="3"
                            aria-disabled="false" onclick='resetForm();'><span
                            class="k-icon k-i-close"></span>Cancel
                    </button>
                </div>
            </g:form>
        </div>
    </div>

    <div class="row">
        <div id="gridSystemEntity"></div>
    </div>
</div>