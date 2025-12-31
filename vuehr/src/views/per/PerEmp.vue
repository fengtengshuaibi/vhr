<template>
    <div>
        <div>
            <div style="display: flex;justify-content: space-between">
                <div>
                    <el-input placeholder="请输入员工名进行搜索..." prefix-icon="el-icon-search"
                              clearable
                              @clear="initEmps"
                              style="width: 350px;margin-right: 10px" v-model="keyword"
                              @keydown.enter.native="initEmps"></el-input>
                    <el-button icon="el-icon-search" type="primary" @click="initEmps">
                        搜索
                    </el-button>
                </div>
            </div>
        </div>
        <div style="margin-top: 10px">
            <el-table
                    :data="emps"
                    stripe
                    border
                    v-loading="loading"
                    element-loading-text="正在加载..."
                    element-loading-spinner="el-icon-loading"
                    element-loading-background="rgba(0, 0, 0, 0.8)"
                    style="width: 100%"
                    height="calc(100vh - 200px)">
                <el-table-column
                        type="selection"
                        width="55">
                </el-table-column>
                <el-table-column prop="name" fixed align="left" label="姓名" width="90"></el-table-column>
                <el-table-column prop="gender" label="性别" align="left" width="85"></el-table-column>
                <el-table-column prop="birthday" width="95" align="left" label="出生日期"></el-table-column>
                <el-table-column prop="idCard" width="150" align="left" label="身份证号码"></el-table-column>
                <el-table-column prop="idCardStartDate" width="100" align="left" label="身份证开始日期"></el-table-column>
                <el-table-column prop="idCardEndDate" width="100" align="left" label="身份证结束日期"></el-table-column>
                <el-table-column prop="wedlock" width="70" label="婚姻状况"></el-table-column>
                <el-table-column prop="nation.name" width="50" label="民族"></el-table-column>
                <el-table-column prop="nativePlace" width="80" label="籍贯"></el-table-column>
                <el-table-column prop="politicsstatus.name" label="政治面貌"></el-table-column>
                <el-table-column prop="email" width="180" align="left" label="电子邮件"></el-table-column>
                <el-table-column prop="phone" width="100" align="left" label="电话号码"></el-table-column>
                <el-table-column prop="address" width="220" align="left" label="联系地址"></el-table-column>
                <el-table-column prop="department.name" width="100" align="left" label="所属部门"></el-table-column>
                <el-table-column prop="position.name" width="100" label="职位"></el-table-column>
                <el-table-column prop="jobLevel.name" width="100" label="职称"></el-table-column>
                <el-table-column prop="engageForm" label="聘用形式"></el-table-column>
                <el-table-column prop="tiptopDegree" label="最高学历"></el-table-column>
                <el-table-column prop="specialty" width="150" align="left" label="专业"></el-table-column>
                <el-table-column prop="school" width="150" align="left" label="毕业院校"></el-table-column>
                <el-table-column prop="beginDate" width="95" align="left" label="入职日期"></el-table-column>
                <el-table-column prop="conversionTime" width="95" align="left" label="转正日期"></el-table-column>
                <el-table-column prop="beginContract" width="95" align="left" label="合同起始日期"></el-table-column>
                <el-table-column prop="endContract" width="95" align="left" label="合同截止日期"></el-table-column>
                <el-table-column label="合同期限">
                    <template slot-scope="scope">
                        <el-tag>{{scope.row.contractTerm}}</el-tag>
                        年
                    </template>
                </el-table-column>
                <el-table-column fixed="right" width="120" label="操作">
                    <template slot-scope="scope">
                        <el-button @click="showRoster(scope.row)" style="padding: 3px" size="mini" type="primary">生成花名册</el-button>
                    </template>
                </el-table-column>
            </el-table>
            <div style="display: flex;justify-content: flex-end">
                <el-pagination
                        background
                        @current-change="currentChange"
                        @size-change="sizeChange"
                        layout="sizes, prev, pager, next, jumper, ->, total, slot"
                        :total="total">
                </el-pagination>
            </div>
        </div>
        <el-dialog
                title="员工花名册"
                :visible.sync="dialogVisible"
                width="90%" top="5vh">
            
            <div style="display: flex; justify-content: flex-end; margin-bottom: 10px;">
                <el-button type="primary" size="small" @click="downloadRoster">下载图片</el-button>
            </div>

            <div style="width: 100%; overflow: auto; max-height: 80vh;">
                <div id="roster-container" class="roster-container" v-if="rosterData">
                    <!-- Top Right User Info -->
                    <div class="roster-top-header">
                         <div class="top-user-info">
                             <div class="user-avatar"><i class="el-icon-user-solid"></i></div>
                             <div class="user-name-large">{{rosterData.employee.name}}</div>
                         </div>
                    </div>

                    <div class="roster-body">
                        <!-- Column 1 -->
                        <div class="roster-column">
                            <div class="col-header-wrapper">
                                <div class="header-num">01</div>
                                <div class="header-title-box">
                                    <div class="main-title">入职前信息</div>
                                    <div class="sub-title-text">(招聘与入职阶段)</div>
                                </div>
                            </div>
                            
                            <!-- Basic Info -->
                            <div class="timeline-item">
                                <div class="timeline-left">
                                    <div class="timeline-icon">基础<br>信息</div>
                                    <div class="timeline-line"></div>
                                </div>
                                <div class="timeline-content">
                                    <div class="info-row">
                                        <div class="info-item"><span class="label">性别:</span> {{rosterData.employee.gender}}</div>
                                        <div class="info-item"><span class="label">年龄:</span> {{calculateAge(rosterData.employee.birthday)}}</div>
                                    </div>
                                    <div class="info-row">
                                        <div class="info-item"><span class="label">出生日期:</span> {{formatDate(rosterData.employee.birthday)}}</div>
                                        <div class="info-item"><span class="label">民族:</span> {{rosterData.employee.nation ? rosterData.employee.nation.name : ''}}</div>
                                    </div>
                                    <div class="info-row">
                                        <div class="info-item full-width"><span class="label">身份证号:</span> {{rosterData.employee.idCard}}</div>
                                    </div>
                                    <div class="info-row">
                                        <div class="info-item"><span class="label">身份证开始日期:</span> {{formatDate(rosterData.employee.idCardStartDate)}}</div>
                                        <div class="info-item"><span class="label">身份证结束日期:</span> {{formatDate(rosterData.employee.idCardEndDate)}}</div>
                                    </div>
                                    <div class="info-row">
                                        <div class="info-item"><span class="label">政治面貌:</span> {{rosterData.employee.politicsstatus ? rosterData.employee.politicsstatus.name : ''}}</div>
                                        <div class="info-item"><span class="label">户口类别:</span> {{rosterData.employee.hukouType || ''}}</div>
                                    </div>
                                    <div class="info-row">
                                        <div class="info-item full-width"><span class="label">户口所在地:</span> {{rosterData.employee.nativePlace}}</div>
                                    </div>
                                    <div class="info-row">
                                        <div class="info-item full-width"><span class="label">现居住地址:</span> {{rosterData.employee.address}}</div>
                                    </div>
                                    <div class="info-row">
                                        <div class="info-item full-width"><span class="label">电子邮件:</span> {{rosterData.employee.email}}</div>
                                    </div>
                                    <div class="info-row">
                                        <div class="info-item full-width"><span class="label">联系方式:</span> {{rosterData.employee.phone}}</div>
                                    </div>
                                    <div class="info-row">
                                        <div class="info-item full-width"><span class="label">工作邮箱:</span> {{rosterData.employee.email}}</div>
                                    </div>
                                    <div class="info-row">
                                        <div class="info-item"><span class="label">紧急联系人:</span> {{rosterData.employee.emergencyContact}}</div>
                                        <div class="info-item"><span class="label">联系方式:</span> {{rosterData.employee.emergencyContactPhone}}</div>
                                    </div>
                                </div>
                            </div>

                            <!-- Education -->
                            <div class="timeline-item">
                                <div class="timeline-left">
                                    <div class="timeline-icon">教育<br>资质</div>
                                    <!-- No line for last item in column if preferred, but let's keep it for consistency -->
                                </div>
                                <div class="timeline-content education-box">
                                    <div class="info-row">
                                        <div class="info-item"><span class="label">毕业院校:</span> {{rosterData.employee.school}}</div>
                                        <div class="info-item"><span class="label">专业:</span> {{rosterData.employee.specialty}}</div>
                                    </div>
                                    <div class="info-row">
                                        <div class="info-item"><span class="label">毕业时间:</span> {{formatDate(rosterData.employee.graduationDate)}}</div>
                                        <div class="info-item"><span class="label">学历:</span> {{rosterData.employee.tiptopDegree}}</div>
                                    </div>
                                    <div class="info-row mt-10">
                                        <div class="info-item full-width"><span class="label">专业资格证书:</span> {{rosterData.employee.certificate || '(无)'}}</div>
                                    </div>
                                    <div class="info-row mt-10">
                                        <div class="info-item full-width"><span class="label">培训经历:</span> {{rosterData.employee.trainingHistory || '(无)'}}</div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Column 2 -->
                        <div class="roster-column">
                            <div class="col-header-wrapper">
                                <div class="header-num">02</div>
                                <div class="header-title-box">
                                    <div class="main-title">在职期间信息</div>
                                    <div class="sub-title-text">(动态管理阶段)</div>
                                </div>
                            </div>

                            <!-- Position Info -->
                            <div class="timeline-item">
                                <div class="timeline-left">
                                    <div class="timeline-icon">岗位<br>信息</div>
                                    <div class="timeline-line"></div>
                                </div>
                                <div class="timeline-content">
                                    <div class="info-row">
                                        <div class="info-item"><span class="label">所属公司:</span> 人事人(北京)</div>
                                        <div class="info-item"><span class="label">所属部门:</span> {{rosterData.employee.department ? rosterData.employee.department.name : ''}}</div>
                                        <div class="info-item"><span class="label">职位:</span> {{rosterData.employee.position ? rosterData.employee.position.name : ''}}</div>
                                    </div>
                                    <div class="info-row">
                                        <div class="info-item"><span class="label">汇报上级:</span> (空)</div>
                                        <div class="info-item"><span class="label">入职日期:</span> {{formatDate(rosterData.employee.beginDate)}}</div>
                                    </div>
                                    <div class="info-row">
                                        <div class="info-item"><span class="label">试用期(月):</span> {{rosterData.employee.probation}}</div>
                                        <div class="info-item"><span class="label">转正日期:</span> {{formatDate(rosterData.employee.conversionTime)}}</div>
                                        <div class="info-item"><span class="label">转正评估分值:</span> {{rosterData.employee.conversionScore}}</div>
                                    </div>
                                    <div class="info-row">
                                        <div class="info-item"><span class="label">司龄:</span> {{rosterData.employee.workAge}}年</div>
                                        <div class="info-item"><span class="label">工作地点:</span> {{rosterData.employee.workLocation}}</div>
                                        <div class="info-item"><span class="label">工作状态:</span> {{rosterData.employee.workState}}</div>
                                    </div>
                                    
                                    <!-- 4 Boxes -->
                                    <div class="four-boxes">
                                        <div class="small-box table-box">
                                            <div class="box-title">内部调动记录</div>
                                            <div class="box-content">
                                                 <div class="mini-table-header">
                                                     <span style="flex: 25">日期</span>
                                                     <span style="flex: 20">前部门</span>
                                                     <span style="flex: 20">前职位</span>
                                                     <span style="flex: 20">后部门</span>
                                                     <span style="flex: 20">后职位</span>
                                                 </div>
                                                 <div class="mini-table-row" v-for="item in getTransfers()" :key="item.id">
                                                     <span style="flex: 25">{{formatDate(item.removeDate)}}</span>
                                                     <span style="flex: 20">{{item.beforeDepartment ? item.beforeDepartment.name : ''}}</span>
                                                     <span style="flex: 20">{{item.beforePosition ? item.beforePosition.name : ''}}</span>
                                                     <span style="flex: 20">{{item.afterDepartment ? item.afterDepartment.name : ''}}</span>
                                                     <span style="flex: 20">{{item.afterPosition ? item.afterPosition.name : ''}}</span>
                                                 </div>
                                                 <div v-if="getTransfers().length === 0" class="no-data">暂无记录</div>
                                            </div>
                                        </div>
                                        <div class="small-box table-box">
                                            <div class="box-title">晋升/降级记录</div>
                                            <div class="box-content">
                                                 <div class="mini-table-header">
                                                     <span style="flex: 3">日期</span>
                                                     <span style="flex: 3">前职位</span>
                                                     <span style="flex: 3">后职位</span>
                                                     <span style="flex: 2">类型</span>
                                                 </div>
                                                 <div class="mini-table-row" v-for="item in getPromotions()" :key="item.id">
                                                     <span style="flex: 3">{{formatDate(item.removeDate)}}</span>
                                                     <span style="flex: 3">{{item.beforePosition ? item.beforePosition.name : ''}}</span>
                                                     <span style="flex: 3">{{item.afterPosition ? item.afterPosition.name : ''}}</span>
                                                     <span style="flex: 2">{{item.operateType == 0 ? '晋升' : '降级'}}</span>
                                                 </div>
                                                 <div v-if="getPromotions().length === 0" class="no-data">暂无记录</div>
                                            </div>
                                        </div>
                                        <div class="small-box table-box">
                                            <div class="box-title">评优</div>
                                            <div class="box-content">
                                                 <div class="mini-table-header">
                                                     <span style="flex: 3">日期</span>
                                                     <span style="flex: 7">说明</span>
                                                 </div>
                                                 <div class="mini-table-row" v-for="item in (rosterData.appraisals || [])" :key="item.id">
                                                     <span style="flex: 3">{{formatDate(item.appDate)}}</span>
                                                     <span style="flex: 7">{{item.appResult}}</span>
                                                 </div>
                                                 <div v-if="(!rosterData.appraisals || rosterData.appraisals.length === 0)" class="no-data">暂无记录</div>
                                            </div>
                                        </div>
                                        <div class="small-box table-box">
                                            <div class="box-title">奖惩记录</div>
                                            <div class="box-content">
                                                 <div class="mini-table-header">
                                                     <span style="flex: 3">日期</span>
                                                     <span style="flex: 2">类型</span>
                                                     <span style="flex: 5">说明</span>
                                                 </div>
                                                 <div class="mini-table-row" v-for="item in (rosterData.ecs || [])" :key="item.id">
                                                     <span style="flex: 3">{{formatDate(item.ecDate)}}</span>
                                                     <span style="flex: 2">{{item.ecType == 0 ? '奖励' : '惩罚'}}</span>
                                                     <span style="flex: 5">{{item.ecReason}}</span>
                                                 </div>
                                                 <div v-if="(!rosterData.ecs || rosterData.ecs.length === 0)" class="no-data">暂无记录</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Contract Info -->
                            <div class="timeline-item">
                                <div class="timeline-left">
                                    <div class="timeline-icon">合同<br>信息</div>
                                    <div class="timeline-line"></div>
                                </div>
                                <div class="timeline-content contract-box-bg">
                                    <div class="info-row">
                                        <div class="info-item"><span class="label">用工类型:</span> {{rosterData.contract ? rosterData.contract.employmentType : ''}}</div>
                                        <div class="info-item"><span class="label">合同期限类型:</span> {{rosterData.contract ? rosterData.contract.contractType : ''}}</div>
                                    </div>
                                    <div class="info-row">
                                        <div class="info-item"><span class="label">签订次数:</span> {{rosterData.contract ? rosterData.contract.signCount : ''}}</div>
                                        <div class="info-item"><span class="label">合同文件扫描件:</span> {{(rosterData.contract && rosterData.contract.attachments) ? '已上传' : '未上传'}}</div>
                                    </div>
                                    <div class="contract-list">
                                        <div class="contract-row">
                                            <div class="c-num">01</div>
                                            <div class="c-detail">首次签订日期: {{rosterData.contract ? formatDate(rosterData.contract.firstSignDate) : ''}}</div>
                                            <div class="c-detail">首次签订期限(年): {{rosterData.contract ? rosterData.contract.firstSignTerm : ''}}</div>
                                            <div class="c-detail">合同终止日期: {{rosterData.contract ? formatDate(rosterData.contract.endDate) : ''}}</div>
                                        </div>
                                        <div class="contract-row">
                                            <div class="c-num">02</div>
                                            <div class="c-detail">二次签订日期: {{rosterData.contract ? formatDate(rosterData.contract.secondSignDate) : ''}}</div>
                                            <div class="c-detail">二次签订期限(年): {{rosterData.contract ? rosterData.contract.secondSignTerm : ''}}</div>
                                            <div class="c-detail">合同终止日期: {{calculateContractEndDate(rosterData.contract ? rosterData.contract.secondSignDate : null, rosterData.contract ? rosterData.contract.secondSignTerm : null)}}</div>
                                        </div>
                                        <div class="contract-row">
                                            <div class="c-num">03</div>
                                            <div class="c-detail">三次签订日期: {{rosterData.contract ? formatDate(rosterData.contract.thirdSignDate) : ''}}</div>
                                            <div class="c-detail">三次签订期限(年): {{(rosterData.contract && rosterData.contract.thirdSignDate) ? '∞' : ''}}</div>
                                            <div class="c-detail">合同终止日期: {{(rosterData.contract && rosterData.contract.thirdSignDate) ? '∞' : ''}}</div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="timeline-item">
                                <div class="timeline-left">
                                    <div class="timeline-icon">考勤<br>休假</div>
                                    <div class="timeline-line"></div>
                                </div>
                                <div class="timeline-content attendance-box-bg">
                                    <div style="font-size: 12px; font-weight: bold; color: #00008B; margin-bottom: 5px;">{{new Date().getFullYear()}}年度汇总</div>
                                    <div class="info-row">
                                        <div class="info-item"><span class="label">迟到/早退:</span> {{getAttendanceSum('lateEarlyLeaveTimes')}}次</div>
                                        <div class="info-item"><span class="label">缺卡:</span> {{getAttendanceSum('missingCardTimes')}}次</div>
                                        <div class="info-item"><span class="label">加班:</span> {{getAttendanceSum('overtimeHours')}}h</div>
                                        <div class="info-item"><span class="label">调休:</span> {{getAttendanceSum('compLeaveHours')}}h</div>
                                    </div>
                                    <div class="info-row">
                                        <div class="info-item"><span class="label">年假:</span> {{getAttendanceSum('annualLeaveDays')}}天</div>
                                        <div class="info-item"><span class="label">病假:</span> {{getAttendanceSum('sickLeaveDays')}}天</div>
                                        <div class="info-item"><span class="label">事假:</span> {{getAttendanceSum('personalLeaveDays')}}天</div>
                                        <div class="info-item"><span class="label">婚假:</span> {{getAttendanceSum('marriageLeaveDays')}}天</div>
                                    </div>
                                    <div class="info-row">
                                        <div class="info-item"><span class="label">产假:</span> {{getAttendanceSum('maternityLeaveDays')}}天</div>
                                        <div class="info-item"><span class="label">陪产假:</span> {{getAttendanceSum('paternityLeaveDays')}}天</div>
                                        <div class="info-item"><span class="label">丧假:</span> {{getAttendanceSum('funeralLeaveDays')}}天</div>
                                        <div class="info-item"><span class="label">工伤假:</span> {{getAttendanceSum('workInjuryLeaveDays')}}天</div>
                                    </div>
                                    <div class="info-row">
                                        <div class="info-item"><span class="label">产检假:</span> {{getAttendanceSum('prenatalCheckLeaveHours')}}h</div>
                                        <div class="info-item"><span class="label">哺乳假:</span> {{getAttendanceSum('breastfeedingLeaveHours')}}h</div>
                                        <div class="info-item"><span class="label">育儿假:</span> {{getAttendanceSum('childcareLeaveHours')}}h</div>
                                    </div>
                                </div>
                            </div>

                            <!-- Performance -->
                            <div class="timeline-item">
                                <div class="timeline-left">
                                    <div class="timeline-icon">绩效<br>考核</div>
                                </div>
                                <div class="timeline-content performance-box-bg">
                                    <div class="perf-grid">
                                        <div class="perf-cell" style="width: 60px; flex: none;">
                                            <div class="perf-month">所属月</div>
                                            <div class="perf-score" style="font-weight: bold; color: #00008B;">考核结果</div>
                                        </div>
                                        <div class="perf-cell" v-for="m in 12" :key="m">
                                            <div class="perf-month">{{m}}月</div>
                                            <div class="perf-score">{{getPerformanceMonth(m)}}</div>
                                        </div>
                                    </div>
                                    <div class="info-row mt-10">
                                        <div class="info-item full-width">
                                            <span class="label">内部管理评分(仅高管):</span>
                                            <span class="exec-score-box">
                                                <span class="exec-score-item" v-for="q in 4" :key="q">
                                                    {{ getExecQuarterScore(q) }}
                                                </span>
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Column 3 -->
                        <div class="roster-column">
                            <div class="col-header-wrapper">
                                <div class="header-num">03</div>
                                <div class="header-title-box">
                                    <div class="main-title">员工访谈</div>
                                </div>
                            </div>

                            <!-- Interview Records: Probation -->
                            <div class="timeline-item">
                                <div class="timeline-left">
                                    <div class="timeline-icon">试用期<br>访谈</div>
                                    <div class="timeline-line"></div>
                                </div>
                                <div class="timeline-content interview-box-bg">
                                    <table style="width: 100%; border-collapse: collapse; font-size: 12px;">
                                        <thead>
                                            <tr>
                                                <th style="border: 1px solid #999; padding: 5px; color: #00008B; width: 100px;">日期</th>
                                                <th style="border: 1px solid #999; padding: 5px; color: #00008B;">访谈内容</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                             <tr v-for="item in getInterviews([0])" :key="item.id">
                                                 <td style="border: 1px solid #999; padding: 5px; vertical-align: top;">{{formatDate(item.interviewDate)}}</td>
                                                 <td style="border: 1px solid #999; padding: 5px; vertical-align: top;">{{item.content}}</td>
                                             </tr>
                                             <tr v-if="getInterviews([0]).length === 0">
                                                 <td colspan="2" style="border: 1px solid #999; padding: 5px; text-align: center;">暂无记录</td>
                                             </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>

                            <!-- Interview Records: Contract Renewal -->
                            <div class="timeline-item">
                                <div class="timeline-left">
                                    <div class="timeline-icon">合同<br>续签</div>
                                    <div class="timeline-line"></div>
                                </div>
                                <div class="timeline-content interview-box-bg">
                                    <table style="width: 100%; border-collapse: collapse; font-size: 12px;">
                                        <thead>
                                            <tr>
                                                <th style="border: 1px solid #999; padding: 5px; color: #00008B; width: 100px;">日期</th>
                                                <th style="border: 1px solid #999; padding: 5px; color: #00008B;">访谈内容</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                             <tr v-for="item in getInterviews([1])" :key="item.id">
                                                 <td style="border: 1px solid #999; padding: 5px; vertical-align: top;">{{formatDate(item.interviewDate)}}</td>
                                                 <td style="border: 1px solid #999; padding: 5px; vertical-align: top;">{{item.content}}</td>
                                             </tr>
                                             <tr v-if="getInterviews([1]).length === 0">
                                                 <td colspan="2" style="border: 1px solid #999; padding: 5px; text-align: center;">暂无记录</td>
                                             </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>

                            <!-- Performance Interview -->
                            <div class="timeline-item">
                                <div class="timeline-left">
                                    <div class="timeline-icon">绩效<br>访谈</div>
                                </div>
                                <div class="timeline-content interview-box-bg">
                                    <table style="width: 100%; border-collapse: collapse; font-size: 12px;">
                                        <thead>
                                            <tr>
                                                <th style="border: 1px solid #999; padding: 5px; color: #00008B; width: 100px;">日期</th>
                                                <th style="border: 1px solid #999; padding: 5px; color: #00008B;">访谈内容</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                             <tr v-for="item in getInterviews([2])" :key="item.id">
                                                 <td style="border: 1px solid #999; padding: 5px; vertical-align: top;">{{formatDate(item.interviewDate)}}</td>
                                                 <td style="border: 1px solid #999; padding: 5px; vertical-align: top;">{{item.content}}</td>
                                             </tr>
                                             <tr v-if="getInterviews([2]).length === 0">
                                                 <td colspan="2" style="border: 1px solid #999; padding: 5px; text-align: center;">暂无记录</td>
                                             </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>

                            <!-- Footer: Internal Training -->
                    <div class="roster-footer">
                        <div class="footer-left" style="background-color: #00008B;">
                            <div class="footer-icon">内部<br>培训</div>
                        </div>
                        <div class="footer-content">
                            <div class="training-header" style="color: #00008B;">{{new Date().getFullYear()}}年度参加培训场次: {{rosterData.trains ? rosterData.trains.length : 0}}</div>
                            <div class="training-timeline" style="border-color: #00008B;">
                                <!-- Header Column -->
                                <div class="t-cell header-cell" style="border-right-color: #00008B; display: flex; flex-direction: column; height: 60px; width: 80px; flex: none; background: #e6e6fa;">
                                    <div class="t-top" style="flex: 1; border-bottom: 1px solid #00008B; color: #00008B; font-size: 10px; display: flex; flex-direction: column; align-items: center; justify-content: center; padding: 2px; line-height: 1.2; font-weight: bold;">
                                        <span>培训日期</span>
                                        <span>课程名称</span>
                                    </div>
                                    <div class="t-bottom" style="height: 20px; display: flex; align-items: center; justify-content: center; font-size: 10px; color: #00008B; font-weight: bold;">
                                        课程得分
                                    </div>
                                </div>

                                <div class="t-cell" v-for="(t, index) in (rosterData.trains || [])" :key="index" style="border-right-color: #00008B; display: flex; flex-direction: column; height: 60px;">
                                    <div class="t-top" style="flex: 1; border-bottom: 1px solid #00008B; color: #00008B; font-size: 10px; display: flex; flex-direction: column; align-items: center; justify-content: center; padding: 2px; line-height: 1.2;">
                                        <span>{{formatDate(t.traindate).substring(5, 10)}}</span>
                                        <span style="overflow: hidden; text-overflow: ellipsis; white-space: nowrap; max-width: 100%;">{{t.traincontent}}</span>
                                    </div>
                                    <div class="t-bottom" style="height: 20px; display: flex; align-items: center; justify-content: center; font-size: 10px; color: #00008B; font-weight: bold;">
                                        {{t.score}}分
                                    </div>
                                </div>
                                <div class="t-cell" v-for="i in (10 - (rosterData.trains ? rosterData.trains.length : 0))" :key="'empty'+i" style="border-right-color: #00008B; display: flex; flex-direction: column; height: 60px;">
                                    <div class="t-top" style="flex: 1; border-bottom: 1px solid #00008B;">&nbsp;</div>
                                    <div class="t-bottom" style="height: 20px;">&nbsp;</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </el-dialog>
    </div>
