package com.pms

class PmActionsIndicator {
    long id
    long version
    Long actionsId
    String indicator
    String indicatorType
    boolean isPreference = false
    int target
    String remarks
    Long unitId
    String unitStr
    Integer year

    static constraints = {
        remarks nullable: true
        unitId  nullable: true
        unitStr nullable: true
        year    nullable: true
    }
    static mapping = {
        actionsId index: 'actions_id_idx'
        year      index: 'year_idx'
        remarks   sqlType: 'text'
        remarks   size: 2..15000

    }
}
