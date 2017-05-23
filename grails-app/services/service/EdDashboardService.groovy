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
        SELECT tbl.*,CASE WHEN lg.is_submitted THEN TRUE ELSE FALSE END AS crisis_remarks_g,
                CASE WHEN ${userServiceId}!=${serviceId} THEN TRUE ELSE CASE WHEN lg.is_submitted THEN TRUE ELSE FALSE END END AS crisis_remarks_s,
                TRUE AS advice_g,FALSE AS advice_s
         FROM (SELECT  edi.id ,edi.version,edi.issue_name ,ed.description,ed.remarks,ed.ed_advice,edi.is_heading,edi.is_additional
        ,ed.is_followup,ed.followup_month_for FROM  ed_dashboard_issues edi LEFT JOIN ed_dashboard ed ON ed.issue_id=edi.id
        AND ed.service_id = ${serviceId} AND DATE(ed.month_for)=DATE('${month}') WHERE (edi.is_additional<>1 OR edi.is_heading<>0)
        UNION ALL
        SELECT edi.id ,edi.version,edi.issue_name ,ed.description,ed.remarks,ed.ed_advice,edi.is_heading,edi.is_additional
        ,ed.is_followup,ed.followup_month_for FROM  ed_dashboard_issues edi RIGHT JOIN ed_dashboard ed ON ed.issue_id=edi.id
        AND ed.service_id = ${serviceId} AND DATE(ed.month_for)=DATE('${month}') WHERE edi.is_additional=1)tbl
        LEFT JOIN pm_mcrs_log lg ON lg.service_id = ${serviceId} AND lg.month =MONTH('${month}') AND lg.year = YEAR('${month}')
        LEFT JOIN pm_service_sector ss ON ss.id=${serviceId}
        ORDER BY tbl.id;
        """
        List<GroovyRowResult>  lst = executeSelectSql(queryForList)
        return lst
    }
    public List<GroovyRowResult> lstEdDashboardSectorOrCSUIssue(long serviceId,Date month) {
        String queryForList = """
        SELECT  ed.id ,ed.description AS name
        FROM ed_dashboard_issues edi
        INNER JOIN ed_dashboard ed ON ed.service_id = ${serviceId} AND ed.issue_id=edi.id AND MONTH(ed.month_for)=MONTH('${month}') AND YEAR(ed.month_for)=YEAR('${month}')
        WHERE edi.is_additional =TRUE
        ORDER BY edi.id;
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
    public long minimumAdditionalIssuesId() {
        String query = """
        SELECT MIN(id) AS COUNT FROM ed_dashboard_issues WHERE is_additional=1 AND is_heading<>1
        """
        List<GroovyRowResult> max = executeSelectSql(query)
        long con = max[0].count
        return con
    }
}
