package pms

import actions.spTimeSchedule.CreateSPTimeScheduleActionService
import actions.spTimeSchedule.DeleteSPTimeScheduleService
import actions.spTimeSchedule.ListSPTimeScheduleActionService
import actions.spTimeSchedule.UpdateSPTimeScheduleActionService

class spTimeScheduleController extends BaseController {

    static allowedMethods = [
            show: "POST", create: "POST", update: "POST",delete: "POST", list: "POST"
    ]

    CreateSPTimeScheduleActionService createSPTimeScheduleActionService
    UpdateSPTimeScheduleActionService updateSPTimeScheduleActionService
    DeleteSPTimeScheduleService deleteSPTimeScheduleService
    ListSPTimeScheduleActionService listSPTimeScheduleActionService

    def show() {
        render(view: "/spTimeSchedule/show")
    }
    def create() {
        renderOutput(createSPTimeScheduleActionService, params)

    }
    def update() {
        renderOutput(updateSPTimeScheduleActionService, params)

    }
    def delete() {
        renderOutput(deleteSPTimeScheduleService, params)

    }
    def list() {
        renderOutput(listSPTimeScheduleActionService, params)
    }
}