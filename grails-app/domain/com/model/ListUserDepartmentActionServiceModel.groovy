package com.model

class ListUserDepartmentActionServiceModel {

    public static final String MODEL_NAME = 'list_user_department_action_service_model'

    public static final String SQL_LIST_USER_DEPARTMENT_MODEL = """
        CREATE VIEW list_user_department_action_service_model AS
        SELECT ud.id, ud.version, s.id AS service_id,s.name AS service_name, s.short_name AS service_short_name,
             s.sequence AS sequence,u.id AS user_id
                FROM user_department ud
        LEFT JOIN pm_service_sector s ON s.id = ud.service_id
        LEFT JOIN sec_user u ON u.id = ud.user_id
        ORDER BY s.sequence ASC;
    """

    long id
    long version
    long serviceId
    long userId
    String serviceName
    String serviceShortName
    float sequence

    static constraints = {
    }
}
