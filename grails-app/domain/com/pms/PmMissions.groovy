package com.pms

class PmMissions {

    long id
    long version
    long serviceId
    String mission

    static mapping = {
        mission     sqlType: 'text'
    }

    static constraints = {
        mission     size: 2..15000
    }
}
