package com.pms

class PmSprints {
    long id
    long version
    long serviceId
    long goalId
    long actionsId
    String sequence
    int tmpSeq
    String sprints
    String target
    long resPersonId
    String resPerson
    String supportDepartment
    String remarks
    Date startDate
    Date endDate
    int weight
    Date createDate
    long createBy

    static mapping = {
        sprints    sqlType: 'text'
        startDate      sqlType: 'date'
        endDate       sqlType: 'date'
        createDate sqlType: 'date'
        serviceId   index: 'sprints_service_id_idx'
        goalId   index: 'sprints_goal_id_idx'
        actionsId   index: 'sprints_actions_id_idx'
    }

    static constraints = {
        sprints     size: 2..15000
        target(nullable: true)
        resPerson(nullable: true)
        supportDepartment(nullable: true)
        remarks(nullable: true)
        resPersonId (nullable: true)
    }
}
