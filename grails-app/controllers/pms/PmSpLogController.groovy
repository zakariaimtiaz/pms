package pms

import actions.pmSpLog.*
import com.pms.PmSpLog
import com.pms.SecUser
import service.PmSpLogService

class PmSpLogController extends BaseController {

    BaseService baseService
    PmSpLogService pmSpLogService
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
        boolean isAdmin = baseService.isUserSystemAdmin(user.id)
        if(isAdmin) {
            render Boolean.FALSE
            return
        }
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
    def logDetailsById() {
        long logId = Long.parseLong(params.logId.toString())
        def result = pmSpLogService.spLogDetailsByLogId(logId)

        render(view: '/reports/statistical/showSpDetails',
                model:[result:result,service:result[0]?.service,
                       logStart: result[0]?.log_start,year:result[0].year])
    }
}
