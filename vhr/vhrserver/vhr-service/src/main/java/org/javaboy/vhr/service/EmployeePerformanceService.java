package org.javaboy.vhr.service;

import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.*;
import org.javaboy.vhr.mapper.EmployeePerformanceMapper;
import org.javaboy.vhr.model.EmployeePerformance;
import org.javaboy.vhr.model.RespPageBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Service
public class EmployeePerformanceService {
    @Autowired
    EmployeePerformanceMapper employeePerformanceMapper;

    public RespPageBean getEmployeePerformanceByPage(Integer page, Integer size, String empName, Integer year, Date beginDate, Date endDate) {
        if (page != null && size != null) {
            page = (page - 1) * size;
        }
        List<EmployeePerformance> data = employeePerformanceMapper.getEmployeePerformanceByPage(page, size, empName, year, beginDate, endDate);
        Long total = employeePerformanceMapper.getTotal(empName, year, beginDate, endDate);
        RespPageBean bean = new RespPageBean();
        bean.setData(data);
        bean.setTotal(total);
        return bean;
    }

    public Integer addEmployeePerformance(EmployeePerformance employeePerformance) {
        employeePerformance.setCreateDate(new Date());
        employeePerformance.setUpdateDate(new Date());
        return employeePerformanceMapper.insertSelective(employeePerformance);
    }

    public Integer updateEmployeePerformance(EmployeePerformance employeePerformance) {
        employeePerformance.setUpdateDate(new Date());
        return employeePerformanceMapper.updateByPrimaryKeySelective(employeePerformance);
    }

    public Integer deleteEmployeePerformance(Integer id) {
        return employeePerformanceMapper.deleteByPrimaryKey(id);
    }

    public ResponseEntity<byte[]> exportEmployeePerformance(String empName, Integer year, Date beginDate, Date endDate) {
        List<EmployeePerformance> list = employeePerformanceMapper.getEmployeePerformanceByPage(null, null, empName, year, beginDate, endDate);
        return performance2Excel(list);
    }

    public ResponseEntity<byte[]> getTemplate() {
        return performance2Excel(new ArrayList<>());
    }

    private ResponseEntity<byte[]> performance2Excel(List<EmployeePerformance> list) {
        HSSFWorkbook workbook = new HSSFWorkbook();
        HSSFSheet sheet = workbook.createSheet("员工绩效表");
        HSSFRow header = sheet.createRow(0);
        String[] headers = {"员工姓名", "身份证号", "年份", "1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月", "10月", "11月", "12月"};
        for (int i = 0; i < headers.length; i++) {
            header.createCell(i).setCellValue(headers[i]);
        }

        for (int i = 0; i < list.size(); i++) {
            EmployeePerformance ep = list.get(i);
            HSSFRow row = sheet.createRow(i + 1);
            if (ep.getEmployee() != null) {
                row.createCell(0).setCellValue(ep.getEmployee().getName());
            }
            row.createCell(1).setCellValue(ep.getEid());
            if (ep.getYear() != null) row.createCell(2).setCellValue(ep.getYear());
            if (ep.getMonth1() != null) row.createCell(3).setCellValue(ep.getMonth1());
            if (ep.getMonth2() != null) row.createCell(4).setCellValue(ep.getMonth2());
            if (ep.getMonth3() != null) row.createCell(5).setCellValue(ep.getMonth3());
            if (ep.getMonth4() != null) row.createCell(6).setCellValue(ep.getMonth4());
            if (ep.getMonth5() != null) row.createCell(7).setCellValue(ep.getMonth5());
            if (ep.getMonth6() != null) row.createCell(8).setCellValue(ep.getMonth6());
            if (ep.getMonth7() != null) row.createCell(9).setCellValue(ep.getMonth7());
            if (ep.getMonth8() != null) row.createCell(10).setCellValue(ep.getMonth8());
            if (ep.getMonth9() != null) row.createCell(11).setCellValue(ep.getMonth9());
            if (ep.getMonth10() != null) row.createCell(12).setCellValue(ep.getMonth10());
            if (ep.getMonth11() != null) row.createCell(13).setCellValue(ep.getMonth11());
            if (ep.getMonth12() != null) row.createCell(14).setCellValue(ep.getMonth12());
        }

        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        HttpHeaders headers2 = new HttpHeaders();
        try {
            headers2.setContentDispositionFormData("attachment", new String("员工绩效表.xls".getBytes("UTF-8"), "ISO-8859-1"));
            headers2.setContentType(MediaType.APPLICATION_OCTET_STREAM);
            workbook.write(baos);
        } catch (IOException e) {
            e.printStackTrace();
        }
        return new ResponseEntity<byte[]>(baos.toByteArray(), headers2, HttpStatus.CREATED);
    }

