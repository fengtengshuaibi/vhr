package org.javaboy.vhr.service;

import org.javaboy.vhr.mapper.AttendanceLeaveMapper;
import org.javaboy.vhr.model.AttendanceLeave;
import org.javaboy.vhr.model.RespPageBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class AttendanceLeaveService {
    @Autowired
    AttendanceLeaveMapper attendanceLeaveMapper;

    public RespPageBean getAttendanceLeaveByPage(Integer page, Integer size, String keyword) {
        if (page != null && size != null) {
            page = (page - 1) * size;
        }
        List<AttendanceLeave> data = attendanceLeaveMapper.getAllAttendanceLeaves(page, size, keyword);
        Long total = attendanceLeaveMapper.getTotal(keyword);
        RespPageBean bean = new RespPageBean();
        bean.setData(data);
        bean.setTotal(total);
        return bean;
    }

    public Integer addAttendanceLeave(AttendanceLeave attendanceLeave) {
        return attendanceLeaveMapper.insert(attendanceLeave);
    }

    public Integer deleteAttendanceLeaveById(Integer id) {
        return attendanceLeaveMapper.deleteByPrimaryKey(id);
    }

    public Integer updateAttendanceLeave(AttendanceLeave attendanceLeave) {
        return attendanceLeaveMapper.updateByPrimaryKeySelective(attendanceLeave);
    }

    public Integer addAttendanceLeaves(List<AttendanceLeave> list) {
        return attendanceLeaveMapper.insertBatch(list);
    }

    public List<AttendanceLeave> getAttendanceLeaveByIdCard(String idCard) {
        return attendanceLeaveMapper.getAttendanceLeaveByIdCard(idCard);
    }
}
