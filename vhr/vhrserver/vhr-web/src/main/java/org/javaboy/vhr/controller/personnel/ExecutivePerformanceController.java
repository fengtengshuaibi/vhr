package org.javaboy.vhr.controller.personnel;

import org.javaboy.vhr.model.ExecutivePerformance;
import org.javaboy.vhr.model.RespBean;
import org.javaboy.vhr.model.RespPageBean;
import org.javaboy.vhr.service.ExecutivePerformanceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.Date;
import java.util.List;

@RestController
@RequestMapping("/personnel/score")
public class ExecutivePerformanceController {
    @Autowired
    ExecutivePerformanceService executivePerformanceService;

    @GetMapping("/")
    public RespPageBean getExecutivePerformanceByPage(@RequestParam(defaultValue = "1") Integer page, @RequestParam(defaultValue = "10") Integer size, String empName, Integer year, Date beginDate, Date endDate) {
        return executivePerformanceService.getExecutivePerformanceByPage(page, size, empName, year, beginDate, endDate);
    }

    @PostMapping("/")
    public RespBean addExecutivePerformance(@RequestBody ExecutivePerformance executivePerformance) {
        if (executivePerformanceService.addExecutivePerformance(executivePerformance) == 1) {
            return RespBean.ok("添加成功!");
        }
        return RespBean.error("添加失败!");
    }

    @PutMapping("/")
    public RespBean updateExecutivePerformance(@RequestBody ExecutivePerformance executivePerformance) {
        if (executivePerformanceService.updateExecutivePerformance(executivePerformance) == 1) {
            return RespBean.ok("更新成功!");
        }
        return RespBean.error("更新失败!");
    }

    @DeleteMapping("/{id}")
    public RespBean deleteExecutivePerformance(@PathVariable Integer id) {
        if (executivePerformanceService.deleteExecutivePerformance(id) == 1) {
            return RespBean.ok("删除成功!");
        }
        return RespBean.error("删除失败!");
    }

    @GetMapping("/export")
    public ResponseEntity<byte[]> exportExecutivePerformance(String empName, Integer year, Date beginDate, Date endDate) {
        return executivePerformanceService.exportExecutivePerformance(empName, year, beginDate, endDate);
    }
    
    @GetMapping("/template")
    public ResponseEntity<byte[]> getTemplate() {
        return executivePerformanceService.getTemplate();
    }

    @PostMapping("/import")
    public RespBean importExecutivePerformance(MultipartFile file) {
        List<ExecutivePerformance> list = executivePerformanceService.excel2Performance(file);
        if (executivePerformanceService.addExecutivePerformances(list) > 0) {
            return RespBean.ok("导入成功!");
        }
        return RespBean.error("导入失败!");
    }
}
