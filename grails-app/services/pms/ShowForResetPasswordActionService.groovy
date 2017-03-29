package pms

import com.pms.SecUser
import grails.transaction.Transactional
import org.apache.log4j.Logger
import org.codehaus.groovy.grails.web.servlet.mvc.GrailsParameterMap

@Transactional
class ShowForResetPasswordActionService extends BaseService implements ActionServiceIntf {

    private Logger log = Logger.getLogger(getClass());

    private static final String APP_USER = "secUser"
    private static final String EMP_NAME = "empname"
    private static final String USERNAME = "username"
    private static final String USER_INFO_MAP = "userInfoMap"
    private static final String PASSWORD_RESET_LINK = "passwordResetLink"
    private static final String TIME_EXPIRED_MSG = "Time to reset password has expired"
    private static final String USER_NOT_FOUND_MSG = "Invalid link or password already reset"


    /**
     * 1. check input validation
     * 2. check time validation for reset password
     * @param params -parameters from UI
     * @param obj -N/A
     * @return -a map containing all objects necessary for execute
     * map contains isError(true/false) depending on method success
     */
    @org.springframework.transaction.annotation.Transactional(readOnly = true)
    public Map executePreCondition(Map parameters) {
        try {
            GrailsParameterMap params = (GrailsParameterMap) parameters
            SecUser secUser = SecUser.findByPasswordResetLink(params.link)
            if (!secUser) {
                return super.setError(params, USER_NOT_FOUND_MSG)
            }
            // check time validation for reset password
            Date currentDate = new Date()
            if (currentDate.compareTo(secUser.passwordResetValidity) > 0) {
                return super.setError(params, TIME_EXPIRED_MSG)
            }
            params.put(APP_USER, secUser)
            return params
        } catch (Exception e) {
            log.error(e.getMessage())
            throw new RuntimeException(e)
        }
    }

    /**
     * Build map with user info for show in UI
     * @param parameters -N/A
     * @param obj -map returned from executePreCondition method
     * @return -a map contains isError(true/false) depending on method success
     */
    @org.springframework.transaction.annotation.Transactional
    public Map execute(Map result) {
        try {
            SecUser secUser = (SecUser) result.get(APP_USER)
            Map userInfoMap = buildUserInfoMap(secUser)    // build map with user info for show in UI
            result.put(USER_INFO_MAP, userInfoMap)
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
        return result
    }

    /**
     * Build failure result in case of any error
     * @param obj -map returned from previous methods, can be null
     * @return -a map containing isError = true, relevant error message and user information
     */
    public Map buildFailureResultForUI(Map result) {
        return result
    }

    /**
     * Build map with user information
     * @param user -object of AppUser
     * @return -a map containing user information
     */
    private Map buildUserInfoMap(SecUser user) {
        Map userInfoMap = new LinkedHashMap()
        userInfoMap.put(PASSWORD_RESET_LINK, user ? user.passwordResetLink : EMPTY_SPACE)
        userInfoMap.put(USERNAME, user ? user.username : EMPTY_SPACE)
        userInfoMap.put(EMP_NAME, user ? user.employeeName+' (' + user.employeeId + ')' : EMPTY_SPACE)
        return userInfoMap
    }
}