</template>

<script>
    import html2canvas from 'html2canvas';

    export default {
        name: "PerEmp",
        data() {
            return {
                emps: [],
                loading: false,
                total: 0,
                page: 1,
                size: 10,
                keyword: '',
                dialogVisible: false,
                rosterData: null,
                currentEid: ''
            }
        },
        mounted() {
            this.initEmps();
        },
        methods: {
            sizeChange(currentSize) {
                this.size = currentSize;
                this.initEmps();
            },
            currentChange(currentPage) {
                this.page = currentPage;
                this.initEmps();
            },
            initEmps() {
                this.loading = true;
                let url = '/personnel/emp/?page=' + this.page + '&size=' + this.size + "&name=" + this.keyword;
                this.getRequest(url).then(resp => {
                    this.loading = false;
                    if (resp) {
                        this.emps = resp.data;
                        this.total = resp.total;
                    }
                });
            },
            showRoster(data) {
                this.currentEid = data.idCard;
                this.getRequest("/personnel/emp/roster/data/" + data.idCard).then(resp => {
                    if (resp) {
                        this.rosterData = resp;
                        this.dialogVisible = true;
                    }
                });
            },
            downloadRoster() {
                // Ensure DOM is rendered
                this.$nextTick(() => {
                    let element = document.getElementById("roster-container");
                    html2canvas(element, {
                        useCORS: true,
                        scale: 2 // Higher resolution
                    }).then(canvas => {
                        let link = document.createElement("a");
                        link.href = canvas.toDataURL("image/png");
                        link.download = this.rosterData.employee.name + "_花名册.png";
                        link.click();
                    });
                });
            },
            formatDate(dateStr) {
                if (!dateStr) return '';
                if (typeof dateStr === 'string' && dateStr.length >= 10) {
                    return dateStr.substring(0, 10);
                }
                return dateStr;
            },
            calculateAge(birthday) {
                if (!birthday) return '';
                let birthDate = new Date(birthday);
                let today = new Date();
                let age = today.getFullYear() - birthDate.getFullYear();
                let m = today.getMonth() - birthDate.getMonth();
                if (m < 0 || (m === 0 && today.getDate() < birthDate.getDate())) {
                    age--;
                }
                return age;
            },
            getPerformanceMonth(m) {
                if (!this.rosterData || !this.rosterData.performance) return '';
                return this.rosterData.performance['month' + m] || '';
            },
            getExecQuarterScore(q) {
                if (!this.rosterData || !this.rosterData.execPerformance) return '';
                const val = this.rosterData.execPerformance['quarter' + q];
                return val != null ? val : '';
            },
            getTransfers() {
                if (!this.rosterData || !this.rosterData.removes) return [];
                return this.rosterData.removes.filter(item => item.operateType === 2);
            },
            getPromotions() {
                if (!this.rosterData || !this.rosterData.removes) return [];
                return this.rosterData.removes.filter(item => item.operateType === 0 || item.operateType === 1);
            },
            getInterviews(types) {
                if (!this.rosterData || !this.rosterData.interviews) return [];
                return this.rosterData.interviews.filter(item => types.includes(item.type));
            },
            parseAttachments(urlStr) {
                if (!urlStr) return [];
                try {
                    if (urlStr.startsWith('[')) {
                        return JSON.parse(urlStr);
                    } else {
                        return [];
                    }
                } catch (e) {
                    return [];
                }
            },
            isImage(url) {
                if (!url) return false;
                const ext = url.substring(url.lastIndexOf('.') + 1).toLowerCase();
                return ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'].includes(ext);
            },
            downloadFile(url) {
                window.open(url, '_blank');
            },
            calculateContractEndDate(startDate, term) {
                if (!startDate || !term) return '';
                let start = new Date(startDate);
                let year = start.getFullYear();
                let month = start.getMonth();
                let day = start.getDate();
                let termNum = parseFloat(term);
                if (isNaN(termNum)) return '';
                
                // Add years
                let endYear = year + Math.floor(termNum);
                let remainingTerm = termNum - Math.floor(termNum);
                let endMonth = month;
                
                // Simple logic: just add years. 
                // Ideally we should handle months if term is 1.5 etc, but term is usually integer.
                // Assuming term is integer years for now as per typical contract logic
                
                let endDate = new Date(endYear, endMonth, day);
                // Contract usually ends 1 day before the anniversary
                endDate.setDate(endDate.getDate() - 1);
                
                let y = endDate.getFullYear();
                let m = (endDate.getMonth() + 1).toString().padStart(2, '0');
                let d = endDate.getDate().toString().padStart(2, '0');
                return `${y}-${m}-${d}`;
            },
            getAttendanceSum(prop) {
                if (!this.rosterData || !this.rosterData.attendanceLeaves) return 0;
                let currentYear = new Date().getFullYear();
                let sum = 0;
                this.rosterData.attendanceLeaves.forEach(item => {
                    if (item.year === currentYear) {
                        let val = item[prop];
                        if (val) sum += parseFloat(val);
                    }
                });
                // Format to remove unnecessary decimals
                return parseFloat(sum.toFixed(2));
            }
        }
    }
