package pms

import actions.pmMissions.CreatePmMissionsActionService
import actions.pmMissions.DeletePmMissionsActionService
import actions.pmMissions.ListPmMissionsActionService
import actions.pmMissions.UpdatePmMissionsActionService

class PmMissionsController  extends BaseController {

    static allowedMethods = [
            show: "POST", create: "POST", update: "POST",delete: "POST", list: "POST"
    ]

    CreatePmMissionsActionService createPmMissionsActionService
    UpdatePmMissionsActionService updatePmMissionsActionService
    DeletePmMissionsActionService deletePmMissionsActionService
    ListPmMissionsActionService listPmMissionsActionService

    def show() {
        render(view: "/pmMissions/show")
    }
    def create() {
        renderOutput(createPmMissionsActionService, params)

    }
    def update() {
        renderOutput(updatePmMissionsActionService, params)

    }
    def delete() {
        renderOutput(deletePmMissionsActionService, params)

    }
    def list() {
        renderOutput(listPmMissionsActionService, params)
    }
}
