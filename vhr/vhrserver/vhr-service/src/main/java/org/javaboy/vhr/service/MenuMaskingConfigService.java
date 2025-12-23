package org.javaboy.vhr.service;

import org.javaboy.vhr.mapper.MenuMaskingConfigMapper;
import org.javaboy.vhr.model.MenuMaskingConfig;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class MenuMaskingConfigService {
    @Autowired
    MenuMaskingConfigMapper menuMaskingConfigMapper;

    public List<MenuMaskingConfig> getConfigsByMenuId(Integer menuId) {
        return menuMaskingConfigMapper.getConfigsByMenuId(menuId);
    }

    public int addConfig(MenuMaskingConfig config) {
        return menuMaskingConfigMapper.insertSelective(config);
    }

    public int updateConfig(MenuMaskingConfig config) {
        return menuMaskingConfigMapper.updateByPrimaryKeySelective(config);
    }

    public int deleteConfig(Integer id) {
        return menuMaskingConfigMapper.deleteByPrimaryKey(id);
    }
}
