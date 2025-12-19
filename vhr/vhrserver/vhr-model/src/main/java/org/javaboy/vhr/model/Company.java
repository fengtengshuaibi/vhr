package org.javaboy.vhr.model;

import java.io.Serializable;

public class Company implements Serializable {
    private Integer id;
    private String name;
    private String departmentIds;
    private String posIds;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDepartmentIds() {
        return departmentIds;
    }

    public void setDepartmentIds(String departmentIds) {
        this.departmentIds = departmentIds;
    }

    public String getPosIds() {
        return posIds;
    }

    public void setPosIds(String posIds) {
        this.posIds = posIds;
    }
}
