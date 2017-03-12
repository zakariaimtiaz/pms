package service

import com.pms.AppMail
import groovy.sql.GroovyRowResult
import pms.BaseService

class AppMailService extends BaseService {

    public void sendMail(AppMail appMail) {

    }


    public void sendMail(AppMail appMail, List<Long> entityIds, Long entityTypeReservedId) {
        appMail.recipients = getAllMailAddresses(appMail.companyId, appMail.roleIds, entityIds, entityTypeReservedId)
        if (appMail.recipients && !appMail.recipients.equals(EMPTY_SPACE)) {
            sendMail(appMail)
        }
    }


    public String getAllMailAddresses(long companyId, String roleIds, List<Long> entityIds, Long entityTypeReservedId) {
        String filterAppUserEntityMapping = EMPTY_SPACE
        //email addresses of all user's in role
        if (entityIds && entityTypeReservedId && (entityIds.size() > 0) && (entityTypeReservedId != 0)) {
            String entityIdsStr = buildCommaSeparatedStringOfIds(entityIds)
            entityTypeObj =  appUserEntityTypeCacheUtility.readByReservedAndCompany(entityTypeReservedId, companyId)
            filterAppUserEntityMapping = """
            RIGHT JOIN app_user_entity au_en ON au_en.app_user_id = au.id
            AND au_en.entity_type_id = :entityTypeId AND au_en.entity_id IN (${entityIdsStr})
            """
        }
        String query = """
            SELECT DISTINCT(login_id)
            FROM app_user au
            ${filterAppUserEntityMapping}
            WHERE au.company_id = :companyId
            AND au.enabled = true
            AND au.id IN
            (SELECT ur.user_id FROM user_role ur
            WHERE ur.role_id IN (${roleIds}))
        """

        Map queryParams = [
                entityTypeId: entityTypeObj ? entityTypeObj.id : 0L,
                companyId   : companyId
        ]
        List<GroovyRowResult> result = executeSelectSql(query, queryParams)
        String comaSeparatedMail = EMPTY_SPACE
        if (result.size() > 0) {
            comaSeparatedMail = result[0][0].toString()
            for (int i = 1; i < result.size(); i++) {
                comaSeparatedMail += (COMA + result[i][0].toString())
            }
        }
        return comaSeparatedMail
    }

    public void createDefaultDataForApplication(long companyId) {

        executeInsertSql("""
            INSERT INTO app_mail (id, version, body, company_id, is_active, mime_type, subject, transaction_code, role_ids, plugin_id, is_required_role_ids, is_manual_send, is_required_recipients, recipients, controller_name, action_name, updated_by, has_send)
            VALUES (NEXTVAL('app_mail_id_seq'), 0, '<div>
            <p>
                Dear \${userName}, <br/>
                Your Login ID : \${loginId}
            </p>
            <p>
                To reset your password please click the link below (or copy/paste into your web browser):<br/>
                <a target="_blank" href="\${link}">\${link}</a>
            </p>
            <p>
                For security reason, you will be asked for a security code.<br/>
                Your security code is <strong>\${securityCode}</strong>
            </p>
            <p>
                <strong>Please Note, you must reset your password within 24 hours of your request.</strong>
            </p>
            <p>
                Regards,<br/>
                \${company}
            </p>
            <i>This is an auto-generated email, which does not need reply.<br/></i>
            </div>', :companyId, true, 'html', 'Your request for password reset', 'SendMailForPasswordResetActionService', null, 1, false, false, false, null, null, null, 0, false);
        """, queryParams)
    }

}