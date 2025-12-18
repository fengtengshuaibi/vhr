package org.javaboy.vhr.utils;

import org.apache.poi.hpsf.DocumentSummaryInformation;
import org.apache.poi.hpsf.SummaryInformation;
import org.apache.poi.hssf.usermodel.*;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.javaboy.vhr.model.*;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.multipart.MultipartFile;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @作者 江南一点雨
 * @公众号 江南一点雨
 * @微信号 a_java_boy
 * @GitHub https://github.com/lenve
 * @博客 http://wangsong.blog.csdn.net
 * @网站 http://www.javaboy.org
 * @时间 2019-11-11 23:25
 */
public class POIUtils {

    public static ResponseEntity<byte[]> employee2Excel(List<Employee> list) {
        //1. 创建一个 Excel 文档
        HSSFWorkbook workbook = new HSSFWorkbook();
        //2. 创建文档摘要
        workbook.createInformationProperties();
        //3. 获取并配置文档信息
        DocumentSummaryInformation docInfo = workbook.getDocumentSummaryInformation();
        //文档类别
        docInfo.setCategory("员工信息");
        //文档管理员
        docInfo.setManager("javaboy");
        //设置公司信息
        docInfo.setCompany("www.javaboy.org");
        //4. 获取文档摘要信息
        SummaryInformation summInfo = workbook.getSummaryInformation();
        //文档标题
        summInfo.setTitle("员工信息表");
        //文档作者
        summInfo.setAuthor("javaboy");
        // 文档备注
        summInfo.setComments("本文档由 javaboy 提供");
        //5. 创建样式
        //创建标题行的样式
        HSSFCellStyle headerStyle = workbook.createCellStyle();
        headerStyle.setFillForegroundColor(IndexedColors.YELLOW.index);
        headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        HSSFCellStyle dateCellStyle = workbook.createCellStyle();
        dateCellStyle.setDataFormat(HSSFDataFormat.getBuiltinFormat("m/d/yy"));
        HSSFSheet sheet = workbook.createSheet("员工信息表");
        //设置列的宽度
        for (int i = 0; i < 50; i++) {
            sheet.setColumnWidth(i, 15 * 256);
        }
        
        //6. 创建标题行
        HSSFRow r0 = sheet.createRow(0);
        String[] headers = {
            "姓名", "工号", "性别", "出生日期", "身份证号码", "婚姻状况", "民族", "籍贯", "政治面貌", 
            "电话号码", "联系地址", "所属部门", "职称", "职位", "聘用形式", "最高学历", "专业", "毕业院校", "入职日期", 
            "在职状态", "邮箱", "合同期限(年)", "合同起始日期", "合同终止日期", "转正日期",
            "年龄", "身份证开始日期", "身份证终止日期", "户口类别", "户口所在地", "紧急联系人", "紧急联系电话", 
            "生育状况", "子女信息", "毕业时间", "专业资格证书", "培训经历", "原工作单位", "原职位", 
            "原入职/离职时间", "过往工作业绩", "原离职原因", "证明人", "证明人联系方式", "入职前测评结果", 
            "试用期", "转正评分", "工作地点", "奖惩记录", "离职原因"
        };
        
        for (int i = 0; i < headers.length; i++) {
            HSSFCell cell = r0.createCell(i);
            cell.setCellStyle(headerStyle);
            cell.setCellValue(headers[i]);
        }

        for (int i = 0; i < list.size(); i++) {
            Employee emp = list.get(i);
            HSSFRow row = sheet.createRow(i + 1);
            row.createCell(0).setCellValue(emp.getName());
            row.createCell(1).setCellValue(emp.getWorkID());
            row.createCell(2).setCellValue(emp.getGender());
            HSSFCell cell3 = row.createCell(3);
            cell3.setCellStyle(dateCellStyle);
            cell3.setCellValue(emp.getBirthday());
            row.createCell(4).setCellValue(emp.getIdCard());
            row.createCell(5).setCellValue(emp.getWedlock());
            row.createCell(6).setCellValue(emp.getNation().getName());
            row.createCell(7).setCellValue(emp.getNativePlace());
            row.createCell(8).setCellValue(emp.getPoliticsstatus().getName());
            row.createCell(9).setCellValue(emp.getPhone());
            row.createCell(10).setCellValue(emp.getAddress());
            row.createCell(11).setCellValue(emp.getDepartment().getName());
            row.createCell(12).setCellValue(emp.getJobLevel().getName());
            row.createCell(13).setCellValue(emp.getPosition().getName());
            row.createCell(14).setCellValue(emp.getEngageForm());
            row.createCell(15).setCellValue(emp.getTiptopDegree());
            row.createCell(16).setCellValue(emp.getSpecialty());
            row.createCell(17).setCellValue(emp.getSchool());
            HSSFCell cell18 = row.createCell(18);
            cell18.setCellStyle(dateCellStyle);
            cell18.setCellValue(emp.getBeginDate());
            row.createCell(19).setCellValue(emp.getWorkState());
            row.createCell(20).setCellValue(emp.getEmail());
            row.createCell(21).setCellValue(emp.getContractTerm());
            HSSFCell cell22 = row.createCell(22);
            cell22.setCellStyle(dateCellStyle);
            cell22.setCellValue(emp.getBeginContract());
            HSSFCell cell23 = row.createCell(23);
            cell23.setCellStyle(dateCellStyle);
            cell23.setCellValue(emp.getEndContract());
            HSSFCell cell24 = row.createCell(24);
            cell24.setCellStyle(dateCellStyle);
            cell24.setCellValue(emp.getConversionTime());
            
            // New fields
            if(emp.getAge() != null) row.createCell(25).setCellValue(emp.getAge());
            HSSFCell cell26 = row.createCell(26); cell26.setCellStyle(dateCellStyle); cell26.setCellValue(emp.getIdCardStartDate());
            HSSFCell cell27 = row.createCell(27); cell27.setCellStyle(dateCellStyle); cell27.setCellValue(emp.getIdCardEndDate());
            row.createCell(28).setCellValue(emp.getHukouType());
            row.createCell(29).setCellValue(emp.getHukouLocation());
            row.createCell(30).setCellValue(emp.getEmergencyContact());
            row.createCell(31).setCellValue(emp.getEmergencyContactPhone());
            row.createCell(32).setCellValue(emp.getFertilityStatus());
            row.createCell(33).setCellValue(emp.getChildrenInfo());
            HSSFCell cell34 = row.createCell(34); cell34.setCellStyle(dateCellStyle); cell34.setCellValue(emp.getGraduationDate());
            row.createCell(35).setCellValue(emp.getCertificate());
            row.createCell(36).setCellValue(emp.getTrainingHistory());
            row.createCell(37).setCellValue(emp.getPreviousCompany());
            row.createCell(38).setCellValue(emp.getPreviousPosition());
            row.createCell(39).setCellValue(emp.getPreviousStartEnd());
            row.createCell(40).setCellValue(emp.getPastPerformance());
            row.createCell(41).setCellValue(emp.getPreviousResignationReason());
            row.createCell(42).setCellValue(emp.getReference());
            row.createCell(43).setCellValue(emp.getReferencePhone());
            row.createCell(44).setCellValue(emp.getAssessmentResult());
            if(emp.getProbation() != null) row.createCell(45).setCellValue(emp.getProbation());
            if(emp.getConversionScore() != null) row.createCell(46).setCellValue(emp.getConversionScore());
            row.createCell(47).setCellValue(emp.getWorkLocation());
            row.createCell(48).setCellValue(emp.getRewardsPunishments());
            row.createCell(49).setCellValue(emp.getResignationReason());
        }

        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        HttpHeaders headers2 = new HttpHeaders();
        try {
            headers2.setContentDispositionFormData("attachment", new String("员工表.xls".getBytes("UTF-8"), "ISO-8859-1"));
            headers2.setContentType(MediaType.APPLICATION_OCTET_STREAM);
            workbook.write(baos);
        } catch (IOException e) {
            e.printStackTrace();
        }
        return new ResponseEntity<byte[]>(baos.toByteArray(), headers2, HttpStatus.CREATED);
    }

