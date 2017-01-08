package pms

import actions.pmSpSummary.CreatePmSpSummaryActionService
import actions.pmSpSummary.DeletePmSpSummaryActionService
import actions.pmSpSummary.ListPmSpSummaryActionService
import actions.pmSpSummary.UpdatePmSpSummaryActionService


class PmSpSummaryController extends BaseController {

    CreatePmSpSummaryActionService createPmSpSummaryActionService
    UpdatePmSpSummaryActionService updatePmSpSummaryActionService
    ListPmSpSummaryActionService listPmSpSummaryActionService
    DeletePmSpSummaryActionService deletePmSpSummaryActionService

    static allowedMethods = [
            show: "POST", create: "POST", update: "POST", delete: "POST", list: "POST"
    ]

    def show() {
        render(view: "/pmSpSummary/show")
    }
    def create() {
        renderOutput(createPmSpSummaryActionService, params)

    }
    def update() {
        renderOutput(updatePmSpSummaryActionService, params)

    }
    def delete() {
        renderOutput(deletePmSpSummaryActionService, params)

    }
    def list() {
        renderOutput(listPmSpSummaryActionService, params)
    }
}
