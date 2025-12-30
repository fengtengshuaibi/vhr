package org.javaboy.vhr.task;

import org.javaboy.vhr.service.EmployeeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component
public class WorkAgeTask {
    @Autowired
    EmployeeService employeeService;

    @Scheduled(cron = "0 0 2 * * ?")
    public void updateWorkAge() {
        employeeService.updateWorkAge();
    }
}
