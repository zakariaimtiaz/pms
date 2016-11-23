
package com.pms

class SpTimeSchedule {

    long id
    long version
    Date fromDate
    Date toDate
    String description

    static mapping = {
        fromDate     sqlType: 'date'
        toDate     sqlType: 'date'
    }

    static constraints = {

    }
}