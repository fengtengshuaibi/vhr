package org.javaboy.vhr.service;

import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.*;
import org.javaboy.vhr.mapper.ExecutivePerformanceMapper;
import org.javaboy.vhr.model.ExecutivePerformance;
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
public class ExecutivePerformanceService {
    @Autowired
    ExecutivePerformanceMapper executivePerformanceMapper;

    public RespPageBean getExecutivePerformanceByPage(Integer page, Integer size, String empName, Integer year, Date beginDate, Date endDate) {
        if (page != null && size != null) {
            page = (page - 1) * size;
        }
        List<ExecutivePerformance> data = executivePerformanceMapper.getExecutivePerformanceByPage(page, size, empName, year, beginDate, endDate);
        Long total = executivePerformanceMapper.getTotal(empName, year, beginDate, endDate);
        RespPageBean bean = new RespPageBean();
        bean.setData(data);
        bean.setTotal(total);
        return bean;
    }

    public Integer addExecutivePerformance(ExecutivePerformance executivePerformance) {
        executivePerformance.setCreateDate(new Date());
        executivePerformance.setUpdateDate(new Date());
        return executivePerformanceMapper.insertSelective(executivePerformance);
    }

    public Integer updateExecutivePerformance(ExecutivePerformance executivePerformance) {
        executivePerformance.setUpdateDate(new Date());
        return executivePerformanceMapper.updateByPrimaryKeySelective(executivePerformance);
    }

    public Integer deleteExecutivePerformance(Integer id) {
        return executivePerformanceMapper.deleteByPrimaryKey(id);
    }

    public ResponseEntity<byte[]> exportExecutivePerformance(String empName, Integer year, Date beginDate, Date endDate) {
        List<ExecutivePerformance> list = executivePerformanceMapper.getExecutivePerformanceByPage(null, null, empName, year, beginDate, endDate);
        return performance2Excel(list);
    }

    public ResponseEntity<byte[]> getTemplate() {
        return performance2Excel(new ArrayList<>());
    }

    private ResponseEntity<byte[]> performance2Excel(List<ExecutivePerformance> list) {
        HSSFWorkbook workbook = new HSSFWorkbook();
        HSSFSheet sheet = workbook.createSheet("高管绩效表");
        HSSFRow header = sheet.createRow(0);
        String[] headers = {"员工姓名(必填)", "身份证号(必填,18位)", "年份(必填,数字)", "第一季度(数值,最多2位小数)", "第二季度(数值,最多2位小数)", "第三季度(数值,最多2位小数)", "第四季度(数值,最多2位小数)"};
        for (int i = 0; i < headers.length; i++) {
            header.createCell(i).setCellValue(headers[i]);
        }

        for (int i = 0; i < list.size(); i++) {
            ExecutivePerformance ep = list.get(i);
            HSSFRow row = sheet.createRow(i + 1);
            if (ep.getEmployee() != null) {
                row.createCell(0).setCellValue(ep.getEmployee().getName());
            }
            row.createCell(1).setCellValue(ep.getEid());
            if (ep.getYear() != null) row.createCell(2).setCellValue(ep.getYear());
            if (ep.getQuarter1() != null) row.createCell(3).setCellValue(ep.getQuarter1());
            if (ep.getQuarter2() != null) row.createCell(4).setCellValue(ep.getQuarter2());
            if (ep.getQuarter3() != null) row.createCell(5).setCellValue(ep.getQuarter3());
            if (ep.getQuarter4() != null) row.createCell(6).setCellValue(ep.getQuarter4());
        }

        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        HttpHeaders headers2 = new HttpHeaders();
        try {
            headers2.setContentDispositionFormData("attachment", new String("高管绩效表.xls".getBytes("UTF-8"), "ISO-8859-1"));
            headers2.setContentType(MediaType.APPLICATION_OCTET_STREAM);
            workbook.write(baos);
        } catch (IOException e) {
            e.printStackTrace();
        }
        return new ResponseEntity<byte[]>(baos.toByteArray(), headers2, HttpStatus.CREATED);
    }

    public List<ExecutivePerformance> excel2Performance(MultipartFile file) {
        List<ExecutivePerformance> list = new ArrayList<>();
        try {
            Workbook workbook = WorkbookFactory.create(file.getInputStream());
            Sheet sheet = workbook.getSheetAt(0);
            int rows = sheet.getPhysicalNumberOfRows();
            for (int i = 1; i < rows; i++) {
                Row row = sheet.getRow(i);
                if (row == null) continue;
                ExecutivePerformance ep = new ExecutivePerformance();
                // Column 1: ID Card
                Cell eidCell = row.getCell(1);
                if (eidCell != null) {
                    eidCell.setCellType(CellType.STRING);
                    ep.setEid(eidCell.getStringCellValue());
                } else {
                    continue;
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

                if (row.getCell(3) != null && row.getCell(3).getCellTypeEnum() == CellType.NUMERIC) ep.setQuarter1(row.getCell(3).getNumericCellValue());
                if (row.getCell(4) != null && row.getCell(4).getCellTypeEnum() == CellType.NUMERIC) ep.setQuarter2(row.getCell(4).getNumericCellValue());
                if (row.getCell(5) != null && row.getCell(5).getCellTypeEnum() == CellType.NUMERIC) ep.setQuarter3(row.getCell(5).getNumericCellValue());
                if (row.getCell(6) != null && row.getCell(6).getCellTypeEnum() == CellType.NUMERIC) ep.setQuarter4(row.getCell(6).getNumericCellValue());

                ep.setCreateDate(new Date());
                ep.setUpdateDate(new Date());
                list.add(ep);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public Integer addExecutivePerformances(List<ExecutivePerformance> list) {
        return executivePerformanceMapper.addExecutivePerformances(list);
    }
}
