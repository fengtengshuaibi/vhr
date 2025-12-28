package org.javaboy.vhr.controller.emp;

import org.javaboy.vhr.model.*;
import org.javaboy.vhr.service.TrainingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.HashMap;

@RestController
@RequestMapping("/emp/train")
public class EmpTrainingController {
    @Autowired
    TrainingService trainingService;
    
    private String getCurrentEmployeeId() {
        Hr hr = (Hr) org.springframework.security.core.context.SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        return hr.getEmployeeId();
    }

    @GetMapping("/list")
    public List<EmployeeCourse> getMyCourses(String type, String status) {
        String eid = getCurrentEmployeeId();
        System.out.println("getMyCourses: eid=" + eid + ", type=" + type + ", status=" + status);
        if (eid == null) return null;
        List<EmployeeCourse> list = trainingService.getMyCourses(eid, type, status);
        System.out.println("getMyCourses: result size=" + (list != null ? list.size() : "null"));
        return list;
    }

    @GetMapping("/all")
    public List<Course> getAllCourses(String keywords) {
        return trainingService.getAllCourses(keywords);
    }

    @PostMapping("/add")
    public RespBean addCourse(Integer courseId) {
        String eid = getCurrentEmployeeId();
        if (eid == null) return RespBean.error("未绑定员工档案，无法添加");
        if (trainingService.addElectiveCourse(eid, courseId)) {
            return RespBean.ok("添加成功");
        }
        return RespBean.error("添加失败或已添加");
    }

    @PostMapping("/progress")
    public RespBean updateProgress(@RequestBody Map<String, Object> map) {
        Integer ecId = (Integer) map.get("ecId");
        Integer videoProgress = (Integer) map.get("videoProgress");
        Boolean finished = (Boolean) map.get("finished");
        Double hours = null;
        if (map.get("hours") != null) {
             hours = Double.valueOf(map.get("hours").toString());
        }
        trainingService.updateProgress(ecId, videoProgress, finished, hours);
        return RespBean.ok("更新成功");
    }
    
    @GetMapping("/exam/{cid}")
    public List<CourseQuestion> getExamQuestions(@PathVariable Integer cid) {
        return trainingService.getExamQuestions(cid);
    }
    
    @PostMapping("/submitExam")
    public RespBean submitExamReal(@RequestBody ExamSubmissionDto submission) {
        int score = trainingService.submitExam(submission.getEcId(), submission.getAnswers());
        if (score == -1) {
            return RespBean.error("超过考试次数限制");
        }
        return RespBean.ok("考试结束，得分: " + score, score);
    }

    @GetMapping("/info")
    public Map<String, Object> getInfo() {
        String eid = getCurrentEmployeeId();
        Map<String, Object> map = new HashMap<>();
        if (eid != null) {
            map.put("totalHours", trainingService.getTotalHours(eid));
            map.put("totalScore", trainingService.getTotalScore(eid));
            map.put("finishedCount", trainingService.getCompletedCount(eid));
        }
        map.put("rankList", trainingService.getRankList());
        return map;
    }
}
