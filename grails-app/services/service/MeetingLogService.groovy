package service

import com.pms.MeetingLog
import com.pms.PropertiesReader
import com.pms.SecUser
import com.pms.SystemEntity
import grails.transaction.Transactional
import groovy.sql.GroovyRowResult
import pms.BaseService
import pms.utility.DateUtility

@Transactional
class MeetingLogService extends BaseService {
    public boolean isAnyMeetingHeldForQuarterAnnual(Date startDate,Date endDate,long serviceId) {
        String query = """
SELECT COUNT(id) c FROM meeting_log WHERE service_id=${serviceId} AND
 (held_on BETWEEN DATE('${startDate}') AND DATE('${endDate}') OR end_date BETWEEN DATE('${startDate}') AND DATE('${endDate}'))
        """
        List<GroovyRowResult> lst = executeSelectSql(query)
        int count =(int) lst[0].c
        if (count > 0) {
            return Boolean.TRUE
        }
        return Boolean.FALSE
    }
    public boolean isAnyMeetingHeldForQuarterAnnualUpdate(Date startDate,Date endDate,long serviceId,long meetingId) {
        String query = """
SELECT COUNT(id) c FROM meeting_log WHERE service_id=${serviceId}  AND id<> ${meetingId} AND
 (held_on BETWEEN DATE('${startDate}') AND DATE('${endDate}') OR end_date BETWEEN DATE('${startDate}') AND DATE('${endDate}'))
        """
        List<GroovyRowResult> lst = executeSelectSql(query)
        int count =(int) lst[0].c
        if (count > 0) {
            return Boolean.TRUE
        }
        return Boolean.FALSE
    }
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
            s.id service_id,s.name service,DATE_FORMAT(ml.held_on, '%d-%b-%Y') held_on,
            CASE
            WHEN LOCATE('<table>',ml.log_str)> 0
            THEN REPLACE(ml.log_str, '<table>','<table class="table table-bordered">')
            ELSE ml.log_str END log_str,
            CASE
            WHEN LOCATE('<table>',ml.desc_str)> 0
            THEN REPLACE(ml.desc_str, '<table>','<table class="table table-bordered">')
            ELSE ml.desc_str END desc_str,
            ml.issues,ml.attendees,(SELECT GROUP_CONCAT(NAME SEPARATOR ', ') FROM mis.employee
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
            String userDepartmentLst = currentUserDepartmentListStr()
            additionalParam = " AND ss.id IN (${userDepartmentLst}) "
        }
        int year = Integer.parseInt(yearStr)
        SystemEntity meetingType = SystemEntity.findById(meetingTypeId)
        String query = """"""
        if(meetingType.name.equals("Quarterly")||meetingType.name.equals("Annually")) {
            query = """
                SELECT l.id,0 version,se.name meetingType,l.held_on heldOn,l.end_date endDate,l.upload_date uploadDate,l.desc_str descStr,COALESCE(l.file_name,'') fileName
                    FROM meeting_log l
                    LEFT JOIN system_entity se ON se.id = l.meeting_type_id
                    WHERE DATE_FORMAT(l.held_on,'%Y') = ${year}
                AND l.meeting_type_id = ${meetingTypeId} AND l.is_uploaded=TRUE
                ORDER BY l.held_on DESC
                """
        }else if(meetingType.name.equals("Functional")) {
            query = """
                SELECT tmp.id SERVICE_ID,'' SERVICE_NAME,'' SERVICE_STR,tmp.MEETING_TYPE,
                COALESCE(GROUP_CONCAT(tmp.January ORDER BY tmp.held_on),'') JANUARY,COALESCE(GROUP_CONCAT(tmp.February ORDER BY tmp.held_on),'') FEBRUARY,COALESCE(GROUP_CONCAT(tmp.March ORDER BY tmp.held_on),'') MARCH,
                COALESCE(GROUP_CONCAT(tmp.April ORDER BY tmp.held_on),'')   APRIL,  COALESCE(GROUP_CONCAT(tmp.May ORDER BY tmp.held_on),'')      MAY,     COALESCE(GROUP_CONCAT(tmp.June ORDER BY tmp.held_on),'') JUNE,
                COALESCE(GROUP_CONCAT(tmp.July ORDER BY tmp.held_on),'')    JULY,   COALESCE(GROUP_CONCAT(tmp.August ORDER BY tmp.held_on),'')   AUGUST,  COALESCE(GROUP_CONCAT(tmp.September ORDER BY tmp.held_on),'') SEPTEMBER,
                COALESCE(GROUP_CONCAT(tmp.October ORDER BY tmp.held_on),'') OCTOBER,COALESCE(GROUP_CONCAT(tmp.November ORDER BY tmp.held_on),'') NOVEMBER,COALESCE(GROUP_CONCAT(tmp.December ORDER BY tmp.held_on),'') DECEMBER
                FROM (
                    SELECT l.id,se.name MEETING_TYPE,l.held_on,
                    CASE WHEN DATE_FORMAT(l.held_on,'%M')='January' AND l.upload_date IS NOT NULL   THEN CONCAT(l.id,'&',DATE_FORMAT(l.held_on,'%d-%m-%y'),'&',DATE_FORMAT(l.upload_date,'%d-%m-%y'))
                    WHEN DATE_FORMAT(l.held_on,'%M')='January' THEN CONCAT(l.id,'&',DATE_FORMAT(l.held_on,'%d-%m-%y')) ELSE NULL END January,
                    CASE WHEN DATE_FORMAT(l.held_on,'%M')='February' AND l.upload_date IS NOT NULL  THEN CONCAT(l.id,'&',DATE_FORMAT(l.held_on,'%d-%m-%y'),'&',DATE_FORMAT(l.upload_date,'%d-%m-%y'))
                    WHEN DATE_FORMAT(l.held_on,'%M')='February'  THEN CONCAT(l.id,'&',DATE_FORMAT(l.held_on,'%d-%m-%y'))  ELSE NULL END February,
                    CASE WHEN DATE_FORMAT(l.held_on,'%M')='March' AND l.upload_date IS NOT NULL     THEN CONCAT(l.id,'&',DATE_FORMAT(l.held_on,'%d-%m-%y'),'&',DATE_FORMAT(l.upload_date,'%d-%m-%y'))
                    WHEN DATE_FORMAT(l.held_on,'%M')='March' THEN CONCAT(l.id,'&',DATE_FORMAT(l.held_on,'%d-%m-%y')) ELSE NULL END March,
                    CASE WHEN DATE_FORMAT(l.held_on,'%M')='April' AND l.upload_date IS NOT NULL     THEN CONCAT(l.id,'&',DATE_FORMAT(l.held_on,'%d-%m-%y'),'&',DATE_FORMAT(l.upload_date,'%d-%m-%y'))
                    WHEN DATE_FORMAT(l.held_on,'%M')='April'   THEN CONCAT(l.id,'&',DATE_FORMAT(l.held_on,'%d-%m-%y')) ELSE NULL END April,
                    CASE WHEN DATE_FORMAT(l.held_on,'%M')='May' AND l.upload_date IS NOT NULL       THEN CONCAT(l.id,'&',DATE_FORMAT(l.held_on,'%d-%m-%y'),'&',DATE_FORMAT(l.upload_date,'%d-%m-%y'))
                    WHEN DATE_FORMAT(l.held_on,'%M')='May' THEN CONCAT(l.id,'&',DATE_FORMAT(l.held_on,'%d-%m-%y')) ELSE NULL END May,
                    CASE WHEN DATE_FORMAT(l.held_on,'%M')='June' AND l.upload_date IS NOT NULL      THEN CONCAT(l.id,'&',DATE_FORMAT(l.held_on,'%d-%m-%y'),'&',DATE_FORMAT(l.upload_date,'%d-%m-%y'))
                    WHEN DATE_FORMAT(l.held_on,'%M')='June' THEN CONCAT(l.id,'&',DATE_FORMAT(l.held_on,'%d-%m-%y'))ELSE NULL END June,
                    CASE WHEN DATE_FORMAT(l.held_on,'%M')='July' AND l.upload_date IS NOT NULL      THEN CONCAT(l.id,'&',DATE_FORMAT(l.held_on,'%d-%m-%y'),'&',DATE_FORMAT(l.upload_date,'%d-%m-%y'))
                    WHEN DATE_FORMAT(l.held_on,'%M')='July' THEN CONCAT(l.id,'&',DATE_FORMAT(l.held_on,'%d-%m-%y'))  ELSE NULL END July,
                    CASE WHEN DATE_FORMAT(l.held_on,'%M')='August' AND l.upload_date IS NOT NULL    THEN CONCAT(l.id,'&',DATE_FORMAT(l.held_on,'%d-%m-%y'),'&',DATE_FORMAT(l.upload_date,'%d-%m-%y'))
                    WHEN DATE_FORMAT(l.held_on,'%M')='August' THEN CONCAT(l.id,'&',DATE_FORMAT(l.held_on,'%d-%m-%y'))ELSE NULL END August,
                    CASE WHEN DATE_FORMAT(l.held_on,'%M')='September' AND l.upload_date IS NOT NULL THEN CONCAT(l.id,'&',DATE_FORMAT(l.held_on,'%d-%m-%y'),'&',DATE_FORMAT(l.upload_date,'%d-%m-%y'))
                    WHEN DATE_FORMAT(l.held_on,'%M')='September' THEN CONCAT(l.id,'&',DATE_FORMAT(l.held_on,'%d-%m-%y'))ELSE NULL END September,
                    CASE WHEN DATE_FORMAT(l.held_on,'%M')='October' AND l.upload_date IS NOT NULL   THEN CONCAT(l.id,'&',DATE_FORMAT(l.held_on,'%d-%m-%y'),'&',DATE_FORMAT(l.upload_date,'%d-%m-%y'))
                    WHEN DATE_FORMAT(l.held_on,'%M')='October' THEN CONCAT(l.id,'&',DATE_FORMAT(l.held_on,'%d-%m-%y'))ELSE NULL END October,
                    CASE WHEN DATE_FORMAT(l.held_on,'%M')='November' AND l.upload_date IS NOT NULL  THEN CONCAT(l.id,'&',DATE_FORMAT(l.held_on,'%d-%m-%y'),'&',DATE_FORMAT(l.upload_date,'%d-%m-%y'))
                    WHEN DATE_FORMAT(l.held_on,'%M')='November' THEN CONCAT(l.id,'&',DATE_FORMAT(l.held_on,'%d-%m-%y'))ELSE NULL END November,
                    CASE WHEN DATE_FORMAT(l.held_on,'%M')='December' AND l.upload_date IS NOT NULL  THEN CONCAT(l.id,'&',DATE_FORMAT(l.held_on,'%d-%m-%y'),'&',DATE_FORMAT(l.upload_date,'%d-%m-%y'))
                    WHEN DATE_FORMAT(l.held_on,'%M')='December' THEN CONCAT(l.id,'&',DATE_FORMAT(l.held_on,'%d-%m-%y'))ELSE NULL END December
                    FROM meeting_log l LEFT JOIN system_entity se ON se.id = ${meetingTypeId}
                    WHERE DATE_FORMAT(l.held_on,'%Y') = ${year}  AND l.meeting_type_id = ${meetingTypeId} AND l.is_uploaded=TRUE

                    ORDER BY l.held_on ASC) tmp
                GROUP BY DATE_FORMAT(tmp.held_on,'%M'),DATE_FORMAT(tmp.held_on,'%Y');
                """
        }else{
            query = """
                SELECT tmp.id SERVICE_ID,tmp.name SERVICE_NAME,tmp.short_name SERVICE_STR,tmp.MEETING_TYPE,
                COALESCE(GROUP_CONCAT(tmp.January ORDER BY tmp.held_on),'') JANUARY,COALESCE(GROUP_CONCAT(tmp.February ORDER BY tmp.held_on),'') FEBRUARY,COALESCE(GROUP_CONCAT(tmp.March ORDER BY tmp.held_on),'') MARCH,
                COALESCE(GROUP_CONCAT(tmp.April ORDER BY tmp.held_on),'')   APRIL,  COALESCE(GROUP_CONCAT(tmp.May ORDER BY tmp.held_on),'')      MAY,     COALESCE(GROUP_CONCAT(tmp.June ORDER BY tmp.held_on),'') JUNE,
                COALESCE(GROUP_CONCAT(tmp.July ORDER BY tmp.held_on),'')    JULY,   COALESCE(GROUP_CONCAT(tmp.August ORDER BY tmp.held_on),'')   AUGUST,  COALESCE(GROUP_CONCAT(tmp.September ORDER BY tmp.held_on),'') SEPTEMBER,
                COALESCE(GROUP_CONCAT(tmp.October ORDER BY tmp.held_on),'') OCTOBER,COALESCE(GROUP_CONCAT(tmp.November ORDER BY tmp.held_on),'') NOVEMBER,COALESCE(GROUP_CONCAT(tmp.December  ORDER BY tmp.held_on),'') DECEMBER
                FROM (
                     SELECT ss.id,ss.name,ss.short_name,se.name MEETING_TYPE,l.held_on,
                    CASE WHEN DATE_FORMAT(l.held_on,'%M')='January' AND l.upload_date IS NOT NULL   THEN CONCAT(l.id,'&',DATE_FORMAT(l.held_on,'%d-%m-%y'),'&',DATE_FORMAT(l.upload_date,'%d-%m-%y'))
                    WHEN DATE_FORMAT(l.held_on,'%M')='January' THEN CONCAT(l.id,'&',DATE_FORMAT(l.held_on,'%d-%m-%y')) ELSE NULL END January,
                    CASE WHEN DATE_FORMAT(l.held_on,'%M')='February' AND l.upload_date IS NOT NULL  THEN CONCAT(l.id,'&',DATE_FORMAT(l.held_on,'%d-%m-%y'),'&',DATE_FORMAT(l.upload_date,'%d-%m-%y'))
                    WHEN DATE_FORMAT(l.held_on,'%M')='February'  THEN CONCAT(l.id,'&',DATE_FORMAT(l.held_on,'%d-%m-%y'))  ELSE NULL END February,
                    CASE WHEN DATE_FORMAT(l.held_on,'%M')='March' AND l.upload_date IS NOT NULL     THEN CONCAT(l.id,'&',DATE_FORMAT(l.held_on,'%d-%m-%y'),'&',DATE_FORMAT(l.upload_date,'%d-%m-%y'))
                    WHEN DATE_FORMAT(l.held_on,'%M')='March' THEN CONCAT(l.id,'&',DATE_FORMAT(l.held_on,'%d-%m-%y')) ELSE NULL END March,
                    CASE WHEN DATE_FORMAT(l.held_on,'%M')='April' AND l.upload_date IS NOT NULL     THEN CONCAT(l.id,'&',DATE_FORMAT(l.held_on,'%d-%m-%y'),'&',DATE_FORMAT(l.upload_date,'%d-%m-%y'))
                    WHEN DATE_FORMAT(l.held_on,'%M')='April'   THEN CONCAT(l.id,'&',DATE_FORMAT(l.held_on,'%d-%m-%y')) ELSE NULL END April,
                    CASE WHEN DATE_FORMAT(l.held_on,'%M')='May' AND l.upload_date IS NOT NULL       THEN CONCAT(l.id,'&',DATE_FORMAT(l.held_on,'%d-%m-%y'),'&',DATE_FORMAT(l.upload_date,'%d-%m-%y'))
                    WHEN DATE_FORMAT(l.held_on,'%M')='May' THEN CONCAT(l.id,'&',DATE_FORMAT(l.held_on,'%d-%m-%y')) ELSE NULL END May,
                    CASE WHEN DATE_FORMAT(l.held_on,'%M')='June' AND l.upload_date IS NOT NULL      THEN CONCAT(l.id,'&',DATE_FORMAT(l.held_on,'%d-%m-%y'),'&',DATE_FORMAT(l.upload_date,'%d-%m-%y'))
                    WHEN DATE_FORMAT(l.held_on,'%M')='June' THEN CONCAT(l.id,'&',DATE_FORMAT(l.held_on,'%d-%m-%y'))ELSE NULL END June,
                    CASE WHEN DATE_FORMAT(l.held_on,'%M')='July' AND l.upload_date IS NOT NULL      THEN CONCAT(l.id,'&',DATE_FORMAT(l.held_on,'%d-%m-%y'),'&',DATE_FORMAT(l.upload_date,'%d-%m-%y'))
                    WHEN DATE_FORMAT(l.held_on,'%M')='July' THEN CONCAT(l.id,'&',DATE_FORMAT(l.held_on,'%d-%m-%y'))  ELSE NULL END July,
                    CASE WHEN DATE_FORMAT(l.held_on,'%M')='August' AND l.upload_date IS NOT NULL    THEN CONCAT(l.id,'&',DATE_FORMAT(l.held_on,'%d-%m-%y'),'&',DATE_FORMAT(l.upload_date,'%d-%m-%y'))
                    WHEN DATE_FORMAT(l.held_on,'%M')='August' THEN CONCAT(l.id,'&',DATE_FORMAT(l.held_on,'%d-%m-%y'))ELSE NULL END August,
                    CASE WHEN DATE_FORMAT(l.held_on,'%M')='September' AND l.upload_date IS NOT NULL THEN CONCAT(l.id,'&',DATE_FORMAT(l.held_on,'%d-%m-%y'),'&',DATE_FORMAT(l.upload_date,'%d-%m-%y'))
                    WHEN DATE_FORMAT(l.held_on,'%M')='September' THEN CONCAT(l.id,'&',DATE_FORMAT(l.held_on,'%d-%m-%y'))ELSE NULL END September,
                    CASE WHEN DATE_FORMAT(l.held_on,'%M')='October' AND l.upload_date IS NOT NULL   THEN CONCAT(l.id,'&',DATE_FORMAT(l.held_on,'%d-%m-%y'),'&',DATE_FORMAT(l.upload_date,'%d-%m-%y'))
                    WHEN DATE_FORMAT(l.held_on,'%M')='October' THEN CONCAT(l.id,'&',DATE_FORMAT(l.held_on,'%d-%m-%y'))ELSE NULL END October,
                    CASE WHEN DATE_FORMAT(l.held_on,'%M')='November' AND l.upload_date IS NOT NULL  THEN CONCAT(l.id,'&',DATE_FORMAT(l.held_on,'%d-%m-%y'),'&',DATE_FORMAT(l.upload_date,'%d-%m-%y'))
                    WHEN DATE_FORMAT(l.held_on,'%M')='November' THEN CONCAT(l.id,'&',DATE_FORMAT(l.held_on,'%d-%m-%y'))ELSE NULL END November,
                    CASE WHEN DATE_FORMAT(l.held_on,'%M')='December' AND l.upload_date IS NOT NULL  THEN CONCAT(l.id,'&',DATE_FORMAT(l.held_on,'%d-%m-%y'),'&',DATE_FORMAT(l.upload_date,'%d-%m-%y'))
                    WHEN DATE_FORMAT(l.held_on,'%M')='December' THEN CONCAT(l.id,'&',DATE_FORMAT(l.held_on,'%d-%m-%y'))ELSE NULL END December
                    FROM pm_service_sector ss
                    LEFT JOIN meeting_log l ON l.service_id = ss.id AND l.is_uploaded=TRUE AND DATE_FORMAT(l.held_on,'%Y') = ${year}  AND l.meeting_type_id = ${meetingTypeId}
                    LEFT JOIN system_entity se ON se.id = ${meetingTypeId}
                    WHERE ss.is_in_sp = TRUE
                    ${additionalParam}
                    ORDER BY ss.short_name,l.held_on ASC) tmp
                GROUP BY tmp.short_name;
        """
        }
        List<GroovyRowResult> lst = executeSelectSql(query)
        return lst
    }
    def fileUploader(def file,String prefix){

        String meeting_dir = PropertiesReader.getProperty("meeting.log.location", PropertiesReader.CONFIG_FILE_DB)
        File theDir = new File(meeting_dir);
        if (!theDir.exists()) {
            System.out.println("creating directory: " + theDir.getName());
            boolean result = false;
            try{
                theDir.mkdir();
                result = true;
            }
            catch(SecurityException se){
                //handle it
            }
            if(result) {
                System.out.println("DIR created");
            }
        }

        Random randomGenerator = new Random()
        //int randomInt = randomGenerator.nextInt(1000000)
        def docName = prefix+"_"+file?.getOriginalFilename()
        //log.debug"Random no: "+randomInt

        InputStream is = file?.getInputStream()
        OutputStream os = new FileOutputStream(meeting_dir+docName)   //file path
        //log.debug"Image Size: "+file?.getSize()
        byte[] buffer = new byte[file?.getSize()]
        int bytesRead
        while ((bytesRead = is.read(buffer)) != -1) {
            os.write(buffer, 0, bytesRead)
        }
        is.close()
        os.close()
        return docName
    }
    public boolean fileDelete(String fileName){
        String meeting_dir = PropertiesReader.getProperty("meeting.log.location", PropertiesReader.CONFIG_FILE_DB)

        def file = new File(meeting_dir+fileName)
        boolean fileSuccessfullyDeleted = file.delete()

        return fileSuccessfullyDeleted
    }
}
