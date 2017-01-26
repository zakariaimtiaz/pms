package com.model

class ListHrUserActionServiceModel {

    public static final String MODEL_NAME = 'list_hr_user_action_service_model'
    public static final String SQL_LIST_HR_USER_MODEL = """
    DROP TABLE IF EXISTS list_hr_user_action_service_model;

    CREATE OR REPLACE VIEW list_hr_user_action_service_model AS
        SELECT u.id,u.username AS login_id,u.employee_name,u.password,s.static_name AS service
             FROM `mis`.sec_user u
        LEFT JOIN `mis`.employee e ON e.employee_id = u.employee_id
        LEFT JOIN `mis`.service s ON e.service_id = s.id
        WHERE e.employee_status_id = 1
        ORDER BY s.id;
    """

    long id
    long version
    String login_id
    String employee_name
    String password
    String service

    static mapping = {
        datasource 'dataSource_mis'
        cache usage: "read-only"
    }
}
