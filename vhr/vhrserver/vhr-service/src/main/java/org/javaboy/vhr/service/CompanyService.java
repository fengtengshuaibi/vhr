package org.javaboy.vhr.service;

import org.javaboy.vhr.mapper.CompanyMapper;
import org.javaboy.vhr.model.Company;
import org.javaboy.vhr.model.RespPageBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CompanyService {
    @Autowired
    CompanyMapper companyMapper;

    public RespPageBean getAllCompanies(Integer page, Integer size, String name) {
        if (page != null && size != null) {
            page = (page - 1) * size;
        }
        List<Company> data = companyMapper.getAllCompanies(page, size, name);
        Long total = companyMapper.getTotal(name);
        RespPageBean bean = new RespPageBean();
        bean.setData(data);
        bean.setTotal(total);
        return bean;
    }

    public Integer addCompany(Company company) {
        return companyMapper.insertSelective(company);
    }

    public Integer updateCompany(Company company) {
        return companyMapper.updateByPrimaryKeySelective(company);
    }

    public Integer deleteCompanyById(Integer id) {
        return companyMapper.deleteByPrimaryKey(id);
    }
}
