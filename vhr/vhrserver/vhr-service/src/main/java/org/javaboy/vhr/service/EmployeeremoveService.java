package org.javaboy.vhr.service;

import org.javaboy.vhr.mapper.EmployeeremoveMapper;
import org.javaboy.vhr.model.Employeeremove;
import org.javaboy.vhr.model.RespPageBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

@Service
public class EmployeeremoveService {
    @Autowired
    EmployeeremoveMapper employeeremoveMapper;

    public RespPageBean getEmployeeRemovesByPage(Integer page, Integer size, String eid, Date[] beginDateScope) {
        if (page != null && size != null) {
            page = (page - 1) * size;
        }
        List<Employeeremove> data = employeeremoveMapper.getEmployeeRemovesByPage(eid, beginDateScope);
        Long total = (long) data.size();
        RespPageBean bean = new RespPageBean();
        bean.setData(data);
        bean.setTotal(total);
        return bean;
    }

    public Integer addEmployeeremove(Employeeremove employeeremove) {
        return employeeremoveMapper.insertSelective(employeeremove);
    }

    public Integer deleteEmployeeremoveById(Integer id) {
        return employeeremoveMapper.deleteByPrimaryKey(id);
    }

    public Integer updateEmployeeremove(Employeeremove employeeremove) {
        return employeeremoveMapper.updateByPrimaryKeySelective(employeeremove);
    }
}
