package com.pms

class Quartz {

    long id
    long version
    String triggerName
    String jobName
    String description
    String cronExpression
    boolean isActive
    boolean isRunning

    static mapping = {
        description sqlType: 'text'
    }

    static constraints = {
        description(nullable: true)
    }
}
