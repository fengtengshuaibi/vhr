package org.javaboy.vhr.model;

import com.fasterxml.jackson.annotation.JsonFormat;

import java.io.Serializable;
import java.util.Date;

public class Employee implements Serializable {
    private Integer id;

    private String name;

    private String gender;

    @JsonFormat(pattern = "yyyy-MM-dd",timezone = "Asia/Shanghai")
    private Date birthday;

    private String idCard;

    private String wedlock;

    private Integer nationId;

    private String nativePlace;

    private Integer politicId;

    private String email;

    private String phone;

    private String address;

    private Integer departmentId;

    private Integer posId;

    private String tiptopDegree;

    private String specialty;

    private String school;

    @JsonFormat(pattern = "yyyy-MM-dd",timezone = "Asia/Shanghai")
    private Date beginDate;

    private String workState;

    private Double workAge;
    
    // New Fields
    private Integer age;
    @JsonFormat(pattern = "yyyy-MM-dd",timezone = "Asia/Shanghai")
    private Date conversionTime;
    @JsonFormat(pattern = "yyyy-MM-dd",timezone = "Asia/Shanghai")
    private Date notWorkDate;
    @JsonFormat(pattern = "yyyy-MM-dd",timezone = "Asia/Shanghai")
    private Date idCardStartDate;
    @JsonFormat(pattern = "yyyy-MM-dd",timezone = "Asia/Shanghai")
    private Date idCardEndDate;
    private String hukouType;
    private String hukouLocation;
    private String emergencyContact;
    private String emergencyContactPhone;
    private String fertilityStatus;
    private String childrenInfo;
    @JsonFormat(pattern = "yyyy-MM-dd",timezone = "Asia/Shanghai")
    private Date graduationDate;
    private String certificate;
    private String trainingHistory;
    private String previousCompany;
    private String previousPosition;
    private String previousStartEnd;
    private String pastPerformance;
    private String previousResignationReason;
    private String reference;
    private String referencePhone;
    private String assessmentResult;
    private Integer probation;
    private Integer conversionScore;
    private String workLocation;
    private String rewardsPunishments;
    private String resignationReason;

    private Nation nation;
    private Politicsstatus politicsstatus;
    private Department department;
    private Position position;
    private Salary salary;

    public Salary getSalary() {
        return salary;
    }

    public void setSalary(Salary salary) {
        this.salary = salary;
    }
    public Nation getNation() {
        return nation;
    }

    public void setNation(Nation nation) {
        this.nation = nation;
    }

    public Politicsstatus getPoliticsstatus() {
        return politicsstatus;
    }

    public void setPoliticsstatus(Politicsstatus politicsstatus) {
        this.politicsstatus = politicsstatus;
    }

    public Department getDepartment() {
        return department;
    }

    public void setDepartment(Department department) {
        this.department = department;
    }

    public Position getPosition() {
        return position;
    }

    public void setPosition(Position position) {
        this.position = position;
    }

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

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public Date getBirthday() {
        return birthday;
    }

    public void setBirthday(Date birthday) {
        this.birthday = birthday;
    }

    public String getIdCard() {
        return idCard;
    }

    public void setIdCard(String idCard) {
        this.idCard = idCard;
    }

    public String getWedlock() {
        return wedlock;
    }

    public void setWedlock(String wedlock) {
        this.wedlock = wedlock;
    }

    public Integer getNationId() {
        return nationId;
    }

    public void setNationId(Integer nationId) {
        this.nationId = nationId;
    }

    public String getNativePlace() {
        return nativePlace;
    }

    public void setNativePlace(String nativePlace) {
        this.nativePlace = nativePlace;
    }

    public Integer getPoliticId() {
        return politicId;
    }

