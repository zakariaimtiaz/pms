<div class="container-fluid">
    <div class="row" id="rowMailTmpl">
        <div id="application_top_panel" class="panel panel-primary">
            <div class="panel-heading">
                <div class="panel-title">
                    App Mail Template
                </div>
            </div>

            <form id="appMailForm" name='appMailForm' class="form-horizontal form-widgets" role="form">
                <div class="panel-body">
                    <input type="hidden" id="id" name="id" data-bind="value: appMail.id"/>
                    <input type="hidden" id="version" name="version" data-bind="value: appMail.version"/>

                    <div class="form-group">
                        <div class="col-md-8">
                            <div class="form-group">
                                <label class="col-md-2 control-label label-optional"
                                       for="transactionCode">Trans. Code:</label>

                                <div class="col-md-8">
                                    <input type="text" class="form-control" id="transactionCode" name="transactionCode"
                                           tabindex="1" data-bind="value: appMail.transactionCode"
                                           placeholder="Mail template Name"/>
                                </div>

                                <div class="col-md-2 pull-left">
                                    <span class="k-invalid-msg" data-for="transactionCode"></span>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 control-label label-optional" for="roleIds">Role(s):</label>

                                <div class="col-md-8">
                                    <input type="text" class="form-control" id="roleIds" name="roleIds" tabindex="1"
                                           maxlength="255" data-bind="value: appMail.roleIds"
                                           placeholder="Comma separated Role ID(s)"/>
                                </div>

                            </div>

                            <div class="form-group">
                                <label class="col-md-2 control-label label-optional"
                                       for="recipients">Recipient(s):</label>

                                <div class="col-md-8">
                                    <input type="text" class="form-control" id="recipients" name="recipients" tabindex="2"
                                           data-bind="value: appMail.recipients"
                                           placeholder="Comma separated valid email id" maxlength="255"/>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-2 control-label label-required" for="subject">Subject:</label>

                                <div class="col-md-8">
                                    <input type="text" class="form-control" id="subject" name="subject" tabindex="5"
                                           maxlength="255" data-bind="value: appMail.subject"
                                           placeholder="Mail Subject" required validationMessage="Req"/>
                                </div>

                                <div class="col-md-2 pull-left">
                                    <span class="k-invalid-msg" data-for="subject"></span>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="col-md-2 control-label label-required" for="body">Body:</label>

                                <div class="col-md-8">
                                    <textarea type="text" class="form-control" id="body" name="body" rows="5"
                                              maxlength="2040" data-bind="value: appMail.body"
                                              placeholder="Body part of mail..." required="" tabindex="6"
                                              validationMessage="Req"></textarea>
                                </div>

                                <div class="col-md-2 pull-left">
                                    <span class="k-invalid-msg" data-for="body"></span>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-4">
                            <div class="form-group">
                                <label class="col-md-6 control-label label-optional"
                                       for="isActive">Is Active:</label>

                                <div class="col-md-3">
                                    <g:checkBox class="form-control-static" name="isActive" tabindex="5"
                                                data-bind="checked: appMail.isActive"/>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="col-md-6 control-label label-optional"
                                       for="isManualSend">Is Manual:</label>

                                <div class="col-md-3">
                                    <g:checkBox class="form-control-static" name="isManualSend" tabindex="6"
                                                data-bind="checked: appMail.isManualSend"/>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="col-md-6 control-label label-optional"
                                       for="isRequiredRoleIds">Is Req Role IDs:</label>

                                <div class="col-md-3">
                                    <g:checkBox class="form-control-static" name="isRequiredRoleIds" tabindex="7"
                                                data-bind="checked: appMail.isRequiredRoleIds"/>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-md-6 control-label label-optional"
                                       for="isRequiredRecipients">Is Req Recipients:</label>

                                <div class="col-md-3">
                                    <g:checkBox class="form-control-static" name="isRequiredRecipients" tabindex="7"
                                                data-bind="checked: appMail.isRequiredRecipients"/>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="panel-footer">

                    <button id="create" name="create" type="submit" data-role="button"
                            class="k-button k-button-icontext" role="button" tabindex="7"
                            aria-disabled="false"><span class="k-icon k-i-plus"></span>Create
                    </button>

                    <button id="clearFormButton" name="clearFormButton" type="button" data-role="button"
                            class="k-button k-button-icontext" role="button" tabindex="8"
                            aria-disabled="false" onclick='resetForm();'><span class="k-icon k-i-close"></span>Cancel
                    </button>

                </div>
            </form>
        </div>
    </div>

    <div class="row">
        <div id="gridAppMail"></div>
    </div>
</div>



