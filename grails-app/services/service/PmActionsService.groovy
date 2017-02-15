package service

import com.pms.SecUser
import grails.transaction.Transactional
import groovy.sql.GroovyRowResult
import pms.BaseService

import java.text.DateFormat
import java.text.SimpleDateFormat

@Transactional
class PmActionsService extends BaseService {

    public List<GroovyRowResult> lstActionsByServiceIdAndYear(long serviceId, String year) {
        String queryForList = """
            SELECT o.id,o.sequence AS name FROM pm_actions o
                WHERE o.service_id = ${serviceId}
                AND YEAR(start)<='${year}' AND YEAR(end) >='${year}'
                ORDER BY o.goal_id,o.tmp_seq
        """
        List<GroovyRowResult> lst = executeSelectSql(queryForList)
        return lst
    }
    public List<GroovyRowResult> lstActionsForDropDown(long goalId) {
        String queryForList = """
            SELECT o.id AS id, CONCAT(o.sequence,'. ',o.actions) AS name
                FROM pm_actions o
                WHERE o.goal_id = ${goalId}
                ORDER BY o.tmp_seq
        """
        List<GroovyRowResult> lst = executeSelectSql(queryForList)
        return lst
    }
    public boolean taskDateWithinActionsDate(Date start,Date end,long actionsId) {
        String queryForList = """
            SELECT COUNT(id) as c FROM pm_actions
            WHERE START<='${start}' AND END >='${end}' AND id=${actionsId}
        """
        List<GroovyRowResult> lst = executeSelectSql(queryForList)
        int count =(int) lst[0].c
        boolean isWithin=false
        if(count>0){
            isWithin=true
        }
        return isWithin
    }
    public List<GroovyRowResult> lstDepartmentSpStatus(String dateStr) {
        int year = Integer.parseInt(dateStr)

        String query = """
            SELECT ss.name,LEFT(ss.short_name,6) short_name,COUNT(DISTINCT(a.id)) AS count,l.is_submitted,
                        CASE WHEN l.is_submitted THEN CONCAT('Submitted On : ',l.submission_date) ELSE '' END submission_date,
                        CASE WHEN l.is_submitted IS TRUE THEN '#00FF00' ELSE '#FF6666' END col_color
                            FROM pm_service_sector ss
                            LEFT JOIN pm_actions a ON ss.id=a.service_id
                            LEFT JOIN pm_sp_log l ON l.service_id = ss.id AND l.year = ${year}
                            WHERE ss.is_in_sp = TRUE
                            GROUP BY ss.id
            ORDER BY ss.name;
        """
        List<GroovyRowResult> lst = executeSelectSql(query)
        return lst
    }
    public List<GroovyRowResult> lstDepartmentMcrsStatus(String yearStr) {
        int year = Integer.parseInt(yearStr)
        String query = """
                SELECT tmp.short_name service,
                MAX(tmp.January) January ,MAX(tmp.JanuaryD) JanuaryD ,
                MAX(tmp.February) February ,MAX(tmp.FebruaryD) FebruaryD ,
                MAX(tmp.March) March ,MAX(tmp.MarchD) MarchD ,
                MAX(tmp.April) April ,MAX(tmp.AprilD) AprilD ,
                MAX(tmp.May) May ,MAX(tmp.MayD) MayD ,
                MAX(tmp.June) June ,MAX(tmp.JuneD) JuneD ,
                MAX(tmp.July) July ,MAX(tmp.JulyD) JulyD ,
                MAX(tmp.August) August ,MAX(tmp.AugustD) AugustD ,
                MAX(tmp.September) September ,MAX(tmp.SeptemberD) SeptemberD ,
                MAX(tmp.October) October,MAX(tmp.OctoberD) OctoberD,
                MAX(tmp.November) November  ,MAX(tmp.NovemberD) NovemberD  ,
                MAX(tmp.December) December ,MAX(tmp.DecemberD) DecemberD
                FROM (SELECT ss.short_name,
                CASE WHEN l.month_str='January' THEN l.submission_date ELSE NULL END January,
                CASE WHEN l.month_str='January' THEN l.dead_line ELSE NULL END JanuaryD,
                CASE WHEN l.month_str='February' THEN l.submission_date ELSE NULL END February,
                CASE WHEN l.month_str='February' THEN l.dead_line ELSE NULL END FebruaryD,
                CASE WHEN l.month_str='March' THEN l.submission_date ELSE NULL END March,
                CASE WHEN l.month_str='March' THEN l.dead_line ELSE NULL END MarchD,
                CASE WHEN l.month_str='April' THEN l.submission_date ELSE NULL END April,
                CASE WHEN l.month_str='April' THEN l.dead_line ELSE NULL END AprilD,
                CASE WHEN l.month_str='May' THEN l.submission_date ELSE NULL END May,
                CASE WHEN l.month_str='May' THEN l.dead_line ELSE NULL END MayD,
                CASE WHEN l.month_str='June' THEN l.submission_date ELSE NULL END June,
                CASE WHEN l.month_str='June' THEN l.dead_line ELSE NULL END JuneD,
                CASE WHEN l.month_str='July' THEN l.submission_date ELSE NULL END July,
                CASE WHEN l.month_str='July' THEN l.dead_line ELSE NULL END JulyD,
                CASE WHEN l.month_str='August' THEN l.submission_date ELSE NULL END August,
                CASE WHEN l.month_str='August' THEN l.dead_line ELSE NULL END AugustD,
                CASE WHEN l.month_str='September' THEN l.submission_date ELSE NULL END September,
                CASE WHEN l.month_str='September' THEN l.dead_line ELSE NULL END SeptemberD,
                CASE WHEN l.month_str='October' THEN l.submission_date ELSE NULL END October,
                CASE WHEN l.month_str='October' THEN l.dead_line ELSE NULL END OctoberD,
                CASE WHEN l.month_str='November' THEN l.submission_date ELSE NULL END November,
                CASE WHEN l.month_str='November' THEN l.dead_line ELSE NULL END NovemberD,
                CASE WHEN l.month_str='December' THEN l.submission_date ELSE NULL END December,
                CASE WHEN l.month_str='December' THEN l.dead_line ELSE NULL END DecemberD
                FROM pm_service_sector ss
                LEFT JOIN pm_mcrs_log l ON l.service_id = ss.id AND l.year = ${year}
                WHERE ss.is_in_sp = TRUE
                ORDER BY ss.name,l.month) tmp GROUP BY tmp.short_name;
        """
        List<GroovyRowResult> lst = executeSelectSql(query)
        return lst
    }
    public List<GroovyRowResult> lstServiceWiseAcvStatus(String monthStr) {
        DateFormat originalFormat = new SimpleDateFormat("MMMM yyyy", Locale.ENGLISH);
        Date date = originalFormat.parse(monthStr);
        Calendar c = Calendar.getInstance();
        c.setTime(date);
        int month = c.get(Calendar.MONTH)+1
        int year = c.get(Calendar.YEAR)
        SecUser user = currentUserObject();

        String query = """
        (SELECT ROUND(SUM(a_pert)/COUNT(cat_axe)) act_val, "Achieved" act_name,"#00FF00" act_color FROM
                (SELECT cat_axe,IF(ROUND(a_col/ac_count*100)>100,100,ROUND(a_col/ac_count*100)) a_pert FROM
                (SELECT CONCAT('Goal ',g.sequence) cat_axe,COUNT(a.id) ac_count,aid.target,aid.achievement,
                ROUND(SUM(FLOOR(((COALESCE(aid.achievement,0)/aid.target)*100)))/COUNT(ai.id)*COUNT(a.id)/100,2) a_col
                                FROM pm_goals g
                LEFT JOIN pm_service_sector sc ON sc.id = g.service_id
                LEFT JOIN pm_actions a ON a.goal_id = g.id
                LEFT JOIN pm_actions_indicator ai ON a.id = ai.actions_id
                LEFT JOIN pm_actions_indicator_details aid ON ai.id=aid.indicator_id
                JOIN custom_month cm ON cm.name=aid.month_name,
                (SELECT @curmon := ${month}) r
                WHERE g.service_id=  ${user.serviceId}  AND  a.year = ${year} AND cm.sl_index=@curmon AND aid.target > 0
                GROUP BY g.id
                ORDER BY sc.sequence,a.id,ai.id,aid.id) tmp ) tmp2)
        UNION ALL
            (SELECT 100-ROUND(SUM(a_pert)/COUNT(cat_axe)) act_val, "Remaining" act_name,"#FF6666" act_color FROM
                (SELECT cat_axe,IF(ROUND(a_col/ac_count*100)>100,100,ROUND(a_col/ac_count*100)) a_pert FROM
                (SELECT CONCAT('Goal ',g.sequence) cat_axe,COUNT(a.id) ac_count,aid.target,aid.achievement,
                ROUND(SUM(FLOOR(((COALESCE(aid.achievement,0)/aid.target)*100)))/COUNT(ai.id)*COUNT(a.id)/100,2) a_col
                                FROM pm_goals g
                LEFT JOIN pm_service_sector sc ON sc.id = g.service_id
                LEFT JOIN pm_actions a ON a.goal_id = g.id
                LEFT JOIN pm_actions_indicator ai ON a.id = ai.actions_id
                LEFT JOIN pm_actions_indicator_details aid ON ai.id=aid.indicator_id
                JOIN custom_month cm ON cm.name=aid.month_name,
                (SELECT @curmon := ${month}) r
                WHERE g.service_id=  ${user.serviceId}  AND  a.year = ${year} AND cm.sl_index=@curmon AND aid.target > 0
                GROUP BY g.id
                ORDER BY sc.sequence,a.id,ai.id,aid.id) tmp ) tmp2);
        """
        List<GroovyRowResult> lst = executeSelectSql(query)
        return lst
    }
    public List<GroovyRowResult> lstGoalWiseActionStatus(String monthStr) {
        DateFormat originalFormat = new SimpleDateFormat("MMMM yyyy", Locale.ENGLISH);
        Date date = originalFormat.parse(monthStr);
        Calendar c = Calendar.getInstance();
        c.setTime(date);
        int month = c.get(Calendar.MONTH)+1
        int year = c.get(Calendar.YEAR)
        SecUser user = currentUserObject();

        String query = """
            SELECT cat_axe,ac_count,IF((ac_count-a_col)<0,0.00,ac_count-a_col) t_col,a_col,a_color,t_color,goal,ROUND(a_col/ac_count*100) a_pert
            FROM
            (SELECT CONCAT('Goal ',g.sequence) cat_axe,COUNT(a.id) ac_count,
            ROUND(SUM(FLOOR(((COALESCE(aid.achievement,0)/aid.target)*100)))/COUNT(ai.id)*COUNT(a.id)/100,2) a_col,
            '#FF6666' t_color, '#00FF00' a_color,g.goal
            FROM pm_goals g
            LEFT JOIN pm_actions a ON a.goal_id = g.id
            LEFT JOIN pm_actions_indicator ai ON a.id = ai.actions_id
            LEFT JOIN pm_actions_indicator_details aid ON ai.id=aid.indicator_id
            JOIN custom_month cm ON cm.name=aid.month_name,
            (SELECT @curmon := ${month}) r
            WHERE g.service_id = ${user.serviceId} AND a.year = ${year} AND cm.sl_index=@curmon AND aid.target > 0
            GROUP BY g.id
            ORDER BY g.sequence,a.id,ai.id,aid.id) tmp;
        """
        List<GroovyRowResult> lst = executeSelectSql(query)
        return lst
    }
    public List<GroovyRowResult> lstServiceWiseActionStatus(String monthStr) {
        DateFormat originalFormat = new SimpleDateFormat("MMMM yyyy", Locale.ENGLISH);
        Date date = originalFormat.parse(monthStr);
        Calendar c = Calendar.getInstance();
        c.setTime(date);
        int month = c.get(Calendar.MONTH)+1
        int year = c.get(Calendar.YEAR)

        String query = """
            SELECT service_id,service,short_name,ROUND(SUM(a_pert)/COUNT(cat_axe)) a_pert,'#00FF00' a_color,
            100-ROUND(SUM(a_pert)/COUNT(cat_axe)) r_pert,'#FF6666' r_color
            FROM
            (SELECT service_id,service,short_name,cat_axe,IF(ROUND(a_col/ac_count*100)>100,100,ROUND(a_col/ac_count*100)) a_pert FROM
            (SELECT sc.id service_id,g.id AS goal_id,sc.name service,sc.short_name,
            CONCAT('Goal ',g.sequence) cat_axe,COUNT(a.id) ac_count,
            ROUND(SUM(FLOOR(((COALESCE(aid.achievement,0)/aid.target)*100)))/COUNT(ai.id)*COUNT(a.id)/100,2) a_col
            FROM pm_goals g
            LEFT JOIN pm_service_sector sc ON sc.id = g.service_id
            LEFT JOIN pm_actions a ON a.goal_id = g.id
            LEFT JOIN pm_actions_indicator ai ON a.id = ai.actions_id
            LEFT JOIN pm_actions_indicator_details aid ON ai.id=aid.indicator_id
            JOIN custom_month cm ON cm.name=aid.month_name,
            (SELECT @curmon := ${month}) r
            WHERE a.year = ${year} AND cm.sl_index=@curmon AND aid.target > 0
            GROUP BY g.id
            ORDER BY sc.sequence,a.id,ai.id,aid.id) tmp ) tmp2 GROUP BY service_id;
        """
        List<GroovyRowResult> lst = executeSelectSql(query)
        return lst
    }
    public List<GroovyRowResult> findAllDetailsByActionsIdAndIndicatorId(long actionsId, long indicatorId) {
        String query = """
            SELECT aid.*,ai.indicator_type
                FROM pm_actions_indicator_details aid
                LEFT JOIN pm_actions_indicator ai ON ai.id=aid.indicator_id
                WHERE aid.actions_id = ${actionsId} AND aid.indicator_id = ${indicatorId}
        """
        List<GroovyRowResult> lst = executeSelectSql(query)
        return lst
    }
}
