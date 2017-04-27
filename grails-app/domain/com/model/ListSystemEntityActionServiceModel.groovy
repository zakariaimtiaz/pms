package com.model

class ListSystemEntityActionServiceModel {
    public static final String MODEL_NAME = 'list_system_entity_action_service_model'

    public static final String SQL_LIST_SYSTEM_ENTITY_MODEL = """
    CREATE OR REPLACE VIEW list_system_entity_action_service_model AS
          SELECT se.id, se.version, se.name,se.type_id, stp.name AS type_name
          FROM system_entity AS se
          LEFT JOIN system_entity_type stp ON stp.id = se.type_id
          ORDER BY stp.name ASC;
    """

    long id
    long version
    long typeId
    String typeName
    String name

    static mapping = {
        cache usage: "read-only"
    }
}
