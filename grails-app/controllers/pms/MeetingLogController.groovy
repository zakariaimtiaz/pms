package pms

import actions.meetingLog.CreateMeetingLogActionService
import actions.meetingLog.DeleteMeetingLogActionService
import actions.meetingLog.ListMeetingLogActionService
import actions.meetingLog.UpdateMeetingLogActionService
import actions.meetingLog.UploadMeetingLogActionService
import com.pms.*
import grails.converters.JSON
import grails.plugin.springsecurity.SpringSecurityService
import groovy.sql.GroovyRowResult
import service.MeetingLogService
import service.SecUserService

class MeetingLogController extends BaseController {

    private static final String MEETING_TYPE = "Meeting Type"

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
    UploadMeetingLogActionService uploadMeetingLogActionService


    def show() {
        def loggedUser = springSecurityService.principal
        SecUser user = SecUser.read(loggedUser.id)
        PmServiceSector service = PmServiceSector.read(user.serviceId)
        boolean isAdmin = baseService.isUserSystemAdmin(user.id)
        SystemEntityType type = SystemEntityType.findByName(MEETING_TYPE)
        SystemEntity meetingType = SystemEntity.findByNameAndTypeId(params.type.toString(),type.id)
        List<GroovyRowResult> lstEmployeeDO
        List<GroovyRowResult> lstEmployee
        if(meetingType.name.equals("Monthly")){
            lstEmployeeDO = secUserService.currentDepartmentEmpListForMeeting(user,"MonthlyDO")
            lstEmployeeDO.remove(0)
            lstEmployee = secUserService.currentDepartmentEmpListForMeeting(user,"Monthly")
        }
        else{
            lstEmployee = secUserService.currentDepartmentEmpList(user)
        }
        lstEmployee.remove(0)
        render(view: "/meetingLog/show", model: [isAdmin:isAdmin,
                                                 serviceId:user.serviceId,
                                                 categoryId:service.categoryId,
                                                 lstEmployee: lstEmployee as JSON,
                                                 lstEmployeeDO: lstEmployeeDO as JSON,
                                                 meetingTypeId:meetingType.id,
                                                 meetingType: meetingType.name])
    }
    def showFunctional() {
        def loggedUser = springSecurityService.principal
        SecUser user = SecUser.read(loggedUser.id)
        PmServiceSector service = PmServiceSector.read(user.serviceId)
        boolean isAdmin = baseService.isUserSystemAdmin(user.id)
        List<GroovyRowResult> lstEmployee = secUserService.empListForFunctionalMeeting()
        lstEmployee.remove(0)
        List<GroovyRowResult> lstEmployeeDO
        SystemEntityType type = SystemEntityType.findByName(MEETING_TYPE)
        SystemEntity meetingType = SystemEntity.findByNameAndTypeId(params.type.toString(),type.id)
        render(view: "/meetingLog/show", model: [isAdmin:isAdmin,
                                                 serviceId:user.serviceId,
                                                 categoryId:service.categoryId,
                                                 lstEmployee: lstEmployee as JSON,
                                                 lstEmployeeDO: lstEmployeeDO as JSON,
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
    def uploadMeetingLog() {
        renderOutput(uploadMeetingLogActionService, params)
    }
    def list() {
        renderOutput(listMeetingLogActionService, params)
    }
    def detailsLog(){
        long id = Long.parseLong(params.id.toString())
        long meetingTypeId = Long.parseLong(params.meetingTypeId.toString())
        SystemEntity meetingType = SystemEntity.read(meetingTypeId)
        List<GroovyRowResult> resultSet = meetingLogService.meetingDetails(id)
        render(view: "/reports/meetingLog/showMeetingDetails", model: [resultSet:resultSet[0],meetingType: meetingType.name])
    }
    def showQuarterAnnual() {
        def loggedUser = springSecurityService.principal
        SecUser user = SecUser.read(loggedUser.id)
        long serviceId= baseService.serviceIdByRole()
        boolean isAdmin = baseService.isUserSystemAdmin(user.id)
        SystemEntityType type = SystemEntityType.findByName(MEETING_TYPE)
        SystemEntity meetingType = SystemEntity.findByNameAndTypeId(params.type.toString(),type.id)
        render(view: "/meetingLog/quarterAnnual/show", model: [isAdmin:isAdmin,
                                                 serviceId:serviceId,
                                                 meetingTypeId:meetingType.id,
                                                 meetingType: meetingType.name])
    }
    def downloadFile() {
        String meeting_dir = PropertiesReader.getProperty("meeting.log.location", PropertiesReader.CONFIG_FILE_DB)
       long id = Long.parseLong(params.id)
        MeetingLog meetingLog=MeetingLog.findById(id)
        def file = new File("${meeting_dir}/${meetingLog.fileName}")
        if (file.exists())
        {
            response.setContentType("application/octet-stream") // or or image/JPEG or text/xml or whatever type the file is
            response.setHeader("Content-disposition", "attachment;filename=\"${file.name}\"")
            response.outputStream << file.bytes
        }
        else render "Error!" // appropriate error handling
    }

}
