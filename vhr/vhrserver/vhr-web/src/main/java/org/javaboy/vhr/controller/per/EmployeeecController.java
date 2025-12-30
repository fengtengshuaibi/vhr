package org.javaboy.vhr.controller.per;

import org.javaboy.vhr.model.Employeeec;
import org.javaboy.vhr.model.RespBean;
import org.javaboy.vhr.model.RespPageBean;
import org.javaboy.vhr.service.EmployeeecService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Date;

@RestController
@RequestMapping("/personnel/ec")
public class EmployeeecController {
    @Autowired
    EmployeeecService employeeecService;

    @GetMapping("/")
    public RespPageBean getEmployeeEcsByPage(@RequestParam(defaultValue = "1") Integer page, @RequestParam(defaultValue = "10") Integer size, String eid, Date[] beginDateScope) {
        return employeeecService.getEmployeeEcsByPage(page, size, eid, beginDateScope);
    }

    @PostMapping("/")
    public RespBean addEmployeeec(@RequestBody Employeeec employeeec) {
        if (employeeecService.addEmployeeec(employeeec) == 1) {
            return RespBean.ok("添加成功!");
        }
        return RespBean.error("添加失败!");
    }

    @DeleteMapping("/{id}")
    public RespBean deleteEmployeeecById(@PathVariable Integer id) {
        if (employeeecService.deleteEmployeeecById(id) == 1) {
            return RespBean.ok("删除成功!");
        }
        return RespBean.error("删除失败!");
    }

    @PutMapping("/")
    public RespBean updateEmployeeec(@RequestBody Employeeec employeeec) {
        if (employeeecService.updateEmployeeec(employeeec) == 1) {
            return RespBean.ok("更新成功!");
        }
        return RespBean.error("更新失败!");
    }
}
