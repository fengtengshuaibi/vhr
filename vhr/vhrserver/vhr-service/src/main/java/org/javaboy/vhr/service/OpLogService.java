package org.javaboy.vhr.service;

import org.javaboy.vhr.mapper.OpLogMapper;
import org.javaboy.vhr.model.OpLog;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

@Service
public class OpLogService {
    @Autowired
    OpLogMapper opLogMapper;

    public List<OpLog> getAllOpLogs() {
        return opLogMapper.getAllOpLogs();
    }

    public Integer addOpLog(OpLog opLog) {
        opLog.setAdddate(new Date());
        return opLogMapper.insertSelective(opLog);
    }
}