    public List<EmployeePerformance> excel2Performance(MultipartFile file) {
        List<EmployeePerformance> list = new ArrayList<>();
        try {
            Workbook workbook = WorkbookFactory.create(file.getInputStream());
            Sheet sheet = workbook.getSheetAt(0);
            int rows = sheet.getPhysicalNumberOfRows();
            for (int i = 1; i < rows; i++) {
                Row row = sheet.getRow(i);
                if (row == null) continue;
                EmployeePerformance ep = new EmployeePerformance();
                // Column 1: ID Card
                Cell eidCell = row.getCell(1);
                if (eidCell != null) {
                    eidCell.setCellType(CellType.STRING);
                    ep.setEid(eidCell.getStringCellValue());
                } else {
                    continue; // Skip if no ID Card
                }

                // Column 2: Year
                Cell yearCell = row.getCell(2);
                if (yearCell != null) {
                    if (yearCell.getCellTypeEnum() == CellType.NUMERIC) {
                        ep.setYear((int) yearCell.getNumericCellValue());
                    } else if (yearCell.getCellTypeEnum() == CellType.STRING) {
                        try {
                            ep.setYear(Integer.parseInt(yearCell.getStringCellValue()));
                        } catch (NumberFormatException e) {
                        }
                    }
                }

                if (row.getCell(3) != null && row.getCell(3).getCellTypeEnum() == CellType.NUMERIC) ep.setMonth1(row.getCell(3).getNumericCellValue());
                if (row.getCell(4) != null && row.getCell(4).getCellTypeEnum() == CellType.NUMERIC) ep.setMonth2(row.getCell(4).getNumericCellValue());
                if (row.getCell(5) != null && row.getCell(5).getCellTypeEnum() == CellType.NUMERIC) ep.setMonth3(row.getCell(5).getNumericCellValue());
                if (row.getCell(6) != null && row.getCell(6).getCellTypeEnum() == CellType.NUMERIC) ep.setMonth4(row.getCell(6).getNumericCellValue());
                if (row.getCell(7) != null && row.getCell(7).getCellTypeEnum() == CellType.NUMERIC) ep.setMonth5(row.getCell(7).getNumericCellValue());
                if (row.getCell(8) != null && row.getCell(8).getCellTypeEnum() == CellType.NUMERIC) ep.setMonth6(row.getCell(8).getNumericCellValue());
                if (row.getCell(9) != null && row.getCell(9).getCellTypeEnum() == CellType.NUMERIC) ep.setMonth7(row.getCell(9).getNumericCellValue());
                if (row.getCell(10) != null && row.getCell(10).getCellTypeEnum() == CellType.NUMERIC) ep.setMonth8(row.getCell(10).getNumericCellValue());
                if (row.getCell(11) != null && row.getCell(11).getCellTypeEnum() == CellType.NUMERIC) ep.setMonth9(row.getCell(11).getNumericCellValue());
                if (row.getCell(12) != null && row.getCell(12).getCellTypeEnum() == CellType.NUMERIC) ep.setMonth10(row.getCell(12).getNumericCellValue());
                if (row.getCell(13) != null && row.getCell(13).getCellTypeEnum() == CellType.NUMERIC) ep.setMonth11(row.getCell(13).getNumericCellValue());
                if (row.getCell(14) != null && row.getCell(14).getCellTypeEnum() == CellType.NUMERIC) ep.setMonth12(row.getCell(14).getNumericCellValue());

                ep.setCreateDate(new Date());
                ep.setUpdateDate(new Date());
                list.add(ep);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public Integer addEmployeePerformances(List<EmployeePerformance> list) {
        return employeePerformanceMapper.addEmployeePerformances(list);
    }
}
