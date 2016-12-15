package pms

import actions.reports.ListSpMonthlyPlanActionService
import actions.reports.ListSpPlanActionService
import com.pms.SecUser
import grails.converters.JSON

class ReportsController  extends BaseController  {
    BaseService baseService
    ListSpPlanActionService listSpPlanActionService
    ListSpMonthlyPlanActionService listSpMonthlyPlanActionService

    static allowedMethods = [
            showSpPlan: "POST", listSpPlan: "POST"
    ]
    def showSpPlan() {
        SecUser user = baseService.currentUserObject()
        render(view: "/reports/strategicPlan/yearly/show", model: [serviceId:user.serviceId])
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
}
