package pms

import actions.pmMcrsLog.CreatePmMcrsLogActionService
import actions.pmMcrsLog.ListPmMcrsLogActionService
import actions.pmMcrsLog.SubmitPmMcrsLogActionService
import actions.pmMcrsLog.UpdatePmMcrsDeadLineActionService
import actions.pmMcrsLog.UpdatePmMcrsLogActionService
import com.pms.PmMcrsLog
import com.pms.PmServiceSector
import com.pms.SecUser

class PmMcrsLogController extends BaseController{

    BaseService baseService
    CreatePmMcrsLogActionService createPmMcrsLogActionService
    UpdatePmMcrsLogActionService updatePmMcrsLogActionService
    SubmitPmMcrsLogActionService submitPmMcrsLogActionService
    ListPmMcrsLogActionService listPmMcrsLogActionService
    UpdatePmMcrsDeadLineActionService updatePmMcrsDeadLineActionService

    def show() {
        SecUser user = baseService.currentUserObject()
        long serviceId = user.serviceId
        boolean isAdmin = baseService.isUserSystemAdmin(user.id)
        PmServiceSector service = PmServiceSector.findByShortName("MIS")
        if(isAdmin){ serviceId = service.id}
        render(view: "/pmMcrsLog/show", model: [serviceId:serviceId,isAdmin:isAdmin])
    }
    def create() {
        renderOutput(createPmMcrsLogActionService, params)

    }
    def update() {
        renderOutput(updatePmMcrsLogActionService, params)

    }
    def list() {
        renderOutput(listPmMcrsLogActionService, params)
    }
    def showSubmission() {
        SecUser user = baseService.currentUserObject()
        render(view: "/pmMcrsLog/showSubmission", model: [serviceId:user.serviceId])
    }
    def submission() {
        renderOutput(submitPmMcrsLogActionService, params)
    }
    def updateDeadLine() {
        renderOutput(updatePmMcrsDeadLineActionService, params)
    }
}
