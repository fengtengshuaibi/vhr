package org.javaboy.vhr.service;

import org.javaboy.vhr.mapper.*;
import org.javaboy.vhr.model.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class EmployeeRosterService {

    @Autowired
    EmployeeMapper employeeMapper;
    @Autowired
    ContractMapper contractMapper;
    @Autowired
    EmployeePerformanceMapper employeePerformanceMapper;
    @Autowired
    ExecutivePerformanceMapper executivePerformanceMapper;
    @Autowired
    EmployeetrainMapper employeetrainMapper;
    @Autowired
    EmployeeAppraisalMapper employeeAppraisalMapper;
    @Autowired
    EmployeeecMapper employeeecMapper;
    @Autowired
    EmployeeremoveMapper employeeremoveMapper;
    // ... other mappers

    public Map<String, Object> getEmployeeRosterData(String eid) {
        Map<String, Object> map = new HashMap<>();
        
        // Fetch Data
        Employee employee = employeeMapper.getEmployeeById(eid);
        if (employee == null) return null;
        map.put("employee", employee);
        
        Contract contract = contractMapper.selectByPrimaryKey(eid);
        map.put("contract", contract);
        
        // Performance
        List<EmployeePerformance> perList = employeePerformanceMapper.getEmployeePerformanceByPage(null, null, employee.getName(), null, null, null);
        EmployeePerformance performance = null;
        if (perList != null && !perList.isEmpty()) {
            // Find latest year
            perList.sort((p1, p2) -> p2.getYear().compareTo(p1.getYear()));
            for (EmployeePerformance p : perList) {
                if (p.getEid().equals(eid)) {
                    performance = p;
                    break;
                }
            }
        }
        map.put("performance", performance);
        
        List<ExecutivePerformance> execList = executivePerformanceMapper.getExecutivePerformanceByPage(null, null, employee.getName(), null, null, null);
        ExecutivePerformance execPerformance = null;
        if (execList != null && !execList.isEmpty()) {
            execList.sort((p1, p2) -> p2.getYear().compareTo(p1.getYear()));
            for (ExecutivePerformance p : execList) {
                if (p.getEid().equals(eid)) {
                    execPerformance = p;
                    break;
                }
            }
        }
        map.put("execPerformance", execPerformance);

        // Trainings
        List<Employeetrain> trains = employeetrainMapper.getEmployeeTrainsByPage(null, null, new Employeetrain(), new Date[]{getYearStart(), getYearEnd()});
        List<Employeetrain> myTrains = new java.util.ArrayList<>();
        if (trains != null) {
            for(Employeetrain et : trains) {
                if(et.getEid().equals(eid)) {
                    myTrains.add(et);
                }
            }
        }
        map.put("trains", myTrains);

        // Appraisals
        List<EmployeeAppraisal> appraisals = employeeAppraisalMapper.getEmployeeAppraisalsByPage(eid, null);
        map.put("appraisals", appraisals);

        // EC (Rewards/Punishments)
        List<Employeeec> ecs = employeeecMapper.getEmployeeEcsByPage(eid, null);
        map.put("ecs", ecs);

        // Removes (Transfers)
        List<Employeeremove> removes = employeeremoveMapper.getEmployeeRemovesByPage(eid, null);
        map.put("removes", removes);
        
        return map;
    }

    public byte[] generateRosterImage(String eid) {
        // Fetch Data
        Employee employee = employeeMapper.getEmployeeById(eid);
        if (employee == null) return null;
        
        Contract contract = contractMapper.selectByPrimaryKey(eid);
        // Performance
        List<EmployeePerformance> perList = employeePerformanceMapper.getEmployeePerformanceByPage(null, null, employee.getName(), null, null, null);
        EmployeePerformance performance = null;
        if (perList != null && !perList.isEmpty()) {
            perList.sort((p1, p2) -> p2.getYear().compareTo(p1.getYear()));
            for (EmployeePerformance p : perList) {
                if (p.getEid().equals(eid)) {
                    performance = p;
                    break;
                }
            }
        }
        
        List<ExecutivePerformance> execList = executivePerformanceMapper.getExecutivePerformanceByPage(null, null, employee.getName(), null, null, null);
        ExecutivePerformance execPerformance = null;
        if (execList != null && !execList.isEmpty()) {
            execList.sort((p1, p2) -> p2.getYear().compareTo(p1.getYear()));
            for (ExecutivePerformance p : execList) {
                if (p.getEid().equals(eid)) {
                    execPerformance = p;
                    break;
                }
            }
        }

        // Create Image
        int width = 1600;
        int height = 1200;
        BufferedImage image = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
        Graphics2D g2d = image.createGraphics();
        
        // Anti-aliasing
        g2d.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
        g2d.setRenderingHint(RenderingHints.KEY_TEXT_ANTIALIASING, RenderingHints.VALUE_TEXT_ANTIALIAS_ON);

        // Background
        g2d.setColor(new Color(0, 0, 139)); // Dark Blue Background
        g2d.fillRect(0, 0, width, height);

        // Font
        Font titleFont = new Font("SimHei", Font.BOLD, 30);
        Font headerFont = new Font("SimHei", Font.BOLD, 24);
        Font labelFont = new Font("SimHei", Font.BOLD, 16);
        Font valueFont = new Font("SimSun", Font.PLAIN, 16);

        // Header
        g2d.setColor(Color.WHITE);
        g2d.setFont(titleFont);
        // g2d.setColor(new Color(0, 0, 139)); // No longer dark blue text on dark blue background
        g2d.drawString("员工花名册 - " + employee.getName(), 1200, 50);

        // Sections
        int startX = 50;
        int startY = 100;
        int colWidth = 480;
        int gap = 30;

        // Column 1: Basic & Sensitive & Education & Work
        drawSection(g2d, "01", "入职前信息(招聘与入职阶段)", startX, startY, colWidth, headerFont, labelFont, valueFont, employee, null, null, null);

        // Column 2: Job Phase
        drawSection2(g2d, "02", "入职后信息(在职阶段)", startX + colWidth + gap, startY, colWidth, headerFont, labelFont, valueFont, employee, contract, performance, execPerformance);

        // Column 3: Exit Phase
        drawSection3(g2d, "03", "离职阶段信息", startX + (colWidth + gap) * 2, startY, colWidth, headerFont, labelFont, valueFont, employee);

        g2d.dispose();

        try (ByteArrayOutputStream baos = new ByteArrayOutputStream()) {
            ImageIO.write(image, "jpg", baos);
            return baos.toByteArray();
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
    }

    private void drawSection(Graphics2D g2d, String num, String title, int x, int y, int width, Font headerFont, Font labelFont, Font valueFont, Employee emp, Contract con, EmployeePerformance per, ExecutivePerformance exec) {
        // Draw Header
        drawSectionHeader(g2d, num, title, x, y, width, headerFont);
        
        int curY = y + 80;
        int lineHeight = 30;
        
        // Draw subsections
        curY = drawSubSection(g2d, "基础信息", x, curY, width, labelFont);
        drawField(g2d, "姓名", emp.getName(), x, curY, valueFont);
        drawField(g2d, "性别", emp.getGender(), x + 200, curY, valueFont);
        curY += lineHeight;
        drawField(g2d, "身份证", emp.getIdCard(), x, curY, valueFont);
        curY += lineHeight;
        drawField(g2d, "出生日期", formatDate(emp.getBirthday()), x, curY, valueFont);
        drawField(g2d, "民族", emp.getNation() != null ? emp.getNation().getName() : "", x + 200, curY, valueFont);
        curY += lineHeight;
        drawField(g2d, "政治面貌", emp.getPoliticsstatus() != null ? emp.getPoliticsstatus().getName() : "", x, curY, valueFont);
        curY += lineHeight;
        drawField(g2d, "籍贯", emp.getNativePlace(), x, curY, valueFont);
        curY += lineHeight;
        drawField(g2d, "联系方式", emp.getPhone(), x, curY, valueFont);
        curY += lineHeight;
        drawField(g2d, "邮箱", emp.getEmail(), x, curY, valueFont);
        curY += lineHeight;
        drawField(g2d, "居住地址", emp.getAddress(), x, curY, valueFont);
        curY += lineHeight;
        drawField(g2d, "紧急联系人", emp.getEmergencyContact(), x, curY, valueFont);
        drawField(g2d, "紧急电话", emp.getEmergencyContactPhone(), x + 200, curY, valueFont);
        curY += 20;

        curY = drawSubSection(g2d, "敏感信息", x, curY, width, labelFont);
        drawField(g2d, "婚姻状况", emp.getWedlock(), x, curY, valueFont);
        drawField(g2d, "生育状况", emp.getFertilityStatus(), x + 200, curY, valueFont);
        curY += lineHeight;
        drawField(g2d, "子女信息", emp.getChildrenInfo(), x, curY, valueFont);
        curY += 20;

        curY = drawSubSection(g2d, "教育资质", x, curY, width, labelFont);
        drawField(g2d, "最高学历", emp.getTiptopDegree(), x, curY, valueFont);
        drawField(g2d, "毕业院校", emp.getSchool(), x + 200, curY, valueFont);
        curY += lineHeight;
        drawField(g2d, "专业", emp.getSpecialty(), x, curY, valueFont);
        curY += lineHeight;
        drawField(g2d, "毕业时间", formatDate(emp.getGraduationDate()), x, curY, valueFont);
        curY += lineHeight;
        drawField(g2d, "资格证书", emp.getCertificate(), x, curY, valueFont);
        curY += lineHeight;
        drawField(g2d, "培训经历", emp.getTrainingHistory(), x, curY, valueFont);
        curY += 20;

        curY = drawSubSection(g2d, "工作经历", x, curY, width, labelFont);
        drawField(g2d, "原单位", emp.getPreviousCompany(), x, curY, valueFont);
        curY += lineHeight;
        drawField(g2d, "原职位", emp.getPreviousPosition(), x, curY, valueFont);
        curY += lineHeight;
        drawField(g2d, "起止时间", emp.getPreviousStartEnd(), x, curY, valueFont);
        curY += lineHeight;
        drawField(g2d, "离职原因", emp.getPreviousResignationReason(), x, curY, valueFont);
        curY += lineHeight;
        drawField(g2d, "证明人", emp.getReference(), x, curY, valueFont);
        drawField(g2d, "电话", emp.getReferencePhone(), x + 200, curY, valueFont);
        curY += 20;
        
        curY = drawSubSection(g2d, "人才测评", x, curY, width, labelFont);
        drawField(g2d, "测评结果", emp.getAssessmentResult(), x, curY, valueFont);
    }

    private void drawSection2(Graphics2D g2d, String num, String title, int x, int y, int width, Font headerFont, Font labelFont, Font valueFont, Employee emp, Contract con, EmployeePerformance per, ExecutivePerformance exec) {
        drawSectionHeader(g2d, num, title, x, y, width, headerFont);
        
        int curY = y + 80;
        int lineHeight = 30;

        curY = drawSubSection(g2d, "岗位信息", x, curY, width, labelFont);
        drawField(g2d, "部门", emp.getDepartment() != null ? emp.getDepartment().getName() : "", x, curY, valueFont);
        drawField(g2d, "职位", emp.getPosition() != null ? emp.getPosition().getName() : "", x + 200, curY, valueFont);
        curY += lineHeight;
        drawField(g2d, "工作地点", emp.getWorkLocation(), x, curY, valueFont);
        drawField(g2d, "入职日期", formatDate(emp.getBeginDate()), x + 200, curY, valueFont);
        curY += lineHeight;
        drawField(g2d, "工龄", emp.getWorkAge() + "年", x, curY, valueFont);
        drawField(g2d, "试用期", emp.getProbation() + "个月", x + 200, curY, valueFont);
        curY += lineHeight;
        drawField(g2d, "转正日期", formatDate(emp.getConversionTime()), x, curY, valueFont);
        drawField(g2d, "转正评分", emp.getConversionScore() + "", x + 200, curY, valueFont);
        curY += lineHeight;
        drawField(g2d, "状态", emp.getWorkState(), x, curY, valueFont);
        curY += 20;

        curY = drawSubSection(g2d, "合同信息", x, curY, width, labelFont);
        if (con != null) {
             drawField(g2d, "用工类型", con.getEmploymentType(), x, curY, valueFont);
             drawField(g2d, "合同类型", con.getContractType(), x + 200, curY, valueFont);
             curY += lineHeight;
             drawField(g2d, "签订次数", con.getSignCount() + "", x, curY, valueFont);
             drawField(g2d, "截止日期", formatDate(con.getEndDate()), x + 200, curY, valueFont);
             curY += lineHeight;
             drawField(g2d, "首次签订", formatDate(con.getFirstSignDate()) + " (" + con.getFirstSignTerm() + "年)", x, curY, valueFont);
             curY += lineHeight;
             drawField(g2d, "二次签订", formatDate(con.getSecondSignDate()) + " (" + con.getSecondSignTerm() + "年)", x, curY, valueFont);
             curY += lineHeight;
             drawField(g2d, "三次签订", formatDate(con.getThirdSignDate()), x, curY, valueFont);
        } else {
             drawField(g2d, "暂无合同信息", "", x, curY, valueFont);
        }
        curY += 20;

        curY = drawSubSection(g2d, "考勤休假", x, curY, width, labelFont);
        drawField(g2d, "迟到/早退", "(空)", x, curY, valueFont);
        drawField(g2d, "加班(小时)", "(空)", x + 200, curY, valueFont);
        curY += lineHeight;
        drawField(g2d, "年假(天)", "(空)", x, curY, valueFont);
        drawField(g2d, "病假(天)", "(空)", x + 200, curY, valueFont);
        curY += 20;

        curY = drawSubSection(g2d, "绩效管理", x, curY, width, labelFont);
        if (per != null) {
            String scores = String.format("1月:%s 2月:%s 3月:%s 4月:%s", per.getMonth1(), per.getMonth2(), per.getMonth3(), per.getMonth4());
            drawField(g2d, "", scores, x, curY, valueFont);
            curY += lineHeight;
            scores = String.format("5月:%s 6月:%s 7月:%s 8月:%s", per.getMonth5(), per.getMonth6(), per.getMonth7(), per.getMonth8());
            drawField(g2d, "", scores, x, curY, valueFont);
            curY += lineHeight;
            scores = String.format("9月:%s 10月:%s 11月:%s 12月:%s", per.getMonth9(), per.getMonth10(), per.getMonth11(), per.getMonth12());
            drawField(g2d, "", scores, x, curY, valueFont);
        } else {
            drawField(g2d, "暂无绩效", "", x, curY, valueFont);
        }
        if (exec != null) {
             curY += lineHeight;
             String scores = String.format("Q1:%s Q2:%s Q3:%s Q4:%s", exec.getQuarter1(), exec.getQuarter2(), exec.getQuarter3(), exec.getQuarter4());
             drawField(g2d, "内部评分", scores, x, curY, valueFont);
        }
        curY += 20;
        
        curY = drawSubSection(g2d, "内部培训", x, curY, width, labelFont);
        
        // Fetch training data for current year
        SimpleDateFormat yearFormat = new SimpleDateFormat("yyyy");
        String currentYear = yearFormat.format(new Date());
        
        // Use EmployeeTrainMapper (need to inject)
        // Since we are in EmployeeRosterService, we need to autowire EmployeetrainMapper
        List<Employeetrain> trains = employeetrainMapper.getEmployeeTrainsByPage(null, null, new Employeetrain(), new Date[]{getYearStart(), getYearEnd()});
        
        int count = 0;
        List<Employeetrain> myTrains = new java.util.ArrayList<>();
        if (trains != null) {
            for(Employeetrain et : trains) {
                if(et.getEid().equals(emp.getIdCard())) {
                    myTrains.add(et);
                    count++;
                }
            }
        }
        
        drawField(g2d, "年份", currentYear, x, curY, valueFont);
        drawField(g2d, "参加培训总场次", count + "场", x + 200, curY, valueFont);
        curY += 30;
        
        if (myTrains.isEmpty()) {
             drawField(g2d, "", "暂无培训记录", x, curY, valueFont);
        } else {
             SimpleDateFormat mdFormat = new SimpleDateFormat("MM:dd");
             for (Employeetrain t : myTrains) {
                 String dateStr = mdFormat.format(t.getTraindate());
                 String content = t.getTraincontent();
                 Integer score = t.getScore();
                 String line = dateStr + " " + content + " (得分:" + (score != null ? score : 0) + ")";
                 drawField(g2d, "", line, x, curY, valueFont);
                 curY += 20;
             }
        }
    }

    private Date getYearStart() {
        java.util.Calendar c = java.util.Calendar.getInstance();
        c.set(java.util.Calendar.MONTH, 0);
        c.set(java.util.Calendar.DAY_OF_MONTH, 1);
        c.set(java.util.Calendar.HOUR_OF_DAY, 0);
        c.set(java.util.Calendar.MINUTE, 0);
        c.set(java.util.Calendar.SECOND, 0);
        return c.getTime();
    }
    
    private Date getYearEnd() {
        java.util.Calendar c = java.util.Calendar.getInstance();
        c.set(java.util.Calendar.MONTH, 11);
        c.set(java.util.Calendar.DAY_OF_MONTH, 31);
        c.set(java.util.Calendar.HOUR_OF_DAY, 23);
        c.set(java.util.Calendar.MINUTE, 59);
        c.set(java.util.Calendar.SECOND, 59);
        return c.getTime();
    }

    private void drawSection3(Graphics2D g2d, String num, String title, int x, int y, int width, Font headerFont, Font labelFont, Font valueFont, Employee emp) {
        drawSectionHeader(g2d, num, title, x, y, width, headerFont);
        
        int curY = y + 80;
        int lineHeight = 30;

        curY = drawSubSection(g2d, "离职日期", x, curY, width, labelFont);
        drawField(g2d, "", formatDate(emp.getNotWorkDate()), x, curY, valueFont);
        curY += 30;

        curY = drawSubSection(g2d, "离职原因", x, curY, width, labelFont);
        drawField(g2d, "", emp.getResignationReason(), x, curY, valueFont);
        curY += 30;
        
        curY = drawSubSection(g2d, "面谈记录", x, curY, width, labelFont);
        curY += 80; // Placeholder space
        
        curY = drawSubSection(g2d, "交接记录", x, curY, width, labelFont);
    }

    private void drawSectionHeader(Graphics2D g2d, String num, String title, int x, int y, int width, Font font) {
        // Draw white rounded rectangle background for header (contrast against dark blue bg)
        g2d.setColor(Color.WHITE); 
        g2d.fillRoundRect(x, y, width, 60, 20, 20);
        
        // Draw Number
        g2d.setColor(new Color(0, 0, 139)); // Dark Blue Text
        g2d.setFont(new Font("SimHei", Font.BOLD, 48));
        g2d.drawString(num, x + 20, y + 45);
        
        // Draw Title
        g2d.setFont(new Font("SimHei", Font.BOLD, 24));
        g2d.drawString(title, x + 100, y + 38);
    }

    private int drawSubSection(Graphics2D g2d, String title, int x, int y, int width, Font font) {
        // Circle icon - White
        g2d.setColor(Color.WHITE); 
        g2d.fillOval(x, y - 20, 50, 50);
        
        // Text inside circle - Dark Blue
        g2d.setColor(new Color(0, 0, 139));
        g2d.setFont(new Font("SimHei", Font.BOLD, 14));
        String shortTitle = title.length() > 2 ? title.substring(0, 2) : title;
        g2d.drawString(shortTitle, x + 10, y + 10);
        
        // Bar - Light Blue/White
        g2d.setColor(new Color(236, 245, 255));
        g2d.fillRect(x + 60, y - 10, width - 60, 30);
        
        g2d.setColor(new Color(0, 0, 139)); // Dark Blue Text
        g2d.setFont(new Font("SimHei", Font.BOLD, 16));
        g2d.drawString(title, x + 70, y + 10);
        
        return y + 30; // Return next Y position
    }


    private void drawField(Graphics2D g2d, String label, String value, int x, int y, Font font) {
        g2d.setFont(font);
        g2d.setColor(Color.WHITE); // White text on dark background
        if (label != null && !label.isEmpty()) {
            g2d.drawString(label + ": " + (value == null ? "" : value), x, y);
        } else {
            g2d.drawString((value == null ? "" : value), x, y);
        }
    }

    private String formatDate(Date date) {
        if (date == null) return "";
        return new SimpleDateFormat("yyyy-MM-dd").format(date);
    }
}
