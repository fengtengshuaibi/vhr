package org.javaboy.vhr.controller.per;

import org.javaboy.vhr.model.EmployeeInterview;
import org.javaboy.vhr.model.RespBean;
import org.javaboy.vhr.model.RespPageBean;
import org.javaboy.vhr.service.EmployeeInterviewService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.beans.factory.annotation.Value;

import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.util.FileCopyUtils;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.UUID;
import javax.servlet.http.HttpServletRequest;

@RestController
@RequestMapping("/per/interview")
public class EmployeeInterviewController {
    @Autowired
    EmployeeInterviewService employeeInterviewService;

    @Value("${interview.upload.path}")
    private String uploadPath;

    @GetMapping("/")
    public RespPageBean getEmployeeInterviewsByPage(@RequestParam(defaultValue = "1") Integer page,
                                                    @RequestParam(defaultValue = "10") Integer size,
                                                    String empName, Integer type, Integer year) {
        return employeeInterviewService.getEmployeeInterviewsByPage(page, size, empName, type, year);
    }

    @PostMapping("/")
    public RespBean addEmployeeInterview(@RequestBody EmployeeInterview employeeInterview) {
        if (employeeInterviewService.addEmployeeInterview(employeeInterview) == 1) {
            return RespBean.ok("添加成功!");
        }
        return RespBean.error("添加失败!");
    }

    @PutMapping("/")
    public RespBean updateEmployeeInterview(@RequestBody EmployeeInterview employeeInterview) {
        if (employeeInterviewService.updateEmployeeInterview(employeeInterview) == 1) {
            return RespBean.ok("更新成功!");
        }
        return RespBean.error("更新失败!");
    }

    @DeleteMapping("/{id}")
    public RespBean deleteEmployeeInterview(@PathVariable Integer id) {
        if (employeeInterviewService.deleteEmployeeInterview(id) == 1) {
            return RespBean.ok("删除成功!");
        }
        return RespBean.error("删除失败!");
    }

    @PostMapping("/upload")
    public RespBean upload(@RequestParam("file") MultipartFile file, HttpServletRequest request) {
        if (file.getSize() > 10 * 1024 * 1024) {
            return RespBean.error("文件大小不能超过10MB!");
        }
        String fileName = file.getOriginalFilename();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
        String format = sdf.format(new Date());
        File saveFile = new File(uploadPath + format);
        if (!saveFile.exists()) {
            saveFile.mkdirs();
        }
        try {
            file.transferTo(new File(saveFile, fileName));
            String url = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + "/interview/files/" + format + "/" + fileName;
            // Return JSON object with name and url
            return RespBean.ok("上传成功", "{\"name\":\"" + fileName + "\",\"url\":\"" + url + "\"}");
        } catch (IOException e) {
            e.printStackTrace();
            return RespBean.error("上传失败: " + e.getMessage());
        }
    }

    @GetMapping("/download/{fileName:.+}")
    public ResponseEntity<byte[]> download(@PathVariable String fileName) {
        // Need to find the file in subdirectories as they are stored by date
        File rootDir = new File(uploadPath);
        File targetFile = findFile(rootDir, fileName);

        if (targetFile == null || !targetFile.exists()) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }

        try {
            HttpHeaders headers = new HttpHeaders();
            headers.setContentDispositionFormData("attachment", URLEncoder.encode(fileName, "UTF-8"));
            headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
            return new ResponseEntity<>(FileCopyUtils.copyToByteArray(targetFile), headers, HttpStatus.CREATED);
        } catch (IOException e) {
            e.printStackTrace();
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @DeleteMapping("/file")
    public RespBean deleteFile(@RequestParam String fileName, @RequestParam(required = false) String date) {
        File file = null;
        if (date != null) {
            file = new File(uploadPath + date + "/" + fileName);
        } else {
            file = findFile(new File(uploadPath), fileName);
        }

        if (file != null && file.exists()) {
            if (file.delete()) {
                return RespBean.ok("删除成功!");
            }
        }
        return RespBean.error("删除失败!");
    }

    private File findFile(File dir, String name) {
        if (!dir.exists() || !dir.isDirectory()) return null;
        File[] files = dir.listFiles();
        if (files != null) {
            for (File file : files) {
                if (file.isDirectory()) {
                    File found = findFile(file, name);
                    if (found != null) return found;
                } else if (file.getName().equals(name)) {
                    return file;
                }
            }
        }
        return null;
    }
}
