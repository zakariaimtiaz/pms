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
        SELECT  edi.id ,edi.version,edi.issue_name ,ed.description,ed.remarks,ed.ed_advice,edi.is_heading,edi.is_additional
                ,CASE WHEN lg.is_submitted THEN TRUE ELSE FALSE END AS crisis_remarks_g,
                CASE WHEN ${userServiceId}!=${serviceId} THEN TRUE ELSE CASE WHEN lg.is_submitted THEN TRUE ELSE FALSE END END AS crisis_remarks_s,
                TRUE AS advice_g,FALSE AS advice_s
        FROM ed_dashboard_issues edi
        LEFT JOIN ed_dashboard ed ON ed.service_id = ${serviceId} AND ed.issue_id=edi.id AND MONTH(ed.month_for)=MONTH('${month}') AND YEAR(ed.month_for)=YEAR('${month}')
        LEFT JOIN pm_mcrs_log lg ON lg.service_id = ${serviceId} AND lg.month =MONTH('${month}') AND lg.year = YEAR('${month}')
        LEFT JOIN pm_service_sector ss ON ed.service_id=ss.id
        ORDER BY edi.id;
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
}
