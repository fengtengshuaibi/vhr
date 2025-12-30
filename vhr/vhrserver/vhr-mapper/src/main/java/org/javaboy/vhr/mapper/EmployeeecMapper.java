package org.javaboy.vhr.mapper;

import org.javaboy.vhr.model.Employeeec;
import java.util.List;
import org.apache.ibatis.annotations.Param;
import java.util.Date;

public interface EmployeeecMapper {
    int deleteByPrimaryKey(Integer id);

    int insert(Employeeec record);

    int insertSelective(Employeeec record);

    Employeeec selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(Employeeec record);

    int updateByPrimaryKey(Employeeec record);
    
    List<Employeeec> getEmployeeEcsByPage(@Param("eid") String eid, @Param("beginDateScope") Date[] beginDateScope);
}