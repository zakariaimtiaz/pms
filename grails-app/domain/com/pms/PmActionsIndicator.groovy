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
    Boolean isExtend = Boolean.FALSE
    String closingNote
    Date closingMonth

    static constraints = {
        remarks nullable: true
        unitId  nullable: true
        unitStr nullable: true
        year    nullable: true
        closingNote    nullable: true
        closingMonth    nullable: true
        isExtend    nullable: true
    }
    static mapping = {
        actionsId index: 'actions_id_idx'
        year      index: 'year_idx'
        remarks   sqlType: 'text'
        remarks   size: 2..15000
        closingMonth      sqlType: 'date'

    }
}
