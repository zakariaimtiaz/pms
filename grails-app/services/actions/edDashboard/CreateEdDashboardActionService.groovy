package actions.edDashboard

import com.pms.EdDashboard
import com.pms.EdDashboardIssues
import com.pms.PmMcrsLog
import com.pms.SecUser
import grails.plugin.springsecurity.SpringSecurityService
import grails.transaction.Transactional
import org.apache.log4j.Logger
import pms.ActionServiceIntf
import pms.BaseService
import pms.utility.DateUtility

import java.text.DateFormat
import java.text.SimpleDateFormat

@Transactional
class CreateEdDashboardActionService extends BaseService implements ActionServiceIntf {

    SpringSecurityService springSecurityService
    private static final String SAVE_SUCCESS_MESSAGE = "Dashboard has been saved successfully"
    private static final String ALREADY_EXIST = "Dashboard already exist"
    private static final String ED_DASHBOARD = "edDashboard"

    private Logger log = Logger.getLogger(getClass())



    @Transactional(readOnly = true)
    public Map executePreCondition(Map params) {
        try {
            if (!params.hfServiceIdModal&&!params.hfMonthModal) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    @Transactional
    public Map execute(Map result) {
        try {
            String startDateStr = result.hfMonthModal.toString()
            DateFormat originalFormat = new SimpleDateFormat("MMMM yyyy", Locale.ENGLISH);

            Date start = originalFormat.parse(startDateStr);
            Calendar c = Calendar.getInstance();
            c.setTime(start);
            c.set(Calendar.DAY_OF_MONTH, c.getActualMinimum(Calendar.DAY_OF_MONTH));
            Date monthFor = DateUtility.getSqlDate(c.getTime())
            long serviceId = Long.parseLong(result.hfServiceIdModal.toString())

            int month = c.get(Calendar.MONTH);
            int year = c.get(Calendar.YEAR);

            PmMcrsLog pmMcrsLog = PmMcrsLog.findByServiceIdAndMonthAndYear(serviceId,month+1,year)
            SecUser user = SecUser.read(springSecurityService.principal.id)
            boolean isTop = isUserTopManagement(user.id)
            boolean isEdAssist = isEdAssistantRole(user.id)

            if(!isTop && !isEdAssist && pmMcrsLog?.isSubmitted){
                return super.setError(result, 'Already submitted for this month');
            }

                Long i = Long.parseLong(result.hfClickingRowNo)
                EdDashboard edDashboard = EdDashboard.findByServiceIdAndMonthForAndIssueId(serviceId, monthFor, i)
                if (!edDashboard) {
                    edDashboard = new EdDashboard()
                }

                edDashboard.serviceId = serviceId
                edDashboard.monthFor = monthFor
                edDashboard.issueId = i
                edDashboard.description = result.description
                edDashboard.remarks = result.remarks
                edDashboard.createBy = springSecurityService?.principal?.id
                edDashboard.createDate = DateUtility.getSqlDate(new Date())
                edDashboard.edAdvice =EMPTY_SPACE
                edDashboard.isFollowup = result.selection != 'New' ? true : false
                if(edDashboard.isFollowup){
                    String followupDateStr = result.followupMonth

                    start = originalFormat.parse(followupDateStr);
                    c = Calendar.getInstance();
                    c.setTime(start);
                    c.set(Calendar.DAY_OF_MONTH, c.getActualMinimum(Calendar.DAY_OF_MONTH));
                    edDashboard.followupMonthFor = DateUtility.getSqlDate(c.getTime())
                }

                if (!edDashboard.description.isEmpty()) {
                    edDashboard.save()
                }


            return result
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }
    /**
     *
     * @param result - map received from execute method
     * @return - map
     */
    public Map executePostCondition(Map result) {
        return result
    }
    /**
     *
     * @param result - map received from executePost method
     * @return - map containing success message
     */
    public Map buildSuccessResultForUI(Map result) {
        return super.setSuccess(result, SAVE_SUCCESS_MESSAGE)
    }
    /**
     *
     * @param result - map received from previous method
     * @return - map
     */
    public Map buildFailureResultForUI(Map result) {
        return result
    }


}
