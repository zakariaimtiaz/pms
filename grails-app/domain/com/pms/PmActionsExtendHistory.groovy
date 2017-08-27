package com.pms

class PmActionsExtendHistory {

    long id
    long version
    long actionsId
    Date end

    static mapping = {
        actionsId index: 'actions_id_idx'
        end        sqlType: 'date'
    }

    static constraints = {
    }
}
