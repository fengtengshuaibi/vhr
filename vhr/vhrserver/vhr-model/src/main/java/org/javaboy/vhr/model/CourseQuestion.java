package org.javaboy.vhr.model;

import java.io.Serializable;

public class CourseQuestion implements Serializable {
    private Integer id;
    private Integer courseId;
    private String type;
    private String content;
    private String options;
    private String correctAnswer;
    private Integer score;

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public Integer getCourseId() { return courseId; }
    public void setCourseId(Integer courseId) { this.courseId = courseId; }
    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    public String getOptions() { return options; }
    public void setOptions(String options) { this.options = options; }
    public String getCorrectAnswer() { return correctAnswer; }
    public void setCorrectAnswer(String correctAnswer) { this.correctAnswer = correctAnswer; }
    public Integer getScore() { return score; }
    public void setScore(Integer score) { this.score = score; }
}
