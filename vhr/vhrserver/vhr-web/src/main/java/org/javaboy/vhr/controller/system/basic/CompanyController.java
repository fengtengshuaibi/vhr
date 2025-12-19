package org.javaboy.vhr.controller.system.basic;

import org.javaboy.vhr.model.Company;
import org.javaboy.vhr.model.RespPageBean;
import org.javaboy.vhr.model.RespBean;
import org.javaboy.vhr.service.CompanyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/system/basic/company")
public class CompanyController {
    @Autowired
    CompanyService companyService;

    @GetMapping("/")
    public RespPageBean getAllCompanies(@RequestParam(defaultValue = "1") Integer page, @RequestParam(defaultValue = "10") Integer size, String name) {
        return companyService.getAllCompanies(page, size, name);
    }

    @PostMapping("/")
    public RespBean addCompany(@RequestBody Company company) {
        if (companyService.addCompany(company) == 1) {
            return RespBean.ok("添加成功!");
        }
        return RespBean.error("添加失败!");
    }

    @PutMapping("/")
    public RespBean updateCompany(@RequestBody Company company) {
        if (companyService.updateCompany(company) == 1) {
            return RespBean.ok("更新成功!");
        }
        return RespBean.error("更新失败!");
    }

    @DeleteMapping("/{id}")
    public RespBean deleteCompanyById(@PathVariable Integer id) {
        if (companyService.deleteCompanyById(id) == 1) {
            return RespBean.ok("删除成功!");
        }
        return RespBean.error("删除失败!");
    }
}
