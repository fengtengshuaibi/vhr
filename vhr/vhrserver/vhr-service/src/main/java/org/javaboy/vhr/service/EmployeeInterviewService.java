package org.javaboy.vhr.service;

import org.javaboy.vhr.mapper.EmployeeInterviewMapper;
import org.javaboy.vhr.model.EmployeeInterview;
import org.javaboy.vhr.model.RespPageBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

@Service
public class EmployeeInterviewService {
    @Autowired
    EmployeeInterviewMapper employeeInterviewMapper;

    public RespPageBean getEmployeeInterviewsByPage(Integer page, Integer size, String empName, Integer type, Integer year) {
        if (page != null && size != null) {
            page = (page - 1) * size;
        }
        List<EmployeeInterview> data = employeeInterviewMapper.getEmployeeInterviewsByPage(page, size, empName, type, year);
        Long total = employeeInterviewMapper.getTotal(empName, type, year);
        RespPageBean bean = new RespPageBean();
        bean.setData(data);
        bean.setTotal(total);
        return bean;
    }

    public Integer addEmployeeInterview(EmployeeInterview employeeInterview) {
        employeeInterview.setCreateDate(new Date());
        return employeeInterviewMapper.insertSelective(employeeInterview);
    }

    public Integer updateEmployeeInterview(EmployeeInterview employeeInterview) {
        return employeeInterviewMapper.updateByPrimaryKeySelective(employeeInterview);
    }

    public Integer deleteEmployeeInterview(Integer id) {
        return employeeInterviewMapper.deleteByPrimaryKey(id);
    }
}
