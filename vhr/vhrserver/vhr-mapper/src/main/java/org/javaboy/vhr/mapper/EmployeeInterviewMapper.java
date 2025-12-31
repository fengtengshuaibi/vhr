package org.javaboy.vhr.mapper;

import org.javaboy.vhr.model.EmployeeInterview;
import org.apache.ibatis.annotations.Param;
import java.util.List;

public interface EmployeeInterviewMapper {
    int deleteByPrimaryKey(Integer id);
    int insert(EmployeeInterview record);
    int insertSelective(EmployeeInterview record);
    EmployeeInterview selectByPrimaryKey(Integer id);
    int updateByPrimaryKeySelective(EmployeeInterview record);
    int updateByPrimaryKey(EmployeeInterview record);
    List<EmployeeInterview> getEmployeeInterviewsByPage(@Param("page") Integer page, @Param("size") Integer size, @Param("empName") String empName, @Param("type") Integer type, @Param("year") Integer year);
    Long getTotal(@Param("empName") String empName, @Param("type") Integer type, @Param("year") Integer year);
    List<EmployeeInterview> getEmployeeInterviewsByEid(@Param("eid") String eid);
    List<EmployeeInterview> getEmployeeInterviewsByEidAndYear(@Param("eid") String eid, @Param("year") Integer year);
}
