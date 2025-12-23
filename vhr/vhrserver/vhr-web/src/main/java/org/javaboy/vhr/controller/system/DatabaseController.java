package org.javaboy.vhr.controller.system;

import org.flywaydb.core.Flyway;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.javaboy.vhr.model.RespBean;

import javax.sql.DataSource;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/system/data")
public class DatabaseController {
    @Autowired
    DataSource dataSource;

    @GetMapping("/tables")
    public List<Map<String, Object>> getTables() {
        List<Map<String, Object>> tables = new ArrayList<>();
        try (Connection conn = dataSource.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT TABLE_NAME, TABLE_COMMENT, TABLE_ROWS FROM information_schema.TABLES WHERE TABLE_SCHEMA = (SELECT DATABASE())")) {
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("name", rs.getString("TABLE_NAME"));
                map.put("comment", rs.getString("TABLE_COMMENT"));
                map.put("rows", rs.getLong("TABLE_ROWS"));
                tables.add(map);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return tables;
    }

    @GetMapping("/export/{tableName}")
    public String exportTable(@PathVariable String tableName) {
        StringBuilder sql = new StringBuilder();
        try (Connection conn = dataSource.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT * FROM " + tableName)) {
            
            int columnCount = rs.getMetaData().getColumnCount();
            while (rs.next()) {
                sql.append("INSERT INTO ").append(tableName).append(" VALUES (");
                for (int i = 1; i <= columnCount; i++) {
                    Object value = rs.getObject(i);
                    if (value == null) {
                        sql.append("NULL");
                    } else if (value instanceof Number) {
                        sql.append(value);
                    } else {
                        sql.append("'").append(value.toString().replace("'", "\\'")).append("'");
                    }
                    if (i < columnCount) {
                        sql.append(", ");
                    }
                }
                sql.append(");\n");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return "Error exporting table";
        }
        return sql.toString();
    }

    @PostMapping("/import")
    public RespBean importData(@RequestParam("file") MultipartFile file) {
        try (Connection conn = dataSource.getConnection();
             Statement stmt = conn.createStatement();
             BufferedReader reader = new BufferedReader(new InputStreamReader(file.getInputStream()))) {
            String line;
            while ((line = reader.readLine()) != null) {
                if (line.trim().length() > 0 && !line.startsWith("--")) {
                    stmt.addBatch(line);
                }
            }
            stmt.executeBatch();
            return RespBean.ok("导入成功!");
        } catch (Exception e) {
            e.printStackTrace();
            return RespBean.error("导入失败!");
        }
    }
}