    /**
     * Excel 解析成 员工数据集合
     *
     * @param file
     * @param allNations
     * @param allPoliticsstatus
     * @param allDepartments
     * @param allPositions
     * @param allJobLevels
     * @return
     */
    public static Map<String, Object> excel2Employee(MultipartFile file, List<Nation> allNations, List<Politicsstatus> allPoliticsstatus, List<Department> allDepartments, List<Position> allPositions, List<JobLevel> allJobLevels) {
        Map<String, Object> resultMap = new HashMap<>();
        List<Employee> list = new ArrayList<>();
        List<String> errors = new ArrayList<>();
        
        Employee employee = null;
        try {
            //1. 创建一个 workbook 对象
            HSSFWorkbook workbook = new HSSFWorkbook(file.getInputStream());
            //2. 获取 workbook 中表单的数量
            int numberOfSheets = workbook.getNumberOfSheets();
            for (int i = 0; i < numberOfSheets; i++) {
                //3. 获取表单
                HSSFSheet sheet = workbook.getSheetAt(i);
                //4. 获取表单中的行数
                int physicalNumberOfRows = sheet.getPhysicalNumberOfRows();
                for (int j = 0; j < physicalNumberOfRows; j++) {
                    //5. 跳过标题行
                    if (j == 0) {
                        continue;//跳过标题行
                    }
                    //6. 获取行
                    HSSFRow row = sheet.getRow(j);
                    if (row == null) {
                        continue;//防止数据中间有空行
                    }
                    //7. 获取列数
                    int physicalNumberOfCells = row.getPhysicalNumberOfCells();
                    employee = new Employee();
                    boolean hasError = false;
                    StringBuilder errorMsg = new StringBuilder("第 " + (j + 1) + " 行: ");
                    
                    for (int k = 0; k < physicalNumberOfCells; k++) {
                        HSSFCell cell = row.getCell(k);
                        if (cell == null) continue;
                        
                        try {
                            switch (cell.getCellType()) {
                                case STRING:
                                    String cellValue = cell.getStringCellValue();
                                    switch (k) {
                                        case 0: 
                                            if (cellValue.length() > 10) throw new IllegalArgumentException("姓名超长(10)");
                                            employee.setName(cellValue); 
                                            break;
                                        case 1: 
                                            if (cellValue.length() > 8) throw new IllegalArgumentException("工号超长(8)");
                                            employee.setWorkID(cellValue); 
                                            break;
                                        case 2: 
                                            if (cellValue.length() > 4) throw new IllegalArgumentException("性别超长(4)");
                                            employee.setGender(cellValue); 
                                            break;
                                        case 4:
                                            if (cellValue.length() > 18) throw new IllegalArgumentException("身份证超长(18)");
                                            employee.setIdCard(cellValue); 
                                            break;
                                        case 5: employee.setWedlock(cellValue); break;
                                        case 6:
                                            int nationIndex = allNations.indexOf(new Nation(cellValue));
                                            if (nationIndex == -1) throw new IllegalArgumentException("民族不存在");
                                            employee.setNationId(allNations.get(nationIndex).getId());
                                            break;
                                        case 7:
                                            if (cellValue.length() > 100) throw new IllegalArgumentException("籍贯超长(100)");
                                            employee.setNativePlace(cellValue); 
                                            break;
                                        case 8:
                                            int politicstatusIndex = allPoliticsstatus.indexOf(new Politicsstatus(cellValue));
                                            if (politicstatusIndex == -1) throw new IllegalArgumentException("政治面貌不存在");
                                            employee.setPoliticId(allPoliticsstatus.get(politicstatusIndex).getId());
                                            break;
                                        case 9:
                                            if (cellValue.length() > 11) throw new IllegalArgumentException("电话超长(11)");
                                            employee.setPhone(cellValue); 
                                            break;
                                        case 10:
                                            if (cellValue.length() > 64) throw new IllegalArgumentException("地址超长(64)");
                                            employee.setAddress(cellValue); 
                                            break;
                                        case 11:
                                            int departmentIndex = allDepartments.indexOf(new Department(cellValue));
                                            if (departmentIndex == -1) throw new IllegalArgumentException("部门不存在");
                                            employee.setDepartmentId(allDepartments.get(departmentIndex).getId());
                                            break;
                                        case 12:
                                            int jobLevelIndex = allJobLevels.indexOf(new JobLevel(cellValue));
                                            if (jobLevelIndex == -1) throw new IllegalArgumentException("职称不存在");
                                            employee.setJobLevelId(allJobLevels.get(jobLevelIndex).getId());
                                            break;
                                        case 13:
                                            int positionIndex = allPositions.indexOf(new Position(cellValue));
                                            if (positionIndex == -1) throw new IllegalArgumentException("职位不存在");
                                            employee.setPosId(allPositions.get(positionIndex).getId());
                                            break;
                                        case 14: employee.setEngageForm(cellValue); break;
                                        case 15: employee.setTiptopDegree(cellValue); break;
                                        case 16:
                                            if (cellValue.length() > 32) throw new IllegalArgumentException("专业超长(32)");
                                            employee.setSpecialty(cellValue); 
                                            break;
                                        case 17:
                                            if (cellValue.length() > 32) throw new IllegalArgumentException("学校超长(32)");
                                            employee.setSchool(cellValue); 
                                            break;
                                        case 19: employee.setWorkState(cellValue); break;
                                        case 20:
                                            if (cellValue.length() > 50) throw new IllegalArgumentException("邮箱超长(50)");
                                            employee.setEmail(cellValue); 
                                            break;
                                        
                                        // New String fields
                                        case 28: if (cellValue.length() > 32) throw new IllegalArgumentException("户口类型超长(32)"); employee.setHukouType(cellValue); break;
                                        case 29: if (cellValue.length() > 255) throw new IllegalArgumentException("户口所在地超长(255)"); employee.setHukouLocation(cellValue); break;
                                        case 30: if (cellValue.length() > 32) throw new IllegalArgumentException("紧急联系人超长(32)"); employee.setEmergencyContact(cellValue); break;
                                        case 31: if (cellValue.length() > 32) throw new IllegalArgumentException("紧急电话超长(32)"); employee.setEmergencyContactPhone(cellValue); break;
                                        case 32: if (cellValue.length() > 32) throw new IllegalArgumentException("生育状况超长(32)"); employee.setFertilityStatus(cellValue); break;
                                        case 33: if (cellValue.length() > 255) throw new IllegalArgumentException("子女信息超长(255)"); employee.setChildrenInfo(cellValue); break;
                                        case 35: if (cellValue.length() > 255) throw new IllegalArgumentException("证书超长(255)"); employee.setCertificate(cellValue); break;
                                        case 36: employee.setTrainingHistory(cellValue); break;
                                        case 37: if (cellValue.length() > 255) throw new IllegalArgumentException("原单位超长(255)"); employee.setPreviousCompany(cellValue); break;
                                        case 38: if (cellValue.length() > 255) throw new IllegalArgumentException("原职位超长(255)"); employee.setPreviousPosition(cellValue); break;
                                        case 39: if (cellValue.length() > 64) throw new IllegalArgumentException("原起止超长(64)"); employee.setPreviousStartEnd(cellValue); break;
                                        case 40: employee.setPastPerformance(cellValue); break;
                                        case 41: if (cellValue.length() > 255) throw new IllegalArgumentException("原离职原因超长(255)"); employee.setPreviousResignationReason(cellValue); break;
                                        case 42: if (cellValue.length() > 32) throw new IllegalArgumentException("证明人超长(32)"); employee.setReference(cellValue); break;
                                        case 43: if (cellValue.length() > 32) throw new IllegalArgumentException("证明人电话超长(32)"); employee.setReferencePhone(cellValue); break;
                                        case 44: if (cellValue.length() > 255) throw new IllegalArgumentException("测评结果超长(255)"); employee.setAssessmentResult(cellValue); break;
                                        case 47: if (cellValue.length() > 255) throw new IllegalArgumentException("工作地点超长(255)"); employee.setWorkLocation(cellValue); break;
                                        case 48: employee.setRewardsPunishments(cellValue); break;
                                        case 49: if (cellValue.length() > 255) throw new IllegalArgumentException("离职原因超长(255)"); employee.setResignationReason(cellValue); break;
                                    }
                                    break;
                                case NUMERIC:
                                    if (HSSFDateUtil.isCellDateFormatted(cell)) {
                                        // Date fields
                                        switch (k) {
                                            case 3: employee.setBirthday(cell.getDateCellValue()); break;
                                            case 18: employee.setBeginDate(cell.getDateCellValue()); break;
                                            case 22: employee.setBeginContract(cell.getDateCellValue()); break;
                                            case 23: employee.setEndContract(cell.getDateCellValue()); break;
                                            case 24: employee.setConversionTime(cell.getDateCellValue()); break;
                                            // New Date fields
                                            case 26: employee.setIdCardStartDate(cell.getDateCellValue()); break;
                                            case 27: employee.setIdCardEndDate(cell.getDateCellValue()); break;
                                            case 34: employee.setGraduationDate(cell.getDateCellValue()); break;
                                        }
                                    } else {
                                        // Numeric fields
                                        switch (k) {
                                            case 21: employee.setContractTerm(cell.getNumericCellValue()); break;
                                            // New Numeric fields
                                            case 25: employee.setAge((int)cell.getNumericCellValue()); break;
                                            case 45: employee.setProbation((int)cell.getNumericCellValue()); break;
                                            case 46: employee.setConversionScore((int)cell.getNumericCellValue()); break;
                                        }
                                    }
                                    break;
                                default:
                                    break;
                            }
                        } catch (Exception e) {
                            hasError = true;
                            errorMsg.append("列").append(k + 1).append("错误: ").append(e.getMessage()).append("; ");
                        }
                    }
                    if (hasError) {
                        errors.add(errorMsg.toString());
                    } else if (employee.getIdCard() == null || employee.getIdCard().isEmpty()) {
                        errors.add("第 " + (j + 1) + " 行: 身份证号为空");
                    } else {
                        list.add(employee);
                    }
                }
            }

        } catch (IOException e) {
            e.printStackTrace();
            errors.add("文件读取失败");
        }
        resultMap.put("list", list);
        resultMap.put("errors", errors);
        return resultMap;
    }
}