    public void setPoliticId(Integer politicId) {
        this.politicId = politicId;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public Integer getDepartmentId() {
        return departmentId;
    }

    public void setDepartmentId(Integer departmentId) {
        this.departmentId = departmentId;
    }

    public Integer getPosId() {
        return posId;
    }

    public void setPosId(Integer posId) {
        this.posId = posId;
    }

    public String getTiptopDegree() {
        return tiptopDegree;
    }

    public void setTiptopDegree(String tiptopDegree) {
        this.tiptopDegree = tiptopDegree;
    }

    public String getSpecialty() {
        return specialty;
    }

    public void setSpecialty(String specialty) {
        this.specialty = specialty;
    }

    public String getSchool() {
        return school;
    }

    public void setSchool(String school) {
        this.school = school;
    }

    public Date getBeginDate() {
        return beginDate;
    }

    public void setBeginDate(Date beginDate) {
        this.beginDate = beginDate;
    }

    public String getWorkState() {
        return workState;
    }

    public void setWorkState(String workState) {
        this.workState = workState;
    }

    public Date getConversionTime() {
        return conversionTime;
    }

    public void setConversionTime(Date conversionTime) {
        this.conversionTime = conversionTime;
    }

    public Date getNotWorkDate() {
        return notWorkDate;
    }

    public void setNotWorkDate(Date notWorkDate) {
        this.notWorkDate = notWorkDate;
    }

    public Double getWorkAge() {
        return workAge;
    }

    public void setWorkAge(Double workAge) {
        this.workAge = workAge;
    }

    public Integer getAge() {
        return age;
    }

    public void setAge(Integer age) {
        this.age = age;
    }

    public Date getIdCardStartDate() {
        return idCardStartDate;
    }

    public void setIdCardStartDate(Date idCardStartDate) {
        this.idCardStartDate = idCardStartDate;
    }

    public Date getIdCardEndDate() {
        return idCardEndDate;
    }

    public void setIdCardEndDate(Date idCardEndDate) {
        this.idCardEndDate = idCardEndDate;
    }

    public String getHukouType() {
        return hukouType;
    }

    public void setHukouType(String hukouType) {
        this.hukouType = hukouType;
    }

    public String getHukouLocation() {
        return hukouLocation;
    }

    public void setHukouLocation(String hukouLocation) {
        this.hukouLocation = hukouLocation;
    }

    public String getEmergencyContact() {
        return emergencyContact;
    }

    public void setEmergencyContact(String emergencyContact) {
        this.emergencyContact = emergencyContact;
    }

    public String getEmergencyContactPhone() {
        return emergencyContactPhone;
    }

    public void setEmergencyContactPhone(String emergencyContactPhone) {
        this.emergencyContactPhone = emergencyContactPhone;
    }

    public String getFertilityStatus() {
        return fertilityStatus;
    }

    public void setFertilityStatus(String fertilityStatus) {
        this.fertilityStatus = fertilityStatus;
    }

    public String getChildrenInfo() {
        return childrenInfo;
    }

    public void setChildrenInfo(String childrenInfo) {
        this.childrenInfo = childrenInfo;
    }

    public Date getGraduationDate() {
        return graduationDate;
    }

    public void setGraduationDate(Date graduationDate) {
        this.graduationDate = graduationDate;
    }

    public String getCertificate() {
        return certificate;
    }

    public void setCertificate(String certificate) {
        this.certificate = certificate;
    }

    public String getTrainingHistory() {
        return trainingHistory;
    }

    public void setTrainingHistory(String trainingHistory) {
        this.trainingHistory = trainingHistory;
    }

    public String getPreviousCompany() {
        return previousCompany;
    }

    public void setPreviousCompany(String previousCompany) {
        this.previousCompany = previousCompany;
    }

    public String getPreviousPosition() {
        return previousPosition;
    }

    public void setPreviousPosition(String previousPosition) {
        this.previousPosition = previousPosition;
    }

    public String getPreviousStartEnd() {
        return previousStartEnd;
    }

    public void setPreviousStartEnd(String previousStartEnd) {
        this.previousStartEnd = previousStartEnd;
    }

    public String getPastPerformance() {
        return pastPerformance;
    }

    public void setPastPerformance(String pastPerformance) {
        this.pastPerformance = pastPerformance;
    }

    public String getPreviousResignationReason() {
        return previousResignationReason;
    }

    public void setPreviousResignationReason(String previousResignationReason) {
        this.previousResignationReason = previousResignationReason;
    }

    public String getReference() {
        return reference;
    }

    public void setReference(String reference) {
        this.reference = reference;
    }

    public String getReferencePhone() {
        return referencePhone;
    }

    public void setReferencePhone(String referencePhone) {
        this.referencePhone = referencePhone;
    }

    public String getAssessmentResult() {
        return assessmentResult;
    }

    public void setAssessmentResult(String assessmentResult) {
        this.assessmentResult = assessmentResult;
    }

    public Integer getProbation() {
        return probation;
    }

    public void setProbation(Integer probation) {
        this.probation = probation;
    }

    public Integer getConversionScore() {
        return conversionScore;
    }

    public void setConversionScore(Integer conversionScore) {
        this.conversionScore = conversionScore;
    }

    public String getWorkLocation() {
        return workLocation;
    }

    public void setWorkLocation(String workLocation) {
        this.workLocation = workLocation;
    }

    public String getRewardsPunishments() {
        return rewardsPunishments;
    }

    public void setRewardsPunishments(String rewardsPunishments) {
        this.rewardsPunishments = rewardsPunishments;
    }

    public String getResignationReason() {
        return resignationReason;
    }

    public void setResignationReason(String resignationReason) {
        this.resignationReason = resignationReason;
    }

    @Override
    public String toString() {
        return "Employee{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", gender='" + gender + '\'' +
                ", birthday=" + birthday +
                ", idCard='" + idCard + '\'' +
                ", wedlock='" + wedlock + '\'' +
                ", nationId=" + nationId +
                ", nativePlace='" + nativePlace + '\'' +
                ", politicId=" + politicId +
                ", email='" + email + '\'' +
                ", phone='" + phone + '\'' +
                ", address='" + address + '\'' +
                ", departmentId=" + departmentId +
                ", posId=" + posId +
                ", tiptopDegree='" + tiptopDegree + '\'' +
                ", specialty='" + specialty + '\'' +
                ", school='" + school + '\'' +
                ", beginDate=" + beginDate +
                ", workState='" + workState + '\'' +
                ", conversionTime=" + conversionTime +
                ", notWorkDate=" + notWorkDate +
                ", workAge=" + workAge +
                ", age=" + age +
                ", idCardStartDate=" + idCardStartDate +
                ", idCardEndDate=" + idCardEndDate +
                ", hukouType='" + hukouType + '\'' +
                ", hukouLocation='" + hukouLocation + '\'' +
                ", emergencyContact='" + emergencyContact + '\'' +
                ", emergencyContactPhone='" + emergencyContactPhone + '\'' +
                ", fertilityStatus='" + fertilityStatus + '\'' +
                ", childrenInfo='" + childrenInfo + '\'' +
                ", graduationDate=" + graduationDate +
                ", certificate='" + certificate + '\'' +
                ", trainingHistory='" + trainingHistory + '\'' +
                ", previousCompany='" + previousCompany + '\'' +
                ", previousPosition='" + previousPosition + '\'' +
                ", previousStartEnd='" + previousStartEnd + '\'' +
                ", pastPerformance='" + pastPerformance + '\'' +
                ", previousResignationReason='" + previousResignationReason + '\'' +
                ", reference='" + reference + '\'' +
                ", referencePhone='" + referencePhone + '\'' +
                ", assessmentResult='" + assessmentResult + '\'' +
                ", probation=" + probation +
                ", conversionScore=" + conversionScore +
                ", workLocation='" + workLocation + '\'' +
                ", rewardsPunishments='" + rewardsPunishments + '\'' +
                ", resignationReason='" + resignationReason + '\'' +
                ", nation=" + nation +
                ", politicsstatus=" + politicsstatus +
                ", department=" + department +
                ", position=" + position +
                '}';
    }
}
