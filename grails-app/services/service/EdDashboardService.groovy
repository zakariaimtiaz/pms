package service

import grails.transaction.Transactional
import groovy.sql.GroovyRowResult
import pms.BaseService
import pms.utility.DateUtility

import java.text.DateFormat
import java.text.SimpleDateFormat

@Transactional
class EdDashboardService  extends BaseService{

    public List<GroovyRowResult> lstEdDashboardIssue(long serviceId) {
        long userServiceId = currentUserObject().serviceId
        String serviceString=''
        if(serviceId>0){
            serviceString=' where ed.service_id='+ serviceId
        }
        String queryForList = """
        SELECT ed.id ,ed.version, ed.service_id AS serviceId,ss.short_name AS serShortName,ed.month_for AS monthFor,edi.id AS issueId,edi.issue_name ,
       ed.description,ed.remarks,ed.ed_advice,ed.followup_month_for AS followupMonthFor,ed.is_followup AS isFollowup,edi.is_heading,edi.is_additional,lg.is_submitted
        FROM ed_dashboard_issues edi
        RIGHT JOIN ed_dashboard ed ON ed.issue_id=edi.id
        LEFT JOIN pm_mcrs_log lg ON lg.service_id = ed.service_id AND lg.month =MONTH(ed.month_for) AND lg.year = YEAR(ed.month_for)
        LEFT JOIN pm_service_sector ss ON ed.service_id=ss.id
        """+serviceString+"""
        ORDER BY ed.service_id ASC,ed.month_for DESC,edi.id ASC;

        """
        List<GroovyRowResult>  lst = executeSelectSql(queryForList)
        return lst
    }
    public List<GroovyRowResult> lstEdDashboardIssue(long serviceId,String d ) {
        DateFormat originalFormat = new SimpleDateFormat("MMMM yyyy", Locale.ENGLISH);
        Date start = originalFormat.parse(d.toString());
        Calendar c = Calendar.getInstance();
        c.setTime(start);
        c.set(Calendar.DAY_OF_MONTH, c.getActualMinimum(Calendar.DAY_OF_MONTH));
        Date month = DateUtility.getSqlDate(c.getTime())
        long userServiceId = currentUserObject().serviceId
        String queryForList = """
        SELECT ed.id ,ed.version,edi.issue_name as issueName ,ed.description,ed.remarks,ed.ed_advice as edAdvice
        FROM  ed_dashboard_issues edi RIGHT JOIN ed_dashboard ed ON ed.issue_id=edi.id
        AND ed.service_id = ${serviceId} AND DATE(ed.month_for)=DATE('${month}') WHERE edi.is_heading<>1 AND is_followup<>1
        ORDER BY edi.id
        """
        List<GroovyRowResult>  lst = executeSelectSql(queryForList)
        return lst
    }
    public List<GroovyRowResult> lstEdDashboardSectorOrCSUIssue(long serviceId,Date month) {
        String queryForList = """
        SELECT id,issue_name AS name FROM ed_dashboard_issues WHERE is_additional<>TRUE AND id NOT IN
            (SELECT issue_id FROM ed_dashboard WHERE service_id=${serviceId} AND MONTH(month_for)=MONTH('${month}') AND YEAR(month_for)=YEAR('${month}'))
        ORDER BY id ASC
        """
        List<GroovyRowResult>  lst = executeSelectSql(queryForList)
        return lst
    }
    public List<GroovyRowResult> lstEdDashboardDescriptionAndRemarks(long serviceId,Date month,long issuesId) {
        String queryForList = """
        SELECT description,GROUP_CONCAT(CONCAT('<FONT color="#79a9f7">',MONTHNAME(month_for),':</FONT>\\<br />\\<b> Remarks: \\</b>',remarks,'\\<br />\\<b>ED\\\'s Advice: \\</b>',ed_advice)SEPARATOR'\\<br />') AS remarks
            FROM ed_dashboard WHERE service_id=${serviceId} AND (month_for=DATE('${month}') OR followup_month_for=DATE('${month}')) AND issue_id='${issuesId}'
            GROUP BY description
        """
        List<GroovyRowResult>  lst = executeSelectSql(queryForList)
        return lst
    }
    public long minimumAdditionalIssuesId(long serviceId,Date month) {
        String query = """
        SELECT CASE WHEN COALESCE(MAX(ed.issue_id),0)>6 THEN MAX(ed.issue_id)+1 ELSE MIN(edi.id) END AS cnt
        FROM ed_dashboard_issues edi LEFT JOIN ed_dashboard ed ON edi.id=ed.issue_id AND
        ed.service_id=${serviceId} AND MONTH(ed.month_for)=MONTH('${month}') AND YEAR(ed.month_for)=YEAR('${month}') AND ed.is_followup<>1
        WHERE  edi.is_additional<>0
        """
        List<GroovyRowResult> max = executeSelectSql(query)
        long con = max[0].count
        return con
    }
    public List<GroovyRowResult> lstUnresolveEdDashboardIssue(long serviceId,String d ) {
        DateFormat originalFormat = new SimpleDateFormat("MMMM yyyy", Locale.ENGLISH);
        Date start = originalFormat.parse(d.toString());
        Calendar c = Calendar.getInstance();
        c.setTime(start);
        c.set(Calendar.DAY_OF_MONTH, c.getActualMinimum(Calendar.DAY_OF_MONTH));
        Date month = DateUtility.getSqlDate(c.getTime())
        long userServiceId = currentUserObject().serviceId
        String queryForList = """
     SELECT ed.id ,ed.version,edi.issue_name ,ed.description,ed.remarks,ed.ed_advice,ed.is_resolve
,ed.is_followup,ed.followup_month_for,CONCAT(MONTHNAME(ed.month_for),' ',YEAR(ed.month_for)) AS issuedMonthStr
,CASE WHEN ed.is_followup=1 AND ed.is_resolve <> 1 THEN 'Follow-up' WHEN ed.is_resolve = 1 THEN 'Resolve' ELSE 'Unresolve' END AS issue_status
 FROM  ed_dashboard ed INNER JOIN ed_dashboard_issues edi ON ed.issue_id=edi.id
INNER JOIN pm_mcrs_log lg ON lg.service_id = ed.service_id AND MONTH(ed.month_for)=MONTH(lg.submission_date_db) AND YEAR(ed.month_for)>= YEAR(lg.submission_date_db)
WHERE ed.service_id = ${serviceId}  AND COALESCE(lg.is_submitted_db,FALSE) =1 AND DATE(ed.month_for)<DATE('${month}') AND ((ed.is_followup<>1
AND ed.is_resolve <> 1) OR COALESCE(MONTH(ed.status_change_date),DATE('${month}'))> MONTH(lg.submission_date_db) AND COALESCE(YEAR(ed.status_change_date),DATE('${month}'))>= YEAR(lg.submission_date_db))
GROUP BY  ed.issue_id,ed.month_for
ORDER BY ed.issue_id,ed.month_for;
        """
        List<GroovyRowResult>  lst = executeSelectSql(queryForList)
        return lst
    }
}
