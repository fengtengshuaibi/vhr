package org.javaboy.vhr.mapper;

import org.apache.ibatis.annotations.Param;
import org.javaboy.vhr.model.Contract;

import java.util.List;

public interface ContractMapper {
    int deleteByPrimaryKey(String idCard);

    int insert(Contract record);

    int insertSelective(Contract record);

    Contract selectByPrimaryKey(String idCard);

    int updateByPrimaryKeySelective(Contract record);

    int updateByPrimaryKey(Contract record);

    List<Contract> getContractsByPage(@Param("page") Integer page, @Param("size") Integer size, 
                                      @Param("contract") Contract contract, 
                                      @Param("daysToExpiry") Integer daysToExpiry);

    Long getTotal(@Param("contract") Contract contract, @Param("daysToExpiry") Integer daysToExpiry);

    Integer addContracts(@Param("list") List<Contract> list);
}
