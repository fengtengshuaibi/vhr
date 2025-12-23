package org.javaboy.vhr.model;

import java.io.Serializable;
import java.util.Date;

public class ExecutivePerformance implements Serializable {
    private Integer id;
    private String eid;
    private Integer year;
    private Double quarter1;
    private Double quarter2;
    private Double quarter3;
    private Double quarter4;
    private Date createDate;
    private Date updateDate;

    private Employee employee;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getEid() {
        return eid;
    }

    public void setEid(String eid) {
        this.eid = eid;
    }

    public Integer getYear() {
        return year;
    }

    public void setYear(Integer year) {
        this.year = year;
    }

    public Double getQuarter1() {
        return quarter1;
    }

    public void setQuarter1(Double quarter1) {
        this.quarter1 = quarter1;
    }

    public Double getQuarter2() {
        return quarter2;
    }

    public void setQuarter2(Double quarter2) {
        this.quarter2 = quarter2;
    }

    public Double getQuarter3() {
        return quarter3;
    }

    public void setQuarter3(Double quarter3) {
        this.quarter3 = quarter3;
    }

    public Double getQuarter4() {
        return quarter4;
    }

    public void setQuarter4(Double quarter4) {
        this.quarter4 = quarter4;
    }

    public Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }

    public Date getUpdateDate() {
        return updateDate;
    }

    public void setUpdateDate(Date updateDate) {
        this.updateDate = updateDate;
    }

    public Employee getEmployee() {
        return employee;
    }

    public void setEmployee(Employee employee) {
        this.employee = employee;
    }
}
