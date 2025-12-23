package org.javaboy.vhr.controller.statistics;

import org.javaboy.vhr.model.RespPageBean;
import org.javaboy.vhr.service.EmployeePerformanceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Date;

@RestController
@RequestMapping("/statistics/performance")
public class PerformanceStatisticsController {
    @Autowired
    EmployeePerformanceService employeePerformanceService;

    @GetMapping("/")
    public RespPageBean getEmployeePerformanceByPage(@RequestParam(defaultValue = "1") Integer page, @RequestParam(defaultValue = "10") Integer size, String empName, Integer year, Date beginDate, Date endDate) {
        return employeePerformanceService.getEmployeePerformanceByPage(page, size, empName, year, beginDate, endDate);
    }

    @GetMapping("/export")
    public ResponseEntity<byte[]> exportEmployeePerformance(String empName, Integer year, Date beginDate, Date endDate) {
        return employeePerformanceService.exportEmployeePerformance(empName, year, beginDate, endDate);
    }
}
