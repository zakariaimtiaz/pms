package pms

import actions.pmServiceSector.CreatePmServiceSectorActionService
import actions.pmServiceSector.DeletePmServiceSectorActionService
import actions.pmServiceSector.ListPmServiceSectorActionService
import actions.pmServiceSector.UpdatePmServiceSectorActionService
import com.pms.PmServiceSector
import grails.converters.JSON
import groovy.sql.GroovyRowResult
import service.PmServiceSectorService

class PmServiceSectorController extends BaseController {

    static allowedMethods = [
            show: "POST", create: "POST", update: "POST",delete: "POST", list: "POST", serviceListByCategoryId: "POST"
    ]

    PmServiceSectorService pmServiceSectorService
    CreatePmServiceSectorActionService createPmServiceSectorActionService
    DeletePmServiceSectorActionService deletePmServiceSectorActionService
    ListPmServiceSectorActionService listPmServiceSectorActionService
    UpdatePmServiceSectorActionService updatePmServiceSectorActionService

    def serviceListByCategoryId() {
        long categoryId = Long.parseLong(params.serviceCategoryId.toString())
        List<PmServiceSector> lstService = pmServiceSectorService.categoryWiseServiceList(categoryId)
        Map result = [lstService: lstService]
        render result as JSON
    }

    def activeServiceList() {
        List<GroovyRowResult> lst = pmServiceSectorService.activeList()
        Map result = [lstValue: lst]
        render result as JSON
    }


    def show() {
        render(view: "/pmServiceSector/show")
    }
    def create() {
        renderOutput(createPmServiceSectorActionService, params)

    }
    def update() {
        renderOutput(updatePmServiceSectorActionService, params)

    }
    def delete() {
        renderOutput(deletePmServiceSectorActionService, params)

    }
    def list() {
        renderOutput(listPmServiceSectorActionService, params)
    }
}
