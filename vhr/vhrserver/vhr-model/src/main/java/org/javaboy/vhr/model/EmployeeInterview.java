package org.javaboy.vhr.model;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;

public class EmployeeInterview {
    private Integer id;
    private String eid;
    private Integer year;
    @JsonFormat(pattern = "yyyy-MM-dd", timezone = "Asia/Shanghai")
    private Date interviewDate;
    private Integer type;
    private String content;
    private String attachmentUrl;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "Asia/Shanghai")
    private Date createDate;
    private Employee employee;

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public String getEid() { return eid; }
    public void setEid(String eid) { this.eid = eid; }
    public Integer getYear() { return year; }
    public void setYear(Integer year) { this.year = year; }
    public Date getInterviewDate() { return interviewDate; }
    public void setInterviewDate(Date interviewDate) { this.interviewDate = interviewDate; }
    public Integer getType() { return type; }
    public void setType(Integer type) { this.type = type; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content == null ? null : content.trim(); }
    public String getAttachmentUrl() { return attachmentUrl; }
    public void setAttachmentUrl(String attachmentUrl) { this.attachmentUrl = attachmentUrl == null ? null : attachmentUrl.trim(); }
    public Date getCreateDate() { return createDate; }
    public void setCreateDate(Date createDate) { this.createDate = createDate; }
    public Employee getEmployee() { return employee; }
    public void setEmployee(Employee employee) { this.employee = employee; }
}
