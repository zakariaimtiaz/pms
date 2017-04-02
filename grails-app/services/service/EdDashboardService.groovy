package service

import grails.transaction.Transactional
import groovy.sql.GroovyRowResult
import pms.BaseService

@Transactional
class EdDashboardService  extends BaseService{

    public List<GroovyRowResult> lstEdDashboardIssue(long serviceId,Date month) {
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
