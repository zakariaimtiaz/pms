package com.pms

/**
 * Created by User on 11/21/16.
 */
class SPTimeSchedule {
    long id
    long version
    Date fromDate
    Date toDate
    String description

    static mapping = {
        fromDate     sqlType: 'Date'
        toDate     sqlType: 'Date'
    }

    static constraints = {

    }
}
