package com.pms

class PmProjects {
    long id
    long version
    String name
    String shortName
    String code
    Long typeId
    String description
    Date startDate
    Date endDate
    Date createDate
    String donor
    long createBy
    boolean isActive

    static mapping = {
        createDate sqlType: 'date'
        startDate sqlType: 'date'
        endDate sqlType: 'date'
        typeId   index: 'pm_projects_type_id_idx'
    }

    static constraints = {
        description(nullable: true)
        donor(nullable: true)
        startDate(nullable: true)
        endDate(nullable: true)
        isActive(nullable: true)

    }
}
