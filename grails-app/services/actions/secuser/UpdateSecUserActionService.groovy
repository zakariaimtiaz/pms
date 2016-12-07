package actions.secuser

import com.model.ListSecUserActionServiceModel
import com.pms.SecUser
import com.pms.UserDepartment
import grails.plugin.springsecurity.SpringSecurityService
import grails.transaction.Transactional
import org.apache.log4j.Logger
import pms.ActionServiceIntf
import pms.BaseService
import service.SecUserService

@Transactional
class UpdateSecUserActionService extends BaseService implements ActionServiceIntf {

    private static final String UPDATE_SUCCESS_MESSAGE = "User has been updated successfully"
    private static final String USER_ALREADY_EXIST = "Same User name already exist"
    private static final String SEC_USER = "secUser"

    SecUserService secUserService
    SpringSecurityService springSecurityService

    private Logger log = Logger.getLogger(getClass())

    public Map executePreCondition(Map params) {
        try {
            if ((!params.id) || (!params.username)) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            long id = Long.parseLong(params.id.toString())
            SecUser oldUser = (SecUser) secUserService.read(id)
            String name = params.username.toString()
            int duplicateCount = secUserService.countByUsernameIlikeAndIdNotEqual(name, id)
            if (duplicateCount > 0) {
                return super.setError(params, USER_ALREADY_EXIST)
            }
            SecUser secUser = buildObject(params, oldUser)
            params.put(SEC_USER, secUser)
            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    @Transactional
    public Map execute(Map result) {
        try {
            SecUser user = (SecUser) result.get(SEC_USER)
            secUserService.update(user)

            int count = UserDepartment.countByServiceIdAndUserId(user.serviceId,user.id)
            if(count==0){
                UserDepartment userDepart = new UserDepartment()
                userDepart.serviceId = user.serviceId
                userDepart.userId =user.id
                userDepart.save()
            }

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
        SecUser secUser = (SecUser) result.get(SEC_USER)
        ListSecUserActionServiceModel model = ListSecUserActionServiceModel.read(secUser.id)
        result.put(SEC_USER, model)
        return super.setSuccess(result, UPDATE_SUCCESS_MESSAGE)
    }

    /**
     *
     * @param result - map received from previous method
     * @return - map
     */
    public Map buildFailureResultForUI(Map params) {
        return params
    }

    /**
     * Build SecUser object
     * @param parameterMap -serialized parameters from UI
     * @param oldSecUser -object of SecUser
     * @return -new SecUser object
     */
    private SecUser buildObject(Map parameterMap, SecUser oldSecUser) {
        long serviceId = Long.parseLong(parameterMap.serviceId.toString())
        String str = parameterMap.fullName
        int startIndex = str.indexOf("(");
        int endIndex = str.indexOf(")");
        String toBeReplaced = str.substring(startIndex, endIndex + 1);
        parameterMap.fullName = str.replace(toBeReplaced, "");

        SecUser user = new SecUser(parameterMap)
        oldSecUser.serviceId = serviceId
        oldSecUser.username = user.username
        oldSecUser.fullName = user.fullName
        oldSecUser.enabled = user.enabled
        oldSecUser.password = springSecurityService.encodePassword(user.password)
        oldSecUser.accountExpired = user.accountExpired
        oldSecUser.accountLocked = user.accountLocked
        return oldSecUser
    }
}
