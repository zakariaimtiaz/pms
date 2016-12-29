package com.pms

class PmServiceSector {

    long id
    long categoryId
    String name
    String shortName
    float sequence = 0.00f
    boolean isDisplayble = true
    boolean isInSp = true
    String staticName
    String departmentHead

    static constraints = {
        staticName(nullable: true)
        departmentHead(nullable: true)
    }
}
