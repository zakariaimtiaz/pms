package pms

import actions.meetingLog.CreateMeetingLogActionService
import actions.meetingLog.DeleteMeetingLogActionService
import actions.meetingLog.ListMeetingLogActionService
import actions.meetingLog.UpdateMeetingLogActionService
import com.pms.SecUser
import com.pms.SystemEntity
import grails.converters.JSON
import grails.plugin.springsecurity.SpringSecurityService
import groovy.sql.GroovyRowResult
import service.SecUserService


class MeetingLogController extends BaseController {

    static allowedMethods = [
            show: "POST", create: "POST", update: "POST",delete: "POST", list: "POST"
    ]

    BaseService baseService
    SpringSecurityService springSecurityService
    SecUserService secUserService
    CreateMeetingLogActionService createMeetingLogActionService
    UpdateMeetingLogActionService updateMeetingLogActionService
    DeleteMeetingLogActionService deleteMeetingLogActionService
    ListMeetingLogActionService listMeetingLogActionService



    def show() {
        def loggedUser = springSecurityService.principal
        SecUser user = SecUser.read(loggedUser.id)
        boolean isAdmin = baseService.isUserSystemAdmin(user.id)
        List<GroovyRowResult> lstEmployee = secUserService.currentDepartmentEmpList(user)
        lstEmployee.remove(0)
        long meetingTypeId = SystemEntity.findByNameAndTypeId("Weekly",5L).id
        SystemEntity meetingType = SystemEntity.findByNameAndTypeId(params.Type.toString(),5L)
        if(meetingType) meetingTypeId = meetingType.id
        render(view: "/meetingLog/show", model: [isAdmin:isAdmin,serviceId:user.serviceId,
                                                 lstEmployee: lstEmployee as JSON,meetingTypeId:meetingTypeId])
    }
    def create() {
        renderOutput(createMeetingLogActionService, params)

    }
    def update() {
        renderOutput(updateMeetingLogActionService, params)

    }
    def delete() {
        renderOutput(deleteMeetingLogActionService, params)

    }
    def list() {
        renderOutput(listMeetingLogActionService, params)
    }

}
