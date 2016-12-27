package com.pms

class PmActionsIndicator {
    long id
    long version
    Long actionsId
    String indicator
    String indicatorType
    int target
    String remarks
    Long unitId
    String unitStr

    static constraints = {
        remarks nullable: true
        unitId  nullable: true
        unitStr nullable: true
    }
}
