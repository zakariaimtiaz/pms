package actions.reports.dashboard

import com.pms.SecRole
import com.pms.SecUser
import com.pms.SecUserSecRole
import grails.plugin.springsecurity.SpringSecurityService
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
    BaseService baseService
    SpringSecurityService springSecurityService

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
            List<Long> lst = currentUserDepartmentList()
            boolean isRestricted=baseService.isUserDashboardRestricted(springSecurityService.principal.id)
            String restrictedStr = EMPTY_SPACE
            if(isRestricted){
                restrictedStr= " AND COALESCE(ss.is_restricted,FALSE) <> TRUE"
            }

            String serviceStr = EMPTY_SPACE
            if (serviceId > 0) {
                serviceStr = " AND ss.id = ${serviceId}"
            }
            if(serviceId == 0 && lst.size() > 1){
                String serviceIds = buildCommaSeparatedStringOfIds(lst)
                serviceStr = " AND ss.id IN (${serviceIds})"
            }
            String monthStr = result.month.toString()
            DateFormat originalFormat = new SimpleDateFormat("MMMM yyyy", Locale.ENGLISH);

            Date date = originalFormat.parse(monthStr);
            Calendar c = Calendar.getInstance();
            c.setTime(date);
            Date month = DateUtility.getSqlDate(c.getTime());
            String statusType=result.statusType;

            if (result.containsKey("hr")) {
                List lstVal = buildResultList(month, 1L, serviceStr,statusType,restrictedStr)
                result.put("hr", lstVal)
                result.put("hrCount", lstVal.size())
            }
            if (result.containsKey("fld")) {
                List lstVal = buildResultList(month, 2L, serviceStr,statusType,restrictedStr)
                result.put("fld", lstVal)
                result.put("fldCount", lstVal.size())
            }
            if (result.containsKey("govt")) {
                List lstVal = buildResultList(month, 3L, serviceStr,statusType,restrictedStr)
                result.put("govt", lstVal)
                result.put("govtCount", lstVal.size())
            }
            if (result.containsKey("dnr")) {
                List lstVal = buildResultList(month, 4L, serviceStr,statusType,restrictedStr)
                result.put("dnr", lstVal)
                result.put("dnrCount", lstVal.size())
            }
            if (result.containsKey("np")) {
                List lstVal = buildResultList(month, 5L, serviceStr,statusType,restrictedStr)
                result.put("np", lstVal)
                result.put("npCount", lstVal.size())
            }
            if (result.containsKey("cssp")) {
                List lstVal = buildResultCsspList(month, serviceStr,statusType,restrictedStr)
                result.put("cssp", lstVal)
                result.put("csspCount", lstVal.size())
            }
            if (result.containsKey("noIssue")) {
                List lstVal = buildResultNoIssueList(month, serviceStr,restrictedStr)
                result.put("noIssue", lstVal)
                result.put("noIssueCount", lstVal.size())
            }
            if (result.containsKey("notSubmitted")) {
                List lstVal = buildResultNotSubmittedList(month, serviceStr,restrictedStr)
                result.put("notSubmitted", lstVal)
                result.put("notSubmitCount", lstVal.size())
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

    private List<GroovyRowResult> buildResultList(Date month, long issueId, String serviceStr,String statusType,String restrictedStr) {
        String query = """
        SELECT ed.id 'ID',ss.id 'SERVICE_ID',ss.name 'SERVICE', ed.description 'ISSUE', ed.remarks 'REMARKS', ed.ed_advice 'ADVICE',
        CASE WHEN ed.is_followup = TRUE  THEN TRUE ELSE FALSE END 'IS_FOLLOWUP',
        CASE WHEN ed.is_followup = TRUE  THEN DATE_FORMAT(ed.followup_month_for,'%M %Y') ELSE '' END 'FOLLOWUP_MONTH'
        FROM ed_dashboard_issues edi
        LEFT JOIN ed_dashboard ed ON ed.issue_id=edi.id AND MONTH(ed.month_for)=MONTH('${month}')
        AND YEAR(ed.month_for)=YEAR('${month}')
        LEFT JOIN pm_mcrs_log lg ON lg.month =MONTH('${month}') AND lg.year = YEAR('${month}')
        LEFT JOIN pm_service_sector ss ON ed.service_id=ss.id AND ss.is_in_sp = TRUE
        WHERE edi.id = ${issueId} AND ed.description IS NOT NULL AND ed.description != '' AND ed.description != 'n/a'
        AND ed.description != 'na' AND ed.description != 'NA' AND ed.description != 'N/A'
        AND ss.id IN (
           SELECT DISTINCT(service_id) FROM pm_mcrs_log
                  WHERE is_submitted_db = TRUE AND MONTH = MONTH('${month}') AND YEAR=YEAR('${month}')
            )
        ${serviceStr} ${restrictedStr}
        GROUP BY ss.id
        ORDER BY ss.short_name;
        """
        if(statusType=="Resolved Issue"){
            query = """
        SELECT ed.id 'ID',ss.id 'SERVICE_ID',ss.name 'SERVICE', ed.description 'ISSUE', ed.remarks 'REMARKS', ed.ed_advice 'ADVICE',
        CASE WHEN ed.is_followup = TRUE  THEN TRUE ELSE FALSE END 'IS_FOLLOWUP',
        CASE WHEN ed.is_followup = TRUE  THEN DATE_FORMAT(ed.followup_month_for,'%M %Y') ELSE '' END 'FOLLOWUP_MONTH'
        FROM ed_dashboard_issues edi
        LEFT JOIN ed_dashboard ed ON ed.issue_id=edi.id
        LEFT JOIN pm_mcrs_log lg ON lg.month =MONTH(ed.month_for) AND lg.year = YEAR(ed.month_for)
        LEFT JOIN pm_service_sector ss ON ed.service_id=ss.id AND ss.is_in_sp = TRUE
        WHERE edi.id = ${issueId} AND ed.description IS NOT NULL AND ed.description != '' AND ed.description != 'n/a'
        AND ed.description != 'na' AND ed.description != 'NA' AND ed.description != 'N/A' AND ed.is_resolve=1
        ${serviceStr} ${restrictedStr}
        GROUP BY ss.id
        ORDER BY ss.short_name;
        """
        }
        else if(statusType=="Upcoming Issue"){
            query = """
        SELECT ed.id 'ID',ss.id 'SERVICE_ID',ss.name 'SERVICE', ed.description 'ISSUE', ed.remarks 'REMARKS', ed.ed_advice 'ADVICE',
        CASE WHEN ed.is_followup = TRUE  THEN TRUE ELSE FALSE END 'IS_FOLLOWUP',
        CASE WHEN ed.is_followup = TRUE  THEN DATE_FORMAT(ed.followup_month_for,'%M %Y') ELSE '' END 'FOLLOWUP_MONTH'
        FROM ed_dashboard_issues edi
        LEFT JOIN ed_dashboard ed ON ed.issue_id=edi.id
        LEFT JOIN pm_mcrs_log lg ON lg.month =MONTH(ed.month_for) AND lg.year = YEAR(ed.month_for)
        LEFT JOIN pm_service_sector ss ON ed.service_id=ss.id AND ss.is_in_sp = TRUE
        WHERE edi.id = ${issueId} AND ed.description IS NOT NULL AND ed.description != '' AND ed.description != 'n/a'
        AND ed.description != 'na' AND ed.description != 'NA' AND ed.description != 'N/A' AND ed.month_for>DATE('${month}')
        AND ed.is_followup=1
        ${serviceStr} ${restrictedStr}
        GROUP BY ss.id
        ORDER BY ss.short_name;
        """
        }
        List<GroovyRowResult> lstValue = executeSelectSql(query)
        return lstValue
    }

    private List<GroovyRowResult> buildResultCsspList(Date month, String serviceStr,String statusType,String restrictedStr) {
        String query = """
        SELECT ed.id 'ID',ss.id 'SERVICE_ID',ss.name 'SERVICE', ed.description 'ISSUE',  ed.remarks 'REMARKS',
         ed.ed_advice 'ADVICE', ed.is_followup 'IS_FOLLOWUP', DATE_FORMAT(ed.followup_month_for,'%M %Y')  'FOLLOWUP_MONTH'
        FROM ed_dashboard_issues edi
        LEFT JOIN ed_dashboard ed ON ed.issue_id=edi.id AND MONTH(ed.month_for)=MONTH('${month}')
        AND YEAR(ed.month_for)=YEAR('${month}')
        LEFT JOIN pm_service_sector ss ON ed.service_id=ss.id AND ss.is_in_sp = TRUE
        WHERE edi.id IN (7,8,9,10,11,12,13,14,15,16,17,18,19,20) AND ed.description IS NOT NULL AND ed.description != '' AND ed.description != 'n/a'
        AND ed.description != 'na' AND ed.description != 'NA' AND ed.description != 'N/A'
        AND ss.id IN (
           SELECT DISTINCT(service_id) FROM pm_mcrs_log
                  WHERE is_submitted_db = TRUE AND MONTH = MONTH('${month}') AND YEAR=YEAR('${month}')
            )
        ${serviceStr} ${restrictedStr}
        ORDER BY ss.short_name;
        """
        if(statusType=="Resolved Issue") {
            query = """
        SELECT ed.id 'ID',ss.id 'SERVICE_ID',ss.name 'SERVICE', ed.description 'ISSUE',  ed.remarks 'REMARKS',
         ed.ed_advice 'ADVICE', ed.is_followup 'IS_FOLLOWUP', DATE_FORMAT(ed.followup_month_for,'%M %Y')  'FOLLOWUP_MONTH'
        FROM ed_dashboard_issues edi
        LEFT JOIN ed_dashboard ed ON ed.issue_id=edi.id
        LEFT JOIN pm_service_sector ss ON ed.service_id=ss.id AND ss.is_in_sp = TRUE
        WHERE edi.id IN (7,8,9,10,11,12,13,14,15,16,17,18,19,20) AND ed.description IS NOT NULL AND ed.description != '' AND ed.description != 'n/a'
        AND ed.description != 'na' AND ed.description != 'NA' AND ed.description != 'N/A' AND ed.is_resolve=1
        ${serviceStr} ${restrictedStr}
        ORDER BY ss.short_name;
        """
        }
        else if(statusType=="Upcoming Issue"){
            query = """
        SELECT ed.id 'ID',ss.id 'SERVICE_ID',ss.name 'SERVICE', ed.description 'ISSUE',  ed.remarks 'REMARKS',
         ed.ed_advice 'ADVICE', ed.is_followup 'IS_FOLLOWUP', DATE_FORMAT(ed.followup_month_for,'%M %Y')  'FOLLOWUP_MONTH'
        FROM ed_dashboard_issues edi
        LEFT JOIN ed_dashboard ed ON ed.issue_id=edi.id
        LEFT JOIN pm_service_sector ss ON ed.service_id=ss.id AND ss.is_in_sp = TRUE
        WHERE edi.id IN (7,8,9,10,11,12,13,14,15,16,17,18,19,20) AND ed.description IS NOT NULL AND ed.description != '' AND ed.description != 'n/a'
        AND ed.description != 'na' AND ed.description != 'NA' AND ed.description != 'N/A' AND ed.month_for>DATE('${month}')
        AND ed.is_followup=1
        ${serviceStr} ${restrictedStr}
        ORDER BY ss.short_name;
        """
        }
        List<GroovyRowResult> lstValue = executeSelectSql(query)
        return lstValue
    }

    private List<GroovyRowResult> buildResultNoIssueList(Date month, String serviceStr,String restrictedStr) {
        String query = """
        SELECT ss.id ID,ss.id SERVICE_ID,ss.name SERVICE, ss.department_head  DEPARTMENT_HEAD
        FROM pm_service_sector ss
        WHERE ss.is_displayble = TRUE AND ss.is_in_sp = TRUE
        AND ss.id NOT IN (
           SELECT DISTINCT(service_id) FROM pm_mcrs_log
                  WHERE is_submitted_db <> TRUE AND month_str = MONTHNAME('${month}')
            )
        AND ss.id NOT IN (
            SELECT DISTINCT(service_id)
            FROM ed_dashboard
            WHERE month_for = '${month}' OR followup_month_for = '${month}'
            )
        ${serviceStr} ${restrictedStr}
        ORDER BY ss.name ASC;
        """
        List<GroovyRowResult> lstValue = executeSelectSql(query)
        return lstValue
    }
    private List<GroovyRowResult> buildResultNotSubmittedList(Date month, String serviceStr,String restrictedStr) {
        String query = """
        SELECT ss.id ID, ss.id SERVICE_ID, ss.name SERVICE
            FROM pm_mcrs_log l
        LEFT JOIN pm_service_sector ss ON l.service_id = ss.id AND ss.is_in_sp = TRUE
            WHERE l.is_submitted_db <> TRUE AND l.month = MONTH('${month}') AND l.year=YEAR('${month}')
            ${serviceStr} ${restrictedStr}
        ORDER BY ss.name ASC;
        """
        List<GroovyRowResult> lstValue = executeSelectSql(query)
        return lstValue
    }
}
