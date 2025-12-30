package org.javaboy.vhr.mapper;

import org.javaboy.vhr.model.Employeeremove;
import java.util.List;
import org.apache.ibatis.annotations.Param;
import java.util.Date;

public interface EmployeeremoveMapper {
    int deleteByPrimaryKey(Integer id);

    int insert(Employeeremove record);

    int insertSelective(Employeeremove record);

    Employeeremove selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(Employeeremove record);

    int updateByPrimaryKey(Employeeremove record);
    
    List<Employeeremove> getEmployeeRemovesByPage(@Param("eid") String eid, @Param("beginDateScope") Date[] beginDateScope);
}