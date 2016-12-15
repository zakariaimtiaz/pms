package service

import grails.transaction.Transactional
import groovy.sql.GroovyRowResult
import pms.BaseService

@Transactional
class PmProjectsService  extends BaseService{

    def activeList() {
        String queryForList = """
                SELECT s.id AS id, CONCAT(s.name,' (',s.short_name,')', ' - (', s.code, ')') AS name
                        FROM pm_projects s
                        WHERE s.is_active = TRUE
                        ORDER BY s.name ASC
        """
        List<GroovyRowResult> lst = executeSelectSql(queryForList)
        lst = listForKendoDropdown(lst, null, null)
        return lst
    }
}
