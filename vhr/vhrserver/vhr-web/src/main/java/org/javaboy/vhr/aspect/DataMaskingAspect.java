package org.javaboy.vhr.aspect;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.javaboy.vhr.model.Menu;
import org.javaboy.vhr.model.MenuMaskingConfig;
import org.javaboy.vhr.model.RespPageBean;
import org.javaboy.vhr.service.MenuMaskingConfigService;
import org.javaboy.vhr.service.MenuService;
import org.javaboy.vhr.utils.DataMaskingUtils;
import org.springframework.beans.BeanWrapper;
import org.springframework.beans.BeanWrapperImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.util.AntPathMatcher;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

@Aspect
@Component
public class DataMaskingAspect {
    @Autowired
    MenuService menuService;
    @Autowired
    MenuMaskingConfigService maskingConfigService;

    private AntPathMatcher pathMatcher = new AntPathMatcher();

    @Pointcut("execution(* org.javaboy.vhr.controller.emp.EmpBasicController.getEmployeeByPage(..))")
    public void getDataPointCut() {
    }

    @AfterReturning(value = "getDataPointCut()", returning = "result")
    public void maskData(JoinPoint joinPoint, Object result) {
        if (result instanceof RespPageBean) {
            RespPageBean pageBean = (RespPageBean) result;
            List<?> data = pageBean.getData();
            if (data == null || data.isEmpty()) {
                return;
            }

            // 获取当前请求的URL
            ServletRequestAttributes attributes = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
            if (attributes == null) {
                return;
            }
            HttpServletRequest request = attributes.getRequest();
            String requestURI = request.getRequestURI();

            // 查找匹配的菜单
            List<Menu> allMenus = menuService.getAllMenusWithRole();
            Integer menuId = null;
            for (Menu menu : allMenus) {
                if (menu.getUrl() != null && pathMatcher.match(menu.getUrl(), requestURI)) {
                    menuId = menu.getId();
                    break;
                }
            }

            if (menuId == null) {
                return;
            }

            // 获取脱敏配置
            List<MenuMaskingConfig> configs = maskingConfigService.getConfigsByMenuId(menuId);
            if (configs == null || configs.isEmpty()) {
                return;
            }

            // 执行脱敏
            for (Object obj : data) {
                BeanWrapper beanWrapper = new BeanWrapperImpl(obj);
                for (MenuMaskingConfig config : configs) {
                    if (config.getEnabled() != null && config.getEnabled()) {
                        String fieldName = config.getFieldName();
                        try {
                            Object value = beanWrapper.getPropertyValue(fieldName);
                            if (value instanceof String) {
                                String maskedValue = DataMaskingUtils.mask((String) value, config.getMaskingType());
                                beanWrapper.setPropertyValue(fieldName, maskedValue);
                            }
                        } catch (Exception e) {
                            // 忽略不存在的字段或无法访问的字段
                        }
                    }
                }
            }
        }
    }
}
