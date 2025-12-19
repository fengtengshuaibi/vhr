package org.javaboy.vhr.utils;

import org.apache.poi.hpsf.DocumentSummaryInformation;
import org.apache.poi.hpsf.SummaryInformation;
import org.apache.poi.hssf.usermodel.*;
import org.apache.poi.ss.usermodel.*;
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
 * @作者 小腾
 * @GitHub https://github.com/fengtengshuaibi?tab=repositories * @时间 2019-11-11 23:25
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
            "姓名(必填, max 10)", "性别(必填, max 4)", "部门(必填, 系统值)", "职位(必填, 系统值)", 
            "年龄(数字)", "出生日期(yyyy-MM-dd)", "民族(必填, 系统值)", "身份证号(必填, max 18)", 
            "身份证开始日期", "身份证终止日期", "入职日期(必填)", "试用期(月)", 
            "转正日期", "转正评分", "司龄(月,数字 max 4)", "工作地点(max 255)",
            "政治面貌(必填, 系统值)", "户口类别(max 32)", "户口所在地(max 255)", "现居住地址(max 64)", 
            "电子邮箱(max 50)", "联系方式(max 11)", "紧急联系人(max 32)", "紧急联系电话(max 32)", 
            "婚姻状况(已婚/未婚/离异)", "生育状况(max 32)", "子女信息(max 255)", "学历(本科/大专/硕士/博士/高中/初中/小学/其他)", 
            "毕业时间", "毕业院校(max 32)", "专业(max 32)", "职称/资格证书(max 255)", 
            "培训经历", "原工作单位(max 255)", "原职务(max 255)", "入职/离职时间(max 64)", 
            "过往工作业绩", "原单位离职原因(max 255)", "证明人(max 32)", "证明人电话(max 32)", 
            "入职前测评结果(max 255)", "工作状态(在职/离职)", "奖惩记录", "离职日期", "离职原因(max 255)"
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
            row.createCell(1).setCellValue(emp.getGender());
            row.createCell(2).setCellValue(emp.getDepartment().getName());
            row.createCell(3).setCellValue(emp.getPosition().getName());
            if(emp.getAge() != null) row.createCell(4).setCellValue(emp.getAge());
            
            HSSFCell cell5 = row.createCell(5);
            cell5.setCellStyle(dateCellStyle);
            cell5.setCellValue(emp.getBirthday());
            
            row.createCell(6).setCellValue(emp.getNation().getName());
            row.createCell(7).setCellValue(emp.getIdCard());
            
            HSSFCell cell8 = row.createCell(8); cell8.setCellStyle(dateCellStyle); cell8.setCellValue(emp.getIdCardStartDate());
            HSSFCell cell9 = row.createCell(9); cell9.setCellStyle(dateCellStyle); cell9.setCellValue(emp.getIdCardEndDate());
            HSSFCell cell10 = row.createCell(10); cell10.setCellStyle(dateCellStyle); cell10.setCellValue(emp.getBeginDate());
            
            if(emp.getProbation() != null) row.createCell(11).setCellValue(emp.getProbation());
            
            HSSFCell cell12 = row.createCell(12); cell12.setCellStyle(dateCellStyle); cell12.setCellValue(emp.getConversionTime());
            if(emp.getConversionScore() != null) row.createCell(13).setCellValue(emp.getConversionScore());
            if(emp.getWorkAge() != null) row.createCell(14).setCellValue(emp.getWorkAge());
            row.createCell(15).setCellValue(emp.getWorkLocation());
            row.createCell(16).setCellValue(emp.getPoliticsstatus().getName());
            row.createCell(17).setCellValue(emp.getHukouType());
            row.createCell(18).setCellValue(emp.getHukouLocation());
            row.createCell(19).setCellValue(emp.getAddress());
            row.createCell(20).setCellValue(emp.getEmail());
            row.createCell(21).setCellValue(emp.getPhone());
            row.createCell(22).setCellValue(emp.getEmergencyContact());
            row.createCell(23).setCellValue(emp.getEmergencyContactPhone());
            row.createCell(24).setCellValue(emp.getWedlock());
            row.createCell(25).setCellValue(emp.getFertilityStatus());
            row.createCell(26).setCellValue(emp.getChildrenInfo());
            row.createCell(27).setCellValue(emp.getTiptopDegree());
            
            HSSFCell cell28 = row.createCell(28); cell28.setCellStyle(dateCellStyle); cell28.setCellValue(emp.getGraduationDate());
            
            row.createCell(29).setCellValue(emp.getSchool());
            row.createCell(30).setCellValue(emp.getSpecialty());
            row.createCell(31).setCellValue(emp.getCertificate());
            row.createCell(32).setCellValue(emp.getTrainingHistory());
            row.createCell(33).setCellValue(emp.getPreviousCompany());
            row.createCell(34).setCellValue(emp.getPreviousPosition());
            row.createCell(35).setCellValue(emp.getPreviousStartEnd());
            row.createCell(36).setCellValue(emp.getPastPerformance());
            row.createCell(37).setCellValue(emp.getPreviousResignationReason());
            row.createCell(38).setCellValue(emp.getReference());
            row.createCell(39).setCellValue(emp.getReferencePhone());
            row.createCell(40).setCellValue(emp.getAssessmentResult());
            row.createCell(41).setCellValue(emp.getWorkState());
            row.createCell(42).setCellValue(emp.getRewardsPunishments());
            
            HSSFCell cell43 = row.createCell(43); cell43.setCellStyle(dateCellStyle); cell43.setCellValue(emp.getNotWorkDate());
            
            row.createCell(44).setCellValue(emp.getResignationReason());
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
            Workbook workbook = WorkbookFactory.create(file.getInputStream());
            //2. 获取 workbook 中表单的数量
            int numberOfSheets = workbook.getNumberOfSheets();
            for (int i = 0; i < numberOfSheets; i++) {
                //3. 获取表单
                Sheet sheet = workbook.getSheetAt(i);
                //4. 获取表单中的行数
                int physicalNumberOfRows = sheet.getPhysicalNumberOfRows();
                for (int j = 0; j < physicalNumberOfRows; j++) {
                    //5. 跳过标题行
                    if (j == 0) {
                        continue;//跳过标题行
                    }
                    //6. 获取行
                    Row row = sheet.getRow(j);
                    if (row == null) {
                        continue;//防止数据中间有空行
                    }
                    //7. 获取列数
                    int physicalNumberOfCells = row.getPhysicalNumberOfCells();
                    employee = new Employee();
                    boolean hasError = false;
                    StringBuilder errorMsg = new StringBuilder("第 " + (j + 1) + " 行: ");
                    
                    for (int k = 0; k < physicalNumberOfCells; k++) {
                        Cell cell = row.getCell(k);
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
                                            if (cellValue.length() > 4) throw new IllegalArgumentException("性别超长(4)");
                                            employee.setGender(cellValue); 
                                            break;
                                        case 2:
                                            int departmentIndex = allDepartments.indexOf(new Department(cellValue));
                                            if (departmentIndex == -1) throw new IllegalArgumentException("部门不存在");
                                            employee.setDepartmentId(allDepartments.get(departmentIndex).getId());
                                            break;
                                        case 3:
                                            int positionIndex = allPositions.indexOf(new Position(cellValue));
                                            if (positionIndex == -1) throw new IllegalArgumentException("职位不存在");
                                            employee.setPosId(allPositions.get(positionIndex).getId());
                                            break;
                                        case 6:
                                            int nationIndex = allNations.indexOf(new Nation(cellValue));
                                            if (nationIndex == -1) throw new IllegalArgumentException("民族不存在");
                                            employee.setNationId(allNations.get(nationIndex).getId());
                                            break;
                                        case 7:
                                            if (cellValue.length() > 18) throw new IllegalArgumentException("身份证超长(18)");
                                            employee.setIdCard(cellValue); 
                                            break;
                                        case 15:
                                            if (cellValue.length() > 255) throw new IllegalArgumentException("工作地点超长(255)");
                                            employee.setWorkLocation(cellValue); 
                                            break;
                                        case 16:
                                            int politicstatusIndex = allPoliticsstatus.indexOf(new Politicsstatus(cellValue));
                                            if (politicstatusIndex == -1) throw new IllegalArgumentException("政治面貌不存在");
                                            employee.setPoliticId(allPoliticsstatus.get(politicstatusIndex).getId());
                                            break;
                                        case 17: if (cellValue.length() > 32) throw new IllegalArgumentException("户口类型超长(32)"); employee.setHukouType(cellValue); break;
                                        case 18: if (cellValue.length() > 255) throw new IllegalArgumentException("户口所在地超长(255)"); employee.setHukouLocation(cellValue); break;
                                        case 19:
                                            if (cellValue.length() > 64) throw new IllegalArgumentException("地址超长(64)");
                                            employee.setAddress(cellValue); 
                                            break;
                                        case 20:
                                            if (cellValue.length() > 50) throw new IllegalArgumentException("邮箱超长(50)");
                                            employee.setEmail(cellValue); 
                                            break;
                                        case 21:
                                            if (cellValue.length() > 11) throw new IllegalArgumentException("电话超长(11)");
                                            employee.setPhone(cellValue); 
                                            break;
                                        case 22: if (cellValue.length() > 32) throw new IllegalArgumentException("紧急联系人超长(32)"); employee.setEmergencyContact(cellValue); break;
                                        case 23: if (cellValue.length() > 32) throw new IllegalArgumentException("紧急电话超长(32)"); employee.setEmergencyContactPhone(cellValue); break;
                                        case 24: employee.setWedlock(cellValue); break;
                                        case 25: if (cellValue.length() > 32) throw new IllegalArgumentException("生育状况超长(32)"); employee.setFertilityStatus(cellValue); break;
                                        case 26: if (cellValue.length() > 255) throw new IllegalArgumentException("子女信息超长(255)"); employee.setChildrenInfo(cellValue); break;
                                        case 27: employee.setTiptopDegree(cellValue); break;
                                        case 29:
                                            if (cellValue.length() > 32) throw new IllegalArgumentException("学校超长(32)");
                                            employee.setSchool(cellValue); 
                                            break;
                                        case 30:
                                            if (cellValue.length() > 32) throw new IllegalArgumentException("专业超长(32)");
                                            employee.setSpecialty(cellValue); 
                                            break;
                                        case 31: if (cellValue.length() > 255) throw new IllegalArgumentException("证书超长(255)"); employee.setCertificate(cellValue); break;
                                        case 32: employee.setTrainingHistory(cellValue); break;
                                        case 33: if (cellValue.length() > 255) throw new IllegalArgumentException("原单位超长(255)"); employee.setPreviousCompany(cellValue); break;
                                        case 34: if (cellValue.length() > 255) throw new IllegalArgumentException("原职位超长(255)"); employee.setPreviousPosition(cellValue); break;
                                        case 35: if (cellValue.length() > 64) throw new IllegalArgumentException("原起止超长(64)"); employee.setPreviousStartEnd(cellValue); break;
                                        case 36: employee.setPastPerformance(cellValue); break;
                                        case 37: if (cellValue.length() > 255) throw new IllegalArgumentException("原离职原因超长(255)"); employee.setPreviousResignationReason(cellValue); break;
                                        case 38: if (cellValue.length() > 32) throw new IllegalArgumentException("证明人超长(32)"); employee.setReference(cellValue); break;
                                        case 39: if (cellValue.length() > 32) throw new IllegalArgumentException("证明人电话超长(32)"); employee.setReferencePhone(cellValue); break;
                                        case 40: if (cellValue.length() > 255) throw new IllegalArgumentException("测评结果超长(255)"); employee.setAssessmentResult(cellValue); break;
                                        case 41: employee.setWorkState(cellValue); break;
                                        case 42: employee.setRewardsPunishments(cellValue); break;
                                        case 44: if (cellValue.length() > 255) throw new IllegalArgumentException("离职原因超长(255)"); employee.setResignationReason(cellValue); break;
                                    }
                                    break;
                                case NUMERIC:
                                    if (DateUtil.isCellDateFormatted(cell)) {
                                        // Date fields
                                        switch (k) {
                                            case 5: employee.setBirthday(cell.getDateCellValue()); break;
                                            case 8: employee.setIdCardStartDate(cell.getDateCellValue()); break;
                                            case 9: employee.setIdCardEndDate(cell.getDateCellValue()); break;
                                            case 10: employee.setBeginDate(cell.getDateCellValue()); break;
                                            case 12: employee.setConversionTime(cell.getDateCellValue()); break;
                                            case 28: employee.setGraduationDate(cell.getDateCellValue()); break;
                                            case 43: employee.setNotWorkDate(cell.getDateCellValue()); break;
                                        }
                                    } else {
                                        // Numeric fields
                                        switch (k) {
                                            case 4: employee.setAge((int)cell.getNumericCellValue()); break;
                                            case 11: employee.setProbation((int)cell.getNumericCellValue()); break;
                                            case 13: employee.setConversionScore((int)cell.getNumericCellValue()); break;
                                            case 14: employee.setWorkAge(cell.getNumericCellValue()); break;
                                            case 21: employee.setPhone(new java.text.DecimalFormat("#").format(cell.getNumericCellValue())); break;
                                            case 23: employee.setEmergencyContactPhone(new java.text.DecimalFormat("#").format(cell.getNumericCellValue())); break;
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
                    if (employee.getBirthday() == null && employee.getIdCard() != null && employee.getIdCard().length() == 18) {
                        try {
                            String birthdayStr = employee.getIdCard().substring(6, 14);
                            java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyyMMdd");
                            employee.setBirthday(sdf.parse(birthdayStr));
                        } catch (Exception e) {
                            // ignore
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

    /**
     * 合同数据导出
     */
    public static ResponseEntity<byte[]> contract2Excel(List<Contract> list) {
        HSSFWorkbook workbook = new HSSFWorkbook();
        workbook.createInformationProperties();
        DocumentSummaryInformation docInfo = workbook.getDocumentSummaryInformation();
        docInfo.setCategory("合同信息");
        docInfo.setManager("javaboy");
        docInfo.setCompany("www.javaboy.org");
        SummaryInformation summInfo = workbook.getSummaryInformation();
        summInfo.setTitle("合同信息表");
        summInfo.setAuthor("javaboy");
        summInfo.setComments("本文档由 javaboy 提供");
        HSSFCellStyle headerStyle = workbook.createCellStyle();
        headerStyle.setFillForegroundColor(IndexedColors.YELLOW.index);
        headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        HSSFCellStyle dateCellStyle = workbook.createCellStyle();
        dateCellStyle.setDataFormat(HSSFDataFormat.getBuiltinFormat("m/d/yy"));
        HSSFSheet sheet = workbook.createSheet("合同信息表");
        for (int i = 0; i < 15; i++) {
            sheet.setColumnWidth(i, 15 * 256);
        }
        
        HSSFRow r0 = sheet.createRow(0);
        String[] headers = {
            "姓名(必填)", 
            "身份证号(必填, 长度18位)", 
            "用工形式(必填, 选填: 全日制/非全日制)", 
            "合同类型(必填, 选填: 固定期限/无固定期限)", 
            "首次签订日期(选填, 格式: 2022-01-01)", 
            "首次签订期限(选填, 单位: 年, 数字)", 
            "第二次签订日期(选填, 格式: 2022-01-01)", 
            "第二次签订期限(选填, 单位: 年, 数字)", 
            "第三次签订日期(选填, 格式: 2022-01-01)", 
            "签订次数(选填, 数字: 1/2/3)", 
            "劳动合同截止日期(选填, 格式: 2022-01-01)"
        };
        
        for (int i = 0; i < headers.length; i++) {
            HSSFCell cell = r0.createCell(i);
            cell.setCellStyle(headerStyle);
            cell.setCellValue(headers[i]);
        }

        for (int i = 0; i < list.size(); i++) {
            Contract c = list.get(i);
            HSSFRow row = sheet.createRow(i + 1);
            row.createCell(0).setCellValue(c.getName());
            row.createCell(1).setCellValue(c.getIdCard());
            row.createCell(2).setCellValue(c.getEmploymentType());
            row.createCell(3).setCellValue(c.getContractType());
            
            HSSFCell cell4 = row.createCell(4); cell4.setCellStyle(dateCellStyle); cell4.setCellValue(c.getFirstSignDate());
            if(c.getFirstSignTerm() != null) row.createCell(5).setCellValue(c.getFirstSignTerm());
            
            HSSFCell cell6 = row.createCell(6); cell6.setCellStyle(dateCellStyle); cell6.setCellValue(c.getSecondSignDate());
            if(c.getSecondSignTerm() != null) row.createCell(7).setCellValue(c.getSecondSignTerm());
            
            HSSFCell cell8 = row.createCell(8); cell8.setCellStyle(dateCellStyle); cell8.setCellValue(c.getThirdSignDate());
            if(c.getSignCount() != null) row.createCell(9).setCellValue(c.getSignCount());
            
            HSSFCell cell10 = row.createCell(10); cell10.setCellStyle(dateCellStyle); cell10.setCellValue(c.getEndDate());
        }

        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        HttpHeaders headers2 = new HttpHeaders();
        try {
            headers2.setContentDispositionFormData("attachment", new String("合同表.xls".getBytes("UTF-8"), "ISO-8859-1"));
            headers2.setContentType(MediaType.APPLICATION_OCTET_STREAM);
            workbook.write(baos);
        } catch (IOException e) {
            e.printStackTrace();
        }
        return new ResponseEntity<byte[]>(baos.toByteArray(), headers2, HttpStatus.CREATED);
    }

    /**
     * Excel 解析成 合同数据集合
     */
    public static Map<String, Object> excel2Contract(MultipartFile file) {
        Map<String, Object> resultMap = new HashMap<>();
        List<Contract> list = new ArrayList<>();
        List<String> errors = new ArrayList<>();
        
        Contract contract = null;
        try {
            Workbook workbook = WorkbookFactory.create(file.getInputStream());
            int numberOfSheets = workbook.getNumberOfSheets();
            for (int i = 0; i < numberOfSheets; i++) {
                Sheet sheet = workbook.getSheetAt(i);
                int physicalNumberOfRows = sheet.getPhysicalNumberOfRows();
                for (int j = 0; j < physicalNumberOfRows; j++) {
                    if (j == 0) continue; //跳过标题行
                    Row row = sheet.getRow(j);
                    if (row == null) continue;
                    
                    int physicalNumberOfCells = row.getPhysicalNumberOfCells();
                    contract = new Contract();
                    boolean hasError = false;
                    StringBuilder errorMsg = new StringBuilder("第 " + (j + 1) + " 行: ");
                    
                    for (int k = 0; k < physicalNumberOfCells; k++) {
                        Cell cell = row.getCell(k);
                        if (cell == null) continue;
                        
                        try {
                            switch (cell.getCellType()) {
                                case STRING:
                                    String cellValue = cell.getStringCellValue();
                                    switch (k) {
                                        case 0: contract.setName(cellValue); break;
                                        case 1: 
                                            if (cellValue.length() > 18) throw new IllegalArgumentException("身份证超长");
                                            contract.setIdCard(cellValue); 
                                            break;
                                        case 2: contract.setEmploymentType(cellValue); break;
                                        case 3: contract.setContractType(cellValue); break;
                                    }
                                    break;
                                case NUMERIC:
                                    if (DateUtil.isCellDateFormatted(cell)) {
                                        switch (k) {
                                            case 4: contract.setFirstSignDate(cell.getDateCellValue()); break;
                                            case 6: contract.setSecondSignDate(cell.getDateCellValue()); break;
                                            case 8: contract.setThirdSignDate(cell.getDateCellValue()); break;
                                            case 10: contract.setEndDate(cell.getDateCellValue()); break;
                                        }
                                    } else {
                                        switch (k) {
                                            case 2: contract.setEmploymentType(new java.text.DecimalFormat("#").format(cell.getNumericCellValue())); break;
                                            case 3: contract.setContractType(new java.text.DecimalFormat("#").format(cell.getNumericCellValue())); break;
                                            case 5: contract.setFirstSignTerm(cell.getNumericCellValue()); break;
                                            case 7: contract.setSecondSignTerm(cell.getNumericCellValue()); break;
                                            case 9: contract.setSignCount((int)cell.getNumericCellValue()); break;
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
                    } else if (contract.getIdCard() == null || contract.getIdCard().isEmpty()) {
                        errors.add("第 " + (j + 1) + " 行: 身份证号为空");
                    } else {
                        list.add(contract);
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