</script>

<style scoped>
.roster-container {
    background: white;
    padding: 30px;
    min-width: 1600px; /* Increase width to ensure everything fits */
    width: 1600px;
    margin: 0 auto;
    font-family: "Microsoft YaHei", "SimHei", sans-serif;
    color: #333;
    position: relative;
}

/* Top Header */
.roster-top-header {
    display: flex;
    justify-content: flex-end;
    margin-bottom: 20px;
    padding-right: 20px;
}
.top-user-info {
    display: flex;
    align-items: center;
}
.user-avatar {
    font-size: 40px;
    color: #409EFF;
    margin-right: 15px;
}
.user-name-large {
    font-size: 32px;
    font-weight: bold;
    color: #409EFF;
}

/* Layout */
.roster-body {
    display: flex;
    justify-content: space-between;
    margin-bottom: 30px;
}
.roster-column {
    width: 32%;
}

/* Column Header */
.col-header-wrapper {
    display: flex;
    align-items: center;
    margin-bottom: 25px;
}
.header-num {
    width: 60px;
    height: 60px;
    border: 3px solid #00008B; /* Dark Blue */
    border-radius: 10px;
    color: #00008B; /* Dark Blue */
    font-size: 36px;
    font-weight: bold;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-right: -10px; /* Overlap */
    z-index: 2;
    background: white;
}
.header-title-box {
    background: #00008B; /* Dark Blue */
    color: white;
    height: 50px;
    border-radius: 0 25px 25px 0;
    padding: 5px 20px 5px 30px; /* Left padding for overlap */
    display: flex;
    flex-direction: column;
    justify-content: center;
    flex: 1;
}
.main-title {
    font-size: 18px;
    font-weight: bold;
}
.sub-title-text {
    font-size: 12px;
}

