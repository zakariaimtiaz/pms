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
        render(view: "/EdDashboard/show", model: [serviceId: user.serviceId])
    }
    def create() {
        renderOutput(createEdDashboardActionService, params)

    }
    def update() {
        renderOutput(updateEdDashboardActionService, params)

    }

    def list(String serviceId,String month) {
        def gString = ''
        def map = [:]
        int sId
        Date d
        try {

            DateFormat originalFormat = new SimpleDateFormat("MMMM yyyy", Locale.ENGLISH);

            Date start = originalFormat.parse(month);
            Calendar c = Calendar.getInstance();
            c.setTime(start);
            c.set(Calendar.DAY_OF_MONTH, c.getActualMinimum(Calendar.DAY_OF_MONTH));
            d = DateUtility.getSqlDate(c.getTime())
            sId = Long.parseLong(serviceId)
        }catch (Exception ex){
            SecUser user = baseService.currentUserObject()
            sId=user.serviceId
        }

        List<GroovyRowResult> listValue = edDashboardService.lstEdDashboardIssue(sId,d)

        gString = g.render(template: "/edDashboard/table", model:[list:listValue])
        map.put('tableHtml', gString)
        render map as JSON
        //render result as JSON
    }
}
