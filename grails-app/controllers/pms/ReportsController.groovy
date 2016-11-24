package pms

import actions.reports.ListSpMonthlyPlanActionService
import actions.reports.ListSpPlanActionService

class ReportsController  extends BaseController  {
    ListSpPlanActionService listSpPlanActionService
    ListSpMonthlyPlanActionService listSpMonthlyPlanActionService

    static allowedMethods = [
            showSpPlan: "POST", listSpPlan: "POST"
    ]
    def showSpPlan() {
        render(view: "/reports/strategicPlan/show")
    }
    def showSpMonthlyPlan() {
        render(view: "/reports/strategicPlan/monthly/show")
    }
    def listSpPlan() {
        renderOutput(listSpPlanActionService,params)
    }
    def listSpMonthlyPlan() {
        renderOutput(listSpMonthlyPlanActionService,params)
    }
}
