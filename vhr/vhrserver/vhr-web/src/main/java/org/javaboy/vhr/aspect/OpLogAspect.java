package org.javaboy.vhr.aspect;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.javaboy.vhr.model.Hr;
import org.javaboy.vhr.model.OpLog;
import org.javaboy.vhr.service.OpLogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;

import java.util.Date;

@Aspect
@Component
public class OpLogAspect {
    @Autowired
    OpLogService opLogService;

    @Pointcut("@annotation(org.springframework.web.bind.annotation.PostMapping) || " +
            "@annotation(org.springframework.web.bind.annotation.PutMapping) || " +
            "@annotation(org.springframework.web.bind.annotation.DeleteMapping)")
    public void opLogPointcut() {
    }

    @AfterReturning(value = "opLogPointcut()", returning = "result")
    public void saveOpLog(JoinPoint joinPoint, Object result) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !(authentication.getPrincipal() instanceof Hr)) {
            return;
        }
        Hr hr = (Hr) authentication.getPrincipal();
        String methodName = joinPoint.getSignature().getName();
        String className = joinPoint.getTarget().getClass().getSimpleName();
        String args = "";
        if (joinPoint.getArgs().length > 0) {
            args = joinPoint.getArgs()[0].toString();
        }
        
        OpLog opLog = new OpLog();
        opLog.setHrid(hr.getId());
        opLog.setAdddate(new Date());
        String operate = "执行操作: " + className + "." + methodName + ", 参数: " + args;
        if (operate.length() > 255) {
            operate = operate.substring(0, 255);
        }
        opLog.setOperate(operate);
        opLogService.addOpLog(opLog);
    }
}
