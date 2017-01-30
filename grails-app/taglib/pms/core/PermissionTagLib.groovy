package pms.core

import com.pms.SecUser
import grails.plugin.springsecurity.SpringSecurityService
import pms.BaseService

class PermissionTagLib {

    SpringSecurityService springSecurityService
    BaseService baseService
    static namespace = "sec"

    def fullName = { attrs ->
        String username = SecUser.read(springSecurityService.principal.id).fullName
        out << username
    }

    def ifAnyUrls = { attrs, body ->
        List<String> urls = attrs.remove('urls').split(',')
        Boolean hasAccess = Boolean.FALSE
        for (int i = 0; i < urls.size(); i++) {
            hasAccess = sec.access(url: urls.get(i).trim()) { Boolean.TRUE }
            if (hasAccess) {
                out << body()
                break
            }
        }
    }

    def isDashboardForUser = {attrs, body ->
        long id = SecUser.read(springSecurityService.principal.id).id
        if(!baseService.isUserSystemAdmin(id)&&!baseService.isUserTopManagement(id)){
            out << body()
        }
    }
    def isDashboardForManagement = {attrs, body ->
        long id = SecUser.read(springSecurityService.principal.id).id
        if(baseService.isUserSystemAdmin(id)||baseService.isUserTopManagement(id)){
            out << body()
        }
    }
}
