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
            long serviceId = Long.parseLong(result.serviceId.toString())
            String serviceStr = EMPTY_SPACE
            if(serviceId > 0){
                serviceStr = " AND ss.id = ${serviceId}"
            }

            String monthStr = result.month.toString()
            DateFormat originalFormat = new SimpleDateFormat("MMMM yyyy", Locale.ENGLISH);

            Date date = originalFormat.parse(monthStr);
            Calendar c = Calendar.getInstance();
            c.setTime(date);
            Date month = DateUtility.getSqlDate(c.getTime());

            if (result.containsKey("hr")) {
                List lstVal = buildResultHRList(month,serviceStr)
                result.put("hr", lstVal)
                result.put("hrCount", lstVal.size())
            }
            if (result.containsKey("fld")) {
                List lstVal = buildResultFLDList(month,serviceStr)
                result.put("fld", lstVal)
                result.put("fldCount", lstVal.size())
            }
            if (result.containsKey("govt")) {
                List lstVal = buildResultGOVTList(month,serviceStr)
                result.put("govt", lstVal)
                result.put("govtCount", lstVal.size())
            }
            if (result.containsKey("dnr")) {
                List lstVal = buildResultDNRList(month,serviceStr)
                result.put("dnr", lstVal)
                result.put("dnrCount", lstVal.size())
            }
            if (result.containsKey("np")) {
                List lstVal = buildResultNPList(month,serviceStr)
                result.put("np", lstVal)
                result.put("npCount", lstVal.size())
            }
            if (result.containsKey("cssp")) {
                List lstVal = buildResultCsspList(month,serviceStr)
                result.put("cssp", lstVal)
                result.put("csspCount", lstVal.size())
            }
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

    private List<GroovyRowResult> buildResultHRList(Date month, String serviceStr) {
        String query = """
        SELECT ss.id 'SERVICE_ID',ss.name 'SERVICE',
        CASE WHEN edi.id=1  AND ed.description != '' AND ed.description != 'n/a' THEN ed.description ELSE '' END 'HR_ISSUE',
        CASE WHEN edi.id=1  AND ed.remarks != ''     AND ed.remarks != 'n/a'     THEN ed.remarks     ELSE '' END 'HR_REMARKS',
        CASE WHEN edi.id=1  AND ed.ed_advice != ''   AND ed.ed_advice != 'n/a'   THEN ed.ed_advice   ELSE '' END 'HR_ADVICE',
        CASE WHEN edi.id=1  AND ed.is_followup=TRUE  THEN TRUE ELSE FALSE END 'HR_IS_FOLLOWUP',
        CASE WHEN edi.id=1  AND ed.is_followup=TRUE  THEN DATE_FORMAT(ed.followup_month_for,'%M %Y') ELSE '' END 'HR_FOLLOWUP_MONTH',
        CASE WHEN edi.id=1  AND ed.description != '' AND ed.description != 'n/a' THEN 1 ELSE 0 END 'HR_COUNT'
        FROM ed_dashboard_issues edi
        LEFT JOIN ed_dashboard ed ON ed.issue_id=edi.id AND MONTH(ed.month_for)=MONTH('${month}')
        AND YEAR(ed.month_for)=YEAR('${month}')
        LEFT JOIN pm_mcrs_log lg ON lg.month =MONTH('${month}') AND lg.year = YEAR('${month}')
        LEFT JOIN pm_service_sector ss ON ed.service_id=ss.id AND ss.is_in_sp = TRUE
        WHERE edi.id = 1 AND ed.description IS NOT NULL AND ed.description != '' AND ed.description != 'n/a'
        AND ed.description != 'na' AND ed.description != 'NA' AND ed.description != 'N/A'
        ${serviceStr}
        GROUP BY ss.id
        ORDER BY ss.short_name;
        """
        List<GroovyRowResult> lstValue = executeSelectSql(query)
        return lstValue
    }

    private List<GroovyRowResult> buildResultFLDList(Date month, String serviceStr) {
        String query = """
        SELECT ss.id 'SERVICE_ID',ss.name 'SERVICE',
        CASE WHEN edi.id=2 AND ed.description != '' AND ed.description != 'n/a' THEN ed.description ELSE '' END 'FIELD_ISSUE',
        CASE WHEN edi.id=2 AND ed.remarks != ''     AND ed.remarks != 'n/a'     THEN ed.remarks     ELSE '' END 'FIELD_REMARKS',
        CASE WHEN edi.id=2 AND ed.ed_advice != ''   AND ed.ed_advice != 'n/a'   THEN ed.ed_advice   ELSE '' END 'FIELD_ADVICE',
        CASE WHEN edi.id=2 AND ed.is_followup=TRUE  THEN TRUE ELSE FALSE END 'FIELD_IS_FOLLOWUP',
        CASE WHEN edi.id=2 AND ed.is_followup=TRUE  THEN DATE_FORMAT(ed.followup_month_for,'%M %Y') ELSE '' END 'FIELD_FOLLOWUP_MONTH'
        FROM ed_dashboard_issues edi
        LEFT JOIN ed_dashboard ed ON ed.issue_id=edi.id AND MONTH(ed.month_for)=MONTH('${month}')
        AND YEAR(ed.month_for)=YEAR('${month}')
        LEFT JOIN pm_mcrs_log lg ON lg.month =MONTH('${month}') AND lg.year = YEAR('${month}')
        LEFT JOIN pm_service_sector ss ON ed.service_id=ss.id AND ss.is_in_sp = TRUE
        WHERE edi.id = 2 AND ed.description IS NOT NULL AND ed.description != '' AND ed.description != 'n/a'
        AND ed.description != 'na' AND ed.description != 'NA' AND ed.description != 'N/A'
        ${serviceStr}
        GROUP BY ss.id
        ORDER BY ss.short_name;
        """
        List<GroovyRowResult> lstValue = executeSelectSql(query)
        return lstValue
    }

    private List<GroovyRowResult> buildResultGOVTList(Date month, String serviceStr) {
        String query = """
        SELECT ss.id 'SERVICE_ID',ss.name 'SERVICE',
        CASE WHEN edi.id=3 AND ed.description != '' AND ed.description != 'n/a' THEN ed.description ELSE '' END 'GOVERNMENT_ISSUE',
        CASE WHEN edi.id=3 AND ed.remarks != ''     AND ed.remarks != 'n/a'     THEN ed.remarks     ELSE '' END 'GOVERNMENT_REMARKS',
        CASE WHEN edi.id=3 AND ed.ed_advice != ''   AND ed.ed_advice != 'n/a'   THEN ed.ed_advice   ELSE '' END 'GOVERNMENT_ADVICE',
        CASE WHEN edi.id=3 AND ed.is_followup=TRUE  THEN TRUE ELSE FALSE END 'GOVERNMENT_IS_FOLLOWUP',
        CASE WHEN edi.id=3 AND ed.is_followup=TRUE  THEN DATE_FORMAT(ed.followup_month_for,'%M %Y') ELSE '' END 'GOVERNMENT_FOLLOWUP_MONTH'
        FROM ed_dashboard_issues edi
        LEFT JOIN ed_dashboard ed ON ed.issue_id=edi.id AND MONTH(ed.month_for)=MONTH('${month}')
        AND YEAR(ed.month_for)=YEAR('${month}')
        LEFT JOIN pm_mcrs_log lg ON lg.month =MONTH('${month}') AND lg.year = YEAR('${month}')
        LEFT JOIN pm_service_sector ss ON ed.service_id=ss.id AND ss.is_in_sp = TRUE
        WHERE edi.id = 3 AND ed.description IS NOT NULL AND ed.description != '' AND ed.description != 'n/a'
        AND ed.description != 'na' AND ed.description != 'NA' AND ed.description != 'N/A'
        ${serviceStr}
        GROUP BY ss.id
        ORDER BY ss.short_name;
        """
        List<GroovyRowResult> lstValue = executeSelectSql(query)
        return lstValue
    }

    private List<GroovyRowResult> buildResultDNRList(Date month, String serviceStr) {
        String query = """
        SELECT ss.id 'SERVICE_ID',ss.name 'SERVICE',
        CASE WHEN edi.id=4 AND ed.description != '' AND ed.description != 'n/a' THEN ed.description ELSE '' END 'DONOR_ISSUE',
        CASE WHEN edi.id=4 AND ed.remarks != ''     AND ed.remarks != 'n/a'     THEN ed.remarks     ELSE '' END 'DONOR_REMARKS',
        CASE WHEN edi.id=4 AND ed.ed_advice != ''   AND ed.ed_advice != 'n/a'   THEN ed.ed_advice   ELSE '' END 'DONOR_ADVICE',
        CASE WHEN edi.id=4 AND ed.is_followup=TRUE  THEN TRUE ELSE FALSE END 'DONOR_IS_FOLLOWUP',
        CASE WHEN edi.id=4 AND ed.is_followup=TRUE  THEN DATE_FORMAT(ed.followup_month_for,'%M %Y') ELSE '' END 'DONOR_FOLLOWUP_MONTH'
        FROM ed_dashboard_issues edi
        LEFT JOIN ed_dashboard ed ON ed.issue_id=edi.id AND MONTH(ed.month_for)=MONTH('${month}')
        AND YEAR(ed.month_for)=YEAR('${month}')
        LEFT JOIN pm_mcrs_log lg ON lg.month =MONTH('${month}') AND lg.year = YEAR('${month}')
        LEFT JOIN pm_service_sector ss ON ed.service_id=ss.id AND ss.is_in_sp = TRUE
        WHERE edi.id = 4 AND ed.description IS NOT NULL AND ed.description != '' AND ed.description != 'n/a'
        AND ed.description != 'na' AND ed.description != 'NA' AND ed.description != 'N/A'
        ${serviceStr}
        GROUP BY ss.id
        ORDER BY ss.short_name;
        """
        List<GroovyRowResult> lstValue = executeSelectSql(query)
        return lstValue
    }

    private List<GroovyRowResult> buildResultNPList(Date month, String serviceStr) {
        String query = """
        SELECT ss.id 'SERVICE_ID',ss.name 'SERVICE',
        CASE WHEN edi.id=5 AND ed.description != '' AND ed.description != 'n/a' THEN ed.description ELSE '' END 'NEW_PROJECT_ISSUE',
        CASE WHEN edi.id=5 AND ed.remarks != ''     AND ed.remarks != 'n/a'     THEN ed.remarks     ELSE '' END 'NEW_PROJECT_REMARKS',
        CASE WHEN edi.id=5 AND ed.ed_advice != ''   AND ed.ed_advice != 'n/a'   THEN ed.ed_advice   ELSE '' END 'NEW_PROJECT_ADVICE',
        CASE WHEN edi.id=5 AND ed.is_followup=TRUE  THEN TRUE ELSE FALSE END 'NP_IS_FOLLOWUP',
        CASE WHEN edi.id=5 AND ed.is_followup=TRUE  THEN DATE_FORMAT(ed.followup_month_for,'%M %Y') ELSE '' END 'NP_FOLLOWUP_MONTH'

        FROM ed_dashboard_issues edi
        LEFT JOIN ed_dashboard ed ON ed.issue_id=edi.id AND MONTH(ed.month_for)=MONTH('${month}')
        AND YEAR(ed.month_for)=YEAR('${month}')
        LEFT JOIN pm_mcrs_log lg ON lg.month =MONTH('${month}') AND lg.year = YEAR('${month}')
        LEFT JOIN pm_service_sector ss ON ed.service_id=ss.id AND ss.is_in_sp = TRUE
        WHERE edi.id = 5 AND ed.description IS NOT NULL AND ed.description != '' AND ed.description != 'n/a'
        AND ed.description != 'na' AND ed.description != 'NA' AND ed.description != 'N/A'
        ${serviceStr}
        GROUP BY ss.id
        ORDER BY ss.short_name;
        """
        List<GroovyRowResult> lstValue = executeSelectSql(query)
        return lstValue
    }

    private List<GroovyRowResult> buildResultCsspList(Date month, String serviceStr) {
        String query = """
        SELECT ss.id 'SERVICE_ID',ss.name 'SERVICE', ed.description 'ISSUE',  ed.remarks 'REMARKS',
         ed.ed_advice 'ADVICE', ed.is_followup 'IS_FOLLOWUP', DATE_FORMAT(ed.followup_month_for,'%M %Y')  'FOLLOWUP_MONTH'
        FROM ed_dashboard_issues edi
        LEFT JOIN ed_dashboard ed ON ed.issue_id=edi.id AND MONTH(ed.month_for)=MONTH('${month}')
        AND YEAR(ed.month_for)=YEAR('${month}')
        LEFT JOIN pm_service_sector ss ON ed.service_id=ss.id AND ss.is_in_sp = TRUE
        WHERE edi.id IN (7,8,9,10,11,12) AND ed.description IS NOT NULL AND ed.description != '' AND ed.description != 'n/a'
        AND ed.description != 'na' AND ed.description != 'NA' AND ed.description != 'N/A'
        ${serviceStr}
        ORDER BY ss.short_name;
        """
        List<GroovyRowResult> lstValue = executeSelectSql(query)
        return lstValue
    }
}
