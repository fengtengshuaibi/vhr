package org.javaboy.vhr.mapper;

import org.apache.ibatis.annotations.Param;
import org.javaboy.vhr.model.ExecutivePerformance;
import java.util.Date;
import java.util.List;

public interface ExecutivePerformanceMapper {
    int deleteByPrimaryKey(Integer id);

    int insert(ExecutivePerformance record);

    int insertSelective(ExecutivePerformance record);

    ExecutivePerformance selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(ExecutivePerformance record);

    int updateByPrimaryKey(ExecutivePerformance record);

    List<ExecutivePerformance> getExecutivePerformanceByPage(@Param("page") Integer page, @Param("size") Integer size, @Param("empName") String empName, @Param("year") Integer year, @Param("beginDate") Date beginDate, @Param("endDate") Date endDate);

    Long getTotal(@Param("empName") String empName, @Param("year") Integer year, @Param("beginDate") Date beginDate, @Param("endDate") Date endDate);

    Integer addExecutivePerformances(@Param("list") List<ExecutivePerformance> list);
    
    List<ExecutivePerformance> getAllExecutivePerformances();
}
