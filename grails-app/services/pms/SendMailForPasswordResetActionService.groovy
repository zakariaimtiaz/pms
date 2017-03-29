package pms

import com.pms.SecUser
import grails.plugin.springsecurity.SpringSecurityService
import grails.transaction.Transactional
import org.apache.log4j.Logger
import org.codehaus.groovy.grails.web.mapping.LinkGenerator
import org.codehaus.groovy.grails.web.servlet.mvc.GrailsParameterMap

@Transactional
class SendMailForPasswordResetActionService extends BaseService implements ActionServiceIntf {

    private Logger log = Logger.getLogger(getClass())

    private static final String SEC_USER = "secUser"
    private static final String USER_NOT_FOUND_MSG = "User not found with the given login ID"
    private static final String SHOW_RESET_PASSWORD = "showResetPassword"
    private static final String DATE_FORMAT = "dd_MMM_yy_hh_mm_ss"
    private static final String SUCCESS_MESSAGE = "Please check your mail and follow the given instructions"
    private static final String EMAIL_PATTERN = """^[-0-9a-zA-Z.+_]+@[-0-9a-zA-Z.+_]+\\.[a-zA-Z]{2,4}\$"""
    private static final String INVALID_EMAIL = "Invalid email address"
    private static final String EMAIL_NOT_FOUND = "Email id not found. Please contact to HR"
    private static final String EMAIL_ID = "email"
    private static final String NO_LOGIN_ID_FOUND = "No login ID found"
    private static final String CHAR_SET = "ABCDEFGHIJKLMNPQRSTUVWXYZ1234567891234567891234567"
    private static final int CODE_LENGTH = 5

    SpringSecurityService springSecurityService
    LinkGenerator grailsLinkGenerator
    def mailService

    @org.springframework.transaction.annotation.Transactional(readOnly = true)
    public Map executePreCondition(Map parameters) {
        try {
            GrailsParameterMap params = (GrailsParameterMap) parameters
            if(!params.loginId){
                return super.setError(parameters, NO_LOGIN_ID_FOUND)
            }
            SecUser secUser = SecUser.findByUsernameAndEnabled(params.loginId.toString(), Boolean.TRUE)
            String checkValidationMsg = checkInputValidation(secUser)
            if (checkValidationMsg) {
                return super.setError(params, checkValidationMsg)
            }
            String email = employeeEmailId(secUser.employeeId)
            params.put(EMAIL_ID, email)
            params.put(SEC_USER, secUser)
            return params
        } catch (Exception e) {
            log.error(e.getMessage())
            throw new RuntimeException(e)
        }
    }

    @org.springframework.transaction.annotation.Transactional
    public Map execute(Map result) {
        try {
            String email = result.get(EMAIL_ID)
            SecUser secUser = (SecUser) result.get(SEC_USER)
            buildPasswordResetProperties(secUser)
            String msg = sendMail(secUser, email)
            if (msg) {
                return super.setError(result, msg)
            }
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
     * Do nothing for build failure result for UI
     */
    public Map buildFailureResultForUI(Map result) {
        return result
    }

    private String employeeEmailId(String employeeId){
        String query = """
            SELECT official_email FROM employee WHERE employee_id = ${employeeId}
        """
        String emailId = groovySql_mis.rows(query)[0].official_email
        return emailId
    }

    private String checkInputValidation(SecUser secUser) {
        if (!secUser) {
            return USER_NOT_FOUND_MSG
        }
        String email = employeeEmailId(secUser.employeeId)
        if (email == null || email == EMPTY_SPACE) {
            return EMAIL_NOT_FOUND
        }
        if (!email.matches(EMAIL_PATTERN)) {
            return INVALID_EMAIL
        }
        return null
    }

    private void buildPasswordResetProperties(SecUser user) {
        user.passwordResetLink = springSecurityService.encodePassword(user.username + new Date().format(DATE_FORMAT))
        user.passwordResetCode = generateSecurityCode()
        user.passwordResetValidity = new Date() + 1
        user.save()
    }

    /**
     * Generate security code for reset password
     * @return -generated security code
     */
    private String generateSecurityCode() {
        Random random = new Random()
        char[] code = new char[CODE_LENGTH]
        for (int i = 0; i < CODE_LENGTH; i++) {
            code[i] = CHAR_SET.charAt(random.nextInt(CHAR_SET.length()))
        }
        return new String(code)
    }

    private String sendMail(SecUser user, String email) {
        String link = grailsLinkGenerator.link(controller: "login", action: SHOW_RESET_PASSWORD, absolute: true, params: [link: user.passwordResetLink])
        String name = user.employeeName
        String employeeId = user.employeeId
        String loginId = user.username
        String securityCode = user.passwordResetCode

        String body = """
        <div>
            <p>
                Dear ${name}, <br/>
                Your Login ID    : ${loginId} <br/>
                Your Employee ID : ${employeeId}
            </p>
            <p>
                To reset your password please click the link below (or copy/paste into your web browser):<br/>
                <a target="_blank" href="${link}">${link}</a>
            </p>
            <p>
                For security reason, you will be asked for a security code.<br/>
                Your security code is <strong>${securityCode}</strong>
            </p>
            <p>
                <strong>Please Note, you must reset your password within 24 hours of your request.</strong>
            </p>
            <p>
                Regards,<br/>
                 Friendship
            </p>
            <i>This is an auto-generated email, which does not need reply.<br/></i>
            </div>
        """
        Thread trd = new Thread(){
            public void run() {
                mailService.sendMail {
                    to "${email}"
                    from "support.mis@friendship-bd.org"
                    subject "Password reset link"
                    html (body)
                }
            }
        }.start();
        return null
    }


}
