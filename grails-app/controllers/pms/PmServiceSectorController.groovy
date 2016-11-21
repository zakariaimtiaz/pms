package pms

import actions.pmServiceSector.CreatePmServiceSectorActionService
import actions.pmServiceSector.DeletePmServiceSectorActionService
import actions.pmServiceSector.ListPmServiceSectorActionService
import actions.pmServiceSector.UpdatePmServiceSectorActionService
import actions.secUserSecRole.UpdateSecUserSecRoleActionService
import com.pms.PmServiceSector
import grails.converters.JSON

class PmServiceSectorController extends BaseController {

    static allowedMethods = [
            show: "POST", create: "POST", update: "POST",delete: "POST", list: "POST", serviceListByCategoryId: "POST"
    ]

    def baseService
    CreatePmServiceSectorActionService createPmServiceSectorActionService
    DeletePmServiceSectorActionService deletePmServiceSectorActionService
    ListPmServiceSectorActionService listPmServiceSectorActionService
    UpdatePmServiceSectorActionService updatePmServiceSectorActionService

    def serviceListByCategoryId() {
        long categoryId = Long.parseLong(params.serviceCategoryId.toString())
        List<PmServiceSector> lstService = PmServiceSector.findAllByCategoryId(categoryId, [sort: 'sequence', order: 'asc'])
        lstService = baseService.listForKendoDropdown(lstService, null, null)
        Map result = [lstService: lstService]
        render result as JSON
    }

    def activeServiceList() {
        List<PmServiceSector> lst = PmServiceSector.findAllByIsDisplayble(true,[sort: "sequence",order: "asc"])
        lst = baseService.listForKendoDropdown(lst, null, null)
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
