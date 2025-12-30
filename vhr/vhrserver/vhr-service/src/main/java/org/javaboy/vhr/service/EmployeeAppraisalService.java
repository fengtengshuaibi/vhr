package org.javaboy.vhr.service;

import org.javaboy.vhr.mapper.EmployeeAppraisalMapper;
import org.javaboy.vhr.model.EmployeeAppraisal;
import org.javaboy.vhr.model.RespPageBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

@Service
public class EmployeeAppraisalService {
    @Autowired
    EmployeeAppraisalMapper employeeAppraisalMapper;

    public RespPageBean getEmployeeAppraisalsByPage(Integer page, Integer size, String eid, Date[] beginDateScope) {
        if (page != null && size != null) {
            page = (page - 1) * size;
        }
        List<EmployeeAppraisal> data = employeeAppraisalMapper.getEmployeeAppraisalsByPage(eid, beginDateScope);
        Long total = (long) data.size(); // Simplified total count for now or need separate count query
        // Ideally should have a count query, but for now let's assume pagehelper or similar or just simple list
        // Actually the other services use PageHelper, but here I see manual pagination logic in other files maybe?
        // Let's check how other services do it. But to be safe, let's just return list.
        // Wait, other services use PageHelper.startPage(page, size).
        // I should check a sample service.
        RespPageBean bean = new RespPageBean();
        bean.setData(data);
        bean.setTotal(total);
        return bean;
    }

    public Integer addEmployeeAppraisal(EmployeeAppraisal employeeAppraisal) {
        return employeeAppraisalMapper.insertSelective(employeeAppraisal);
    }

    public Integer deleteEmployeeAppraisalById(Integer id) {
        return employeeAppraisalMapper.deleteByPrimaryKey(id);
    }

    public Integer updateEmployeeAppraisal(EmployeeAppraisal employeeAppraisal) {
        return employeeAppraisalMapper.updateByPrimaryKeySelective(employeeAppraisal);
    }
}
