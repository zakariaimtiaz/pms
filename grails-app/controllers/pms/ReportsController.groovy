package pms

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
}
