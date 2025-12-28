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

    private void deleteFile(String fileName) {
        if (fileName != null && !fileName.isEmpty()) {
            if (fileName.startsWith("/video/")) {
                fileName = fileName.substring(7);
            }
            File file = new File(videoPath, fileName);
            if (file.exists()) {
                file.delete();
            }
        }
    }

    private void calculateDuration(Course course) {
        if (course.getVideoUrl() != null) {
            File file = new File(videoPath, course.getVideoUrl());
            if (file.exists()) {
                try {
                    com.coremedia.iso.IsoFile isoFile = new com.coremedia.iso.IsoFile(file.getAbsolutePath());
                    double durationInSeconds = (double) isoFile.getMovieBox().getMovieHeaderBox().getDuration() /
                            isoFile.getMovieBox().getMovieHeaderBox().getTimescale();
                    isoFile.close();
                    // Convert to hours with 4 decimal places
                    double hours = durationInSeconds / 3600.0;
                    java.math.BigDecimal bd = new java.math.BigDecimal(Double.toString(hours));
                    bd = bd.setScale(4, java.math.RoundingMode.HALF_UP);
                    course.setDuration(bd.doubleValue());
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
    }

    @PostMapping("/course")
    public RespBean addCourse(@RequestBody Course course) {
        calculateDuration(course);
        if (trainingService.addCourse(course)) {
            return RespBean.ok("添加成功!");
        }
        return RespBean.error("添加失败!");
    }

    @DeleteMapping("/course/{id}")
    public RespBean deleteCourse(@PathVariable Integer id) {
        Course c = trainingService.getCourseById(id);
        if (c != null) {
            deleteFile(c.getVideoUrl());
            deleteFile(c.getCoverUrl());
        }
        if (trainingService.deleteCourse(id)) {
            return RespBean.ok("删除成功!");
        }
        return RespBean.error("删除失败!");
    }

    @DeleteMapping("/course/")
    public RespBean deleteCoursesByIds(Integer[] ids) {
        if (ids != null) {
            for (Integer id : ids) {
                Course c = trainingService.getCourseById(id);
                if (c != null) {
                    deleteFile(c.getVideoUrl());
                    deleteFile(c.getCoverUrl());
                }
            }
        }
        if (trainingService.deleteCourses(ids)) {
            return RespBean.ok("删除成功!");
        }
        return RespBean.error("删除失败!");
    }

    @PutMapping("/course/")
    public RespBean updateCourse(@RequestBody Course course) {
        calculateDuration(course);
        // Check old files
        Course oldCourse = trainingService.getCourseById(course.getId());
        if (oldCourse != null) {
            // Check Video
            if (course.getVideoUrl() != null && !course.getVideoUrl().equals(oldCourse.getVideoUrl())) {
                deleteFile(oldCourse.getVideoUrl());
            }
            // Check Cover
            if (course.getCoverUrl() != null && !course.getCoverUrl().equals(oldCourse.getCoverUrl())) {
                deleteFile(oldCourse.getCoverUrl());
            }
        }
        if (trainingService.updateCourse(course)) {
            return RespBean.ok("更新成功!");
        }
        return RespBean.error("更新失败!");
    }

    @PostMapping("/upload")
    public RespBean uploadVideo(MultipartFile file) {
        File folder = new File(videoPath);
        if (!folder.exists()) {
            folder.mkdirs();
        }
        String oldName = file.getOriginalFilename();
        // Use original filename (overwrite if exists)
        try {
            file.transferTo(new File(folder, oldName));
            return RespBean.ok("上传成功", oldName); 
        } catch (IOException e) {
            e.printStackTrace();
        }
        return RespBean.error("上传失败");
    }

    @PostMapping("/delete-file")
    public RespBean deleteFileEndpoint(@RequestParam String fileName) {
        deleteFile(fileName);
        return RespBean.ok("删除成功");
    }
    
    @GetMapping("/stats")
    public List<java.util.Map<String, Object>> getStats(String keywords) {
        return trainingService.getTrainingStats(keywords);
    }

    @GetMapping("/list")
    public List<Course> getAllCourses(String keywords) {
        return trainingService.getAllCourses(keywords);
    }

    @GetMapping("/course/{courseId}/questions")
    public List<CourseQuestion> getCourseQuestions(@PathVariable Integer courseId) {
        return trainingService.getExamQuestions(courseId);
    }
}
