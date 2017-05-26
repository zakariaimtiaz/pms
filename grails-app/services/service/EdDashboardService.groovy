package service

import grails.transaction.Transactional
import groovy.sql.GroovyRowResult
import pms.BaseService

@Transactional
class EdDashboardService  extends BaseService{

    public List<GroovyRowResult> lstEdDashboardIssue(long serviceId,Date monthFor) {

        String queryForList = """
            SELECT  edi.id ,edi.version,edi.issue_name ,ed.description,ed.remarks,ed.ed_advice,
                  CASE WHEN MONTH(DATE_FORMAT('${monthFor}' + INTERVAL 1 MONTH, '%Y-%m-01'))>=MONTH(NOW())
                  AND YEAR(DATE_FORMAT('${monthFor}' + INTERVAL 1 MONTH, '%Y-%m-01'))>=YEAR(NOW())
                  THEN FALSE ELSE TRUE END AS isReadable
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
