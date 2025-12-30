package org.javaboy.vhr.service;

import org.javaboy.vhr.mapper.EmployeetrainMapper;
import org.javaboy.vhr.model.Employeetrain;
import org.javaboy.vhr.model.RespPageBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

@Service
public class EmployeeTrainService {
    @Autowired
    EmployeetrainMapper employeetrainMapper;

    public RespPageBean getEmployeeTrainsByPage(Integer page, Integer size, Employeetrain employeetrain, Date[] beginDateScope) {
        if (page != null && size != null) {
            page = (page - 1) * size;
        }
        List<Employeetrain> data = employeetrainMapper.getEmployeeTrainsByPage(page, size, employeetrain, beginDateScope);
        Long total = employeetrainMapper.getTotal(employeetrain, beginDateScope);
        RespPageBean bean = new RespPageBean();
        bean.setData(data);
        bean.setTotal(total);
        return bean;
    }

    public Integer addEmployeeTrain(Employeetrain employeetrain) {
        return employeetrainMapper.insertSelective(employeetrain);
    }

    public Integer updateEmployeeTrain(Employeetrain employeetrain) {
        return employeetrainMapper.updateByPrimaryKeySelective(employeetrain);
    }

    public Integer deleteEmployeeTrain(Integer id) {
        return employeetrainMapper.deleteByPrimaryKey(id);
    }
}
