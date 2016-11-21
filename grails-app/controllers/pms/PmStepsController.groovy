package pms

import actions.pmSteps.CreatePmStepsActionService
import actions.pmSteps.DeletePmStepsActionService
import actions.pmSteps.ListPmStepsActionService
import actions.pmSteps.UpdatePmStepsActionService

class PmStepsController  extends BaseController {

    static allowedMethods = [
            show: "POST", create: "POST", update: "POST",delete: "POST", list: "POST"
    ]

    CreatePmStepsActionService createPmStepsActionService
    UpdatePmStepsActionService updatePmStepsActionService
    DeletePmStepsActionService deletePmStepsActionService
    ListPmStepsActionService listPmStepsActionService


    def show() {
        render(view: "/pmSteps/show")
    }
    def create() {
        renderOutput(createPmStepsActionService, params)

    }
    def update() {
        renderOutput(updatePmStepsActionService, params)

    }
    def delete() {
        renderOutput(deletePmStepsActionService, params)

    }
    def list() {
        renderOutput(listPmStepsActionService, params)
    }
}
