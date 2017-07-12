package com.pms

class PmServiceSector {

    long id
    long categoryId
    String name
    String shortName
    float sequence = 0.00f
    boolean isDisplayble = true
    boolean isInSp = true
    boolean isActive = true
    String staticName
    String departmentHeadId
    String departmentHead
    String departmentHeadGender
    String contactDesignation
    String contactEmail
    boolean isRestricted = false

    static constraints = {
        staticName(nullable: true)
        departmentHead(nullable: true)
        departmentHeadGender(nullable: true)
        isRestricted(nullable: true)
    }
}
