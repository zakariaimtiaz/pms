package service

import com.pms.SecUser
import groovy.sql.GroovyRowResult
import pms.BaseService

class SecUserService extends BaseService {

    public SecUser read(long id) {
       return SecUser.read(id)
    }

    public int countByUsernameIlike(String username){
        return SecUser.countByUsernameIlike(username)
    }

    public int countByUsernameIlikeAndIdNotEqual(String username, long id){
        return SecUser.countByUsernameIlikeAndIdNotEqual(username, id)
    }

    public String syncHrUsers() {
        String message = "HR user list is up-to-date"
        String queryStr = """
            INSERT INTO pms.sec_user(version, account_expired, account_locked,enabled, password,
            password_expired, username, full_name, service_id)

            SELECT 0 version,false account_expired,false account_locked,true enabled,e.password password,
            false password_expired,e.login_id username,e.employee_name full_name,s.id service_id
            FROM list_hr_user_action_service_model e
            LEFT JOIN pm_service_sector s ON s.static_name = e.service
            LEFT JOIN sec_user u ON u.username=e.login_id
            WHERE u.username IS NULL AND s.id IS NOT NULL
            ORDER BY s.id;
        """
        String queryStr2 = """
            INSERT INTO user_department(version,user_id,service_id)
            SELECT 0,u.id,u.service_id
            FROM sec_user u
            WHERE u.id NOT IN (SELECT DISTINCT(user_id) FROM user_department);
        """
        String queryStr3 = """
            INSERT INTO sec_user_sec_role(sec_user_id,sec_role_id)
            SELECT u.id,(SELECT id FROM sec_role WHERE authority="ROLE_REPORT_USER")
            FROM sec_user u
            WHERE u.id NOT IN (SELECT DISTINCT(sec_user_id) FROM sec_user_sec_role);
        """
        executeSql(queryStr)
        executeSql(queryStr2)
        executeSql(queryStr3)
        return message
    }
    public List<GroovyRowResult> getGeneralUsers() {
        String queryStr = """
            SELECT u.* FROM sec_user u
            WHERE u.enabled = true
            AND id !=1
        """
        List<GroovyRowResult> result = executeSelectSql(queryStr)
        return result
    }
}
