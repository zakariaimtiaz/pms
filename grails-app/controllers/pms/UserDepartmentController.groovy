package pms

import actions.userDepartment.CreateUserDepartmentActionService
import actions.userDepartment.DeleteUserDepartmentActionService
import actions.userDepartment.ListUserDepartmentActionService

class UserDepartmentController extends BaseController {

    static allowedMethods = [
            show: "POST", create: "POST", update: "POST",delete: "POST", list: "POST"
    ]

    CreateUserDepartmentActionService createUserDepartmentActionService
    DeleteUserDepartmentActionService deleteUserDepartmentActionService
    ListUserDepartmentActionService listUserDepartmentActionService


    def show(){
        render(view: "/userDepartment/show", model:[userId:params.userId])
    }

    def reloadDropDown() {
        render app.dropDownService(params)
    }

    def create() {
        renderOutput(createUserDepartmentActionService, params)

    }

    def delete() {
        renderOutput(deleteUserDepartmentActionService, params)

    }
    def list() {
        renderOutput(listUserDepartmentActionService, params)
    }
}
