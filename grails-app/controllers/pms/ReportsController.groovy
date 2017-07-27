package pms

import actions.reports.dashboard.DownloadEdDashBoardActionService
import actions.reports.dashboard.ListEdDashBoardActionService
import actions.reports.mcrs.DownloadMCRSActionService
import actions.reports.mcrs.ListMCRSActionService
import actions.reports.monthly.DownloadMonthlySPActionService
import actions.reports.monthly.ListSpMonthlyPlanActionService
import actions.reports.spSummary.DownloadSpSummaryActionService
import actions.reports.spSummary.ListReportSpSummaryActionService
import actions.reports.yearly.DownloadYearlySPActionService
import actions.reports.yearly.DownloadYearlySPDetailsActionService
import actions.reports.yearly.ListYearlySPActionService
import com.pms.MeetingLog
import com.pms.PmMcrsLog
import com.pms.PmSapBackupLog
import com.pms.PropertiesReader
import com.pms.SecUser
import com.pms.SystemEntity
import grails.converters.JSON
import grails.plugin.springsecurity.SpringSecurityService
import groovy.sql.GroovyRowResult
import pms.utility.DateUtility
import service.MeetingLogService
import service.PmActionsService
import service.PmSpLogService

class ReportsController  extends BaseController  {

    BaseService baseService
    SpringSecurityService springSecurityService
    PmActionsService pmActionsService
    MeetingLogService meetingLogService
    PmSpLogService pmSpLogService

    ListMCRSActionService listMCRSActionService
    DownloadMCRSActionService downloadMCRSActionService

    ListSpMonthlyPlanActionService listSpMonthlyPlanActionService
    DownloadMonthlySPActionService downloadMonthlySPActionService

    ListYearlySPActionService listYearlySPActionService
    DownloadYearlySPActionService downloadYearlySPActionService
    DownloadYearlySPDetailsActionService downloadYearlySPDetailsActionService

    ListEdDashBoardActionService listEdDashBoardActionService
    DownloadEdDashBoardActionService downloadEdDashBoardActionService

    ListReportSpSummaryActionService listReportSpSummaryActionService
    DownloadSpSummaryActionService downloadSpSummaryActionService

    static allowedMethods = [
            showSpStatus: "POST", showMcrsStatus: "POST", showMcrs: "POST", showSpMonthlyPlan: "POST", showYearlySP: "POST"
    ]
    //################## Statical Status Start ###########################

    def showSpStatus() {
        render(view: "/reports/statistical/showSP")
    }
    def listSpStatus() {
        List<GroovyRowResult> lst = pmActionsService.lstDepartmentSpStatus(params.year.toString())
        render lst as JSON
    }

    def showMcrsStatus() {
        render(view: "/reports/statistical/showMcrs")
    }
    def listMcrsStatus() {
        List<GroovyRowResult> lst = pmActionsService.lstDepartmentMcrsStatus(params.year.toString())
        render lst as JSON
    }

    def showMeetingStatus() {
        def loggedUser = springSecurityService.principal
        SecUser user = SecUser.read(loggedUser.id)
        boolean isSysAdmin = baseService.isUserSystemAdmin(user.id)

        SystemEntity meetingType = SystemEntity.findByNameAndTypeId(params.type.toString(),5L)
        if(meetingType.name.equals("Quarterly")||meetingType.name.equals("Annually")){
            render(view: "/reports/meetingLog/QuarterAnnual/showMeeting", model: [isSysAdmin   : isSysAdmin, meetingTypeId: meetingType.id,
                                                                     meetingType: meetingType.name])
        }else {
            render(view: "/reports/meetingLog/showMeeting", model: [isSysAdmin   : isSysAdmin, meetingTypeId: meetingType.id,
                                                                    userServiceId: user.serviceId, meetingType: meetingType.name])
        }
    }
    def listMeetingStatus() {
        long meetingTypeId = Long.parseLong(params.meetingTypeId.toString())
        List<GroovyRowResult> lst = meetingLogService.lstDepartmentWeeklyMeetingStatus(params.year.toString(), meetingTypeId)
        render lst as JSON
    }

    //##################  Submission Status End ###########################

