package service

import grails.transaction.Transactional
import groovy.sql.GroovyRowResult
import pms.BaseService

@Transactional
class EdDashboardService  extends BaseService{

    public List<GroovyRowResult> lstEdDashboardIssue(long serviceId) {
        String queryForList = """
            SELECT  edi.id ,edi.version,edi.issue_name ,ed.description,ed.remarks,ed.ed_advice
                  FROM ed_dashboard_issues edi LEFT JOIN ed_dashboard ed  ON ed.issue_id=edi.id
                  LEFT JOIN pm_service_sector ss ON ed.service_id=ss.id ORDER BY edi.id
        """
        List<GroovyRowResult> lst = executeSelectSql(queryForList)
        return lst
    }
}
