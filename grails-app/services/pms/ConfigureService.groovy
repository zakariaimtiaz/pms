package pms

import com.model.*
import com.pms.FeatureManagement
import com.pms.SecRole
import com.pms.SecUser
import com.pms.SecUserSecRole
import grails.transaction.Transactional
import service.ThemeService

@Transactional
class ConfigureService extends BaseService {

    public void initSchema() {
        customExecuteSql(ListSystemEntityActionServiceModel.MODEL_NAME, ListSystemEntityActionServiceModel.SQL_LIST_SYSTEM_ENTITY_MODEL)
        customExecuteSql(ListThemeActionServiceModel.MODEL_NAME, ListThemeActionServiceModel.SQL_LIST_THEME_MODEL)
        customExecuteSql(ListAppMailActionServiceModel.MODEL_NAME, ListAppMailActionServiceModel.SQL_LIST_APP_MAIL_MODEL)
        customExecuteSql(ListMeetingLogActionServiceModel.MODEL_NAME, ListMeetingLogActionServiceModel.SQL_LIST_MEETING_LOG_MODEL)
        customExecuteSql(ListPmMissionsActionServiceModel.MODEL_NAME, ListPmMissionsActionServiceModel.SQL_LIST_MISSION_MODEL)
        customExecuteSql(ListPmGoalsActionServiceModel.MODEL_NAME, ListPmGoalsActionServiceModel.SQL_LIST_GOALS_MODEL)
        customExecuteSql(ListPmActionsActionServiceModel.MODEL_NAME, ListPmActionsActionServiceModel.SQL_LIST_ACTIONS_MODEL)
        customExecuteSql(ListPmAdditionalActionsActionServiceModel.MODEL_NAME, ListPmAdditionalActionsActionServiceModel.SQL_LIST_ADDITIONAL_ACTIONS_MODEL)
        customExecuteSql(ListPmMcrsLogActionServiceModel.MODEL_NAME, ListPmMcrsLogActionServiceModel.SQL_LIST_PM_MCRS_LOG_MODEL)
        customExecuteSql(ListPmProjectsActionServiceModel.MODEL_NAME, ListPmProjectsActionServiceModel.SQL_LIST_PROJECTS_MODEL)
        customExecuteSql(ListPmServiceSectorActionServiceModel.MODEL_NAME, ListPmServiceSectorActionServiceModel.SQL_LIST_SERVICE_MODEL)
        customExecuteSql(ListPmSpLogActionServiceModel.MODEL_NAME, ListPmSpLogActionServiceModel.SQL_LIST_PM_SP_LOG_MODEL)
        customExecuteSql(ListPmSprintsActionServiceModel.MODEL_NAME, ListPmSprintsActionServiceModel.SQL_LIST_SPRINTS_MODEL)
        customExecuteSql(ListPmSpSummaryActionServiceModel.MODEL_NAME, ListPmSpSummaryActionServiceModel.SQL_LIST_SP_SUMMARY_MODEL)
        customExecuteSql(ListQuartzActionServiceModel.MODEL_NAME, ListQuartzActionServiceModel.SQL_LIST_QUARTZ_MODEL)
        customExecuteSql(ListSpTimeScheduleActionServiceModel.MODEL_NAME, ListSpTimeScheduleActionServiceModel.SQL_LIST_SP_TIME_SCHEDULE_MODEL)
}

    public boolean customExecuteSql(String model, String query) {
        String dropTable = """ DROP TABLE IF EXISTS ${model} """
        String dropView = """ DROP VIEW IF EXISTS ${model} """
        executeSql(dropTable)
        executeSql(dropView)
        executeSql(query)
        return true;
    }

