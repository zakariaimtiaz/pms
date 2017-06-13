package pms

import com.logic27.awls.crypto.CryptoUtil
import com.pms.SecUser
import grails.converters.JSON
import grails.plugin.springsecurity.SpringSecurityUtils
import groovy.sql.GroovyRowResult
import org.springframework.security.authentication.AccountExpiredException
import org.springframework.security.authentication.CredentialsExpiredException
import org.springframework.security.authentication.DisabledException
import org.springframework.security.authentication.LockedException
import org.springframework.security.core.context.SecurityContextHolder
import org.springframework.security.web.WebAttributes
import pms.utility.Tools
import service.PmActionsService

import javax.servlet.http.HttpServletResponse

class LoginController extends BaseController {

    BaseService baseService
    PmActionsService pmActionsService
    SendMailForPasswordResetActionService sendMailForPasswordResetActionService
    ShowForResetPasswordActionService showForResetPasswordActionService
    ManageSecUserPasswordActionService manageSecUserPasswordActionService

    def SessionRegistry

    /**
     * Dependency injection for the authenticationTrustResolver.
     */
    def authenticationTrustResolver

    /**
     * Dependency injection for the springSecurityService.
     */
    def springSecurityService

    /**
     * Default action; redirects to 'defaultTargetUrl' if logged in, /login/auth otherwise.
     */
    def index() {
        if (springSecurityService.isLoggedIn()) {
            redirect uri: SpringSecurityUtils.securityConfig.successHandler.defaultTargetUrl
        } else {
            redirect action: 'auth', params: params
        }
    }

    /**
     * Show the login page.
     */
    def auth() {
        def config = SpringSecurityUtils.securityConfig
        if (springSecurityService.isLoggedIn()) {
            redirect uri: config.successHandler.defaultTargetUrl
            return
        }
        String view = 'auth'
        String postUrl = "${request.contextPath}${config.apf.filterProcessesUrl}"
        render view: view, model: [postUrl            : postUrl,
                                   rememberMeParameter: config.rememberMe.parameter]
    }

    def loginSuccess() {
        String url = '/'
        redirect(uri: url)
    }

    /**
     * The redirect action for Ajax requests.
     */
    def authAjax() {
        response.setHeader 'Location', SpringSecurityUtils.securityConfig.auth.ajaxLoginFormUrl
        response.sendError HttpServletResponse.SC_UNAUTHORIZED
    }

    /**
     * Show denied page.
     */
    def denied() {
        if (springSecurityService.isLoggedIn() &&
                authenticationTrustResolver.isRememberMe(SecurityContextHolder.context?.authentication)) {
            // have cookie but the page is guarded with IS_AUTHENTICATED_FULLY
            redirect action: 'full', params: params
        }
    }

    /**
     * Login page for users with a remember-me cookie but accessing a IS_AUTHENTICATED_FULLY page.
     */
    def full() {
        def config = SpringSecurityUtils.securityConfig
        render view: 'auth', params: params,
                model: [hasCookie: authenticationTrustResolver.isRememberMe(SecurityContextHolder.context?.authentication),
                        postUrl  : "${request.contextPath}${config.apf.filterProcessesUrl}"]
    }

    /**
     * Callback after a failed login. Redirects to the auth page with a warning message.
     */
    def authfail() {

        String msg = ''
        def exception = session[WebAttributes.AUTHENTICATION_EXCEPTION]
        if (exception) {
            if (exception instanceof AccountExpiredException) {
                msg = g.message(code: "springSecurity.errors.login.expired")
            } else if (exception instanceof CredentialsExpiredException) {
                msg = g.message(code: "springSecurity.errors.login.passwordExpired")
            } else if (exception instanceof DisabledException) {
                msg = g.message(code: "springSecurity.errors.login.disabled")
            } else if (exception instanceof LockedException) {
                msg = g.message(code: "springSecurity.errors.login.locked")
            } else {
                msg = g.message(code: "springSecurity.errors.login.fail")
            }
        }

        if (springSecurityService.isAjax(request)) {
            render([error: msg] as JSON)
        } else {
            flash.message = msg
            redirect action: 'auth', params: params
        }
    }

    /**
     * The Ajax success redirect url.
     */
    def ajaxSuccess() {
        render([success: true, username: springSecurityService.authentication.name] as JSON)
    }

