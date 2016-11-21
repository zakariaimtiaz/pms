package com.pms

class Theme {

    long id             // primary key (Auto generated by its own sequence)
    long version        // entity version in the persistence layer
    String name         // Unique name
    String value        // value of Theme
    String description  // description of the theme
    long moduleId = 1L  // theme belongs to which module (default 1(All))

    static constraints = {
        name(nullable: false)
        value(nullable: false, maxSize: 15359)
        description(nullable: true, maxSize: 1000)
    }

    static mapping = {
    }
}
