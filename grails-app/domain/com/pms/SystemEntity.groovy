package com.pms

class SystemEntity {
    long id
    long version
    long typeId
    String name

    static constraints = {
    }

    static mapping = {
        typeId   index: 'system_entity_system_entity_type_id_idx'
    }
}
