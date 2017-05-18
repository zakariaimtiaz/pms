package pms

import actions.edDashboard.CreateEdDashboardActionService
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

    def show() {
        SecUser user = baseService.currentUserObject()
        String submissionDate = baseService.lastSubmissionDate(user.serviceId)
        render(view: "/edDashboard/show", model: [serviceId: user.serviceId, submissionDate: submissionDate])
    }

    def create() {
        renderOutput(createEdDashboardActionService, params)
    }

    def list() {
        try {
            SecUser user = baseService.currentUserObject()
            boolean isEdAssistant = baseService.isEdAssistantRole(user.id)
            long sId = Long.parseLong(params.serviceId.toString())
            List<GroovyRowResult> listValue
            if (params.month) {
                listValue = edDashboardService.lstEdDashboardIssue(sId, params.month)
                String template = params.template ? params.template : '/edDashboard/table'
                long i = 0
                for (GroovyRowResult item : listValue) {
                    if (item.is_additional) {
                        i = item.id
                    }
                }
                if(i==0){
                    i=edDashboardService.minimumAdditionalIssuesId()
                }
                else{i=i+1}
                def gString = g.render(template: template, model: [list: listValue, isEdAssistant: isEdAssistant,maxAdditionalId:i])
                Map map = new LinkedHashMap()
                map.put('tableHtml', gString)
                render map as JSON
            } else {
                listValue = EdDashboard.findAllByServiceId(sId)
                Map map = new LinkedHashMap()
                map.put('list', listValue)
                map.put('count', listValue.size())
                render map as JSON
            }
        } catch (Exception ex) {
        }
    }

    def retrieveIssueAndMonthData() {
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
