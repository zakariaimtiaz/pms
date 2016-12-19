
package com.pms

class SpTimeSchedule {

    long id
    long version
    Date fromDate
    Date toDate
    String activeYear
    String description
    boolean isActive

    static mapping = {
        fromDate   sqlType: 'date'
        toDate     sqlType: 'date'
    }

    static constraints = {
        description nullable: true
    }
}