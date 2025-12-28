package org.javaboy.vhr.service;

import org.javaboy.vhr.mapper.*;
import org.javaboy.vhr.model.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;
import java.util.Map;

@Service
public class TrainingService {
    @Autowired
    CourseMapper courseMapper;
    @Autowired
    CourseQuestionMapper courseQuestionMapper;
    @Autowired
    EmployeeCourseMapper employeeCourseMapper;
    @Autowired
    EmployeeMapper employeeMapper;

    @Transactional
    public boolean addCourse(Course course) {
        course.setCreateDate(new Date());
        course.setStatus(1);
        int result = courseMapper.insertSelective(course);
        if (result > 0) {
            // Add Questions
            if (course.getQuestions() != null) {
                for (CourseQuestion q : course.getQuestions()) {
                    q.setCourseId(course.getId());
                    courseQuestionMapper.insertSelective(q);
                }
            }
            // If Compulsory, assign to employees
            if ("必修".equals(course.getType()) && course.getDepartmentId() != null) {
                // Get all employees in dept
                Employee emp = new Employee();
                emp.setDepartmentId(course.getDepartmentId());
                List<Employee> emps = employeeMapper.getEmployeeByPage(null, null, emp, null, null, null, null);
                if (emps != null) {
                    for (Employee e : emps) {
                        EmployeeCourse ec = new EmployeeCourse();
                        ec.setEmployeeId(e.getIdCard());
                        ec.setCourseId(course.getId());
                        ec.setStatus("Learning");
                        ec.setCreateDate(new Date());
                        employeeCourseMapper.insertSelective(ec);
                    }
                }
            }
            return true;
        }
        return false;
    }

    public List<Course> getAllCourses(String keywords) {
        return courseMapper.getAllCourses(keywords);
    }

    public Course getCourseById(Integer id) {
        return courseMapper.selectByPrimaryKey(id);
    }

    public boolean deleteCourse(Integer id) {
        return courseMapper.deleteByPrimaryKey(id) > 0;
    }

    public boolean deleteCourses(Integer[] ids) {
        if (ids == null || ids.length == 0) return false;
        return courseMapper.deleteByIds(ids) > 0;
    }

    @Transactional
    public boolean updateCourse(Course course) {
        int result = courseMapper.updateByPrimaryKeySelective(course);
        if (result > 0) {
            // Update Questions
            courseQuestionMapper.deleteByCourseId(course.getId());
            if (course.getHasExam() != null && course.getHasExam() && course.getQuestions() != null) {
                for (CourseQuestion q : course.getQuestions()) {
                    q.setCourseId(course.getId());
                    q.setId(null); // Force insert as new
                    courseQuestionMapper.insertSelective(q);
                }
            }
            
            // Handle Compulsory Assignment
            if ("必修".equals(course.getType()) && course.getDepartmentId() != null) {
                Employee emp = new Employee();
                emp.setDepartmentId(course.getDepartmentId());
                List<Employee> emps = employeeMapper.getEmployeeByPage(null, null, emp, null, null, null, null);
                if (emps != null) {
                    for (Employee e : emps) {
                        EmployeeCourse exist = employeeCourseMapper.getEmployeeCourse(e.getIdCard(), course.getId());
                        if (exist == null) {
                            EmployeeCourse ec = new EmployeeCourse();
                            ec.setEmployeeId(e.getIdCard());
                            ec.setCourseId(course.getId());
                            ec.setStatus("Learning");
                            ec.setCreateDate(new Date());
                            employeeCourseMapper.insertSelective(ec);
                        }
                    }
                }
            }
            return true;
        }
        return false;
    }
    
    public List<EmployeeCourse> getMyCourses(String employeeId, String type, String status) {
        // Get courses from employee_course table
        // Correct order: employeeId, status, type
        return employeeCourseMapper.getEmployeeCourses(employeeId, status, type);
    }
    
    @Transactional
    public boolean addElectiveCourse(String employeeId, Integer courseId) {
        // Check if exists
        EmployeeCourse exist = employeeCourseMapper.getEmployeeCourse(employeeId, courseId);
        if (exist != null) return false;
        
        EmployeeCourse ec = new EmployeeCourse();
        ec.setEmployeeId(employeeId);
        ec.setCourseId(courseId);
        ec.setStatus("Learning");
        ec.setCreateDate(new Date());
        return employeeCourseMapper.insertSelective(ec) > 0;
    }

