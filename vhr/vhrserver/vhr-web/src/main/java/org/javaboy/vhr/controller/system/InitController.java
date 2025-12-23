package org.javaboy.vhr.controller.system;

import org.flywaydb.core.Flyway;
import org.javaboy.vhr.model.RespBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.sql.DataSource;

@RestController
@RequestMapping("/system/init")
public class InitController {
    @Autowired
    DataSource dataSource;

    @PostMapping("/")
    public RespBean initDatabase() {
        try {
            Flyway flyway = Flyway.configure()
                    .dataSource(dataSource)
                    .baselineOnMigrate(true)
                    .load();
            flyway.clean();
            flyway.migrate();
            return RespBean.ok("数据库初始化成功!");
        } catch (Exception e) {
            e.printStackTrace();
            return RespBean.error("数据库初始化失败: " + e.getMessage());
        }
    }
}
