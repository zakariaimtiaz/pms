package pms

import actions.pmObjectives.CreatePmObjectivesActionService
import actions.pmObjectives.DeletePmObjectivesActionService
import actions.pmObjectives.ListPmObjectivesActionService
import actions.pmObjectives.UpdatePmObjectivesActionService
import grails.converters.JSON
import groovy.sql.GroovyRowResult
import service.PmObjectivesService

class PmObjectivesController  extends BaseController {

    BaseService baseService
    PmObjectivesService pmObjectivesService

    static allowedMethods = [
            show: "POST", create: "POST", update: "POST",delete: "POST", list: "POST"
    ]

    CreatePmObjectivesActionService createPmObjectivesActionService
    UpdatePmObjectivesActionService updatePmObjectivesActionService
    DeletePmObjectivesActionService deletePmObjectivesActionService
    ListPmObjectivesActionService listPmObjectivesActionService


    def show() {
        render(view: "/pmObjectives/show")
    }
    def create() {
        renderOutput(createPmObjectivesActionService, params)

    }
    def update() {
        renderOutput(updatePmObjectivesActionService, params)

    }
    def delete() {
        renderOutput(deletePmObjectivesActionService, params)

    }
    def list() {
        renderOutput(listPmObjectivesActionService, params)
    }

    def lstObjectiveByGoalsId() {
        long goalId = Long.parseLong(params.goalId.toString())
        List<GroovyRowResult> lst = pmObjectivesService.lstObjectivesForDropDown(goalId)
        List lstValue = baseService.listForKendoDropdown(lst, null, null)
        Map result = [lstObjectives: lstValue]
        render result as JSON    }
}
