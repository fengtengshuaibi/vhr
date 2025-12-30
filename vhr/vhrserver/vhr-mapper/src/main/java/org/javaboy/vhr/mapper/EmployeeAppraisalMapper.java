package org.javaboy.vhr.mapper;

import org.javaboy.vhr.model.EmployeeAppraisal;
import java.util.List;
import org.apache.ibatis.annotations.Param;
import java.util.Date;

public interface EmployeeAppraisalMapper {
    int deleteByPrimaryKey(Integer id);

    int insert(EmployeeAppraisal record);

    int insertSelective(EmployeeAppraisal record);

    EmployeeAppraisal selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(EmployeeAppraisal record);

    int updateByPrimaryKey(EmployeeAppraisal record);
    
    List<EmployeeAppraisal> getEmployeeAppraisalsByPage(@Param("eid") String eid, @Param("beginDateScope") Date[] beginDateScope);
}