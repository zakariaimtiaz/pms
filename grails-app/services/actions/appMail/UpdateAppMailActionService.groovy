package actions.appMail

import com.model.ListAppMailActionServiceModel
import com.pms.AppMail
import org.apache.log4j.Logger
import org.springframework.transaction.annotation.Transactional
import pms.ActionServiceIntf
import pms.BaseService

class UpdateAppMailActionService extends BaseService implements ActionServiceIntf {

    private static final String SUCCESS_MESSAGE = "Template has been updated successfully"
    private static final String ALREADY_EXIST = "Template already exists"
    private static final String APP_MAIL_OBJ = "appMail"

    private Logger log = Logger.getLogger(getClass())

    public Map executePreCondition(Map params) {
        try {
            if ((!params.id) || (!params.transactionCode)) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            long id = Long.parseLong(params.id.toString())
            AppMail appMail = (AppMail) AppMail.read(id)
            int count = AppMail.countByTransactionCodeIlikeAndIdNotEqual(params.transactionCode.toString(),id)
            if (count > 0) {
                return super.setError(params, ALREADY_EXIST)
            }
            AppMail appMail1 = buildObject(params, appMail)
            params.put(APP_MAIL_OBJ, appMail1)
            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    @Transactional
    public Map execute(Map result) {
        try {
            AppMail appMail = (AppMail) result.get(APP_MAIL_OBJ)
            appMail.save()
            return result
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }
    /**
     *
     * @param result - map received from execute method
     * @return - map
     */
    public Map executePostCondition(Map result) {
        return result
    }
    /**
     *
     * @param result - map received from execute method
     * @return - map with success message
     */
    public Map buildSuccessResultForUI(Map result) {
        AppMail appMail = (AppMail) result.get(APP_MAIL_OBJ)
        ListAppMailActionServiceModel model = ListAppMailActionServiceModel.read(appMail.id)
        result.put(APP_MAIL_OBJ, model)
        return super.setSuccess(result, SUCCESS_MESSAGE)
    }

    /**
     *
     * @param result - map received from previous method
     * @return - map
     */
    public Map buildFailureResultForUI(Map params) {
        return params
    }

    private static AppMail buildObject(Map parameterMap, AppMail oldObject) {
        AppMail mail = new AppMail(parameterMap)
        oldObject.transactionCode = mail.transactionCode
        oldObject.subject = mail.subject
        oldObject.body = mail.body
        oldObject.isActive = mail.isActive
        oldObject.recipients = mail.recipients
        oldObject.roleIds = mail.roleIds
        oldObject.isManualSend = mail.isManualSend
        oldObject.isRequiredRoleIds = mail.isRequiredRoleIds
        oldObject.isRequiredRecipients = mail.isRequiredRecipients
        oldObject.controllerName = mail.controllerName
        oldObject.actionName = mail.actionName
        return oldObject
    }
}
