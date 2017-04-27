package com.model

class ListHrUserActionServiceModel {

    public static final String SQL_LIST_HR_USER_MODEL = """
    SELECT u.id,u.username AS login_id,e.employee_id,u.employee_name,deg.name designation,
    IF(gen.name='Female','Apa','Bhai') gender_str,e.official_email,u.password,s.static_name AS service
             FROM `mis`.sec_user u
        LEFT JOIN `mis`.employee e ON e.employee_id = u.employee_id
        LEFT JOIN `mis`.system_entity deg ON deg.id = e.designation_id AND deg.type_id = 1
        LEFT JOIN `mis`.system_entity gen ON gen.id = e.gender_id AND gen.type_id = 2
        LEFT JOIN `mis`.service s ON e.service_id = s.id
        WHERE e.employee_status_id = 1
        ORDER BY s.id;
    """

    long id
    long version
    String login_id
    String employee_id
    String employee_name
    String designation
    String gender_str
    String official_email
    String password
    String service

    static mapping = {
        datasource 'mis'
        cache usage: "read-only"
    }
}
