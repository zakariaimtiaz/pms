package pms

import actions.edDashboard.CreateEdDashboardActionService
import actions.edDashboard.UpdateEdDashboardActionService
import com.pms.PmSpLog
import com.pms.SecUser
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
        render(view: "/edDashboard/show", model: [serviceId: user.serviceId])
    }
    def create() {
        renderOutput(createEdDashboardActionService, params)

    }
    def update() {
        renderOutput(updateEdDashboardActionService, params)

    }

    def list() {
        try {
            DateFormat originalFormat = new SimpleDateFormat("MMMM yyyy", Locale.ENGLISH);
            Date start = originalFormat.parse(params.month.toString());
            Calendar c = Calendar.getInstance();
            c.setTime(start);
            c.set(Calendar.DAY_OF_MONTH, c.getActualMinimum(Calendar.DAY_OF_MONTH));
            Date d = DateUtility.getSqlDate(c.getTime())
            long sId = Long.parseLong(params.serviceId.toString())
            List<GroovyRowResult> listValue = edDashboardService.lstEdDashboardIssue(sId,d)

            def gString = g.render(template: "/edDashboard/table", model:[list:listValue])
            Map map = new LinkedHashMap()
            map.put('tableHtml', gString)
            render map as JSON
        }catch (Exception ex){
        }
    }
}
