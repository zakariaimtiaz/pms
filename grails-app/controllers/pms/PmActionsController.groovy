package pms

import actions.pmActions.*
import actions.pmActions.ListEditableActionsActionService
import com.pms.*
import grails.converters.JSON
import groovy.sql.GroovyRowResult
import service.PmActionsService
import service.PmProjectsService
import service.PmServiceSectorService

class PmActionsController extends BaseController {

    static allowedMethods = [
            show: "POST", create: "POST", update: "POST",delete: "POST", list: "POST"
    ]
    BaseService baseService
    PmActionsService pmActionsService
    PmProjectsService pmProjectsService
    PmServiceSectorService pmServiceSectorService
    CreatePmActionsActionService createPmActionsActionService
    UpdatePmActionsActionService updatePmActionsActionService
    DeletePmActionsActionService deletePmActionsActionService
    ListPmActionsActionService listPmActionsActionService
    UpdateMRPActionService updateMRPActionService
    UpdateMRPActionExtendedTimeService updateMRPActionExtendedTimeService
    UpdatePreferenceActionService updatePreferenceActionService
    ListMRPActionService listMRPActionService
    ListEditableActionsActionService listEditableActionsActionService
    UpdateEditableActionsActionService updateEditableActionsActionService

    def show() {
        List<GroovyRowResult> lst = pmServiceSectorService.activeList()
        lst.remove(0)
        List<GroovyRowResult> lstProject = pmProjectsService.activeList()
        lstProject.remove(0)
        SecUser user = baseService.currentUserObject()
        boolean isAdmin = baseService.isUserSystemAdmin(user.id)
        boolean isSubmitted = Boolean.FALSE
        if(!isAdmin){
            Calendar now = Calendar.getInstance();   // Gets the current date and time
            int year = now.get(Calendar.YEAR);
            isSubmitted = PmSpLog.findByServiceIdAndYear(user.serviceId, year).isSubmitted
        }
        render(view: "/pmActions/show", model: [lstService  : lst as JSON,
                                                lstProject  : lstProject as JSON,
                                                isAdmin     : isAdmin,
                                                serviceId   : user.serviceId,
                                                isSubmitted : isSubmitted])
    }
    def create() {
        renderOutput(createPmActionsActionService, params)

    }
    def update() {
        renderOutput(updatePmActionsActionService, params)

    }
    def delete() {
        renderOutput(deletePmActionsActionService, params)

    }
    def updateAchievement(){
        renderOutput(updateMRPActionService, params)
    }
    def updateExtendedTimeAchievement(){
        renderOutput(updateMRPActionExtendedTimeService, params)
    }
    def updatePreference(){
        renderOutput(updatePreferenceActionService, params)
    }
    def showEditableActions(){
        render(view: "/pmActions/editableActions/show",
                model:[serviceId : params.serviceId,
                       service   : params.service,
                       year      : params.year
                ])
    }
    def updateEditableActions(){
        renderOutput(updateEditableActionsActionService, params)
    }
    def listEditableActions(){
        renderOutput(listEditableActionsActionService,params)
    }
    def list() {
        renderOutput(listPmActionsActionService, params)
    }
    def lstActionsByServiceIdAndYear() {
        long serviceId = Long.parseLong(params.serviceId.toString())
        String year = params.year.toString()
        List<GroovyRowResult> lst = pmActionsService.lstActionsByServiceIdAndYear(serviceId, year)
        List lstValue = baseService.listForKendoDropdown(lst, null, null)
        Map result = [lstActions: lstValue]
        render result as JSON
    }
    def lstActionsByGoalId() {
        long goalId = Long.parseLong(params.goalId.toString())
        List<GroovyRowResult> lst = pmActionsService.lstActionsForDropDown(goalId)
        List lstValue = baseService.listForKendoDropdown(lst, null, null)
                Map result = [lstActions: lstValue]
                render result as JSON
    }
    def listIndicatorByActions() {
        long actionsId = 0L
        try {
            actionsId = Long.parseLong(params.actionsId.toString())
        }catch (Exception e){
            actionsId = Long.parseLong(params."filter[filters][0][value]".toString())
        }
        List<PmActionsIndicator> lst = PmActionsIndicator.findAllByActionsId(actionsId)
        Map result = [list: lst, count:lst.size()]
        render result as JSON
    }
    def listDetailsByIndicator() {
        if(params.containsKey("indicatorId")){
            long indicatorId = Long.parseLong(params.indicatorId.toString())
            List<PmActionsIndicatorDetails> lst = PmActionsIndicatorDetails.findAllByIndicatorId(indicatorId)
            Map result = [list: lst, count:lst.size()]
            render result as JSON
        }else{
            long actionsId = Long.parseLong(params.actionsId.toString())
            long indicatorId = Long.parseLong(params."filter[filters][0][value]".toString())
            List<GroovyRowResult> lst = pmActionsService.findAllDetailsByActionsIdAndIndicatorId(actionsId, indicatorId)
            Map result = [list: lst, count:lst.size()]
            render result as JSON
        }
    }
    def actionsStartAndEndDateById() {
        long id = Long.parseLong(params.actionId.toString())
        PmActions lst = PmActions.findById(id)

        Map result = [lstActions: lst]
        render result as JSON
    }
    def updateIndicatorDetails(){
        long indicatorId = Long.parseLong(params.indIdModal.toString())
        PmActionsIndicator indicator = PmActionsIndicator.read(indicatorId)
        int count = Integer.parseInt(params.tempCountModal.toString())
        long actionsId = indicator.actionsId
        String start = params.get("month1")
        String end = params.get("month"+count)
            for(int i = 0; i < count; i++){
                String monStr = "month"+(i+1)
                String trStr = "tempTr"+(i+1)
                String acvStr = "tempAcv"+(i+1)
                String paramMonth = params.get(monStr)
                String paramsTar = params.get(trStr)
                String paramsAcv = params.get(acvStr)
                if(!paramsTar) paramsTar = "0"
                if(!paramsAcv) paramsAcv = "0"

                PmActionsIndicatorDetails obj = PmActionsIndicatorDetails.findByActionsIdAndIndicatorIdAndMonthName(actionsId, indicatorId, paramMonth)
                if (obj) {
                    obj.target = Integer.parseInt(paramsTar)
                    obj.achievement = Integer.parseInt(paramsAcv)
                    obj.save()
                }else {
                    PmActionsIndicatorDetails details2 = new PmActionsIndicatorDetails()
                    details2.actionsId = actionsId
                    details2.indicatorId = indicatorId
                    details2.monthName = paramMonth
                    details2.target = Integer.parseInt(paramsTar)
                    details2.achievement = Integer.parseInt(paramsAcv)
                    details2.createDate = new Date()
                    details2.createBy = baseService.currentUserObject().id
                    details2.save()
                }
            }
           pmActionsService.deleteInvalidIndicatorDetails(indicatorId,start,end)
    }
    ////////////MRP///////////////
    def achievement() {
        SecUser user = baseService.currentUserObject()
        SecRole roleAdmin = SecRole.findByAuthority("ROLE_PMS_ADMIN")
        int count = SecUserSecRole.countBySecRoleAndSecUser(roleAdmin, user)
        boolean isAdmin = count > 0
        String submissionDate=baseService.lastMRPSubmissionDate(user.serviceId)

        render(view: "/pmActions/mrp/show", model: [isAdmin:isAdmin,serviceId:user.serviceId,submissionDate:submissionDate])
    }
    def listAchievement(){
        renderOutput(listMRPActionService, params)
    }
}
