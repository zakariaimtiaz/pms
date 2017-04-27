package pms

import actions.pmAdditionalActions.CreatePmAdditionalActionsActionService
import actions.pmAdditionalActions.DeletePmAdditionalActionsActionService
import actions.pmAdditionalActions.ListPmAdditionalActionsActionService
import actions.pmAdditionalActions.UpdatePmAdditionalActionsActionService
import com.pms.PmAdditionalActionsIndicator
import com.pms.SecUser
import grails.converters.JSON
import groovy.sql.GroovyRowResult
import service.PmActionsService
import service.PmProjectsService
import service.PmServiceSectorService

class PmAdditionalActionsController extends BaseController {

    static allowedMethods = [
            show: "POST", create: "POST", update: "POST",delete: "POST", list: "POST"
    ]
    BaseService baseService
    PmActionsService pmActionsService
    PmProjectsService pmProjectsService
    PmServiceSectorService pmServiceSectorService
    CreatePmAdditionalActionsActionService createPmAdditionalActionsActionService
    UpdatePmAdditionalActionsActionService updatePmAdditionalActionsActionService
    DeletePmAdditionalActionsActionService deletePmAdditionalActionsActionService
    ListPmAdditionalActionsActionService listPmAdditionalActionsActionService

    def show() {
        List<GroovyRowResult> lst = pmServiceSectorService.activeList()
        lst.remove(0)
        List<GroovyRowResult> lstProject = pmProjectsService.activeList()
        lstProject.remove(0)
        SecUser user = baseService.currentUserObject()
        String submissionDate=baseService.lastSubmissionDate(user.serviceId)
        render(view: "/pmAdditionalActions/show", model: [lstService  : lst as JSON,
                                                lstProject  : lstProject as JSON,
                                                serviceId   : user.serviceId,submissionDate:submissionDate])
    }
    def create() {
        renderOutput(createPmAdditionalActionsActionService, params)

    }
    def update() {
        renderOutput(updatePmAdditionalActionsActionService, params)

    }
    def delete() {
        renderOutput(deletePmAdditionalActionsActionService, params)

    }

    def list() {
        renderOutput(listPmAdditionalActionsActionService, params)
    }

    def listIndicatorByActions() {
        long actionsId = 0L
        try {
            actionsId = Long.parseLong(params.actionsId.toString())
        }catch (Exception e){
            actionsId = Long.parseLong(params."filter[filters][0][value]".toString())
        }
        List<PmAdditionalActionsIndicator> lst = PmAdditionalActionsIndicator.findAllByActionsId(actionsId)
        Map result = [list: lst, count:lst.size()]
        render result as JSON
    }


}
