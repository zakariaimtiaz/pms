package actions.reports.dashboard

import grails.transaction.Transactional
import groovy.sql.GroovyRowResult
import org.apache.log4j.Logger
import pms.ActionServiceIntf
import pms.BaseService
import pms.utility.DateUtility
import pms.utility.Tools

import java.text.DateFormat
import java.text.SimpleDateFormat

@Transactional
class IssueCounterEdDashBoardActionService extends BaseService implements ActionServiceIntf {

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
            GroovyRowResult obj = buildResult1List(month)
            int count = buildResult2List(month)

            Map resultMap = new LinkedHashMap()
            resultMap.put('HR_COUNT',obj?obj.getAt('HR_COUNT'):0)
            resultMap.put('FIELD_COUNT',obj?obj.getAt('FIELD_COUNT'):0)
            resultMap.put('GOVERNMENT_COUNT',obj?obj.getAt('GOVERNMENT_COUNT'):0)
            resultMap.put('DONOR_COUNT',obj?obj.getAt('DONOR_COUNT'):0)
            resultMap.put('NEW_PROJECT_COUNT',obj?obj.getAt('NEW_PROJECT_COUNT'):0)
            resultMap.put('SP_COUNT',count)

            result.put('counter', resultMap)
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

    private GroovyRowResult buildResult1List(Date month) {
        String query = """
        SELECT SUM(HR_COUNT) HR_COUNT,SUM(FIELD_COUNT) FIELD_COUNT,SUM(GOVERNMENT_COUNT) GOVERNMENT_COUNT,SUM(DONOR_COUNT) DONOR_COUNT,SUM(NEW_PROJECT_COUNT) NEW_PROJECT_COUNT
        FROM
        (SELECT ss.id SERVICE_ID,1 tmp_id,
        CASE WHEN edi.issue_name='HR'   AND ed.description != '' AND ed.description != 'n/a' THEN 1 ELSE 0 END 'HR_COUNT',
        CASE WHEN edi.issue_name='Be%'  AND ed.description != '' AND ed.description != 'n/a' THEN 1 ELSE 0 END 'FIELD_COUNT',
        CASE WHEN edi.issue_name='Go%'  AND ed.description != '' AND ed.description != 'n/a' THEN 1 ELSE 0 END 'GOVERNMENT_COUNT',
        CASE WHEN edi.issue_name='Do%'  AND ed.description != '' AND ed.description != 'n/a' THEN 1 ELSE 0 END 'DONOR_COUNT',
        CASE WHEN edi.issue_name='Ne%'  AND ed.description != '' AND ed.description != 'n/a' THEN 1 ELSE 0 END 'NEW_PROJECT_COUNT'

        FROM ed_dashboard_issues edi
        LEFT JOIN ed_dashboard ed ON ed.issue_id=edi.id AND MONTH(ed.month_for)=MONTH('${month}') AND YEAR(ed.month_for)=YEAR('${month}')
        LEFT JOIN pm_mcrs_log lg ON lg.month =MONTH('${month}') AND lg.year = YEAR('${month}')
        LEFT JOIN pm_service_sector ss ON ed.service_id=ss.id AND ss.is_in_sp = TRUE
        WHERE ss.id IS NOT NULL
        GROUP BY ss.id
        ORDER BY ss.short_name) tmp GROUP BY tmp_id;
        """
        List<GroovyRowResult> grrList = executeSelectSql(query)
        return grrList[0]
    }

    private int buildResult2List(Date month) {
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
        return lstValue.size()
    }
}
