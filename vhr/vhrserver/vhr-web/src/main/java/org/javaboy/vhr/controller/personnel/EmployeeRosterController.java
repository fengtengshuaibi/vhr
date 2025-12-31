package org.javaboy.vhr.controller.personnel;

import org.javaboy.vhr.model.Employee;
import org.javaboy.vhr.model.RespPageBean;
import org.javaboy.vhr.service.EmployeeRosterService;
import org.javaboy.vhr.service.EmployeeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/personnel/emp")
public class EmployeeRosterController {

    @Autowired
    EmployeeRosterService employeeRosterService;
    
    @Autowired
    EmployeeService employeeService;

    @GetMapping("/")
    public RespPageBean getEmployeeByPage(@RequestParam(defaultValue = "1") Integer page, @RequestParam(defaultValue = "10") Integer size, String name) {
        Employee employee = new Employee();
        employee.setName(name);
        return employeeService.getEmployeeByPage(page, size, employee, null, null, null, null);
    }

    @GetMapping("/roster/data/{eid}")
    public Map<String, Object> getEmployeeRosterData(@PathVariable String eid) {
        return employeeRosterService.getEmployeeRosterData(eid);
    }
}
