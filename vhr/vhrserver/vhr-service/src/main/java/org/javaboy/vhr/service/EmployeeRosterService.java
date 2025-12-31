package org.javaboy.vhr.service;

import org.javaboy.vhr.mapper.*;
import org.javaboy.vhr.model.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class EmployeeRosterService {

    @Autowired
    EmployeeMapper employeeMapper;
    @Autowired
    ContractMapper contractMapper;
    @Autowired
    EmployeePerformanceMapper employeePerformanceMapper;
    @Autowired
    ExecutivePerformanceMapper executivePerformanceMapper;
    @Autowired
    EmployeetrainMapper employeetrainMapper;
    @Autowired
    EmployeeAppraisalMapper employeeAppraisalMapper;
    @Autowired
    EmployeeecMapper employeeecMapper;
    @Autowired
    EmployeeremoveMapper employeeremoveMapper;
    @Autowired
    EmployeeInterviewMapper employeeInterviewMapper;
    @Autowired
    AttendanceLeaveMapper attendanceLeaveMapper;

    public Map<String, Object> getEmployeeRosterData(String eid) {
        Map<String, Object> map = new HashMap<>();
        
        // Current Year
        SimpleDateFormat yearFormat = new SimpleDateFormat("yyyy");
        int currentYear = Integer.parseInt(yearFormat.format(new Date()));
        
        // Fetch Data
        Employee employee = employeeMapper.getEmployeeById(eid);
        if (employee == null) return null;
        map.put("employee", employee);
        
        Contract contract = contractMapper.selectByPrimaryKey(eid);
        map.put("contract", contract);

        // Attendance Leave
        List<AttendanceLeave> attendanceLeaves = attendanceLeaveMapper.getAttendanceLeaveByIdCard(employee.getIdCard());
        map.put("attendanceLeaves", attendanceLeaves);
        
        // Performance (Filter by Current Year)
        List<EmployeePerformance> perList = employeePerformanceMapper.getEmployeePerformanceByPage(null, null, employee.getName(), currentYear, null, null);
        EmployeePerformance performance = null;
        if (perList != null && !perList.isEmpty()) {
            for (EmployeePerformance p : perList) {
                if (p.getEid().equals(eid)) {
                    performance = p;
                    break;
                }
            }
        }
        map.put("performance", performance);
        
        List<ExecutivePerformance> execList = executivePerformanceMapper.getExecutivePerformanceByPage(null, null, employee.getName(), currentYear, null, null);
        ExecutivePerformance execPerformance = null;
        if (execList != null && !execList.isEmpty()) {
            for (ExecutivePerformance p : execList) {
                if (p.getEid().equals(eid)) {
                    execPerformance = p;
                    break;
                }
            }
        }
        map.put("execPerformance", execPerformance);

        // Trainings (Filter by Current Year)
        List<Employeetrain> trains = employeetrainMapper.getEmployeeTrainsByPage(null, null, new Employeetrain(), new Date[]{getYearStart(), getYearEnd()});
        List<Employeetrain> myTrains = new java.util.ArrayList<>();
        if (trains != null) {
            for(Employeetrain et : trains) {
                if(et.getEid().equals(eid)) {
                    myTrains.add(et);
                }
            }
        }
        map.put("trains", myTrains);

        // Appraisals (All history)
        List<EmployeeAppraisal> appraisals = employeeAppraisalMapper.getEmployeeAppraisalsByPage(eid, null);
        map.put("appraisals", appraisals);

        // EC (Rewards/Punishments) (Filter by Current Year)
        List<Employeeec> allEcs = employeeecMapper.getEmployeeEcsByPage(eid, null);
        List<Employeeec> ecs = new java.util.ArrayList<>();
        if (allEcs != null) {
            Date start = getYearStart();
            Date end = getYearEnd();
            for (Employeeec ec : allEcs) {
                if (ec.getEcDate() != null && ec.getEcDate().compareTo(start) >= 0 && ec.getEcDate().compareTo(end) <= 0) {
                    ecs.add(ec);
                }
            }
        }
        map.put("ecs", ecs);

        // Removes (Transfers) (All history)
        List<Employeeremove> removes = employeeremoveMapper.getEmployeeRemovesByPage(eid, null);
        map.put("removes", removes);
        
        // Interviews (Filter by Current Year)
        List<EmployeeInterview> interviews = employeeInterviewMapper.getEmployeeInterviewsByEidAndYear(eid, currentYear);
        map.put("interviews", interviews);
        
        return map;
    }

    private Date getYearStart() {
        java.util.Calendar c = java.util.Calendar.getInstance();
        c.set(java.util.Calendar.MONTH, 0);
        c.set(java.util.Calendar.DAY_OF_MONTH, 1);
        c.set(java.util.Calendar.HOUR_OF_DAY, 0);
        c.set(java.util.Calendar.MINUTE, 0);
        c.set(java.util.Calendar.SECOND, 0);
        return c.getTime();
    }
    
    private Date getYearEnd() {
        java.util.Calendar c = java.util.Calendar.getInstance();
        c.set(java.util.Calendar.MONTH, 11);
        c.set(java.util.Calendar.DAY_OF_MONTH, 31);
        c.set(java.util.Calendar.HOUR_OF_DAY, 23);
        c.set(java.util.Calendar.MINUTE, 59);
        c.set(java.util.Calendar.SECOND, 59);
        return c.getTime();
    }
}
