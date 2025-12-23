package org.javaboy.vhr.controller.personnel;

import org.javaboy.vhr.model.EmployeePerformance;
import org.javaboy.vhr.model.RespBean;
import org.javaboy.vhr.model.RespPageBean;
import org.javaboy.vhr.service.EmployeePerformanceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.Date;
import java.util.List;

@RestController
@RequestMapping("/personnel/performance")
public class EmployeePerformanceController {
    @Autowired
    EmployeePerformanceService employeePerformanceService;

    @GetMapping("/")
    public RespPageBean getEmployeePerformanceByPage(@RequestParam(defaultValue = "1") Integer page, @RequestParam(defaultValue = "10") Integer size, String empName, Integer year, Date beginDate, Date endDate) {
        return employeePerformanceService.getEmployeePerformanceByPage(page, size, empName, year, beginDate, endDate);
    }

    @PostMapping("/")
    public RespBean addEmployeePerformance(@RequestBody EmployeePerformance employeePerformance) {
        if (employeePerformanceService.addEmployeePerformance(employeePerformance) == 1) {
            return RespBean.ok("添加成功!");
        }
        return RespBean.error("添加失败!");
    }

    @PutMapping("/")
    public RespBean updateEmployeePerformance(@RequestBody EmployeePerformance employeePerformance) {
        if (employeePerformanceService.updateEmployeePerformance(employeePerformance) == 1) {
            return RespBean.ok("更新成功!");
        }
        return RespBean.error("更新失败!");
    }

    @DeleteMapping("/{id}")
    public RespBean deleteEmployeePerformance(@PathVariable Integer id) {
        if (employeePerformanceService.deleteEmployeePerformance(id) == 1) {
            return RespBean.ok("删除成功!");
        }
        return RespBean.error("删除失败!");
    }

    @GetMapping("/export")
    public ResponseEntity<byte[]> exportEmployeePerformance(String empName, Integer year, Date beginDate, Date endDate) {
        return employeePerformanceService.exportEmployeePerformance(empName, year, beginDate, endDate);
    }
    
    @GetMapping("/template")
    public ResponseEntity<byte[]> getTemplate() {
        return employeePerformanceService.getTemplate();
    }

    @PostMapping("/import")
    public RespBean importEmployeePerformance(MultipartFile file) {
        List<EmployeePerformance> list = employeePerformanceService.excel2Performance(file);
        if (employeePerformanceService.addEmployeePerformances(list) > 0) {
            return RespBean.ok("导入成功!");
        }
        return RespBean.error("导入失败!");
    }
}
