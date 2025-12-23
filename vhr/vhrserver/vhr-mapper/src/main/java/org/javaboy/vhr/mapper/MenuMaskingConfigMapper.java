package org.javaboy.vhr.mapper;

import org.apache.ibatis.annotations.Param;
import org.javaboy.vhr.model.MenuMaskingConfig;
import java.util.List;

public interface MenuMaskingConfigMapper {
    int deleteByPrimaryKey(Integer id);

    int insert(MenuMaskingConfig record);

    int insertSelective(MenuMaskingConfig record);

    MenuMaskingConfig selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(MenuMaskingConfig record);

    int updateByPrimaryKey(MenuMaskingConfig record);

    List<MenuMaskingConfig> getConfigsByMenuId(Integer menuId);

    int deleteByMenuId(Integer menuId);
}
