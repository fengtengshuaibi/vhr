package org.javaboy.vhr.model;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;

public class Employeeremove {
    private Integer id;

    private String eid;

    private Integer beforeDepId;

    private Integer beforePosId;

    private Integer afterDepId;

    private Integer afterJobId;

    private Integer operateType;

    @JsonFormat(pattern = "yyyy-MM-dd", timezone = "Asia/Shanghai")
    private Date removeDate;

    private String reason;

    private String remark;
    
    private Department beforeDepartment;
    private Position beforePosition;
    private Department afterDepartment;
    private Position afterPosition;
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

    public Integer getBeforeDepId() {
        return beforeDepId;
    }

    public void setBeforeDepId(Integer beforeDepId) {
        this.beforeDepId = beforeDepId;
    }

    public Integer getBeforePosId() {
        return beforePosId;
    }

    public void setBeforePosId(Integer beforePosId) {
        this.beforePosId = beforePosId;
    }

    public Integer getAfterDepId() {
        return afterDepId;
    }

    public void setAfterDepId(Integer afterDepId) {
        this.afterDepId = afterDepId;
    }

    public Integer getAfterJobId() {
        return afterJobId;
    }

    public void setAfterJobId(Integer afterJobId) {
        this.afterJobId = afterJobId;
    }

    public Integer getOperateType() {
        return operateType;
    }

    public void setOperateType(Integer operateType) {
        this.operateType = operateType;
    }

    public Date getRemoveDate() {
        return removeDate;
    }

    public void setRemoveDate(Date removeDate) {
        this.removeDate = removeDate;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason == null ? null : reason.trim();
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark == null ? null : remark.trim();
    }

    public Department getBeforeDepartment() {
        return beforeDepartment;
    }

    public void setBeforeDepartment(Department beforeDepartment) {
        this.beforeDepartment = beforeDepartment;
    }

    public Position getBeforePosition() {
        return beforePosition;
    }

    public void setBeforePosition(Position beforePosition) {
        this.beforePosition = beforePosition;
    }

    public Department getAfterDepartment() {
        return afterDepartment;
    }

    public void setAfterDepartment(Department afterDepartment) {
        this.afterDepartment = afterDepartment;
    }

    public Position getAfterPosition() {
        return afterPosition;
    }

    public void setAfterPosition(Position afterPosition) {
        this.afterPosition = afterPosition;
    }

    public Employee getEmployee() {
        return employee;
    }

    public void setEmployee(Employee employee) {
        this.employee = employee;
    }
}