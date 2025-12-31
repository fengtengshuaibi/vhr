package org.javaboy.vhr.mapper;

import org.apache.ibatis.annotations.Param;
import org.javaboy.vhr.model.AttendanceLeave;

import java.util.List;

public interface AttendanceLeaveMapper {
    List<AttendanceLeave> getAllAttendanceLeaves(@Param("page") Integer page, @Param("size") Integer size, @Param("keyword") String keyword);

    Long getTotal(@Param("keyword") String keyword);

    int insert(AttendanceLeave record);

    int updateByPrimaryKeySelective(AttendanceLeave record);

    int deleteByPrimaryKey(Integer id);

    int insertBatch(@Param("list") List<AttendanceLeave> list);

    List<AttendanceLeave> getAttendanceLeaveByIdCard(@Param("idCard") String idCard);
}