    @Transactional
    public void updateProgress(Integer ecId, Integer videoProgress, Boolean finished, Double hours) {
        EmployeeCourse ec = new EmployeeCourse();
        ec.setId(ecId);
        ec.setVideoProgress(videoProgress);
        
        EmployeeCourse current = employeeCourseMapper.selectByPrimaryKey(ecId);
        if (current == null) return;
        boolean alreadyFinished = "Finished".equals(current.getStatus());

        ec.setIsVideoFinished(finished);
        if (hours != null) {
            ec.setStudyHours(hours);
        }
        if (finished && !alreadyFinished) {
            // If no exam, mark as Passed
            if (current != null) {
                Course c = courseMapper.selectByPrimaryKey(current.getCourseId());
                if (c != null && (c.getHasExam() == null || !c.getHasExam())) {
                    ec.setIsPassed(true);
                    ec.setStatus("Finished");
                    ec.setExamScore(c.getCredit() != null ? c.getCredit() : 0);
                }
            }
        }
        ec.setUpdateDate(new Date());
        employeeCourseMapper.updateByPrimaryKeySelective(ec);
    }
    
    public List<CourseQuestion> getExamQuestions(Integer courseId) {
        return courseQuestionMapper.getQuestionsByCourseId(courseId);
    }
    
    @Transactional
    public int submitExam(Integer ecId, List<CourseQuestion> answers) {
        EmployeeCourse ec = employeeCourseMapper.selectByPrimaryKey(ecId);
        Course c = courseMapper.selectByPrimaryKey(ec.getCourseId());
        
        if (ec.getExamAttempts() >= c.getExamLimit()) {
            return -1; // Limit reached
        }
        
        int score = 0;
        // Calculate score
        List<CourseQuestion> correctQuestions = courseQuestionMapper.getQuestionsByCourseId(c.getId());
        for (CourseQuestion ans : answers) {
            for (CourseQuestion correct : correctQuestions) {
                if (ans.getId().equals(correct.getId())) {
                    if ("填空".equals(correct.getType())) {
                        if (correct.getCorrectAnswer() != null && !correct.getCorrectAnswer().trim().isEmpty()) {
                            // Standard answer exists
                            if (ans.getCorrectAnswer() != null && ans.getCorrectAnswer().equals(correct.getCorrectAnswer())) {
                                score += correct.getScore();
                            }
                        } else {
                            // No standard answer, score if not empty
                            if (ans.getCorrectAnswer() != null && !ans.getCorrectAnswer().trim().isEmpty()) {
                                score += correct.getScore();
                            }
                        }
                    } else {
                        if (ans.getCorrectAnswer() != null && ans.getCorrectAnswer().equals(correct.getCorrectAnswer())) {
                            score += correct.getScore();
                        }
                    }
                }
            }
        }
        
        ec.setExamScore(score);
        ec.setExamAttempts(ec.getExamAttempts() + 1);
        // Pass logic? Assume 60%? User didn't specify. "Video complete + Exam pass -> Credit".
        // Let's assume > 0 is pass for now or if score >= total * 0.6.
        // User said "Right answer -> score. If answer is None, just answer gets score".
        // I'll assume 60% pass.
        int totalScore = correctQuestions.stream().mapToInt(CourseQuestion::getScore).sum();
        if (totalScore > 0 && score >= totalScore * 0.6) {
            ec.setIsPassed(true);
            ec.setStatus("Finished");
        } else if (totalScore == 0) {
             ec.setIsPassed(true);
             ec.setStatus("Finished");
        }
        
        employeeCourseMapper.updateByPrimaryKeySelective(ec);
        return score;
    }
    
    public List<Map<String, Object>> getTrainingStats(String keywords) {
        return employeeCourseMapper.getTrainingStats(keywords);
    }

    public List<EmployeeCourse> getRankList() {
        return employeeCourseMapper.getTop10ByScore();
    }
    
    public Double getTotalHours(String eid) {
        return employeeCourseMapper.getTotalStudyHours(eid);
    }
    
    public Integer getTotalScore(String eid) {
        return employeeCourseMapper.getTotalExamScore(eid);
    }

    public Integer getCompletedCount(String eid) {
        return employeeCourseMapper.getCompletedCourseCount(eid);
    }
}
