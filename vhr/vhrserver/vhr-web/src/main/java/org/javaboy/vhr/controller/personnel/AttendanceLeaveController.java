package org.javaboy.vhr.controller.personnel;

import org.javaboy.vhr.model.AttendanceLeave;
import org.javaboy.vhr.model.RespBean;
import org.javaboy.vhr.model.RespPageBean;
import org.javaboy.vhr.service.AttendanceLeaveService;
import org.javaboy.vhr.utils.POIUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/personnel/attendance")
public class AttendanceLeaveController {
    @Autowired
    AttendanceLeaveService attendanceLeaveService;

    @GetMapping("/")
    public RespPageBean getAttendanceLeavesByPage(@RequestParam(defaultValue = "1") Integer page,
                                                  @RequestParam(defaultValue = "10") Integer size,
                                                  String keyword) {
        return attendanceLeaveService.getAttendanceLeaveByPage(page, size, keyword);
    }

    @PostMapping("/")
    public RespBean addAttendanceLeave(@RequestBody AttendanceLeave attendanceLeave) {
        if (attendanceLeaveService.addAttendanceLeave(attendanceLeave) == 1) {
            return RespBean.ok("添加成功!");
        }
        return RespBean.error("添加失败!");
    }

    @PutMapping("/")
    public RespBean updateAttendanceLeave(@RequestBody AttendanceLeave attendanceLeave) {
        if (attendanceLeaveService.updateAttendanceLeave(attendanceLeave) == 1) {
            return RespBean.ok("更新成功!");
        }
        return RespBean.error("更新失败!");
    }

    @DeleteMapping("/{id}")
    public RespBean deleteAttendanceLeave(@PathVariable Integer id) {
        if (attendanceLeaveService.deleteAttendanceLeaveById(id) == 1) {
            return RespBean.ok("删除成功!");
        }
        return RespBean.error("删除失败!");
    }

    @GetMapping("/export")
    public ResponseEntity<byte[]> exportData() {
        List<AttendanceLeave> list = (List<AttendanceLeave>) attendanceLeaveService.getAttendanceLeaveByPage(null, null, null).getData();
        return POIUtils.attendance2Excel(list);
    }

    @GetMapping("/import/template")
    public ResponseEntity<byte[]> importTemplate() {
        return POIUtils.attendanceImportTemplate();
    }

    @PostMapping("/import")
    public RespBean importData(MultipartFile file) {
        Map<String, Object> map = POIUtils.excel2Attendance(file);
        List<AttendanceLeave> list = (List<AttendanceLeave>) map.get("list");
        List<String> errors = (List<String>) map.get("errors");

        if (list != null && list.size() > 0) {
            attendanceLeaveService.addAttendanceLeaves(list);
        }

        if (errors != null && !errors.isEmpty()) {
            return RespBean.ok("部分数据存在问题", errors);
        }
        return RespBean.ok("上传成功");
    }
}
