package pms

import actions.pmGoals.CreatePmGoalsActionService
import actions.pmGoals.DeletePmGoalsActionService
import actions.pmGoals.ListPmGoalsActionService
import actions.pmGoals.UpdatePmGoalsActionService
import actions.pmProjects.CreatePmProjectsActionService
import actions.pmProjects.DeletePmProjectsActionService
import actions.pmProjects.ListPmProjectsActionService
import actions.pmProjects.UpdatePmProjectsActionService
import grails.converters.JSON
import groovy.sql.GroovyRowResult
import service.PmGoalsService

class PmProjectsController extends BaseController {

    BaseService baseService
    PmGoalsService pmGoalsService

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
