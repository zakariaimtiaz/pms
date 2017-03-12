package com.model

class ListAppMailActionServiceModel {

    public static final String MODEL_NAME = 'list_app_mail_action_service_model'
    public static final String SQL_LIST_APP_MAIL_MODEL = """
    CREATE OR REPLACE VIEW list_app_mail_action_service_model AS
          SELECT id, version,subject, body,transaction_code, is_manual_send,controller_name, action_name,
          is_required_role_ids,role_ids,is_required_recipients,recipients,is_active
          FROM app_mail;
    """

    long id
    long version
    String subject
    String body
    String transactionCode
    boolean isManualSend
    String controllerName
    String actionName
    boolean isRequiredRoleIds
    String roleIds
    boolean isRequiredRecipients
    String recipients
    boolean isActive

    static mapping = {
        cache usage: "read-only"
    }
}