/* Timeline */
.timeline-item {
    display: flex;
    margin-bottom: 10px;
}
.timeline-left {
    width: 60px;
    display: flex;
    flex-direction: column;
    align-items: center;
    margin-right: 10px;
}
.timeline-icon {
    width: 50px;
    height: 50px;
    background: #00008B; /* Dark Blue */
    border-radius: 50%;
    color: white;
    font-size: 12px;
    display: flex;
    align-items: center;
    justify-content: center;
    text-align: center;
    line-height: 1.2;
    z-index: 1;
    font-weight: bold;
}
.timeline-line {
    flex: 1;
    border-left: 2px dotted #ccc;
    margin-top: 5px;
    margin-bottom: 5px;
}
.timeline-content {
    flex: 1;
    padding-top: 5px;
    padding-bottom: 15px;
}

/* Info Row */
.info-row {
    display: flex;
    margin-bottom: 6px;
    font-size: 12px;
    line-height: 1.5;
}
.info-item {
    flex: 1;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
}
.info-item.full-width {
    flex: 100%;
}
.info-item .label {
    color: #00008B; /* Dark Blue */
    font-weight: bold;
    margin-right: 5px;
}
.mt-10 {
    margin-top: 10px;
}

/* Specific Boxes */
.education-box, .attendance-box-bg, .contract-box-bg, .interview-box-bg {
    background: #e6e6fa; /* Light lavender/blueish for contrast */
    padding: 10px;
    border-radius: 8px;
}
.text-content {
    font-size: 12px;
    color: #606266;
    margin-top: 5px;
}

