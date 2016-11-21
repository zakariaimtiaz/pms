package pms

import actions.pmObjectives.CreatePmObjectivesActionService
import actions.pmObjectives.DeletePmObjectivesActionService
import actions.pmObjectives.ListPmObjectivesActionService
import actions.pmObjectives.UpdatePmObjectivesActionService

class PmObjectivesController  extends BaseController {

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
}
