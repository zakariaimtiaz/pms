package com.model

class ListSecUserSecRoleActionServiceModel implements Serializable {
    public static final String SQL_LIST_USER_ROLE_MODEL = """
    SELECT sec_user_id AS user_id,CONCAT(u.employee_name,' (',u.username,')') AS username,
           s.id AS service_id,s.name AS service,sec_role_id AS role_id, role.authority,role.apps_id
    FROM sec_user_sec_role ur
         LEFT JOIN sec_user u ON u.id = ur.sec_user_id
         LEFT JOIN mis.service s ON s.id = u.service_id
         LEFT JOIN sec_role role ON role.id = ur.sec_role_id
    WHERE u.enabled = TRUE;
    """

    long appsId
    long userId
    long roleId
    long serviceId
    String username
    String service
    String authority

    static mapping = {
        datasource 'comn'
        id composite: ['roleId', 'userId']
        version false
        cache usage: "read-only"
    }
}
