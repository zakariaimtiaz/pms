package pms

import com.pms.SecUser
import grails.plugin.springsecurity.SpringSecurityService
import grails.transaction.Transactional
import org.apache.log4j.Logger
import org.codehaus.groovy.grails.web.servlet.mvc.GrailsParameterMap

@Transactional
class ManageSecUserPasswordActionService extends BaseService implements ActionServiceIntf{

    private Logger log = Logger.getLogger(getClass())

    private static final String USER_NOT_FOUND_MSG = 'User not found or password already been reset'
    private static final String SUCCESS_MESSAGE = 'Password has been reset successfully'
    private static final String APP_USER = 'secUser'
    private static final String TIME_EXPIRED_MSG = 'Time to reset password has expired'
    private static final String CODE_MISMATCH_MSG = 'Security code mismatched, please check mail for security code'
    private static final String PASSWORD_MISMATCH_MSG = 'Password mismatched, please type again'

    SpringSecurityService springSecurityService


    /**
     * 1. get companyId from request
     * 2. check input validation
     * @param params -serialized parameters from UI
     * @param obj -HttpServletRequest request
     * @return -a map containing all objects necessary for execute
     * map contains isError(true/false) depending on method success
     */
    @Transactional(readOnly = true)
    public Map executePreCondition(Map parameters) {
        try {
            GrailsParameterMap params = (GrailsParameterMap) parameters
            // check required parameters
            if ((!params.link) || (!params.code) || (!params.password) || (!params.retypePassword)) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            String link = params.link
            SecUser appUser = SecUser.findByPasswordResetLink(link)
            String checkValidationMsg = checkInputValidation(params, appUser)
            if (checkValidationMsg) {
                return super.setError(params, checkValidationMsg)
            }
            params.put(APP_USER, appUser)
            return params
        } catch (Exception e) {
            log.error(e.getMessage())
            throw new RuntimeException(e)
        }
    }

    /**
     * Set and update properties of AppUser for reset password
     * @param parameters -serialized parameters from UI
     * @param obj -map returned from executePreCondition method
     * @return -a map contains isError(true/false) depending on method success and related message
     */
    @Transactional
    public Map execute(Map result) {
        try {
            SecUser appUser = (SecUser) result.get(APP_USER)
            cleanPasswordResetProperties(appUser, result)
            return result
        } catch (Exception e) {
            log.error(e.getMessage())
            throw new RuntimeException(e)
        }
    }

    /**
     * Do nothing for post operation
     */
    public Map executePostCondition(Map result) {
        return result
    }

    /**
     * Do nothing for build success result for UI
     */
    public Map buildSuccessResultForUI(Map result) {
        return super.setSuccess(result, SUCCESS_MESSAGE)
    }

    /**
     * Build failure result in case of any error
     * @param obj -map returned from previous methods, can be null
     * @return -a map containing isError = true & relevant error message
     */
    public Map buildFailureResultForUI(Map result) {
        return result
    }

    /**
     * 1. check required parameters
     * 2. get AppUser object by link and companyId
     * 3. check if user exists or not
     * 4. check security code
     * 5. check time validation for reset password
     * 6. check password confirmation
     * 7. check password length
     * 8. check character combination of password
     * @param params -serialized parameters from UI
     * @return -a map containing AppUser object, isError (true/false) and relevant error message
     */
    private String checkInputValidation(GrailsParameterMap params, SecUser appUser) {
        // check if user exists or not
        if (!appUser) {
            return USER_NOT_FOUND_MSG
        }
        // check security code
        String code = params.code
        if (!code.equals(appUser.passwordResetCode)) {
            return CODE_MISMATCH_MSG
        }
        // check time validation for reset password
        Date currentDate = new Date()
        if (currentDate.compareTo(appUser.passwordResetValidity) > 0) {
            return TIME_EXPIRED_MSG
        }
        String password = params.password
        String retypePassword = params.retypePassword
        // check password confirmation
        if (!password.equals(retypePassword)) {
            return PASSWORD_MISMATCH_MSG
        }
        return null
    }

    /**
     * Set properties of AppUser for reset password
     * @param user -object of AppUser
     * @param params -serialized parameters from UI
     */
    private void cleanPasswordResetProperties(SecUser user, Map result) {
        user.password = result.password
        user.passwordResetCode = null
        user.passwordResetValidity = null
        user.passwordResetLink = null
        user.save()
    }
}
