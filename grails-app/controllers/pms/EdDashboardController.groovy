package pms

import actions.edDashboard.CreateEdDashboardActionService
import actions.edDashboard.UpdateEdDashboardActionService
import com.pms.EdDashboard
import com.pms.EdDashboardIssues
import com.pms.PmMcrsLog
import com.pms.PmSpLog
import com.pms.SecRole
import com.pms.SecUser
import com.pms.SecUserSecRole
import grails.converters.JSON
import groovy.sql.GroovyRowResult
import pms.utility.DateUtility
import service.EdDashboardService

import java.text.DateFormat
import java.text.SimpleDateFormat

class EdDashboardController extends BaseController {


    static allowedMethods = [
            show: "POST", create: "POST", update: "POST",delete: "POST", list: "POST"
    ]

    BaseService baseService
    EdDashboardService edDashboardService
    CreateEdDashboardActionService createEdDashboardActionService
    UpdateEdDashboardActionService updateEdDashboardActionService

    def show() {
        SecUser user = baseService.currentUserObject()
        SecRole roleAdmin = SecRole.findByAuthority("ROLE_PMS_ADMIN")
        int count = SecUserSecRole.countBySecRoleAndSecUser(roleAdmin, user)
        boolean isAdmin = count >0

        String submissionDate = baseService.lastSubmissionDate(user.serviceId)

        render(view: "/edDashboard/show", model: [serviceId: user.serviceId,submissionDate:submissionDate])
    }
    def create() {
        renderOutput(createEdDashboardActionService, params)
    }
    def update(){
        renderOutput(updateEdDashboardActionService, params)
    }

    def list() {
        try {
            SecUser user = baseService.currentUserObject()
            boolean isEdAssistant = baseService.isEdAssistantRole(user.id)
            long sId = 0
            if(params.serviceId!=''){
                sId = Long.parseLong(params.serviceId.toString())
            }
            List<GroovyRowResult> listValue
            if (params.month) {
            listValue = edDashboardService.lstEdDashboardIssue(sId, params.month)
                String template = params.template

                 def gString = g.render(template: template, model:[list:listValue,isEdAssistant:isEdAssistant])
                 Map map = new LinkedHashMap()
                 map.put('tableHtml', gString)
                 render map as JSON
        }else {
                listValue = edDashboardService.lstEdDashboardIssue(sId)
                Map map = new LinkedHashMap()
                map.put('list', listValue)
                map.put('count', listValue.size())
                render map as JSON
            }
        }catch (Exception ex){
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
                long issuesId = Long.parseLong(params.issueId.toString())

                int count=EdDashboardIssues.countByIdAndIsAdditional(issuesId,true)
                if (count>0) {
                    List<GroovyRowResult> lst = edDashboardService.lstEdDashboardSectorOrCSUIssue(sId, monthFor)
                    List<GroovyRowResult> lstKendo = BaseService.listForKendoDropdown(lst, null, null)
                    Map result = [lst: lstKendo]
                    result.put('isAdditional',true)
                    render result as JSON
                } else {
                    EdDashboard edDashboard = EdDashboard.findByServiceIdAndMonthForAndIssueId(sId, monthFor, issuesId)
                    Map result = [lst: edDashboard]
                    result.put('isAdditional',false)
                    render result as JSON
                }
            } else {
                long edDashboardId = Long.parseLong(params.dashboardId.toString())
                EdDashboard edDashboard = EdDashboard.findById(edDashboardId)
                Map result = [lst: edDashboard]
                render result as JSON
            }
        }catch (Exception ex){
        }
    }
}
