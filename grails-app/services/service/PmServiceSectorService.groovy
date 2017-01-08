package service

import com.pms.PmServiceSector
import grails.transaction.Transactional
import groovy.sql.GroovyRowResult
import pms.BaseService

@Transactional
class PmServiceSectorService extends BaseService{

    def activeList() {
        String queryForList = """
                SELECT s.id AS id, CONCAT(s.name,' (',s.short_name,')') AS name
                        FROM pm_service_sector s
                        WHERE s.is_displayble = TRUE
                        ORDER BY s.name ASC
        """
        List<GroovyRowResult> lst = executeSelectSql(queryForList)
        lst = listForKendoDropdown(lst, null, null)
        return lst
    }
    def categoryWiseServiceList(long categoryId) {
        List<PmServiceSector> lst = PmServiceSector.findAllByCategoryId(categoryId, [sort: 'sequence', order: 'asc'])
        lst = listForKendoDropdown(lst, null, null)
        return lst
    }
}