/* Four Boxes Grid */
.four-boxes {
    display: flex;
    flex-wrap: wrap;
    justify-content: space-between;
    margin-top: 10px;
}
.small-box {
    width: 48%;
    background: #e6e6fa;
    border-radius: 5px;
    padding: 10px;
    margin-bottom: 10px;
    text-align: center;
    font-size: 12px;
    font-weight: bold;
    color: #00008B; /* Dark Blue */
    min-height: 60px;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
}
.box-detail {
    font-size: 10px;
    font-weight: normal;
    color: #333;
    margin-top: 5px;
}

/* Contract List */
.contract-list {
    margin-top: 10px;
}
.contract-row {
    background: #e6e6fa;
    border-radius: 5px;
    padding: 5px;
    margin-bottom: 5px;
    display: flex;
    align-items: center;
    font-size: 10px;
}
.c-num {
    font-weight: bold;
    color: #00008B; /* Dark Blue */
    margin-right: 5px;
    font-size: 14px;
}
.c-detail {
    margin-right: 10px;
}

/* Performance Grid */
.performance-box-bg {
    background: white; /* Or light blue? */
    border: 1px solid #EBEEF5;
    border-radius: 8px;
    padding: 10px;
}
.perf-grid {
    display: flex;
    flex-wrap: nowrap; /* Force single line */
    border: 1px solid #00008B; /* Dark Blue */
    border-radius: 5px;
    overflow: hidden;
}
.perf-cell {
    flex: 1; /* Equal width */
    border-right: 1px solid #00008B; /* Dark Blue */
    text-align: center;
}
.perf-cell:last-child {
    border-right: none;
}
.perf-month {
    background: #e6e6fa;
    color: #00008B; /* Dark Blue */
    font-size: 12px;
    padding: 2px 0;
    border-bottom: 1px solid #00008B; /* Dark Blue */
    white-space: nowrap;
}
.perf-score {
    font-size: 12px;
    padding: 5px 0;
    min-height: 20px;
}
.exec-score-box {
    display: inline-block;
    margin-left: 10px;
}
.exec-score-item {
    display: inline-block;
    width: 40px;
    height: 18px; /* Fixed height for consistent underline */
    text-align: center;
    border-bottom: 1px solid #333; /* Single underline */
    margin-right: 10px;
    font-weight: bold;
}

