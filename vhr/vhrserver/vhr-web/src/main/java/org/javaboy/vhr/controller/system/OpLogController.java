package org.javaboy.vhr.controller.system;

import org.javaboy.vhr.model.OpLog;
import org.javaboy.vhr.service.OpLogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/system/log")
public class OpLogController {
    @Autowired
    OpLogService opLogService;

    @GetMapping("/")
    public List<OpLog> getAllOpLogs() {
        return opLogService.getAllOpLogs();
    }
}
