package actions.reports.dashboard

import grails.transaction.Transactional
import groovy.sql.GroovyRowResult
import org.apache.log4j.Logger
import pms.ActionServiceIntf
import pms.BaseService
import pms.utility.DateUtility

import java.text.DateFormat
import java.text.SimpleDateFormat

@Transactional
class ListEdDashBoardActionService extends BaseService implements ActionServiceIntf {

    private Logger log = Logger.getLogger(getClass())

    /**
     * No pre conditions required for searching project domains
     *
     * @param params - Request parameters
     * @return - same map of input-parameter containing isError(true/false)
     */
    public Map executePreCondition(Map params) {
        return params
    }

    @Transactional(readOnly = true)
    public Map execute(Map result) {
        try {
            Date month = DateUtility.getSqlDate(new Date());
            if(result.containsKey("month")){
                String monthStr = result.month.toString()
                DateFormat originalFormat = new SimpleDateFormat("MMMM yyyy", Locale.ENGLISH);

                Date date = originalFormat.parse(monthStr);
                Calendar c = Calendar.getInstance();
                c.setTime(date);
                month = DateUtility.getSqlDate(c.getTime());
            }

            if(result.containsKey("cssp")){
                List lstVal = buildResult2List(month)
                result.put(LIST, lstVal)
                result.put(COUNT, lstVal.size())
                return result
            }

            List lstVal = buildResultList(month)
            result.put(LIST, lstVal)
            result.put(COUNT, lstVal.size())
            return result
        } catch (Exception e) {
            log.error(e.getMessage())
            throw new RuntimeException(e)
        }
    }

    /**
     * There is no postCondition, so return the same map as received
     *
     * @param result - resulting map from execute
     * @return - same map of input-parameter containing isError(true/false)
     */
    public Map executePostCondition(Map result) {
        return result
    }

    /**
     * Since there is no success message return the same map
     * @param result -map from execute/executePost method
     * @return - same map of input-parameter containing isError(true/false)
     */
    public Map buildSuccessResultForUI(Map result) {
        return result
    }

    /**
     * The input-parameter Map must have "isError:true" with corresponding message
     * @param result -map returned from previous methods
     * @return - same map of input-parameter containing isError(true/false)
     */
    public Map buildFailureResultForUI(Map result) {
        return result
    }

