package pms

import actions.edDashboard.CreateEdDashboardActionService
import actions.edDashboard.ListEdDashboardActionService
import actions.edDashboard.UpdateEdDashboardActionService
import actions.pmMissions.CreatePmMissionsActionService
import actions.pmMissions.DeletePmMissionsActionService
import actions.pmMissions.ListPmMissionsActionService
import actions.pmMissions.UpdatePmMissionsActionService
import com.pms.PmSpLog
import com.pms.SecUser
import grails.converters.JSON
import groovy.sql.GroovyRowResult

class EdDashboardController extends BaseController {


    static allowedMethods = [
            show: "POST", create: "POST", update: "POST",delete: "POST", list: "POST"
    ]

    BaseService baseService
    CreateEdDashboardActionService createEdDashboardActionService
    UpdateEdDashboardActionService updateEdDashboardActionService
    ListEdDashboardActionService listEdDashboardActionService

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

        long goalId = Long.parseLong(params.goalId.toString())
        List<GroovyRowResult> lst = pmActionsService.lstActionsForDropDown(goalId)
        List lstValue = baseService.listForKendoDropdown(lst, null, null)
        Map result = [lstActions: lstValue]
        render result as JSON
    }
}
