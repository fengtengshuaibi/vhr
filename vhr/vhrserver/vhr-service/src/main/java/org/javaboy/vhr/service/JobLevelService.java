package org.javaboy.vhr.service;

import org.javaboy.vhr.mapper.JobLevelMapper;
import org.javaboy.vhr.model.JobLevel;
import org.javaboy.vhr.model.RespPageBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

/**
 * @作者 小腾
 * @GitHub https://github.com/fengtengshuaibi?tab=repositories * @时间 2019-10-01 16:03
 */
@Service
public class JobLevelService {
    @Autowired
    JobLevelMapper jobLevelMapper;

    public RespPageBean getAllJobLevels(Integer page, Integer size, String name) {
        if (page != null && size != null) {
            page = (page - 1) * size;
        }
        List<JobLevel> data = jobLevelMapper.getAllJobLevels(page, size, name);
        Long total = jobLevelMapper.getTotal(name);
        RespPageBean bean = new RespPageBean();
        bean.setData(data);
        bean.setTotal(total);
        return bean;
    }

    public List<JobLevel> getAllJobLevels() {
        return jobLevelMapper.getAllJobLevels(null, null, null);
    }

    public Integer addJobLevel(JobLevel jobLevel) {
        jobLevel.setCreateDate(new Date());
        jobLevel.setEnabled(true);
        return jobLevelMapper.insertSelective(jobLevel);
    }

    public Integer updateJobLevelById(JobLevel jobLevel) {
        return jobLevelMapper.updateByPrimaryKeySelective(jobLevel);
    }

    public Integer deleteJobLevelById(Integer id) {
        return jobLevelMapper.deleteByPrimaryKey(id);
    }

    public Integer deleteJobLevelsByIds(Integer[] ids) {
        return jobLevelMapper.deleteJobLevelsByIds(ids);
    }
}
