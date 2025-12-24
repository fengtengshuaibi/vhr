package org.javaboy.vhr.controller;

import org.javaboy.vhr.config.FastDFSUtils;
import org.javaboy.vhr.model.Hr;
import org.javaboy.vhr.model.RespBean;
import org.javaboy.vhr.service.HrService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.Map;

/**
 * @作者 小腾
 * @GitHub https://github.com/fengtengshuaibi?tab=repositories * @时间 2020-03-01 13:07
 */
@RestController
public class HrInfoController {

    @Autowired
    HrService hrService;

    @Value("${fastdfs.nginx.host}")
    String nginxHost;

    @GetMapping("/hr/info")
    public Hr getCurrentHr(Authentication authentication) {
        return ((Hr) authentication.getPrincipal());
    }

    @PutMapping("/hr/info")
    public RespBean updateHr(@RequestBody Hr hr, Authentication authentication) {
        if (hrService.updateHr(hr) == 1) {
            SecurityContextHolder.getContext().setAuthentication(new UsernamePasswordAuthenticationToken(hr, authentication.getCredentials(), authentication.getAuthorities()));
            return RespBean.ok("更新成功!");
        }
        return RespBean.error("更新失败!");
    }

    @PutMapping("/hr/pass")
    public RespBean updateHrPasswd(@RequestBody Map<String, Object> info) {
        String oldpass = (String) info.get("oldpass");
        String pass = (String) info.get("pass");
        Integer hrid = (Integer) info.get("hrid");
        if (hrService.updateHrPasswd(oldpass, pass, hrid)) {
            return RespBean.ok("更新成功!");
        }
        return RespBean.error("更新失败!");
    }

    @PostMapping("/hr/userface")
    public RespBean updateHrUserface(MultipartFile file, Integer id,Authentication authentication) {
        String fileId = FastDFSUtils.upload(file);
        String url = nginxHost + fileId;
        if (hrService.updateUserface(url, id) == 1) {
            Hr hr = (Hr) authentication.getPrincipal();
            hr.setUserface(url);
            SecurityContextHolder.getContext().setAuthentication(new UsernamePasswordAuthenticationToken(hr, authentication.getCredentials(), authentication.getAuthorities()));
            return RespBean.ok("更新成功!", url);
        }
        return RespBean.error("更新失败!");
    }

    @PostMapping("/hr/bind")
    public RespBean bindEmployee(@RequestBody Map<String, Object> info, Authentication authentication) {
        String idCard = (String) info.get("idCard");
        Hr currentHr = (Hr) authentication.getPrincipal();
        int result = hrService.bindEmployee(currentHr.getId(), idCard);
        if (result == 1) {
            // Refresh user info
            Hr updatedHr = (Hr) hrService.loadUserByUsername(currentHr.getUsername());
            SecurityContextHolder.getContext().setAuthentication(new UsernamePasswordAuthenticationToken(updatedHr, authentication.getCredentials(), authentication.getAuthorities()));
            return RespBean.ok("绑定成功!", updatedHr);
        } else if (result == -1) {
            return RespBean.error("该员工已被其他账号绑定!");
        }
        return RespBean.error("绑定失败!");
    }
}
