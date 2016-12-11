package service

import groovy.sql.GroovyRowResult
import pms.BaseService

/**
 * Created by User on 12/08/16.
 */
class PmProjectsService extends BaseService{
    def activeProjectsList() {
        String queryForList = """
              SELECT s.id AS id, CONCAT(s.name,' (',s.short_name,')') AS name
                        FROM pm_projects s
                        WHERE s.in_active <> TRUE
                        ORDER BY s.name ASC
        """
        List<GroovyRowResult> lst = executeSelectSql(queryForList)
        lst = listForKendoDropdown(lst, null, null)
        return lst
    }
}
