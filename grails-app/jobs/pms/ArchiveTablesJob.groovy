package pms

import com.pms.PmMcrsLog
import com.pms.PmServiceSector
import pms.utility.DateUtility

class ArchiveTablesJob {
    def mailService

    static triggers = {
        cron name: 'cronTrigger', cronExpression: "0 0 9 * * ?"

    }

    def execute() {
        Calendar now = Calendar.getInstance();
        int year = now.get(Calendar.YEAR);
        int month = now.get(Calendar.MONTH);
        int currentDay = now.get(Calendar.DAY_OF_MONTH);

        List<PmMcrsLog> lstLog = PmMcrsLog.findAllByMonthAndYearAndDeadLineIsNotNull(month, year)
        Calendar c = Calendar.getInstance();

        for (int i = 0; i < lstLog.size(); i++) {
            c.setTime(lstLog[i].deadLine);
            int deadlineDay = c.get(Calendar.DAY_OF_MONTH);
            PmServiceSector sc = PmServiceSector.findByIdAndIsInSp(lstLog[i].serviceId, true)
            if (currentDay + 3 == deadlineDay && sc && !lstLog[i].isSubmitted) {
                //send mail 3 days before deadline
                sendMail(sc.departmentHead,sc.contactEmail,DateUtility.getDateForUI(lstLog[i].deadLine))
            }
            if (deadlineDay == currentDay + 1 && sc && !lstLog[i].isSubmitted) {
                //send mail 1 day after deadline
                sendMail2(sc.departmentHead,sc.contactEmail,DateUtility.getDateForUI(lstLog[i].deadLine))
            }
        }
    }

    private String sendMail(String user,String email, String deadline) {
        String body = """
        <div>
            <p>
                Dear ${user}, <br/>
                Greetings!
            </p>
            <p>
                This is here-by notify that MCRS submission deadline is <strong> ${deadline} </strong>.
                As only 3 days remaining for submission, this is a general reminder for MCRS submission.
            </p>
            <p>
                Thanks in advance.
            </p>
            <p>
                Regards,<br/>
                 Friendship SP Team</b>
            </p>
            <i>This is an auto-generated email, which does not need reply.<br/></i>
            </div>
        """
        Thread trd = new Thread() {
            public void run() {
                mailService.sendMail {
                    to "imtiaz@friendship-bd.org"
                    from "support.mis@friendship-bd.org"
                    subject "MCRS submission"
                    html (body)
                }
            }
        }.start();
        return null
    }

    private void sendMail2(String user,String email, String deadline) {
        String body = """
        <div>
            <p>
                Dear ${user}, <br/>
                Greetings!
            </p>
            <p>
                This is here-by notify that MCRS submission deadline is <strong>${deadline}</b>.<strong/>
                We are very sorry to infor you that you did not submitted your MCRS yet.
            </p>
            <p>
                Please submit your MCRS as soon as possible.<br/>
                Thanks in advance.
            </p>
            <p>
                Regards,<br/>
                 Friendship SP Team</b>
            </p>
            <i>This is an auto-generated email, which does not need reply.<br/></i>
            </div>
        """
        Thread trd = new Thread() {
            public void run() {
                mailService.sendMail {
                    to "${email}"
                    from "support.mis@friendship-bd.org"
                    subject "MCRS deadline exceeds"
                    html (body)
                }
            }
        }.start();
    }
}
