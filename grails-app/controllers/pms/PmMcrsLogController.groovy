package pms

import actions.pmMcrsLog.CreatePmMcrsLogActionService
import actions.pmMcrsLog.ListPmMcrsLogActionService
import actions.pmMcrsLog.UpdatePmMcrsLogActionService
import com.pms.PmMcrsLog
import com.pms.SecUser

class PmMcrsLogController extends BaseController{

    BaseService baseService
    CreatePmMcrsLogActionService createPmMcrsLogActionService
    UpdatePmMcrsLogActionService updatePmMcrsLogActionService

    ListPmMcrsLogActionService listPmMcrsLogActionService

    def show() {SecUser user = baseService.currentUserObject()
        boolean isAdmin = baseService.isUserSystemAdmin(user.id)

        render(view: "/pmMcrsLog/show", model: [serviceId:user.serviceId,isAdmin:isAdmin])
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
}
