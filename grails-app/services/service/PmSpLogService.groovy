package service

import grails.transaction.Transactional
import groovy.sql.GroovyRowResult
import pms.BaseService

@Transactional
class PmSpLogService extends BaseService {

    public List<GroovyRowResult> spLogDetailsByLogId(long logId){
        String queryStr = """
                SELECT @rn:=@rn+1 AS sl,service,year, editable_on, submitted_on,is_current,
                STR_TO_DATE(CONCAT('01,',01,',',year),'%d,%m,%Y') AS log_start
                FROM (SELECT s.name service,l.year,dl.editable_on, dl.submitted_on,dl.is_current
                FROM pm_sp_log_details dl
                LEFT JOIN pm_sp_log l ON l.id = dl.log_id
                LEFT JOIN pm_service_sector s ON s.id=l.service_id
                WHERE log_id = ${logId}) t1, (SELECT @rn:=0) t2;
        """
        List<GroovyRowResult> lst = executeSelectSql(queryStr)
        return lst
    }
}