    //################## MCRS Start ###########################
    def showMcrs() {
        SecUser user = baseService.currentUserObject()
        List<Long> lst = baseService.currentUserDepartmentList()
        boolean isMultiDept = Boolean.FALSE
        if(lst.size() > 1){
            isMultiDept = Boolean.TRUE
        }
        boolean isSysAdmin = baseService.isUserSystemAdmin(user.id)
        boolean isTopMan = baseService.isUserTopManagement(user.id)
        boolean isHOD = baseService.isUserHOD(user.id)
        boolean isSpAdmin = baseService.isEdAdminRole(user.id)

        Long month=1
        Long year=1900
        String submissionDate=""
        def d=PmMcrsLog.executeQuery("select max(submissionDate) as submissionDate from PmMcrsLog where serviceId='${user.serviceId}'  AND isSubmitted=True ")
        if(d[0]) {
            try {
                Date subDate = DateUtility.getSqlDate(DateUtility.parseDateForDB(d[0].toString()))
                month = PmMcrsLog.findBySubmissionDateAndServiceId(subDate,user.serviceId).month+1
                year=PmMcrsLog.findBySubmissionDateAndServiceId(subDate,user.serviceId).year
                submissionDate= (month>12?(year+1):year).toString()+'-'+(month<=9 ? '0'+month:month>12?'01':month).toString()+'-'+'01'

            }catch(Exception ex){}
        }

        render(view: "/reports/mcrs/show", model: [isSysAdmin:isSysAdmin,
                                                   isTopMan: isTopMan,isHOD: isHOD,
                                                   serviceId:user.serviceId,
                                                   isSpAdmin:isSpAdmin,
                                                   isMultiDept:isMultiDept,
                                                   submissionDate:submissionDate])
    }
    def listMcrs() {
        renderOutput(listMCRSActionService,params)
    }
    def downloadMcrs() {
        Map result = (Map) getReportResponse(downloadMCRSActionService, params).report
        renderOutputStream(result.report.toByteArray(), result.format, result.reportFileName)
    }
    //##################    MCRS End ###########################

    //################## Monthly Start #########################
    def showSpMonthlyPlan() {
        SecUser user = baseService.currentUserObject()
        boolean isSysAdmin = baseService.isUserSystemAdmin(user.id)
        boolean isTopMan = baseService.isUserTopManagement(user.id)
        boolean isHOD = baseService.isUserHOD(user.id)
        boolean isSpAdmin = baseService.isEdAdminRole(user.id)

        render(view: "/reports/monthly/show", model: [isSysAdmin:isSysAdmin,
                                                      isTopMan: isTopMan,isHOD: isHOD,isSpAdmin: isSpAdmin,
                                                      serviceId:user.serviceId])
    }
    def listSpMonthlyPlan() {
        renderOutput(listSpMonthlyPlanActionService,params)
    }
    def downloadMonthlySP() {
        Map result = (Map) getReportResponse(downloadMonthlySPActionService, params).report
        renderOutputStream(result.report.toByteArray(), result.format, result.reportFileName)
    }
    //################## Monthly End ###########################

    //################## Yearly Start ##########################
    def showYearlySP() {
        SecUser user = baseService.currentUserObject()
        boolean isSysAdmin = baseService.isUserSystemAdmin(user.id)
        boolean isTopMan = baseService.isUserTopManagement(user.id)
        boolean isSpAdmin = baseService.isEdAdminRole(user.id)
        List<Long> lst = baseService.currentUserDepartmentList()
        boolean isMultiDept = Boolean.FALSE
        if(lst.size() > 1){
            isMultiDept = Boolean.TRUE
        }
        render(view: "/reports/yearly/show", model: [isSysAdmin:isSysAdmin,
                                                     isTopMan: isTopMan,
                                                     isSpAdmin: isSpAdmin,
                                                     isMultiDept:isMultiDept,
                                                     serviceId:user.serviceId])
    }
    def listYearlySP() {
        renderOutput(listYearlySPActionService,params)
    }
    def downloadYearlySP() {
        Map result = (Map) getReportResponse(downloadYearlySPActionService, params).report
        renderOutputStream(result.report.toByteArray(), result.format, result.reportFileName)
    }

    def showYearlySPDetails() {
        SecUser user = baseService.currentUserObject()
        boolean isSysAdmin = baseService.isUserSystemAdmin(user.id)
        boolean isTopMan = baseService.isUserTopManagement(user.id)
        boolean isSpAdmin = baseService.isEdAdminRole(user.id)
        List<Long> lst = baseService.currentUserDepartmentList()
        boolean isMultiDept = Boolean.FALSE
        if(lst.size() > 1){
            isMultiDept = Boolean.TRUE
        }
        render(view: "/reports/yearly/details/show", model: [isSysAdmin:isSysAdmin,
                                                     isTopMan: isTopMan,
                                                     isSpAdmin: isSpAdmin,
                                                     isMultiDept:isMultiDept,
                                                     serviceId:user.serviceId])
    }
    def listYearlySPDetails() {
        renderOutput(listYearlySPActionService,params)
    }
    def downloadYearlySPDetails() {
        Map result = (Map) getReportResponse(downloadYearlySPDetailsActionService, params).report
        renderOutputStream(result.report.toByteArray(), result.format, result.reportFileName)
    }
    //################## Yearly End ###########################

