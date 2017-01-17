package pms

import actions.reports.DownloadActionsIndicatorSPActionService
import actions.reports.DownloadAllIndicatorSPActionService
import actions.reports.ListActionsIndicatorActionService
import actions.reports.ListAllIndicatorSPActionService
import actions.reports.ListSpMonthlyPlanActionService
import actions.reports.ListSpPlanActionService
import actions.reports.yearly.DownloadYearlySPActionService
import actions.reports.yearly.ListYearlySPActionService
import com.pms.PmServiceSector
import com.pms.SecUser
import grails.converters.JSON
import groovy.sql.GroovyRowResult
import service.PmActionsService

class ReportsController  extends BaseController  {
    BaseService baseService
    PmActionsService pmActionsService
    ListSpPlanActionService listSpPlanActionService
    ListSpMonthlyPlanActionService listSpMonthlyPlanActionService
    ListAllIndicatorSPActionService listAllIndicatorSPActionService
    ListActionsIndicatorActionService listActionsIndicatorActionService
    DownloadAllIndicatorSPActionService downloadAllIndicatorSPActionService
    DownloadActionsIndicatorSPActionService downloadActionsIndicatorSPActionService

    ListYearlySPActionService listYearlySPActionService
    DownloadYearlySPActionService downloadYearlySPActionService

    static allowedMethods = [
            showSpPlan: "POST", listSpPlan: "POST"
    ]
    def showSpPlan() {
        SecUser user = baseService.currentUserObject()
        PmServiceSector service = PmServiceSector.read(user.serviceId)
        render(view: "/reports/strategicPlan/yearly/show", model: [serviceId:service.id,serviceName:service.name])
    }
    def showSpMonthlyPlan() {
        SecUser user = baseService.currentUserObject()
        render(view: "/reports/strategicPlan/monthly/show", model: [serviceId:user.serviceId])
    }
    def listSpPlan() {
        renderOutput(listSpPlanActionService,params)
    }
    def listSpMonthlyPlan() {
        renderOutput(listSpMonthlyPlanActionService,params)
    }
    def showSpStatus() {
        List<GroovyRowResult> lst = pmActionsService.lstDepartmentSpStatus()
        render(view: "/reports/statistical/show",model: [lst: lst as JSON])
    }
    def showYearlySP() {
        render(view: "/reports/strategicPlan/yearly/sp/show")
    }
    def listYearlySP() {
        renderOutput(listYearlySPActionService,params)
    }
    def downloadYearlySP() {
        Map result = (Map) getReportResponse(downloadYearlySPActionService, params).report
        renderOutputStream(result.report.toByteArray(), result.format, result.reportFileName)
    }
    def showAllIndicator() {
        List<GroovyRowResult> lst = pmActionsService.lstDepartmentSpStatus()
        render(view: "/reports/strategicPlan/allIndicator/show",model: [lst: lst as JSON])
    }
    def listAllIndicator() {
        renderOutput(listAllIndicatorSPActionService,params)
    }
    def downloadAllIndicator() {
        Map result = (Map) getReportResponse(downloadAllIndicatorSPActionService, params).report
        renderOutputStream(result.report.toByteArray(), result.format, result.reportFileName)
    }
    def showActionsIndicator() {
        List<GroovyRowResult> lst = pmActionsService.lstDepartmentSpStatus()
        render(view: "/reports/strategicPlan/actionsIndicator/show",model: [lst: lst as JSON])
    }
    def listActionsIndicator() {
        renderOutput(listActionsIndicatorActionService,params)
    }
    def downloadActionsIndicator() {
        Map result = (Map) getReportResponse(downloadActionsIndicatorSPActionService, params).report
        renderOutputStream(result.report.toByteArray(), result.format, result.reportFileName)
    }
}
