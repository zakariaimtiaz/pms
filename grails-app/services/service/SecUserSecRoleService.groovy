package service

import com.pms.SecRole
import com.pms.SecUser
import com.pms.SecUserSecRole
import grails.transaction.Transactional
import pms.BaseService

@Transactional
class SecUserSecRoleService extends BaseService{

    public SecUserSecRole read(long id) {
        return SecUserSecRole.read(id)
    }

    public SecUserSecRole findBySecRoleAndSecUser(SecUser user, SecRole role) {
        return SecUserSecRole.findBySecRoleAndSecUser(role, user)
    }
}
