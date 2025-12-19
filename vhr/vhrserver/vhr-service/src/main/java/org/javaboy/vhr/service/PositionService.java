package org.javaboy.vhr.service;

import org.javaboy.vhr.mapper.PositionMapper;
import org.javaboy.vhr.model.Position;
import org.javaboy.vhr.model.RespBean;
import org.javaboy.vhr.model.RespPageBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

/**
 * @作者 小腾
 * @GitHub https://github.com/fengtengshuaibi?tab=repositories * @时间 2019-10-01 15:58
 */
@Service
public class PositionService {
    @Autowired
    PositionMapper positionMapper;

    public RespPageBean getAllPositions(Integer page, Integer size, String name) {
        if (page != null && size != null) {
            page = (page - 1) * size;
        }
        List<Position> data = positionMapper.getAllPositions(page, size, name);
        Long total = positionMapper.getTotal(name);
        RespPageBean bean = new RespPageBean();
        bean.setData(data);
        bean.setTotal(total);
        return bean;
    }

    public List<Position> getAllPositions() {
        return positionMapper.getAllPositions(null, null, null);
    }

    public Integer addPosition(Position position) {
        position.setEnabled(true);
        position.setCreateDate(new Date());
        return positionMapper.insertSelective(position);
    }

    public Integer updatePositions(Position position) {
        return positionMapper.updateByPrimaryKeySelective(position);
    }

    public Integer deletePositionById(Integer id) {
        return positionMapper.deleteByPrimaryKey(id);
    }

    public Integer deletePositionsByIds(Integer[] ids) {
        return positionMapper.deletePositionsByIds(ids);
    }
}
