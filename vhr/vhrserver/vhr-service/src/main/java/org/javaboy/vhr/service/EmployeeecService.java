package org.javaboy.vhr.service;

import org.javaboy.vhr.mapper.EmployeeecMapper;
import org.javaboy.vhr.model.Employeeec;
import org.javaboy.vhr.model.RespPageBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

@Service
public class EmployeeecService {
    @Autowired
    EmployeeecMapper employeeecMapper;

    public RespPageBean getEmployeeEcsByPage(Integer page, Integer size, String eid, Date[] beginDateScope) {
        if (page != null && size != null) {
            page = (page - 1) * size;
        }
        List<Employeeec> data = employeeecMapper.getEmployeeEcsByPage(eid, beginDateScope);
        Long total = (long) data.size();
        RespPageBean bean = new RespPageBean();
        bean.setData(data);
        bean.setTotal(total);
        return bean;
    }

    public Integer addEmployeeec(Employeeec employeeec) {
        return employeeecMapper.insertSelective(employeeec);
    }

    public Integer deleteEmployeeecById(Integer id) {
        return employeeecMapper.deleteByPrimaryKey(id);
    }

    public Integer updateEmployeeec(Employeeec employeeec) {
        return employeeecMapper.updateByPrimaryKeySelective(employeeec);
    }
}