    private List<GroovyRowResult> buildResultList(Date month) {
        String query = """
        SELECT ss.id SERVICE_ID,ss.name SERVICE,
        CASE WHEN edi.issue_name='HR'  AND ed.description != '' AND ed.description != 'n/a' THEN ed.description ELSE '' END 'HR_ISSUE',
        CASE WHEN edi.issue_name='HR'  AND ed.remarks != ''     AND ed.remarks != 'n/a'     THEN ed.remarks     ELSE '' END 'HR_REMARKS',
        CASE WHEN edi.issue_name='HR'  AND ed.ed_advice != ''   AND ed.ed_advice != 'n/a'   THEN ed.ed_advice   ELSE '' END 'HR_ADVICE',
        CASE WHEN edi.issue_name='HR'  AND ed.is_followup=TRUE  THEN true ELSE false END 'HR_IS_FOLLOWUP',
        CASE WHEN edi.issue_name='HR'  AND ed.is_followup=TRUE  THEN DATE_FORMAT(ed.followup_month_for,'%M %Y') ELSE '' END 'HR_FOLLOWUP_MONTH',
        CASE WHEN edi.issue_name='HR'  AND ed.description != '' AND ed.description != 'n/a' THEN 1 ELSE 0 END 'HR_COUNT',

        CASE WHEN edi.issue_name='Be%' AND ed.description != '' AND ed.description != 'n/a' THEN ed.description ELSE '' END 'FIELD_ISSUE',
        CASE WHEN edi.issue_name='Be%' AND ed.remarks != ''     AND ed.remarks != 'n/a'     THEN ed.remarks     ELSE '' END 'FIELD_REMARKS',
        CASE WHEN edi.issue_name='Be%' AND ed.ed_advice != ''   AND ed.ed_advice != 'n/a'   THEN ed.ed_advice   ELSE '' END 'FIELD_ADVICE',
        CASE WHEN edi.issue_name='Be%'  AND ed.is_followup=TRUE  THEN true ELSE false END 'FIELD_IS_FOLLOWUP',
        CASE WHEN edi.issue_name='Be%' AND ed.is_followup=TRUE  THEN DATE_FORMAT(ed.followup_month_for,'%M %Y') ELSE '' END 'FIELD_FOLLOWUP_MONTH',

        CASE WHEN edi.issue_name='Go%' AND ed.description != '' AND ed.description != 'n/a' THEN ed.description ELSE '' END 'GOVERNMENT_ISSUE',
        CASE WHEN edi.issue_name='Go%' AND ed.remarks != ''     AND ed.remarks != 'n/a'     THEN ed.remarks     ELSE '' END 'GOVERNMENT_REMARKS',
        CASE WHEN edi.issue_name='Go%' AND ed.ed_advice != ''   AND ed.ed_advice != 'n/a'   THEN ed.ed_advice   ELSE '' END 'GOVERNMENT_ADVICE',
        CASE WHEN edi.issue_name='Go%'  AND ed.is_followup=TRUE  THEN true ELSE false END 'GOVERNMENT_IS_FOLLOWUP',
        CASE WHEN edi.issue_name='Go%' AND ed.is_followup=TRUE  THEN DATE_FORMAT(ed.followup_month_for,'%M %Y') ELSE '' END 'GOVERNMENT_FOLLOWUP_MONTH',

        CASE WHEN edi.issue_name='Do%' AND ed.description != '' AND ed.description != 'n/a' THEN ed.description ELSE '' END 'DONOR_ISSUE',
        CASE WHEN edi.issue_name='Do%' AND ed.remarks != ''     AND ed.remarks != 'n/a'     THEN ed.remarks     ELSE '' END 'DONOR_REMARKS',
        CASE WHEN edi.issue_name='Do%' AND ed.ed_advice != ''   AND ed.ed_advice != 'n/a'   THEN ed.ed_advice   ELSE '' END 'DONOR_ADVICE',
        CASE WHEN edi.issue_name='Do%' AND ed.is_followup=TRUE  THEN true ELSE false END 'DONOR_IS_FOLLOWUP',
        CASE WHEN edi.issue_name='Do%' AND ed.is_followup=TRUE  THEN DATE_FORMAT(ed.followup_month_for,'%M %Y') ELSE '' END 'DONOR_FOLLOWUP_MONTH',

        CASE WHEN edi.issue_name='Ne%' AND ed.description != '' AND ed.description != 'n/a' THEN ed.description ELSE '' END 'NEW_PROJECT_ISSUE',
        CASE WHEN edi.issue_name='Ne%' AND ed.remarks != ''     AND ed.remarks != 'n/a'     THEN ed.remarks     ELSE '' END 'NEW_PROJECT_REMARKS',
        CASE WHEN edi.issue_name='Ne%' AND ed.ed_advice != ''   AND ed.ed_advice != 'n/a'   THEN ed.ed_advice   ELSE '' END 'NEW_PROJECT_ADVICE',
        CASE WHEN edi.issue_name='Ne%' AND ed.is_followup=TRUE  THEN true ELSE false END 'NP_IS_FOLLOWUP',
        CASE WHEN edi.issue_name='Ne%' AND ed.is_followup=TRUE  THEN DATE_FORMAT(ed.followup_month_for,'%M %Y') ELSE '' END 'NP_FOLLOWUP_MONTH'

        FROM ed_dashboard_issues edi
        LEFT JOIN ed_dashboard ed ON ed.issue_id=edi.id AND MONTH(ed.month_for)=MONTH('${month}') AND YEAR(ed.month_for)=YEAR('${month}')
        LEFT JOIN pm_mcrs_log lg ON lg.month =MONTH('${month}') AND lg.year = YEAR('${month}')
        LEFT JOIN pm_service_sector ss ON ed.service_id=ss.id AND ss.is_in_sp = TRUE
        WHERE ss.id IS NOT NULL
        GROUP BY ss.id
        ORDER BY ss.short_name;
        """
        List<GroovyRowResult> lstValue = executeSelectSql(query)
        return lstValue
    }

    private List<GroovyRowResult> buildResult2List(Date month) {
        String query = """
        SELECT ss.id SERVICE_ID,ss.name SERVICE, ed.description 'ISSUE',  ed.remarks 'REMARKS', ed.ed_advice 'ADVICE',
         ed.is_followup 'IS_FOLLOWUP', DATE_FORMAT(ed.followup_month_for,'%M %Y')  'FOLLOWUP_MONTH'
        FROM ed_dashboard_issues edi
        LEFT JOIN ed_dashboard ed ON ed.issue_id=edi.id AND MONTH(ed.month_for)=MONTH('${month}') AND YEAR(ed.month_for)=YEAR('${month}')
        LEFT JOIN pm_service_sector ss ON ed.service_id=ss.id AND ss.is_in_sp = TRUE
        WHERE edi.id IN (7,8,9,10,11,12) AND ed.description IS NOT NULL AND ed.description!= 'n/a' AND ed.description!= 'N/A'
        ORDER BY ss.short_name;
        """
        List<GroovyRowResult> lstValue = executeSelectSql(query)
        return lstValue
    }
}
