package service

import com.pms.SecUser
import grails.transaction.Transactional
import groovy.sql.GroovyRowResult
import pms.BaseService

@Transactional
class EdDashboardService  extends BaseService{

    public List<GroovyRowResult> lstEdDashboardIssue(long serviceId,Date monthFor) {
        SecUser user = currentUserObject()

        String queryForList = """

                 SELECT  edi.id ,edi.version,edi.issue_name ,ed.description,ed.remarks,ed.ed_advice,edi.is_heading,
                @submission_date:=COALESCE((SELECT MAX(submission_date) FROM pm_mcrs_log WHERE service_id=9 AND is_submitted=TRUE),'1901-01-01'),
                  CASE WHEN MONTH('${monthFor}')<MONTH(@submission_date)
                  AND YEAR('${monthFor}')<=YEAR(@submission_date)
                  THEN TRUE ELSE FALSE END AS isReadable
                FROM ed_dashboard_issues edi LEFT JOIN ed_dashboard ed  ON ed.issue_id=edi.id AND
                ed.service_id=${serviceId} AND MONTH(ed.month_for)=MONTH('${monthFor}')
                AND YEAR(ed.month_for)=YEAR('${monthFor}')
                LEFT JOIN pm_service_sector ss ON ed.service_id=ss.id
                 ORDER BY edi.id
        """
        List<GroovyRowResult>  lst = executeSelectSql(queryForList)
        return lst
    }
}