/* Interview */
.interview-block {
    background: #e6e6fa;
    border-radius: 5px;
    padding: 8px;
}
.interview-title {
    font-weight: bold;
    color: #333;
    margin-bottom: 5px;
    font-size: 13px;
}
.interview-text {
    font-size: 12px;
    color: #606266;
    line-height: 1.4;
}
.interview-empty-box {
    height: 40px;
    background: #c6e2ff; /* Darker placeholder */
    border-radius: 3px;
}
.interview-empty-box.large {
    height: 150px;
    background: #e6e6fa;
}

/* Footer */
.roster-footer {
    display: flex;
    margin-top: 20px;
    border: 1px solid #00008B; /* Dark Blue */
    background: #e6e6fa;
    border-radius: 10px;
    padding: 10px;
}
.footer-left {
    width: 80px;
    display: flex;
    justify-content: center;
    align-items: center;
    background: #00008B; /* Dark Blue */
    border-radius: 50%;
    width: 60px;
    height: 60px;
    color: white;
    font-size: 12px;
    text-align: center;
    font-weight: bold;
    margin-right: 20px;
}
.footer-icon {
    line-height: 1.2;
}
.footer-content {
    flex: 1;
}
.training-header {
    font-weight: bold;
    color: #00008B; /* Dark Blue */
    margin-bottom: 5px;
}
.training-timeline {
    display: flex;
    border: 1px solid #00008B; /* Dark Blue */
    background: white;
}
.t-cell {
    flex: 1;
    border-right: 1px solid #00008B; /* Dark Blue */
    height: 40px;
}
.t-cell:last-child {
    border-right: none;
}

/* Table Box Styles */
.table-box {
    display: block !important; /* Override flex */
    padding: 0 !important;
    overflow: hidden;
}
.box-title {
    background: #00008B;
    color: white;
    padding: 5px;
    font-size: 12px;
    font-weight: bold;
    text-align: center;
}
.box-content {
    padding: 5px;
    background: white;
}
.mini-table-header {
    display: flex;
    font-size: 10px; /* Smaller font for headers */
    font-weight: bold;
    color: #00008B;
    border-bottom: 1px solid #eee;
    padding-bottom: 2px;
    margin-bottom: 2px;
}
.mini-table-row {
    display: flex;
    font-size: 10px; /* Very small font for content */
    margin-bottom: 2px;
    color: #333;
    line-height: 1.2;
}
.mini-table-row span, .mini-table-header span {
    padding-right: 2px;
    word-break: break-all;
    white-space: normal;
}
.no-data {
    text-align: center;
    color: #999;
    font-size: 10px;
    margin-top: 10px;
}
</style>
