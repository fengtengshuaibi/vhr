package org.javaboy.vhr.controller.emp;

import org.javaboy.vhr.model.*;
import org.javaboy.vhr.service.*;
import org.javaboy.vhr.utils.POIUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * @作者 小腾
 * @GitHub https://github.com/fengtengshuaibi?tab=repositories * @时间 2019-10-29 7:41
 */
@RestController
@RequestMapping("/employee/basic")
public class EmpBasicController {
    @Autowired
    EmployeeService employeeService;
    @Autowired
    NationService nationService;
    @Autowired
    PoliticsstatusService politicsstatusService;
    @Autowired
    JobLevelService jobLevelService;
    @Autowired
    PositionService positionService;
    @Autowired
    DepartmentService departmentService;

    @GetMapping("/")
    public RespPageBean getEmployeeByPage(@RequestParam(defaultValue = "1") Integer page, @RequestParam(defaultValue = "10") Integer size, Employee employee, Date[] beginDateScope, Integer[] ageScope, Date[] conversionTimeScope, Date[] notWorkDateScope) {
        return employeeService.getEmployeeByPage(page, size, employee,beginDateScope, ageScope, conversionTimeScope, notWorkDateScope);
    }

    @PostMapping("/")
    public RespBean addEmp(@RequestBody Employee employee) {
        if (employeeService.addEmp(employee) == 1) {
            return RespBean.ok("添加成功!");
        }
        return RespBean.error("添加失败!");
    }

    @DeleteMapping("/{id}")
    public RespBean deleteEmpByEid(@PathVariable String id) {
        if (employeeService.deleteEmpByEid(id) == 1) {
            return RespBean.ok("删除成功!");
        }
        return RespBean.error("删除失败!");
    }

    @DeleteMapping("/")
    public RespBean deleteMany(@RequestParam List<String> ids) {
        if (employeeService.deleteEmps(ids) == ids.size()) {
            return RespBean.ok("删除成功!");
        }
        return RespBean.ok("删除成功!");
    }

    @PutMapping("/")
    public RespBean updateEmp(@RequestBody Employee employee) {
        if (employeeService.updateEmp(employee) == 1) {
            return RespBean.ok("更新成功!");
        }
        return RespBean.error("更新失败!");
    }

    @GetMapping("/nations")
    public List<Nation> getAllNations() {
        return nationService.getAllNations();
    }

    @GetMapping("/politicsstatus")
    public List<Politicsstatus> getAllPoliticsstatus() {
        return politicsstatusService.getAllPoliticsstatus();
    }

    @GetMapping("/joblevels")
    public List<JobLevel> getAllJobLevels() {
        return jobLevelService.getAllJobLevels();
    }

    @GetMapping("/positions")
    public List<Position> getAllPositions() {
        return positionService.getAllPositions();
    }


    @GetMapping("/deps")
    public List<Department> getAllDepartments() {
        return departmentService.getAllDepartments();
    }

    @GetMapping("/simple")
    public List<Employee> getAllSimpleEmployees() {
        return (List<Employee>) employeeService.getEmployeeByPage(null, null, new Employee(), null, null, null, null).getData();
    }

    @GetMapping("/export")
    public ResponseEntity<byte[]> exportData() {
        List<Employee> list = (List<Employee>) employeeService.getEmployeeByPage(null, null, new Employee(),null,null, null, null).getData();
        return POIUtils.employee2Excel(list);
    }

    @GetMapping("/import/template")
    public ResponseEntity<byte[]> importTemplate() {
        return POIUtils.employee2Excel(new ArrayList<>());
    }

    @PostMapping("/import")
    public RespBean importData(MultipartFile file) throws IOException {
        Map<String, Object> map = POIUtils.excel2Employee(file, nationService.getAllNations(), politicsstatusService.getAllPoliticsstatus(), departmentService.getAllDepartmentsWithOutChildren(), positionService.getAllPositions(), jobLevelService.getAllJobLevels());
        List<Employee> list = (List<Employee>) map.get("list");
        List<String> errors = (List<String>) map.get("errors");
        
        if (list != null && list.size() > 0) {
            employeeService.addEmps(list);
        }
        
        if (errors != null && !errors.isEmpty()) {
            return RespBean.ok("部分数据存在问题", errors);
        }
        return RespBean.ok("上传成功");
    }
}