    public void initData() {
        SecUser U1 = new SecUser(username:'admin', password:'admin', enabled:true).save()
        SecRole R1 = new SecRole(name: 'Admin', authority: 'ROLE_PMS_ADMIN').save()
        SecUserSecRole.create(U1, R1)

        new FeatureManagement(url: '/login/**', configAttribute: 'IS_AUTHENTICATED_ANONYMOUSLY', featureName: '').save()
        new FeatureManagement(url: '/logout/**', configAttribute: 'IS_AUTHENTICATED_ANONYMOUSLY', featureName: '').save()
        new FeatureManagement(url: '/css/**', configAttribute: 'IS_AUTHENTICATED_ANONYMOUSLY', featureName: '').save()
        new FeatureManagement(url: '/js/**', configAttribute: 'IS_AUTHENTICATED_ANONYMOUSLY', featureName: '').save()
        new FeatureManagement(url: '/images/**', configAttribute: 'IS_AUTHENTICATED_ANONYMOUSLY', featureName: '').save()
        new FeatureManagement(url: '/dist/**', configAttribute: 'IS_AUTHENTICATED_ANONYMOUSLY', featureName: '').save()
        new FeatureManagement(url: '/components/**', configAttribute: 'IS_AUTHENTICATED_ANONYMOUSLY', featureName: '').save()

        new FeatureManagement(url: '/', configAttribute: 'ROLE_PMS_ADMIN', featureName: '').save()
        new FeatureManagement(url: '/secUser/show', configAttribute: 'ROLE_PMS_ADMIN', featureName: 'Show user').save()
        new FeatureManagement(url: '/secUser/create', configAttribute: 'ROLE_PMS_ADMIN', featureName: 'Create user').save()
        new FeatureManagement(url: '/secUser/update', configAttribute: 'ROLE_PMS_ADMIN', featureName: 'Update user').save()
        new FeatureManagement(url: '/secUser/delete', configAttribute: 'ROLE_PMS_ADMIN', featureName: 'Delete user').save()
        new FeatureManagement(url: '/secUser/list', configAttribute: 'ROLE_PMS_ADMIN', featureName: 'List user').save()
        new FeatureManagement(url: '/secUser/resetPassword', configAttribute: 'ROLE_PMS_ADMIN', featureName: 'Reset password').save()

        new FeatureManagement(url: '/secRole/show', configAttribute: 'ROLE_PMS_ADMIN', featureName: 'Show role').save()
        new FeatureManagement(url: '/secRole/create', configAttribute: 'ROLE_PMS_ADMIN', featureName: 'Create role').save()
        new FeatureManagement(url: '/secRole/update', configAttribute: 'ROLE_PMS_ADMIN', featureName: 'Update role').save()
        new FeatureManagement(url: '/secRole/delete', configAttribute: 'ROLE_PMS_ADMIN', featureName: 'Delete role').save()
        new FeatureManagement(url: '/secRole/list', configAttribute: 'ROLE_PMS_ADMIN', featureName: 'List role').save()

        new FeatureManagement(url: '/secUserSecRole/show', configAttribute: 'ROLE_PMS_ADMIN', featureName: 'Show user role mapping').save()
        new FeatureManagement(url: '/secUserSecRole/create', configAttribute: 'ROLE_PMS_ADMIN', featureName: 'Create user role mapping').save()
        new FeatureManagement(url: '/secUserSecRole/update', configAttribute: 'ROLE_PMS_ADMIN', featureName: 'Update user role mapping').save()
        new FeatureManagement(url: '/secUserSecRole/delete', configAttribute: 'ROLE_PMS_ADMIN', featureName: 'Delete user role mapping').save()
        new FeatureManagement(url: '/secUserSecRole/list', configAttribute: 'ROLE_PMS_ADMIN', featureName: 'List user role mapping').save()
        new FeatureManagement(url: '/secUser/reloadDropDown', configAttribute: 'ROLE_PMS_ADMIN', featureName: 'Reload user dropdown').save()
        new FeatureManagement(url: '/secUserSecRole/report', configAttribute: 'ROLE_PMS_ADMIN', featureName: 'Download user role mapping report').save()

        new FeatureManagement(url: '/featureManagement/show', configAttribute: 'ROLE_PMS_ADMIN', featureName: 'Show feature management').save()
        new FeatureManagement(url: '/featureManagement/update', configAttribute: 'ROLE_PMS_ADMIN', featureName: 'Update feature management').save()
        new FeatureManagement(url: '/featureManagement/listAvailableRole', configAttribute: 'ROLE_PMS_ADMIN', featureName: 'Available features').save()
        new FeatureManagement(url: '/featureManagement/listAssignedRole', configAttribute: 'ROLE_PMS_ADMIN', featureName: 'Assigned features').save()


        executeSql(ThemeService.INSERT_QUERY_COMMON_CSS)

    }
}
