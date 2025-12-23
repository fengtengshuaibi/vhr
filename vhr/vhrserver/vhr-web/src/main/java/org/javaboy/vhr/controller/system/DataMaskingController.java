package org.javaboy.vhr.controller.system;

import org.javaboy.vhr.model.Menu;
import org.javaboy.vhr.model.MenuMaskingConfig;
import org.javaboy.vhr.model.RespBean;
import org.javaboy.vhr.service.MenuMaskingConfigService;
import org.javaboy.vhr.service.MenuService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/system/data-masking")
public class DataMaskingController {
    @Autowired
    MenuService menuService;
    @Autowired
    MenuMaskingConfigService menuMaskingConfigService;

    @GetMapping("/menus")
    public List<Menu> getAllMenus() {
        return menuService.getAllMenus();
    }

    @PutMapping("/menu")
    public RespBean updateMenu(@RequestBody Menu menu) {
        if (menuService.updateMenu(menu) == 1) {
            return RespBean.ok("更新成功!");
        }
        return RespBean.error("更新失败!");
    }

    @PostMapping("/menu")
    public RespBean addMenu(@RequestBody Menu menu) {
        if (menuService.addMenu(menu) == 1) {
            return RespBean.ok("添加成功!", menu);
        }
        return RespBean.error("添加失败!");
    }

    @DeleteMapping("/menu/{id}")
    public RespBean deleteMenu(@PathVariable Integer id) {
        if (menuService.deleteMenu(id) == 1) {
            return RespBean.ok("删除成功!");
        }
        return RespBean.error("删除失败!");
    }

    @GetMapping("/config/{menuId}")
    public List<MenuMaskingConfig> getConfigs(@PathVariable Integer menuId) {
        return menuMaskingConfigService.getConfigsByMenuId(menuId);
    }

    @PostMapping("/config")
    public RespBean addConfig(@RequestBody MenuMaskingConfig config) {
        if (menuMaskingConfigService.addConfig(config) == 1) {
            return RespBean.ok("添加成功!", config);
        }
        return RespBean.error("添加失败!");
    }

    @PutMapping("/config")
    public RespBean updateConfig(@RequestBody MenuMaskingConfig config) {
        if (menuMaskingConfigService.updateConfig(config) == 1) {
            return RespBean.ok("更新成功!");
        }
        return RespBean.error("更新失败!");
    }

    @DeleteMapping("/config/{id}")
    public RespBean deleteConfig(@PathVariable Integer id) {
        if (menuMaskingConfigService.deleteConfig(id) == 1) {
            return RespBean.ok("删除成功!");
        }
        return RespBean.error("删除失败!");
    }
}
