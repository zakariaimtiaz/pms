package pms

import actions.reports.DownloadCompiledSPActionService
import actions.reports.ListActionsIndicatorActionService
import actions.reports.ListCompiledSPActionService
import actions.reports.ListSpMonthlyPlanActionService
import actions.reports.ListSpPlanActionService
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
    ListCompiledSPActionService listCompiledSPActionService
    ListActionsIndicatorActionService listActionsIndicatorActionService
    DownloadCompiledSPActionService downloadCompiledSPActionService

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
    def showCompiledSP() {
        List<GroovyRowResult> lst = pmActionsService.lstDepartmentSpStatus()
        render(view: "/reports/strategicPlan/allIndicator/show",model: [lst: lst as JSON])
    }
    def listCompiledSP() {
        renderOutput(listCompiledSPActionService,params)
    }
    def downloadCompiledSP() {
        Map result = (Map) getReportResponse(downloadCompiledSPActionService, params).report
        renderOutputStream(result.report.toByteArray(), result.format, result.reportFileName)
    }
    def showActionsIndicator() {
        List<GroovyRowResult> lst = pmActionsService.lstDepartmentSpStatus()
        render(view: "/reports/strategicPlan/actionsIndicator/show",model: [lst: lst as JSON])
    }
    def listActionsIndicator() {
        renderOutput(listActionsIndicatorActionService,params)
    }
}
