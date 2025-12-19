package org.javaboy.vhr.model;

import com.fasterxml.jackson.annotation.JsonFormat;

import java.io.Serializable;
import java.util.Date;

public class Contract implements Serializable {
    private String idCard;
    private String name;
    private String employmentType; // 0-全日制、1-非全日制
    private String contractType; // 0-固定期限、1-无固定期限
    @JsonFormat(pattern = "yyyy-MM-dd", timezone = "Asia/Shanghai")
    private Date firstSignDate;
    private Double firstSignTerm;
    @JsonFormat(pattern = "yyyy-MM-dd", timezone = "Asia/Shanghai")
    private Date secondSignDate;
    private Double secondSignTerm;
    @JsonFormat(pattern = "yyyy-MM-dd", timezone = "Asia/Shanghai")
    private Date thirdSignDate;
    private Integer signCount;
    @JsonFormat(pattern = "yyyy-MM-dd", timezone = "Asia/Shanghai")
    private Date endDate;
    private Integer daysToExpiry;
    private String attachments;

    public String getAttachments() {
        return attachments;
    }

    public void setAttachments(String attachments) {
        this.attachments = attachments;
    }

    public String getIdCard() {
        return idCard;
    }

    public void setIdCard(String idCard) {
        this.idCard = idCard;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmploymentType() {
        return employmentType;
    }

    public void setEmploymentType(String employmentType) {
        this.employmentType = employmentType;
    }

    public String getContractType() {
        return contractType;
    }

    public void setContractType(String contractType) {
        this.contractType = contractType;
    }

    public Date getFirstSignDate() {
        return firstSignDate;
    }

    public void setFirstSignDate(Date firstSignDate) {
        this.firstSignDate = firstSignDate;
    }

    public Double getFirstSignTerm() {
        return firstSignTerm;
    }

    public void setFirstSignTerm(Double firstSignTerm) {
        this.firstSignTerm = firstSignTerm;
    }

    public Date getSecondSignDate() {
        return secondSignDate;
    }

    public void setSecondSignDate(Date secondSignDate) {
        this.secondSignDate = secondSignDate;
    }

    public Double getSecondSignTerm() {
        return secondSignTerm;
    }

    public void setSecondSignTerm(Double secondSignTerm) {
        this.secondSignTerm = secondSignTerm;
    }

    public Date getThirdSignDate() {
        return thirdSignDate;
    }

    public void setThirdSignDate(Date thirdSignDate) {
        this.thirdSignDate = thirdSignDate;
    }

    public Integer getSignCount() {
        return signCount;
    }

    public void setSignCount(Integer signCount) {
        this.signCount = signCount;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public Integer getDaysToExpiry() {
        return daysToExpiry;
    }

    public void setDaysToExpiry(Integer daysToExpiry) {
        this.daysToExpiry = daysToExpiry;
    }
}
