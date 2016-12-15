package pms

import actions.pmProjects.CreatePmProjectsActionService
import actions.pmProjects.DeletePmProjectsActionService
import actions.pmProjects.ListPmProjectsActionService
import actions.pmProjects.UpdatePmProjectsActionService

class PmProjectsController extends BaseController {

    static allowedMethods = [
            show: "POST", create: "POST", update: "POST",delete: "POST", list: "POST"
    ]

    CreatePmProjectsActionService createPmProjectsActionService
    UpdatePmProjectsActionService updatePmProjectsActionService
    DeletePmProjectsActionService deletePmProjectsActionService
    ListPmProjectsActionService listPmProjectsActionService



    def show() {
        render(view: "/pmProjects/show")
    }
    def create() {
        renderOutput(createPmProjectsActionService, params)

    }
    def update() {
        renderOutput(updatePmProjectsActionService, params)

    }
    def delete() {
        renderOutput(deletePmProjectsActionService, params)

    }
    def list() {
        renderOutput(listPmProjectsActionService, params)
    }

}