    /**
     * The Ajax denied redirect url.
     */
    def ajaxDenied() {
        render([error: 'access denied'] as JSON)
    }

    def dashBoard() {
        render(template: "../layouts/dashBoard")
    }
    def lstUserDashboard() {
        List<GroovyRowResult> lst = pmActionsService.lstGoalWiseActionStatus(params.month.toString())
        render lst as JSON
    }
    def lstUserPieDashboard() {
        List<GroovyRowResult> lst = pmActionsService.lstServiceWiseAcvStatus(params.month.toString())
        render lst as JSON
    }
    def lstManagementDashboard() {
        List<GroovyRowResult> lst = pmActionsService.lstServiceWiseActionStatus(params.month.toString())
        render lst as JSON
    }

    def resetPassword() {
        SecUser user = SecUser.findByUsername(springSecurityService.authentication.name)
        render(view: '/login/resetPassword', model: [userId: user.id])
    }
    def showResetPassword() {
        String view = '/login/showForgotPassword'
        Map result = getServiceResponse(showForResetPasswordActionService, params)
        Boolean isError = result.isError
        if (isError.booleanValue()) {
            flash.success = false
            flash.message = result.message
            render view: view, model: [userInfoMap: result.userInfoMap]
            return
        }
        flash.message = null
        render view: view, model: [userInfoMap: result.userInfoMap]
    }
    def managePassword(){
        String view = "/login/showForgotPassword"
        Map userInfoMap = [passwordResetLink: params.link, username: params.username, empname: params.empname]
        Map result = getServiceResponse(manageSecUserPasswordActionService, params)
        Boolean isError = result.isError
        if (isError.booleanValue()) {
            flash.success = false
            flash.message = result.message
            render view: view, model: [userInfoMap: userInfoMap]
            return
        }
        flash.success = true
        flash.message = result.message
        render view: view, model: [userInfoMap: userInfoMap]
    }
    def sendPasswordResetLink() {
        Map result = getServiceResponse(sendMailForPasswordResetActionService, params)
        Boolean isError = result.isError
        if (isError.booleanValue()) {
            flash.success = false
            flash.message = result.message
            redirect action: 'auth', params: params
            return
        }
        flash.success = true
        flash.message = result.message
        redirect action: 'auth', params: params
    }

    def listIndicatorLight(){
        def list = []
        def map = [:]

        def map1 = [:]
        map1.put('text','ALL')
        map1.put('value','ALL')
        map1.put('img','circle_grey')
        list << map1

        def map2 = [:]
        map2.put('text','Red')
        map2.put('value','Red')
        map2.put('img','circle_red')
        list << map2

        def map3 = [:]
        map3.put('text','Amber')
        map3.put('value','Amber')
        map3.put('img','circle_yellow')
        list << map3

        def map4 = [:]
        map4.put('text','Green')
        map4.put('value','Green')
        map4.put('img','circle_green')
        list << map4

        map.put('data',list)
        render map as JSON

    }

    def showEncp(){
        render(view: '/login/showEncp')
    }
    def encryptTxt(){
        String txt1 = params.input1
        String txt2 = params.input2

        CryptoUtil cryptoUtil = new CryptoUtil();
        String output1 = txt1.equals('')?'':cryptoUtil.encrypt(Tools.FLASK,txt1);
        String output2 = txt2.equals('')?'':cryptoUtil.encrypt(Tools.FLASK,txt2);
        def map = [:]
        map.put('output1',output1)
        map.put('output2',output2)
        render map as JSON

    }
    def decryptTxt(){
        String txt1 = params.input1
        String txt2 = params.input2
        String output1
        String output2

        CryptoUtil cryptoUtil = new CryptoUtil();
        try {
            output1 = cryptoUtil.decrypt(Tools.FLASK,txt1);
        } catch (Exception ex) {
            output1 = cryptoUtil.encrypt(Tools.FLASK,txt1);
            output1 = cryptoUtil.decrypt(Tools.FLASK,output1);
        }
        try {
            output2 = cryptoUtil.decrypt(Tools.FLASK,txt2);
        } catch (Exception ex) {
            output2 = cryptoUtil.encrypt(Tools.FLASK,txt2);
            output2 = cryptoUtil.decrypt(Tools.FLASK,output2);
        }
        def map = [:]
        map.put('output1',output1)
        map.put('output2',output2)
        render map as JSON
    }

}
