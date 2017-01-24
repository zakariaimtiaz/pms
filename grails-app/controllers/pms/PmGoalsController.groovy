package pms

import actions.pmGoals.CreatePmGoalsActionService
import actions.pmGoals.DeletePmGoalsActionService
import actions.pmGoals.ListPmGoalsActionService
import actions.pmGoals.UpdatePmGoalsActionService
import com.pms.PmSpLog
import com.pms.SecUser
import grails.converters.JSON
import groovy.sql.GroovyRowResult
import service.PmGoalsService

class PmGoalsController  extends BaseController {

    BaseService baseService
    PmGoalsService pmGoalsService

    static allowedMethods = [
            show: "POST", create: "POST", update: "POST",delete: "POST", list: "POST"
    ]

    CreatePmGoalsActionService createPmGoalsActionService
    UpdatePmGoalsActionService updatePmGoalsActionService
    DeletePmGoalsActionService deletePmGoalsActionService
    ListPmGoalsActionService listPmGoalsActionService



    def show() {
        SecUser user = baseService.currentUserObject()
        boolean isAdmin = baseService.isUserSystemAdmin(user.id)
        boolean isSubmitted = true
        if(!isAdmin){
            Calendar now = Calendar.getInstance();   // Gets the current date and time
            int year = now.get(Calendar.YEAR);
            isSubmitted = PmSpLog.findByServiceIdAndYear(user.serviceId, year).isSubmitted
        }
        render(view: "/pmGoals/show", model: [serviceId:user.serviceId,isAdmin: isAdmin,isSubmitted:isSubmitted])
    }
    def create() {
        renderOutput(createPmGoalsActionService, params)

    }
    def update() {
        renderOutput(updatePmGoalsActionService, params)

    }
    def delete() {
        renderOutput(deletePmGoalsActionService, params)

    }
    def list() {
        renderOutput(listPmGoalsActionService, params)
    }

    def lstGoalsByServiceId(){
        long serviceId = Long.parseLong(params.serviceId.toString())
        List<GroovyRowResult> lst = pmGoalsService.lstGoalsForDropDown(serviceId)
        List lstValue = baseService.listForKendoDropdown(lst, null, null)
        Map result = [lstGoals: lstValue]
        render result as JSON
    }
}
