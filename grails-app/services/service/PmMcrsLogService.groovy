package service

import grails.transaction.Transactional
import groovy.sql.GroovyRowResult
import pms.BaseService

@Transactional
class PmMcrsLogService extends BaseService {

    public List<GroovyRowResult> mcrsLogDetailsByLogId(long logId,long logTypeId){
        String queryStr = """
                SELECT @rn:=@rn+1 AS sl,service,month,year,month_str, editable_on, submitted_on,is_current,
                STR_TO_DATE(CONCAT('01,',month,',',year),'%d,%m,%Y') AS log_start
                FROM (
                SELECT s.name service,l.month,l.month_str,l.year,dl.editable_on, dl.submitted_on,dl.is_current
                FROM pm_mcrs_log_details dl
                LEFT JOIN pm_mcrs_log l ON l.id = dl.log_id
                LEFT JOIN pm_service_sector s ON s.id=l.service_id
                    WHERE log_id = ${logId} AND log_type_id = ${logTypeId}
                ) t1, (SELECT @rn:=0) t2;
        """
        List<GroovyRowResult> lst = executeSelectSql(queryStr)
        return lst
    }
}
