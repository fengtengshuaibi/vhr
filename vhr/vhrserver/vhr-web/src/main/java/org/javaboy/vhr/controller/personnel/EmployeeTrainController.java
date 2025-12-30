package org.javaboy.vhr.controller.personnel;

import org.javaboy.vhr.model.Employeetrain;
import org.javaboy.vhr.model.RespBean;
import org.javaboy.vhr.model.RespPageBean;
import org.javaboy.vhr.service.EmployeeTrainService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Date;

@RestController
@RequestMapping("/personnel/train")
public class EmployeeTrainController {
    @Autowired
    EmployeeTrainService employeeTrainService;

    @GetMapping("/")
    public RespPageBean getEmployeeTrainsByPage(@RequestParam(defaultValue = "1") Integer page, @RequestParam(defaultValue = "10") Integer size, Employeetrain employeetrain, Date[] beginDateScope) {
        return employeeTrainService.getEmployeeTrainsByPage(page, size, employeetrain, beginDateScope);
    }

    @PostMapping("/")
    public RespBean addEmployeeTrain(@RequestBody Employeetrain employeetrain) {
        if (employeeTrainService.addEmployeeTrain(employeetrain) == 1) {
            return RespBean.ok("添加成功!");
        }
        return RespBean.error("添加失败!");
    }

    @PutMapping("/")
    public RespBean updateEmployeeTrain(@RequestBody Employeetrain employeetrain) {
        if (employeeTrainService.updateEmployeeTrain(employeetrain) == 1) {
            return RespBean.ok("更新成功!");
        }
        return RespBean.error("更新失败!");
    }

    @DeleteMapping("/{id}")
    public RespBean deleteEmployeeTrain(@PathVariable Integer id) {
        if (employeeTrainService.deleteEmployeeTrain(id) == 1) {
            return RespBean.ok("删除成功!");
        }
        return RespBean.error("删除失败!");
    }
}