    //################## Dashboard Start ###########################
    def showEdDashBoard() {
        SecUser user = baseService.currentUserObject()
        boolean isSysAdmin = baseService.isUserSystemAdmin(user.id)
        boolean isTopMan = baseService.isUserTopManagement(user.id)
        boolean isAssist = baseService.isEdAssistantRole(user.id)
        boolean isSpAdmin = baseService.isEdAdminRole(user.id)
        List<Long> lst = baseService.currentUserDepartmentList()
        boolean isMultiDept = Boolean.FALSE
        if(lst.size() > 1){
            isMultiDept = Boolean.TRUE
        }
        render(view: "/reports/dashboard/show", model: [isSysAdmin:isSysAdmin,
                                                        isTopMan: isTopMan,
                                                        isAssist: isAssist,
                                                        isSpAdmin: isSpAdmin,
                                                        isMultiDept:isMultiDept,
                                                        serviceId:user.serviceId])
    }
    def listEdDashBoard() {
        renderOutput(listEdDashBoardActionService,params)
    }
    def downloadEdDashBoard() {
        Map result = (Map) getReportResponse(downloadEdDashBoardActionService, params).report
        renderOutputStream(result.report.toByteArray(), result.format, result.reportFileName)
    }
    //################## Dashboard End   ###########################

    //################## SP Summary ###########################
    def showSpSummary() {
        SecUser user = baseService.currentUserObject()
        boolean isSysAdmin = baseService.isUserSystemAdmin(user.id)
        boolean isTopMan = baseService.isUserTopManagement(user.id)
        boolean isSpAdmin = baseService.isEdAdminRole(user.id)
        List<Long> lst = baseService.currentUserDepartmentList()
        boolean isMultiDept = Boolean.FALSE
        if(lst.size() > 1){
            isMultiDept = Boolean.TRUE
        }
        render(view: "/reports/spSummary/show", model: [isSysAdmin:isSysAdmin,isMultiDept:isMultiDept,
                                                        isTopMan: isTopMan, isSpAdmin: isSpAdmin,
                                                        serviceId:user.serviceId])
    }
    def listSpSummary() {
        renderOutput(listReportSpSummaryActionService,params)
    }
    def downloadSpSummary() {
        Map result = (Map) getReportResponse(downloadSpSummaryActionService, params).report
        renderOutputStream(result.report.toByteArray(), result.format, result.reportFileName)
    }
    //################## Dashboard End   ###########################
    //################## SAP Backup files view #####################

    def showSapBackupView() {
        SecUser user = baseService.currentUserObject()
        boolean isSysAdmin = baseService.isUserSystemAdmin(user.id)
        boolean isTopMan = baseService.isUserTopManagement(user.id)
        boolean isAssist = baseService.isEdAssistantRole(user.id)
        boolean isSpAdmin = baseService.isEdAdminRole(user.id)
        List<Long> lst = baseService.currentUserDepartmentList()
        boolean isMultiDept = Boolean.FALSE
        if(lst.size() > 1){
            isMultiDept = Boolean.TRUE
        }
        render(view: "/reports/backupView/show", model: [isSysAdmin:isSysAdmin,
                                                        isTopMan: isTopMan,
                                                        isAssist: isAssist,
                                                        isSpAdmin: isSpAdmin,
                                                        isMultiDept:isMultiDept,
                                                        serviceId:user.serviceId])

    }
    def listSapBackupFiles() {
        long serviceId = Long.parseLong(params.serviceId.toString())
        List<GroovyRowResult> lst = pmSpLogService.findAllByYearAndServiceId(Integer.parseInt(params.year.toString()), serviceId)
        render lst as JSON
    }
    def downloadSapBackupFile() {
        String meeting_dir = PropertiesReader.getProperty("sap.backup.location", PropertiesReader.CONFIG_FILE_DB)
        long id = Long.parseLong(params.id)
        PmSapBackupLog pmSapBackupLog=PmSapBackupLog.findById(id)
        def file = new File("${meeting_dir}/${pmSapBackupLog.fileName}")
        if (file.exists())
        {
            response.setContentType("application/octet-stream") // or or image/JPEG or text/xml or whatever type the file is
            response.setHeader("Content-disposition", "attachment;filename=\"${file.name}\"")
            response.outputStream << file.bytes
        }
        else render "Error!" // appropriate error handling
    }
}
