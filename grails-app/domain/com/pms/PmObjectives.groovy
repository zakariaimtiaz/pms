package com.pms

class PmObjectives {

    long id
    long version
    long serviceId
    long goalId
    String objective
    float sequence
    int tmpSeq
    int weight

    static mapping = {
        objective     sqlType: 'text'
    }

    static constraints = {
        objective     size: 2..15000
    }
}
