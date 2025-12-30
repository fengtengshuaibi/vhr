package org.javaboy.vhr.controller.per;

import org.javaboy.vhr.model.EmployeeAppraisal;
import org.javaboy.vhr.model.RespBean;
import org.javaboy.vhr.model.RespPageBean;
import org.javaboy.vhr.service.EmployeeAppraisalService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Date;

@RestController
@RequestMapping("/personnel/appraisal")
public class EmployeeAppraisalController {
    @Autowired
    EmployeeAppraisalService employeeAppraisalService;

    @GetMapping("/")
    public RespPageBean getEmployeeAppraisalsByPage(@RequestParam(defaultValue = "1") Integer page, @RequestParam(defaultValue = "10") Integer size, String eid, Date[] beginDateScope) {
        return employeeAppraisalService.getEmployeeAppraisalsByPage(page, size, eid, beginDateScope);
    }

    @PostMapping("/")
    public RespBean addEmployeeAppraisal(@RequestBody EmployeeAppraisal employeeAppraisal) {
        if (employeeAppraisalService.addEmployeeAppraisal(employeeAppraisal) == 1) {
            return RespBean.ok("添加成功!");
        }
        return RespBean.error("添加失败!");
    }

    @DeleteMapping("/{id}")
    public RespBean deleteEmployeeAppraisalById(@PathVariable Integer id) {
        if (employeeAppraisalService.deleteEmployeeAppraisalById(id) == 1) {
            return RespBean.ok("删除成功!");
        }
        return RespBean.error("删除失败!");
    }

    @PutMapping("/")
    public RespBean updateEmployeeAppraisal(@RequestBody EmployeeAppraisal employeeAppraisal) {
        if (employeeAppraisalService.updateEmployeeAppraisal(employeeAppraisal) == 1) {
            return RespBean.ok("更新成功!");
        }
        return RespBean.error("更新失败!");
    }
}
