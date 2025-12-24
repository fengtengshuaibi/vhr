package org.javaboy.vhr.controller.personnel;

import org.javaboy.vhr.model.*;
import org.javaboy.vhr.service.TrainingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/personnel/train")
public class TrainingController {
    @Autowired
    TrainingService trainingService;
    
    @Value("${vhr.video.path}")
    String videoPath;

    @PostMapping("/course")
    public RespBean addCourse(@RequestBody Course course) {
        if (trainingService.addCourse(course)) {
            return RespBean.ok("添加成功!");
        }
        return RespBean.error("添加失败!");
    }

    @PostMapping("/upload")
    public RespBean uploadVideo(MultipartFile file) {
        File folder = new File(videoPath);
        if (!folder.exists()) {
            folder.mkdirs();
        }
        String oldName = file.getOriginalFilename();
        String newName = UUID.randomUUID().toString() + oldName.substring(oldName.lastIndexOf("."));
        try {
            file.transferTo(new File(folder, newName));
            return RespBean.ok("上传成功", newName); 
        } catch (IOException e) {
            e.printStackTrace();
        }
        return RespBean.error("上传失败");
    }
    
    @GetMapping("/stats")
    public List<EmployeeCourse> getStats(String keywords) {
        return trainingService.getTrainingStats(keywords);
    }

    @GetMapping("/list")
    public List<Course> getAllCourses(String keywords) {
        return trainingService.getAllCourses(keywords);
    }
}
