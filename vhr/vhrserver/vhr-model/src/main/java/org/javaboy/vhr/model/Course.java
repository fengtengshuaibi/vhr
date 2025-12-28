package org.javaboy.vhr.model;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

public class Course implements Serializable {
    private Integer id;
    private String name;
    private String description;
    private String coverUrl;
    private String videoUrl;
    private String category;
    private String type;
    private Integer departmentId;
    private Boolean hasExam;
    private Integer examLimit;
    private Double duration;
    private Integer credit;
    private Date createDate;

    public Double getDuration() { return duration; }
    public void setDuration(Double duration) { this.duration = duration; }
    public Integer getCredit() { return credit; }
    public void setCredit(Integer credit) { this.credit = credit; }
    private Integer status;

    private List<CourseQuestion> questions;

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getCoverUrl() { return coverUrl; }
    public void setCoverUrl(String coverUrl) { this.coverUrl = coverUrl; }
    public String getVideoUrl() { return videoUrl; }
    public void setVideoUrl(String videoUrl) { this.videoUrl = videoUrl; }
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
    public Integer getDepartmentId() { return departmentId; }
    public void setDepartmentId(Integer departmentId) { this.departmentId = departmentId; }
    public Boolean getHasExam() { return hasExam; }
    public void setHasExam(Boolean hasExam) { this.hasExam = hasExam; }
    public Integer getExamLimit() { return examLimit; }
    public void setExamLimit(Integer examLimit) { this.examLimit = examLimit; }
    public Date getCreateDate() { return createDate; }
    public void setCreateDate(Date createDate) { this.createDate = createDate; }
    public Integer getStatus() { return status; }
    public void setStatus(Integer status) { this.status = status; }
    public List<CourseQuestion> getQuestions() { return questions; }
    public void setQuestions(List<CourseQuestion> questions) { this.questions = questions; }
}
