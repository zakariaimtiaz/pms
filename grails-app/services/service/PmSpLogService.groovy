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
    public List<GroovyRowResult> findAllByYearAndServiceId(int year,long serviceId){
        String serviceStr=""
        if(serviceId>0)
        {
            serviceStr=" AND sbl.service_id=${serviceId}"
        }
        else {
            List<GroovyRowResult> lst = currentUserDepartmentList()
            if (lst.size()>1){
                String services=buildCommaSeparatedStringOfIds(lst)
                serviceStr=" AND sbl.service_id IN (${services})"
            }
        }
        String queryStr = """
            SELECT sbl.id,sbl.version,sbl.create_date createDate,sbl.file_name fileName,sbl.service_id serviceId
            ,sbl.year,ss.name AS serviceName,ss.short_name AS shortName
            FROM pm_sap_backup_log sbl LEFT JOIN pm_service_sector ss ON sbl.service_id=ss.id
            WHERE sbl.year=${year} ${serviceStr}
        """
        List<GroovyRowResult> lst = executeSelectSql(queryStr)
        return lst
    }
}
