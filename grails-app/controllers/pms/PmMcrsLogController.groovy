package pms

import actions.pmMcrsLog.CreatePmMcrsLogActionService
import actions.pmMcrsLog.ListPmMcrsLogActionService
import actions.pmMcrsLog.SubmitDashBoardActionService
import actions.pmMcrsLog.SubmitMRPActionService
import actions.pmMcrsLog.UpdatePmMcrsDeadLineActionService
import actions.pmMcrsLog.UpdatePmMcrsLogActionService
import com.pms.PmMcrsLogDetails
import com.pms.PmServiceSector
import com.pms.SecUser
import grails.converters.JSON
import service.PmMcrsLogService

class PmMcrsLogController extends BaseController {

    BaseService baseService
    PmMcrsLogService pmMcrsLogService
    CreatePmMcrsLogActionService createPmMcrsLogActionService
    UpdatePmMcrsLogActionService updatePmMcrsLogActionService
    SubmitMRPActionService submitMRPActionService
    SubmitDashBoardActionService submitDashBoardActionService
    ListPmMcrsLogActionService listPmMcrsLogActionService
    UpdatePmMcrsDeadLineActionService updatePmMcrsDeadLineActionService

    def show() {
        SecUser user = baseService.currentUserObject()
        long serviceId = user.serviceId
        boolean isAdmin = baseService.isUserSystemAdmin(user.id)
        boolean isSpAdmin = baseService.isEdAdminRole(user.id)
        PmServiceSector service = PmServiceSector.findByShortName("MIS")
        if(isAdmin || isSpAdmin){ serviceId = service.id}
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
        List<Long> lst = baseService.currentUserDepartmentList()
        if(lst.size() > 1){
            render(view: "/pmMcrsLog/showSubmissionWithDeptLst", model: [serviceId:user.serviceId])
            return
        }
        render(view: "/pmMcrsLog/showSubmission", model: [serviceId:user.serviceId])
    }
    def submission() {
        renderOutput(submitMRPActionService, params)
    }
    def submissionDashBoard() {
        renderOutput(submitDashBoardActionService, params)
    }
    def updateDeadLine() {
        renderOutput(updatePmMcrsDeadLineActionService, params)
    }
    def logDetailsById() {
        long typeId = Long.parseLong(params.typeId.toString())
        long logId = Long.parseLong(params.logId.toString())
        def result = pmMcrsLogService.mcrsLogDetailsByLogId(logId, typeId)
        String typeStr = 'MRP'
        if(typeId==2){
            typeStr = 'ED\'s Dashboard'
        }

        render(view: '/reports/statistical/showMcrsDetails',
                model:[result:result,service:result[0]?.service,
                       logStart: result[0]?.log_start,
                       month:result[0]?.month_str,typeStr:typeStr])
    }
}
