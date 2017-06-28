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
import pms.utility.DateUtility
import service.MeetingLogService
import service.SecUserService

import java.text.SimpleDateFormat


class MeetingLogController extends BaseController {

    static allowedMethods = [
            show: "POST", create: "POST", update: "POST",delete: "POST", list: "POST"
    ]

    BaseService baseService
    SpringSecurityService springSecurityService
    SecUserService secUserService
    MeetingLogService meetingLogService
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
        SystemEntity meetingType = SystemEntity.findByNameAndTypeId(params.type.toString(),5L)
        render(view: "/meetingLog/show", model: [isAdmin:isAdmin,
                                                 serviceId:user.serviceId,
                                                 lstEmployee: lstEmployee as JSON,
                                                 meetingTypeId:meetingType.id,
                                                 meetingType: meetingType.name])
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
    def detailsLog(){
        long serviceId = Long.parseLong(params.serviceId.toString())
        long meetingTypeId = Long.parseLong(params.meetingTypeId.toString())
        SystemEntity meetingType = SystemEntity.read(meetingTypeId)
        SimpleDateFormat simpleDF = new SimpleDateFormat("dd-MMM-yy")
        Date heldOn = simpleDF.parse(params.heldOn.toString());
        List<GroovyRowResult> resultSet = meetingLogService.dateWiseMeetingDetails(meetingTypeId,serviceId, DateUtility.getSqlDate(heldOn))
        render(view: "/reports/statistical/showMeetingDetails", model: [resultSet:resultSet[0],meetingType: meetingType.name])
    }

}
