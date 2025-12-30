package org.javaboy.vhr.mapper;

import org.apache.ibatis.annotations.Param;
import org.javaboy.vhr.model.Employeetrain;

import java.util.Date;
import java.util.List;

public interface EmployeetrainMapper {
    int deleteByPrimaryKey(Integer id);

    int insert(Employeetrain record);

    int insertSelective(Employeetrain record);

    Employeetrain selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(Employeetrain record);

    int updateByPrimaryKey(Employeetrain record);

    List<Employeetrain> getEmployeeTrainsByPage(@Param("page") Integer page, @Param("size") Integer size, @Param("train") Employeetrain employeetrain, @Param("beginDateScope") Date[] beginDateScope);

    Long getTotal(@Param("train") Employeetrain employeetrain, @Param("beginDateScope") Date[] beginDateScope);
}