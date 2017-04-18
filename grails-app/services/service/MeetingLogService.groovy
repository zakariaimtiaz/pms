package service

import com.pms.MeetingLog
import grails.transaction.Transactional
import pms.utility.DateUtility

@Transactional
class MeetingLogService {

    public boolean isWeeklyMeetingHeld(Date date, long serviceId) {
        Calendar cal = Calendar.getInstance();
        cal.setTime(date);
        for(int i = Calendar.SUNDAY; i <= Calendar.SATURDAY; i++) {
            cal.set(Calendar.DAY_OF_WEEK, i);
            int count = MeetingLog.countByServiceIdAndHeldOn(serviceId,DateUtility.getSqlDate(cal.getTime()))
            if (count > 0) {
                return Boolean.TRUE
            }
        }
        return Boolean.FALSE
    }
    public boolean isWeeklyMeetingHeldUpdate(Date date, long serviceId, long meetingId) {
        Calendar cal = Calendar.getInstance();
        cal.setTime(date);
        for(int i = Calendar.SUNDAY; i <= Calendar.SATURDAY; i++) {
            cal.set(Calendar.DAY_OF_WEEK, i);
            int count = MeetingLog.countByServiceIdAndHeldOnAndIdNotEqual(serviceId,DateUtility.getSqlDate(cal.getTime()),meetingId)
            if (count > 0) {
                return Boolean.TRUE
            }
        }
        return Boolean.FALSE
    }
}
