package service

import com.pms.MeetingLog
import com.pms.SecUser
import com.pms.SystemEntity
import grails.transaction.Transactional
import groovy.sql.GroovyRowResult
import pms.BaseService
import pms.utility.DateUtility

@Transactional
class MeetingLogService extends BaseService {

    public boolean isWeeklyMeetingHeld(Date date, long serviceId, long meetingTypeId) {
        Calendar cal = Calendar.getInstance();
        cal.setTime(date);
        for(int i = Calendar.SUNDAY; i <= Calendar.SATURDAY; i++) {
            cal.set(Calendar.DAY_OF_WEEK, i);
            Date sqlDate = DateUtility.getSqlDate(cal.getTime())
            int count = MeetingLog.countByServiceIdAndHeldOnAndMeetingTypeId(serviceId,sqlDate,meetingTypeId)
            if (count > 0) {
                return Boolean.TRUE
            }
        }
        return Boolean.FALSE
    }

    public boolean isMonthlyMeetingHeld(Date date, long serviceId, long meetingTypeId, long catId) {
        Calendar cal = Calendar.getInstance();
        cal.setTime(date);
        cal.set(Calendar.DAY_OF_MONTH, cal.getActualMinimum(Calendar.DAY_OF_MONTH));
        Date start = DateUtility.getSqlDate(cal.getTime())

        cal.set(Calendar.DAY_OF_MONTH, cal.getActualMaximum(Calendar.DAY_OF_MONTH));
        Date end = DateUtility.getSqlDate(cal.getTime())

        int count = MeetingLog.countByMeetingTypeIdAndMeetingCatIdAndServiceIdAndHeldOnBetween(meetingTypeId,catId,serviceId,start,end)
        if (count > 0) {
            return Boolean.TRUE
        }
        return Boolean.FALSE
    }

