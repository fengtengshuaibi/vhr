package org.javaboy.vhr.service;

import org.javaboy.vhr.mapper.ContractMapper;
import org.javaboy.vhr.model.Contract;
import org.javaboy.vhr.model.RespPageBean;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;

@Service
public class ContractService {
    @Autowired
    ContractMapper contractMapper;
    
    public final static Logger logger = LoggerFactory.getLogger(ContractService.class);

    public RespPageBean getContractsByPage(Integer page, Integer size, Contract contract, Integer daysToExpiry) {
        if (page != null && size != null) {
            page = (page - 1) * size;
        }
        List<Contract> data = contractMapper.getContractsByPage(page, size, contract, daysToExpiry);
        Long total = contractMapper.getTotal(contract, daysToExpiry);
        RespPageBean bean = new RespPageBean();
        bean.setData(data);
        bean.setTotal(total);
        return bean;
    }

    public Integer addContract(Contract contract) {
        return contractMapper.insertSelective(contract);
    }

    public Integer updateContract(Contract contract) {
        return contractMapper.updateByPrimaryKeySelective(contract);
    }

    public Integer deleteContractById(String idCard) {
        return contractMapper.deleteByPrimaryKey(idCard);
    }

    public Integer addContracts(List<Contract> list) {
        if (list == null || list.isEmpty()) {
            return 0;
        }
        int batchSize = 100;
        int size = list.size();
        int threadCount = Math.min((size + batchSize - 1) / batchSize, 10);
        if (threadCount == 0) threadCount = 1;
        
        ExecutorService executorService = Executors.newFixedThreadPool(threadCount);
        List<Future<Integer>> futures = new ArrayList<>();

        try {
            for (int i = 0; i < size; i += batchSize) {
                int end = Math.min(i + batchSize, size);
                List<Contract> subList = list.subList(i, end);
                futures.add(executorService.submit(() -> contractMapper.addContracts(subList)));
            }

            int totalAffected = 0;
            for (Future<Integer> future : futures) {
                totalAffected += future.get();
            }
            return totalAffected;
        } catch (Exception e) {
            logger.error("批量导入合同失败", e);
            throw new RuntimeException("批量导入合同失败: " + e.getMessage());
        } finally {
            executorService.shutdown();
        }
    }
}
