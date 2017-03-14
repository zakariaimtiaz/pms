package service

import com.pms.AppMail
import groovy.sql.GroovyRowResult
import pms.BaseService

class AppMailService extends BaseService {

    public void sendMail(AppMail appMail) {
        appMail.recipients = getAllMailAddresses(appMail.roleIds)
        if (appMail.recipients && !appMail.recipients.equals(EMPTY_SPACE)) {
            sendMail(appMail)
        }
    }


    public String getAllMailAddresses(String roleIds) {
        String query = """
            SELECT DISTINCT(login_id)
            FROM app_user au
            WHERE au.company_id = :companyId
            AND au.enabled = true
            AND au.id IN
            (SELECT ur.user_id FROM user_role ur
            WHERE ur.role_id IN (${roleIds}))
        """

        List<GroovyRowResult> result = executeSelectSql(query)
        String comaSeparatedMail = EMPTY_SPACE
        if (result.size() > 0) {
            comaSeparatedMail = result[0][0].toString()
            for (int i = 1; i < result.size(); i++) {
                comaSeparatedMail += (COMA + result[i][0].toString())
            }
        }
        return comaSeparatedMail
    }
}