package pms

import actions.pmActions.CreatePmActionsActionService
import actions.pmActions.DeletePmActionsActionService
import actions.pmActions.ListPmActionsActionService
import actions.pmActions.UpdatePmActionsActionService

class PmActionsController extends BaseController {

    static allowedMethods = [
            show: "POST", create: "POST", update: "POST",delete: "POST", list: "POST"
    ]

    CreatePmActionsActionService createPmActionsActionService
    UpdatePmActionsActionService updatePmActionsActionService
    DeletePmActionsActionService deletePmActionsActionService
    ListPmActionsActionService listPmActionsActionService

    def show() {
        render(view: "/pmActions/show")
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
}
