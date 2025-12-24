package org.javaboy.vhr.model;

import java.io.Serializable;
import java.util.List;

public class ExamSubmissionDto implements Serializable {
    private Integer ecId;
    private List<CourseQuestion> answers;

    public Integer getEcId() {
        return ecId;
    }

    public void setEcId(Integer ecId) {
        this.ecId = ecId;
    }

    public List<CourseQuestion> getAnswers() {
        return answers;
    }

    public void setAnswers(List<CourseQuestion> answers) {
        this.answers = answers;
    }
}
