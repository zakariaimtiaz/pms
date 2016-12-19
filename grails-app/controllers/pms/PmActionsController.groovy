package pms

import actions.pmActions.CreatePmActionsActionService
import actions.pmActions.DeletePmActionsActionService
import actions.pmActions.ListPmActionsActionService
import actions.pmActions.UpdateIndicatorAchievementActionService
import actions.pmActions.UpdatePmActionsActionService
import com.pms.PmActions
import com.pms.PmActionsIndicator
import com.pms.PmActionsIndicatorDetails
import com.pms.SecUser
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
    UpdateIndicatorAchievementActionService updateIndicatorAchievementActionService

    def show() {
        List<GroovyRowResult> lst = pmServiceSectorService.activeList()
        lst.remove(0)
        List<GroovyRowResult> lstProject = pmProjectsService.activeList()
        lstProject.remove(0)
        SecUser user = baseService.currentUserObject()
        render(view: "/pmActions/show", model: [lstService: lst as JSON, lstProject: lstProject as JSON, serviceId:user.serviceId])
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
        renderOutput(updateIndicatorAchievementActionService, params)
    }
    def list() {
        renderOutput(listPmActionsActionService, params)
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
        long actionsId = Long.parseLong(params.actionsId.toString())
        long indicatorId = Long.parseLong(params."filter[filters][0][value]".toString())
        List<PmActionsIndicatorDetails> lst = PmActionsIndicatorDetails.findAllByActionsIdAndIndicatorId(actionsId, indicatorId)
        Map result = [list: lst, count:lst.size()]
        render result as JSON
    }
    def actionsStartAndEndDateById() {
        long id = Long.parseLong(params.actionId.toString())
        PmActions lst = PmActions.findById(id)

        Map result = [lstActions: lst]
        render result as JSON
    }
    def achievement() {
        SecUser user = baseService.currentUserObject()
        render(view: "/pmActions/achievement/show", model: [serviceId:user.serviceId])
    }
}
