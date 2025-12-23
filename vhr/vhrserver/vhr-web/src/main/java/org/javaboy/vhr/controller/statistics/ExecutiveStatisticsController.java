package org.javaboy.vhr.controller.statistics;

import org.javaboy.vhr.model.RespPageBean;
import org.javaboy.vhr.service.ExecutivePerformanceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Date;

@RestController
@RequestMapping("/statistics/executive")
public class ExecutiveStatisticsController {
    @Autowired
    ExecutivePerformanceService executivePerformanceService;

    @GetMapping("/")
    public RespPageBean getExecutivePerformanceByPage(@RequestParam(defaultValue = "1") Integer page, @RequestParam(defaultValue = "10") Integer size, String empName, Integer year, Date beginDate, Date endDate) {
        return executivePerformanceService.getExecutivePerformanceByPage(page, size, empName, year, beginDate, endDate);
    }

    @GetMapping("/export")
    public ResponseEntity<byte[]> exportExecutivePerformance(String empName, Integer year, Date beginDate, Date endDate) {
        return executivePerformanceService.exportExecutivePerformance(empName, year, beginDate, endDate);
    }
}
