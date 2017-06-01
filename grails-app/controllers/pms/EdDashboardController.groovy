package pms

import actions.edDashboard.CreateEdDashboardActionService
import actions.edDashboard.DeleteEdDashboardIssueActionService
import actions.edDashboard.UpdateEdDashboardActionService
import com.pms.EdDashboard
import com.pms.EdDashboardIssues
import com.pms.SecUser
import grails.converters.JSON
import groovy.sql.GroovyRowResult
import pms.utility.DateUtility
import service.EdDashboardService

import java.text.DateFormat
import java.text.SimpleDateFormat

class EdDashboardController extends BaseController {


    static allowedMethods = [
            show: "POST", create: "POST", update: "POST", delete: "POST", list: "POST"
    ]

    BaseService baseService
    EdDashboardService edDashboardService
    CreateEdDashboardActionService createEdDashboardActionService
    UpdateEdDashboardActionService updateEdDashboardActionService
    DeleteEdDashboardIssueActionService deleteEdDashboardIssueActionService

    def show() {
        SecUser user = baseService.currentUserObject()
        String subDate = baseService.lastDashboardSubmissionDate(user.serviceId)
        render(view: "/edDashboard/show", model: [ subDate: subDate,serviceId: user.serviceId])
    }

    def create() {
        renderOutput(createEdDashboardActionService, params)
    }
    def update() {
        renderOutput(updateEdDashboardActionService, params)
    }
    def delete() {
        renderOutput(deleteEdDashboardIssueActionService, params)
    }

    def list() {
            SecUser user = baseService.currentUserObject()
            long sId = Long.parseLong(params.serviceId.toString())
            List<GroovyRowResult> listValue = edDashboardService.lstEdDashboardIssue(sId, params.month)
            Map map = new LinkedHashMap()
            map.put('list', listValue)
            render map as JSON
    }
    def unresolveList() {
        try {
            SecUser user = baseService.currentUserObject()
            boolean isEdAssistant = baseService.isEdAssistantRole(user.id)
            long sId = Long.parseLong(params.serviceId.toString())
            List<GroovyRowResult> listValue
            if (params.month) {
                listValue = edDashboardService.lstUnresolveEdDashboardIssue(sId, params.month)
                String template = params.template ? params.template : '/edDashboard/table'
                long i = 0

                def gString = g.render(template: template, model: [list: listValue])
                Map map = new LinkedHashMap()
                map.put('tableHtml', gString)
                render map as JSON
            }
        } catch (Exception ex) {
        }
    }

    def retrieveIssueAndMonthData() {
        try {
            SecUser user = baseService.currentUserObject()
            boolean isEdAssistant = baseService.isEdAssistantRole(user.id)
            DateFormat originalFormat = new SimpleDateFormat("MMMM yyyy", Locale.ENGLISH);
            Date start = originalFormat.parse(params.month.toString());
            Calendar c = Calendar.getInstance();
            c.setTime(start);
            c.set(Calendar.DAY_OF_MONTH, c.getActualMinimum(Calendar.DAY_OF_MONTH));
            Date monthFor = DateUtility.getSqlDate(c.getTime())
            long sId = Long.parseLong(params.serviceId.toString())
            if (params.type) {
                List<GroovyRowResult> lst = edDashboardService.lstEdDashboardSectorOrCSUIssue(sId, monthFor)
                List<GroovyRowResult> lstKendo = BaseService.listForKendoDropdown(lst, null, null)
                Map result = [lst: lstKendo]
                render result as JSON
            } else {
            }

            if (!params.dashboardId) {

                    long issuesId = Long.parseLong(params.issueId.toString())

                    // EdDashboard edDashboard = EdDashboard.findByServiceIdAndMonthForAndIssueId(sId, monthFor, issuesId)
                    List<GroovyRowResult> listValue = edDashboardService.lstEdDashboardDescriptionAndRemarks(sId, monthFor, issuesId)
                    Map result = new LinkedHashMap()
                    result.put('lst', listValue)
                    render result as JSON

            } else {
                long edDashboardId = Long.parseLong(params.dashboardId.toString())
                EdDashboard edDashboard = EdDashboard.findById(edDashboardId)
                List<GroovyRowResult> listValue = edDashboardService.lstEdDashboardDescriptionAndRemarks(edDashboard.serviceId, edDashboard.monthFor, edDashboard.issueId)
                Map result = new LinkedHashMap()
                result.put('lst', listValue)
                render result as JSON
            }
        } catch (Exception ex) {
        }
    }
    def retrieveIssueAndMonthDataOld() {
        try {
            if (!params.dashboardId) {
                SecUser user = baseService.currentUserObject()
                boolean isEdAssistant = baseService.isEdAssistantRole(user.id)
                DateFormat originalFormat = new SimpleDateFormat("MMMM yyyy", Locale.ENGLISH);
                Date start = originalFormat.parse(params.month.toString());
                Calendar c = Calendar.getInstance();
                c.setTime(start);
                c.set(Calendar.DAY_OF_MONTH, c.getActualMinimum(Calendar.DAY_OF_MONTH));
                Date monthFor = DateUtility.getSqlDate(c.getTime())
                long sId = Long.parseLong(params.serviceId.toString())

                if (!params.issueId) {
                    List<GroovyRowResult> lst = edDashboardService.lstEdDashboardSectorOrCSUIssue(sId, monthFor)
                    List<GroovyRowResult> lstKendo = BaseService.listForKendoDropdown(lst, null, null)
                    Map result = [lst: lstKendo]
                    render result as JSON
                } else {
                    long issuesId = Long.parseLong(params.issueId.toString())

                    // EdDashboard edDashboard = EdDashboard.findByServiceIdAndMonthForAndIssueId(sId, monthFor, issuesId)
                    List<GroovyRowResult> listValue = edDashboardService.lstEdDashboardDescriptionAndRemarks(sId, monthFor, issuesId)
                    Map result = new LinkedHashMap()
                    result.put('lst', listValue)
                    render result as JSON
                }
            } else {
                long edDashboardId = Long.parseLong(params.dashboardId.toString())
                EdDashboard edDashboard = EdDashboard.findById(edDashboardId)
                List<GroovyRowResult> listValue = edDashboardService.lstEdDashboardDescriptionAndRemarks(edDashboard.serviceId, edDashboard.monthFor, edDashboard.issueId)
                Map result = new LinkedHashMap()
                result.put('lst', listValue)
                render result as JSON
            }
        } catch (Exception ex) {
        }
    }
}
