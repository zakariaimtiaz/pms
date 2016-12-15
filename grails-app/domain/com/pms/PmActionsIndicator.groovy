package com.pms

class PmActionsIndicator {
    long id
    long version
    Long actionsId
    String indicator
    int target
    String remarks

    static constraints = {
        remarks nullable: true
    }
}
