package pms

import actions.pmActions.CreatePmActionsActionService
import actions.pmActions.DeletePmActionsActionService
import actions.pmActions.ListPmActionsActionService
import actions.pmActions.UpdatePmActionsActionService
import actions.pmActionsIndicatorDetails.CreatePmActionsIndicatorDetailsActionService
import actions.pmActionsIndicatorDetails.UpdatePmActionsIndicatorDetailsActionService
import com.pms.PmActions
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
    PmServiceSectorService pmServiceSectorService
    PmProjectsService pmProjectsService
    CreatePmActionsActionService createPmActionsActionService
    UpdatePmActionsActionService updatePmActionsActionService
    DeletePmActionsActionService deletePmActionsActionService
    ListPmActionsActionService listPmActionsActionService
    CreatePmActionsIndicatorDetailsActionService createPmActionsIndicatorDetailsActionService
    UpdatePmActionsIndicatorDetailsActionService updatePmActionsIndicatorDetailsActionService


    def show() {
        List<GroovyRowResult> lst = pmServiceSectorService.activeList()
        lst.remove(0)
        List<GroovyRowResult> lstProjects = pmProjectsService.activeProjectsList()
        lstProjects.remove(0)
        render(view: "/pmActions/show", model: [lstService: lst as JSON, lstProjects:lstProjects as JSON])
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
    def actionsStartAndEndDateById() {
        long id = Long.parseLong(params.actionId.toString())
        PmActions lst = PmActions.findById(id)

        Map result = [lstActions: lst]
        render result as JSON
    }
    def createIndicatorDetails(){

        /*def monthList = params?.list('nameList')
        monthList?.each{ item ->
            println item
        }
        def monthListx = params.list('nameList')*/
        renderOutput(createPmActionsIndicatorDetailsActionService, params)
    }
    def updateIndicatorDetails(){

        renderOutput(updatePmActionsIndicatorDetailsActionService, params)
    }
}
