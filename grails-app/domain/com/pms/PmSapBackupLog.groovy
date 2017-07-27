package com.pms

class PmSapBackupLog {
    long id
    long version
    long serviceId
    int year
    Date createDate
    String fileName

    static mapping = {
        serviceId     index: 'service_id_idx'
        createDate        sqlType: 'date'
    }

    static constraints = {
    }
}
