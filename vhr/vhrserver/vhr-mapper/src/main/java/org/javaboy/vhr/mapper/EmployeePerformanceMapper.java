package org.javaboy.vhr.mapper;

import org.apache.ibatis.annotations.Param;
import org.javaboy.vhr.model.EmployeePerformance;
import java.util.Date;
import java.util.List;

public interface EmployeePerformanceMapper {
    int deleteByPrimaryKey(Integer id);

    int insert(EmployeePerformance record);

    int insertSelective(EmployeePerformance record);

    EmployeePerformance selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(EmployeePerformance record);

    int updateByPrimaryKey(EmployeePerformance record);

    List<EmployeePerformance> getEmployeePerformanceByPage(@Param("page") Integer page, @Param("size") Integer size, @Param("empName") String empName, @Param("year") Integer year, @Param("beginDate") Date beginDate, @Param("endDate") Date endDate);

    Long getTotal(@Param("empName") String empName, @Param("year") Integer year, @Param("beginDate") Date beginDate, @Param("endDate") Date endDate);

    Integer addEmployeePerformances(@Param("list") List<EmployeePerformance> list);
    
    List<EmployeePerformance> getAllEmployeePerformances();
}
