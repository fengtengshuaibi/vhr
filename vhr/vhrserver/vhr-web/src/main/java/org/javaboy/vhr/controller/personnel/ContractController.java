package org.javaboy.vhr.controller.personnel;

import org.javaboy.vhr.model.Contract;
import org.javaboy.vhr.model.RespBean;
import org.javaboy.vhr.model.RespPageBean;
import org.javaboy.vhr.service.ContractService;
import org.javaboy.vhr.utils.POIUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/personnel/contract")
public class ContractController {
    @Value("${contract.upload.path}")
    String uploadPath;

    @Autowired
    ContractService contractService;

    @GetMapping("/")
    public RespPageBean getContractsByPage(@RequestParam(defaultValue = "1") Integer page, 
                                           @RequestParam(defaultValue = "10") Integer size, 
                                           Contract contract, 
                                           Integer daysToExpiry) {
        return contractService.getContractsByPage(page, size, contract, daysToExpiry);
    }

    @PostMapping("/")
    public RespBean addContract(@RequestBody Contract contract) {
        if (contractService.addContract(contract) == 1) {
            return RespBean.ok("添加成功!");
        }
        return RespBean.error("添加失败!");
    }

    @DeleteMapping("/{idCard}")
    public RespBean deleteContract(@PathVariable String idCard) {
        if (contractService.deleteContractById(idCard) == 1) {
            return RespBean.ok("删除成功!");
        }
        return RespBean.error("删除失败!");
    }

    @PutMapping("/")
    public RespBean updateContract(@RequestBody Contract contract) {
        if (contractService.updateContract(contract) == 1) {
            return RespBean.ok("更新成功!");
        }
        return RespBean.error("更新失败!");
    }

    @GetMapping("/export")
    public ResponseEntity<byte[]> exportData() {
        List<Contract> list = (List<Contract>) contractService.getContractsByPage(null, null, new Contract(), null).getData();
        return POIUtils.contract2Excel(list);
    }

    @GetMapping("/import/template")
    public ResponseEntity<byte[]> importTemplate() {
        return POIUtils.contract2Excel(new ArrayList<>());
    }

    @PostMapping("/import")
    public RespBean importData(MultipartFile file) {
        Map<String, Object> map = POIUtils.excel2Contract(file);
        List<Contract> list = (List<Contract>) map.get("list");
        List<String> errors = (List<String>) map.get("errors");
        
        if (list != null && list.size() > 0) {
            contractService.addContracts(list);
        }
        
        if (errors != null && !errors.isEmpty()) {
            return RespBean.ok("部分数据存在问题", errors);
        }
        return RespBean.ok("上传成功");
    }

    @PostMapping("/upload")
    public RespBean upload(@RequestParam("file") MultipartFile file) {
        if (file.isEmpty()) {
            return RespBean.error("文件为空");
        }
        String fileName = file.getOriginalFilename();
        File dest = new File(uploadPath + fileName);
        if (!dest.getParentFile().exists()) {
            dest.getParentFile().mkdirs();
        }
        try {
            file.transferTo(dest);
            return RespBean.ok("上传成功", fileName);
        } catch (IOException e) {
            e.printStackTrace();
            return RespBean.error("上传失败");
        }
    }

    @GetMapping("/download/{fileName:.+}")
    public ResponseEntity<byte[]> download(@PathVariable String fileName) {
        File file = new File(uploadPath + fileName);
        if (!file.exists()) {
            return null;
        }
        try {
            HttpHeaders headers = new HttpHeaders();
            headers.setContentDispositionFormData("attachment", new String(fileName.getBytes("UTF-8"), "ISO-8859-1"));
            headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
            return new ResponseEntity<byte[]>(org.apache.commons.io.FileUtils.readFileToByteArray(file), headers, HttpStatus.CREATED);
        } catch (IOException e) {
            e.printStackTrace();
        }
        return null;
    }
}
