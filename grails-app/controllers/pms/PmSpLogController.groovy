package pms

import actions.pmSpLog.CreatePmSpLogActionService
import actions.pmSpLog.SubmitPmSpLogActionService
import actions.pmSpLog.ListPmSpLogActionService
import actions.pmSpLog.UpdatePmSpLogActionService
import actions.pmSpLog.UpdateSpLogDeadLineActionService
import com.pms.PmServiceSector
import com.pms.PmSpLog
import com.pms.SecUser
import com.pms.SystemEntity
import grails.converters.JSON

class PmSpLogController extends BaseController {

    BaseService baseService
    CreatePmSpLogActionService createPmSpLogActionService
    UpdatePmSpLogActionService updatePmSpLogActionService
    SubmitPmSpLogActionService submitPmSpLogActionService
    ListPmSpLogActionService listPmSpLogActionService
    UpdateSpLogDeadLineActionService updateSpLogDeadLineActionService

    def show() {
        render(view: "/pmSpLog/show")
    }
    def create() {
        renderOutput(createPmSpLogActionService, params)

    }
    def update() {
        renderOutput(updatePmSpLogActionService, params)

    }
    def retrieveSpLog() {
        SecUser user = baseService.currentUserObject()
        PmSpLog spLog = PmSpLog.findByServiceIdAndYear(user.serviceId, Integer.parseInt(params.year.toString()))
        render spLog.isSubmitted
    }
    def list() {
        renderOutput(listPmSpLogActionService, params)
    }
    def showSubmission() {
        SecUser user = baseService.currentUserObject()
        render(view: "/pmSpLog/showSubmission", model: [serviceId:user.serviceId])
    }
    def submission() {
        renderOutput(submitPmSpLogActionService, params)
    }
    def updateDeadLine() {
        renderOutput(updateSpLogDeadLineActionService, params)
    }
}
