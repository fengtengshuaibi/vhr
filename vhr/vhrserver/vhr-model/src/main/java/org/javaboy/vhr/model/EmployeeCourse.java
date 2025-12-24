package org.javaboy.vhr.model;

import java.io.Serializable;
import java.util.Date;

public class EmployeeCourse implements Serializable {
    private Integer id;
    private Integer employeeId;
    private Integer courseId;
    private String status;
    private Integer videoProgress;
    private Boolean isVideoFinished;
    private Double studyHours;
    private Integer examScore;
    private Integer examAttempts;
    private Boolean isPassed;
    private Date createDate;
    private Date updateDate;

    private Course course;
    private Employee employee;

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public Integer getEmployeeId() { return employeeId; }
    public void setEmployeeId(Integer employeeId) { this.employeeId = employeeId; }
    public Integer getCourseId() { return courseId; }
    public void setCourseId(Integer courseId) { this.courseId = courseId; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public Integer getVideoProgress() { return videoProgress; }
    public void setVideoProgress(Integer videoProgress) { this.videoProgress = videoProgress; }
    public Boolean getIsVideoFinished() { return isVideoFinished; }
    public void setIsVideoFinished(Boolean isVideoFinished) { this.isVideoFinished = isVideoFinished; }
    public Double getStudyHours() { return studyHours; }
    public void setStudyHours(Double studyHours) { this.studyHours = studyHours; }
    public Integer getExamScore() { return examScore; }
    public void setExamScore(Integer examScore) { this.examScore = examScore; }
    public Integer getExamAttempts() { return examAttempts; }
    public void setExamAttempts(Integer examAttempts) { this.examAttempts = examAttempts; }
    public Boolean getIsPassed() { return isPassed; }
    public void setIsPassed(Boolean isPassed) { this.isPassed = isPassed; }
    public Date getCreateDate() { return createDate; }
    public void setCreateDate(Date createDate) { this.createDate = createDate; }
    public Date getUpdateDate() { return updateDate; }
    public void setUpdateDate(Date updateDate) { this.updateDate = updateDate; }
    public Course getCourse() { return course; }
    public void setCourse(Course course) { this.course = course; }
    public Employee getEmployee() { return employee; }
    public void setEmployee(Employee employee) { this.employee = employee; }
}
