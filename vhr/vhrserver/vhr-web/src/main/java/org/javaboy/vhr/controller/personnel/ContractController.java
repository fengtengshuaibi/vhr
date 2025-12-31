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

import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.*;

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
    public RespBean upload(@RequestParam("file") MultipartFile file, HttpServletRequest request) {
        if (file.getSize() > 10 * 1024 * 1024) {
             return RespBean.error("文件大小不能超过10MB!");
        }
        String fileName = file.getOriginalFilename();
        // Use original filename, overwrite if exists. 
        // To avoid conflicts between different users/records, we might still want a unique folder or something.
        // But user requirement says "overwrite server file if duplicate name".
        // Let's stick to a date-based folder structure to keep some organization, but within that day folder, duplicates overwrite.
        // Or should we put everything in one big folder? 
        // "overwrite server file if duplicate name" implies if I upload "a.txt" today and "a.txt" tomorrow, they might be different files.
        // If I use date folders, "20231231/a.txt" and "20240101/a.txt" are different.
        // If the requirement means "globally unique filename", that's dangerous.
        // Assuming "overwrite if same name in the same upload context".
        // But here we are just receiving a file.
        // Let's use a date-based folder. If user uploads "a.txt" twice today, the second one overwrites the first one.
        
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
        String format = sdf.format(new Date());
        File saveFile = new File(uploadPath + format);
        if (!saveFile.exists()) {
            saveFile.mkdirs();
        }
        try {
            // Use original filename
            file.transferTo(new File(saveFile, fileName));
            String url = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + "/personnel/contract/download/" + format + "/" + fileName;
            // Return JSON object with name and url
            return RespBean.ok("上传成功", "{\"name\":\"" + fileName + "\",\"url\":\"" + url + "\"}");
        } catch (IOException e) {
            e.printStackTrace();
            return RespBean.error("上传失败: " + e.getMessage());
        }
    }

    @DeleteMapping("/file")
    public RespBean deleteFile(@RequestParam String fileName, @RequestParam String date) {
        if (fileName == null || date == null) {
            return RespBean.error("参数错误!");
        }
        File file = new File(uploadPath + date + "/" + fileName);
        if (file.exists()) {
            if (file.delete()) {
                return RespBean.ok("删除成功!");
            } else {
                return RespBean.error("删除失败!");
            }
        }
        return RespBean.error("文件不存在!");
    }

    @GetMapping("/download/{date}/{fileName:.+}")
    public ResponseEntity<byte[]> download(@PathVariable String date, @PathVariable String fileName) {
        File file = new File(uploadPath + date + "/" + fileName);
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
