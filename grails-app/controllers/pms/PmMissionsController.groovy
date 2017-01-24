package pms

import actions.pmMissions.CreatePmMissionsActionService
import actions.pmMissions.DeletePmMissionsActionService
import actions.pmMissions.ListPmMissionsActionService
import actions.pmMissions.UpdatePmMissionsActionService
import com.pms.PmMissions
import com.pms.PmSpLog
import com.pms.SecUser
import grails.converters.JSON

class PmMissionsController  extends BaseController {

    static allowedMethods = [
            show: "POST", create: "POST", update: "POST",delete: "POST", list: "POST"
    ]

    BaseService baseService
    CreatePmMissionsActionService createPmMissionsActionService
    UpdatePmMissionsActionService updatePmMissionsActionService
    DeletePmMissionsActionService deletePmMissionsActionService
    ListPmMissionsActionService listPmMissionsActionService

    def show() {
        SecUser user = baseService.currentUserObject()
        boolean isAdmin = baseService.isUserSystemAdmin(user.id)
        boolean isSubmitted = true
        if(!isAdmin){
            Calendar now = Calendar.getInstance();   // Gets the current date and time
            int year = now.get(Calendar.YEAR);
            isSubmitted = PmSpLog.findByServiceIdAndYear(user.serviceId, year).isSubmitted
        }
        render(view: "/pmMissions/show", model: [serviceId: user.serviceId,isAdmin:isAdmin,isSubmitted:isSubmitted])
    }
    def create() {
        renderOutput(createPmMissionsActionService, params)

    }
    def update() {
        renderOutput(updatePmMissionsActionService, params)

    }
    def delete() {
        renderOutput(deletePmMissionsActionService, params)

    }
    def list() {
        renderOutput(listPmMissionsActionService, params)
    }
}
