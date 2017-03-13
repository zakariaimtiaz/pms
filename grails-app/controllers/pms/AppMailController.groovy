package pms

import actions.appMail.*

class AppMailController extends BaseController {

    static allowedMethods = [
            create: "POST", show: "POST", update: "POST", delete: "POST",
            list  : "POST", testAppMail: "POST", sendAppMail: "POST"
    ]

    ListAppMailActionService listAppMailActionService
    UpdateAppMailActionService updateAppMailActionService
    CreateAppMailActionService createAppMailActionService
    DeleteAppMailActionService deleteAppMailActionService
    TestAppMailActionService testAppMailActionService
    SendAppMailActionService sendAppMailActionService


    def show() {
        render(view: "/mailTemp/show")
    }

    def create() {
        renderOutput(createAppMailActionService, params)
    }

    def update() {
        renderOutput(updateAppMailActionService, params)
    }

    def delete() {
        renderOutput(deleteAppMailActionService, params)
    }

    def list() {
        renderOutput(listAppMailActionService, params)
    }

    def sendAppMail() {
        renderOutput(sendAppMailActionService, params)
    }

    def testAppMail() {
        renderOutput(testAppMailActionService, params)
    }

}
