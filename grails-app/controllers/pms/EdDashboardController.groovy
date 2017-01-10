package pms

import actions.edDashboard.CreateEdDashboardActionService
import actions.edDashboard.UpdateEdDashboardActionService
import com.pms.PmSpLog
import com.pms.SecUser
import grails.converters.JSON
import groovy.sql.GroovyRowResult
import service.EdDashboardService

class EdDashboardController extends BaseController {


    static allowedMethods = [
            show: "POST", create: "POST", update: "POST",delete: "POST", list: "POST"
    ]

    BaseService baseService
    EdDashboardService edDashboardService
    CreateEdDashboardActionService createEdDashboardActionService
    UpdateEdDashboardActionService updateEdDashboardActionService

    def show() {
        SecUser user = baseService.currentUserObject()
        Calendar now = Calendar.getInstance();   // Gets the current date and time
        int year = now.get(Calendar.YEAR);
        boolean isSubmitted = PmSpLog.findByServiceIdAndYear(user.serviceId, year).isSubmitted
        render(view: "/pmMissions/show", model: [serviceId: user.serviceId,isSubmitted:isSubmitted])
    }
    def create() {
        renderOutput(createEdDashboardActionService, params)

    }
    def update() {
        renderOutput(updateEdDashboardActionService, params)

    }

    def list() {
        SecUser user = baseService.currentUserObject()
        List<GroovyRowResult> lst = edDashboardService.lstEdDashboardIssue(user.serviceId)
        List lstValue = baseService.listForKendoDropdown(lst, null, null)
        Map result = [list: lstValue]
        render result as JSON
    }
}
