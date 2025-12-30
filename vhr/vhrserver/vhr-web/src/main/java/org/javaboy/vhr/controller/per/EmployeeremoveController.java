package org.javaboy.vhr.controller.per;

import org.javaboy.vhr.model.Employeeremove;
import org.javaboy.vhr.model.RespBean;
import org.javaboy.vhr.model.RespPageBean;
import org.javaboy.vhr.service.EmployeeremoveService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Date;

@RestController
@RequestMapping("/personnel/remove")
public class EmployeeremoveController {
    @Autowired
    EmployeeremoveService employeeremoveService;

    @GetMapping("/")
    public RespPageBean getEmployeeRemovesByPage(@RequestParam(defaultValue = "1") Integer page, @RequestParam(defaultValue = "10") Integer size, String eid, Date[] beginDateScope) {
        return employeeremoveService.getEmployeeRemovesByPage(page, size, eid, beginDateScope);
    }

    @PostMapping("/")
    public RespBean addEmployeeremove(@RequestBody Employeeremove employeeremove) {
        if (employeeremoveService.addEmployeeremove(employeeremove) == 1) {
            return RespBean.ok("添加成功!");
        }
        return RespBean.error("添加失败!");
    }

    @DeleteMapping("/{id}")
    public RespBean deleteEmployeeremoveById(@PathVariable Integer id) {
        if (employeeremoveService.deleteEmployeeremoveById(id) == 1) {
            return RespBean.ok("删除成功!");
        }
        return RespBean.error("删除失败!");
    }

    @PutMapping("/")
    public RespBean updateEmployeeremove(@RequestBody Employeeremove employeeremove) {
        if (employeeremoveService.updateEmployeeremove(employeeremove) == 1) {
            return RespBean.ok("更新成功!");
        }
        return RespBean.error("更新失败!");
    }
}
