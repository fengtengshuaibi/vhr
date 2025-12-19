package org.javaboy.vhr.service;

import org.javaboy.vhr.mapper.EmployeeMapper;
import org.javaboy.vhr.model.Employee;
import org.javaboy.vhr.model.MailConstants;
import org.javaboy.vhr.model.MailSendLog;
import org.javaboy.vhr.model.RespPageBean;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.amqp.rabbit.connection.CorrelationData;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.ArrayList;

/**
 * @作者 小腾
 * @GitHub https://github.com/fengtengshuaibi?tab=repositories * @时间 2019-10-29 7:44
 */
@Service
public class EmployeeService {
    @Autowired
    EmployeeMapper employeeMapper;
    @Autowired
    RabbitTemplate rabbitTemplate;
    @Autowired
    MailSendLogService mailSendLogService;
    public final static Logger logger = LoggerFactory.getLogger(EmployeeService.class);
    SimpleDateFormat yearFormat = new SimpleDateFormat("yyyy");
    SimpleDateFormat monthFormat = new SimpleDateFormat("MM");
    DecimalFormat decimalFormat = new DecimalFormat("##.00");

    public RespPageBean getEmployeeByPage(Integer page, Integer size, Employee employee, Date[] beginDateScope, Integer[] ageScope, Date[] conversionTimeScope, Date[] notWorkDateScope) {
        if (page != null && size != null) {
            page = (page - 1) * size;
        }
        List<Employee> data = employeeMapper.getEmployeeByPage(page, size, employee, beginDateScope, ageScope, conversionTimeScope, notWorkDateScope);
        Long total = employeeMapper.getTotal(employee, beginDateScope, ageScope, conversionTimeScope, notWorkDateScope);
        RespPageBean bean = new RespPageBean();
        bean.setData(data);
        bean.setTotal(total);
        return bean;
    }

    public Integer addEmp(Employee employee) {
        int result = employeeMapper.insertSelective(employee);
        if (result == 1) {
            Employee emp = employeeMapper.getEmployeeById(employee.getIdCard());
            //生成消息的唯一id
            String msgId = UUID.randomUUID().toString();
            MailSendLog mailSendLog = new MailSendLog();
            mailSendLog.setMsgId(msgId);
            mailSendLog.setCreateTime(new Date());
            mailSendLog.setExchange(MailConstants.MAIL_EXCHANGE_NAME);
            mailSendLog.setRouteKey(MailConstants.MAIL_ROUTING_KEY_NAME);
            mailSendLog.setEmpId(emp.getIdCard());
            mailSendLog.setTryTime(new Date(System.currentTimeMillis() + 1000 * 60 * MailConstants.MSG_TIMEOUT));
            mailSendLogService.insert(mailSendLog);
            rabbitTemplate.convertAndSend(MailConstants.MAIL_EXCHANGE_NAME, MailConstants.MAIL_ROUTING_KEY_NAME, emp, new CorrelationData(msgId));
        }
        return result;
    }

    public Integer maxWorkID() {
        return employeeMapper.maxWorkID();
    }

    public Integer deleteEmpByEid(String id) {
        return employeeMapper.deleteByPrimaryKey(id);
    }

    public Integer deleteEmps(List<String> ids) {
        return employeeMapper.deleteEmps(ids);
    }

    public Integer updateEmp(Employee employee) {
        return employeeMapper.updateByPrimaryKeySelective(employee);
    }

    public Integer addEmps(List<Employee> list) {
        if (list == null || list.isEmpty()) {
            return 0;
        }
        int batchSize = 100; // 每批处理的数量
        int size = list.size();
        // 根据数据量计算线程数，最大不超过10个线程
        int threadCount = Math.min((size + batchSize - 1) / batchSize, 10);
        if (threadCount == 0) threadCount = 1;
        
        ExecutorService executorService = Executors.newFixedThreadPool(threadCount);
        List<Future<Integer>> futures = new ArrayList<>();

        try {
            for (int i = 0; i < size; i += batchSize) {
                int end = Math.min(i + batchSize, size);
                // 截取子列表，注意 subList 是视图，只要不修改原列表是安全的
                List<Employee> subList = list.subList(i, end);
                futures.add(executorService.submit(() -> employeeMapper.addEmps(subList)));
            }

            int totalAffected = 0;
            for (Future<Integer> future : futures) {
                // get() 会阻塞直到任务完成，按提交顺序等待确保了一定的顺序性（虽然执行是并行的）
                totalAffected += future.get();
            }
            return totalAffected;
        } catch (Exception e) {
            logger.error("批量导入失败", e);
            throw new RuntimeException("批量导入失败: " + e.getMessage());
        } finally {
            executorService.shutdown();
        }
    }

    public RespPageBean getEmployeeByPageWithSalary(Integer page, Integer size) {
        if (page != null && size != null) {
            page = (page - 1) * size;
        }
        List<Employee> list = employeeMapper.getEmployeeByPageWithSalary(page, size);
        RespPageBean respPageBean = new RespPageBean();
        respPageBean.setData(list);
        respPageBean.setTotal(employeeMapper.getTotal(null, null,null, null, null));
        return respPageBean;
    }

    public Integer updateEmployeeSalaryById(Integer eid, Integer sid) {
        return employeeMapper.updateEmployeeSalaryById(eid, sid);
    }

    public Employee getEmployeeById(String empId) {
        return employeeMapper.getEmployeeById(empId);
    }
}