    public boolean isWeeklyMeetingHeldUpdate(Date date, long serviceId, long meetingId, long meetingTypeId) {
        Calendar cal = Calendar.getInstance();
        cal.setTime(date);
        for(int i = Calendar.SUNDAY; i <= Calendar.SATURDAY; i++) {
            cal.set(Calendar.DAY_OF_WEEK, i);
            Date sqlDate = DateUtility.getSqlDate(cal.getTime())
            int count = MeetingLog.countByMeetingTypeIdAndServiceIdAndHeldOnAndIdNotEqual(meetingTypeId,serviceId,sqlDate,meetingId)
            if (count > 0) {
                return Boolean.TRUE
            }
        }
        return Boolean.FALSE
    }
    public boolean isMonthlyMeetingHeldUpdate(Date date, long serviceId, long meetingId, long meetingTypeId, long catId) {
        Calendar cal = Calendar.getInstance();
        cal.setTime(date);
        cal.set(Calendar.DAY_OF_MONTH, cal.getActualMinimum(Calendar.DAY_OF_MONTH));
        Date start = DateUtility.getSqlDate(cal.getTime())

        cal.set(Calendar.DAY_OF_MONTH, cal.getActualMaximum(Calendar.DAY_OF_MONTH));
        Date end = DateUtility.getSqlDate(cal.getTime())

        int count = MeetingLog.countByMeetingTypeIdAndMeetingCatIdAndServiceIdAndHeldOnBetweenAndIdNotEqual(meetingTypeId,catId,serviceId,start,end,meetingId)
        if (count > 0) {
            return Boolean.TRUE
        }
        return Boolean.FALSE
    }
    public List<GroovyRowResult> meetingDetails(long id) {

        String query = """
        SELECT ml.id, ml.version, mt.id meeting_type_id,mt.name meeting_type,cat.id meeting_cat_id, cat.name meeting_cat,
              s.id service_id,s.name service,DATE_FORMAT(ml.held_on, '%d-%b-%Y') held_on,ml.log_str,ml.issues,ml.attendees,
              ml.desc_str,(SELECT GROUP_CONCAT(NAME SEPARATOR ', ') FROM mis.employee
              WHERE LOCATE(CONCAT(',',id,',') ,CONCAT(',',ml.attendees,', '))>0 ) attendees_str
        FROM meeting_log ml
        LEFT JOIN login_auth.sec_user u ON u.employee_id = ml.attendees
        LEFT JOIN system_entity mt ON mt.id = ml.meeting_type_id
        LEFT JOIN meeting_category cat ON cat.id = ml.meeting_cat_id
        LEFT JOIN pm_service_sector s ON s.id = ml.service_id
        WHERE ml.id = ${id}
        """
        List<GroovyRowResult> lst = executeSelectSql(query)
        return lst
    }
    public List<GroovyRowResult> lstDepartmentWeeklyMeetingStatus(String yearStr, long meetingTypeId) {
        String additionalParam = EMPTY_SPACE
        SecUser user = currentUserObject()
        boolean isSysAdmin = isUserSystemAdmin(user.id)
        boolean isTopMan = isUserTopManagement(user.id)
        boolean isSpAdmin = isEdAdminRole(user.id)
        boolean isEdAssistant = isEdAssistantRole(user.id)
        if(!isSysAdmin && !isSpAdmin && !isTopMan&& !isEdAssistant){
            additionalParam = " AND ss.id = ${user.serviceId} "
        }

        int year = Integer.parseInt(yearStr)
        String query = """
                SELECT tmp.id SERVICE_ID,tmp.name SERVICE_NAME,tmp.short_name SERVICE_STR,tmp.MEETING_TYPE,
                COALESCE(GROUP_CONCAT(tmp.January),'') JANUARY,COALESCE(GROUP_CONCAT(tmp.February),'') FEBRUARY,COALESCE(GROUP_CONCAT(tmp.March),'') MARCH,
                COALESCE(GROUP_CONCAT(tmp.April),'')   APRIL,  COALESCE(GROUP_CONCAT(tmp.May),'')      MAY,     COALESCE(GROUP_CONCAT(tmp.June),'') JUNE,
                COALESCE(GROUP_CONCAT(tmp.July),'')    JULY,   COALESCE(GROUP_CONCAT(tmp.August),'')   AUGUST,  COALESCE(GROUP_CONCAT(tmp.September),'') SEPTEMBER,
                COALESCE(GROUP_CONCAT(tmp.October),'') OCTOBER,COALESCE(GROUP_CONCAT(tmp.November),'') NOVEMBER,COALESCE(GROUP_CONCAT(tmp.December),'') DECEMBER
                FROM (
                    SELECT ss.id,ss.name,ss.short_name,se.name MEETING_TYPE,
                    CASE WHEN DATE_FORMAT(l.held_on,'%M')='January'   THEN CONCAT(l.id,'&',DATE_FORMAT(l.held_on,'%d-%b-%y')) ELSE NULL END January,
                    CASE WHEN DATE_FORMAT(l.held_on,'%M')='February'  THEN CONCAT(l.id,'&',DATE_FORMAT(l.held_on,'%d-%b-%y')) ELSE NULL END February,
                    CASE WHEN DATE_FORMAT(l.held_on,'%M')='March'     THEN CONCAT(l.id,'&',DATE_FORMAT(l.held_on,'%d-%b-%y')) ELSE NULL END March,
                    CASE WHEN DATE_FORMAT(l.held_on,'%M')='April'     THEN CONCAT(l.id,'&',DATE_FORMAT(l.held_on,'%d-%b-%y')) ELSE NULL END April,
                    CASE WHEN DATE_FORMAT(l.held_on,'%M')='May'       THEN CONCAT(l.id,'&',DATE_FORMAT(l.held_on,'%d-%b-%y')) ELSE NULL END May,
                    CASE WHEN DATE_FORMAT(l.held_on,'%M')='June'      THEN CONCAT(l.id,'&',DATE_FORMAT(l.held_on,'%d-%b-%y')) ELSE NULL END June,
                    CASE WHEN DATE_FORMAT(l.held_on,'%M')='July'      THEN CONCAT(l.id,'&',DATE_FORMAT(l.held_on,'%d-%b-%y')) ELSE NULL END July,
                    CASE WHEN DATE_FORMAT(l.held_on,'%M')='August'    THEN CONCAT(l.id,'&',DATE_FORMAT(l.held_on,'%d-%b-%y')) ELSE NULL END August,
                    CASE WHEN DATE_FORMAT(l.held_on,'%M')='September' THEN CONCAT(l.id,'&',DATE_FORMAT(l.held_on,'%d-%b-%y')) ELSE NULL END September,
                    CASE WHEN DATE_FORMAT(l.held_on,'%M')='October'   THEN CONCAT(l.id,'&',DATE_FORMAT(l.held_on,'%d-%b-%y')) ELSE NULL END October,
                    CASE WHEN DATE_FORMAT(l.held_on,'%M')='November'  THEN CONCAT(l.id,'&',DATE_FORMAT(l.held_on,'%d-%b-%y')) ELSE NULL END November,
                    CASE WHEN DATE_FORMAT(l.held_on,'%M')='December'  THEN CONCAT(l.id,'&',DATE_FORMAT(l.held_on,'%d-%b-%y')) ELSE NULL END December
                    FROM pm_service_sector ss
                    LEFT JOIN meeting_log l ON l.service_id = ss.id AND DATE_FORMAT(l.held_on,'%Y') = ${year}  AND l.meeting_type_id = ${meetingTypeId}
                    LEFT JOIN system_entity se ON se.id = ${meetingTypeId}
                    WHERE ss.is_in_sp = TRUE
                    ${additionalParam}
                    ORDER BY ss.short_name ASC) tmp
                GROUP BY tmp.short_name;
        """
        List<GroovyRowResult> lst = executeSelectSql(query)
        return lst
    }
}
