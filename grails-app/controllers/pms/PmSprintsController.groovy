package pms

import actions.pmSprints.CreatePmSprintsActionService
import actions.pmSprints.DeletePmSprintsActionService
import actions.pmSprints.ListPmSprintsActionService
import actions.pmSprints.UpdatePmSprintsActionService
import com.pms.PmActions
import grails.converters.JSON
import groovy.sql.GroovyRowResult

class PmSprintsController  extends BaseController {

    static allowedMethods = [
            show: "POST", create: "POST", update: "POST",delete: "POST", list: "POST"
    ]

    CreatePmSprintsActionService createPmSprintsActionService
    UpdatePmSprintsActionService updatePmSprintsActionService
    DeletePmSprintsActionService deletePmSprintsActionService
    ListPmSprintsActionService listPmSprintsActionService


    def show() {
        render(view: "/pmSprints/show")
    }
    def create() {
        renderOutput(createPmSprintsActionService, params)

    }
    def update() {
        renderOutput(updatePmSprintsActionService, params)

    }
    def delete() {
        renderOutput(deletePmSprintsActionService, params)

    }
    def list() {
        renderOutput(listPmSprintsActionService, params)
    }

}
