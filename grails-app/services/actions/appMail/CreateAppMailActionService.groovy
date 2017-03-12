package actions.appMail

import com.model.ListAppMailActionServiceModel
import com.pms.AppMail
import org.apache.log4j.Logger
import org.springframework.transaction.annotation.Transactional
import pms.ActionServiceIntf
import pms.BaseService


class CreateAppMailActionService extends BaseService implements ActionServiceIntf {

    private Logger log = Logger.getLogger(getClass())

    private static final String APP_MAIL = "appMail"
    private static final String SUCCESS_MESSAGE = "Mail has been saved successfully"
    private static final String ALREADY_EXIST = "Mail template already exists"

    @Transactional(readOnly = true)
    public Map executePreCondition(Map params) {
        try {
            if (!params.transactionCode && !params.subject && !params.body) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            int count = AppMail.countByTransactionCodeIlike(params.transactionCode.toString())
            if (count > 0) {
                return super.setError(params, ALREADY_EXIST)
            }
            AppMail appMail = buildObject(params)
            params.put(APP_MAIL, appMail)
            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    @Transactional
    public Map execute(Map result) {
        try {
            AppMail appMail = (AppMail) result.get(APP_MAIL)
            appMail.save()
            return result
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    public Map executePostCondition(Map result) {
        return result
    }

    @Transactional(readOnly = true)
    Map buildSuccessResultForUI(Map result) {
        try{
            AppMail mail = (AppMail) result.get(APP_MAIL)
            ListAppMailActionServiceModel model = ListAppMailActionServiceModel.read(mail.id)
            result.put(APP_MAIL, model)
            return super.setSuccess(result, SUCCESS_MESSAGE)
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    public Map buildFailureResultForUI(Map result) {
        return result
    }

    private static AppMail buildObject(Map params) {
        AppMail appMail = new AppMail(params)
        return appMail
    }

}
