package org.javaboy.vhr.model;

import java.io.Serializable;

public class AttendanceLeave implements Serializable {
    private Integer id;
    private String idCard;
    private String name;
    private Integer year;
    private Integer month;
    private Integer lateEarlyLeaveTimes;
    private Integer missingCardTimes;
    private Double overtimeHours;
    private Double compLeaveHours;
    private Double personalLeaveDays;
    private Double sickLeaveDays;
    private Double annualLeaveDays;
    private Double marriageLeaveDays;
    private Double prenatalCheckLeaveHours;
    private Double maternityLeaveDays;
    private Double paternityLeaveDays;
    private Double breastfeedingLeaveHours;
    private Double childcareLeaveHours;
    private Double funeralLeaveDays;
    private Double workInjuryLeaveDays;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
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

    public Integer getYear() {
        return year;
    }

    public void setYear(Integer year) {
        this.year = year;
    }

    public Integer getMonth() {
        return month;
    }

    public void setMonth(Integer month) {
        this.month = month;
    }

    public Integer getLateEarlyLeaveTimes() {
        return lateEarlyLeaveTimes;
    }

    public void setLateEarlyLeaveTimes(Integer lateEarlyLeaveTimes) {
        this.lateEarlyLeaveTimes = lateEarlyLeaveTimes;
    }

    public Integer getMissingCardTimes() {
        return missingCardTimes;
    }

    public void setMissingCardTimes(Integer missingCardTimes) {
        this.missingCardTimes = missingCardTimes;
    }

    public Double getOvertimeHours() {
        return overtimeHours;
    }

    public void setOvertimeHours(Double overtimeHours) {
        this.overtimeHours = overtimeHours;
    }

    public Double getCompLeaveHours() {
        return compLeaveHours;
    }

    public void setCompLeaveHours(Double compLeaveHours) {
        this.compLeaveHours = compLeaveHours;
    }

    public Double getPersonalLeaveDays() {
        return personalLeaveDays;
    }

    public void setPersonalLeaveDays(Double personalLeaveDays) {
        this.personalLeaveDays = personalLeaveDays;
    }

    public Double getSickLeaveDays() {
        return sickLeaveDays;
    }

    public void setSickLeaveDays(Double sickLeaveDays) {
        this.sickLeaveDays = sickLeaveDays;
    }

    public Double getAnnualLeaveDays() {
        return annualLeaveDays;
    }

    public void setAnnualLeaveDays(Double annualLeaveDays) {
        this.annualLeaveDays = annualLeaveDays;
    }

    public Double getMarriageLeaveDays() {
        return marriageLeaveDays;
    }

    public void setMarriageLeaveDays(Double marriageLeaveDays) {
        this.marriageLeaveDays = marriageLeaveDays;
    }

    public Double getPrenatalCheckLeaveHours() {
        return prenatalCheckLeaveHours;
    }

    public void setPrenatalCheckLeaveHours(Double prenatalCheckLeaveHours) {
        this.prenatalCheckLeaveHours = prenatalCheckLeaveHours;
    }

    public Double getMaternityLeaveDays() {
        return maternityLeaveDays;
    }

    public void setMaternityLeaveDays(Double maternityLeaveDays) {
        this.maternityLeaveDays = maternityLeaveDays;
    }

    public Double getPaternityLeaveDays() {
        return paternityLeaveDays;
    }

    public void setPaternityLeaveDays(Double paternityLeaveDays) {
        this.paternityLeaveDays = paternityLeaveDays;
    }

    public Double getBreastfeedingLeaveHours() {
        return breastfeedingLeaveHours;
    }

    public void setBreastfeedingLeaveHours(Double breastfeedingLeaveHours) {
        this.breastfeedingLeaveHours = breastfeedingLeaveHours;
    }

    public Double getChildcareLeaveHours() {
        return childcareLeaveHours;
    }

    public void setChildcareLeaveHours(Double childcareLeaveHours) {
        this.childcareLeaveHours = childcareLeaveHours;
    }

    public Double getFuneralLeaveDays() {
        return funeralLeaveDays;
    }

    public void setFuneralLeaveDays(Double funeralLeaveDays) {
        this.funeralLeaveDays = funeralLeaveDays;
    }

    public Double getWorkInjuryLeaveDays() {
        return workInjuryLeaveDays;
    }

    public void setWorkInjuryLeaveDays(Double workInjuryLeaveDays) {
        this.workInjuryLeaveDays = workInjuryLeaveDays;
    }
}
