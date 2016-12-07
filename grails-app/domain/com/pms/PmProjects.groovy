package com.pms

class PmProjects {
    long id
    long version
    String name
    String shortName
    Long typeId
    String code
    Long serviceId
    String donor
    String description
    Date startDate
    Date endDate
    Date createDate
    long createBy
    boolean inActive

    static mapping = {
        createDate sqlType: 'date'
        startDate sqlType: 'date'
        endDate sqlType: 'date'
        typeId   index: 'pm_projects_type_id_idx'
    }

    static constraints = {
        description(nullable: true)
        serviceId(nullable: true)
        donor(nullable: true)
        startDate(nullable: true)
        endDate(nullable: true)
        inActive(nullable: true)

    }
}
