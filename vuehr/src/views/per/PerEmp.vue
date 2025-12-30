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
                <el-table-column prop="workID" label="工号" align="left" width="85"></el-table-column>
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
                                        <div class="info-item full-width"><span class="label">身份证:</span> {{rosterData.employee.idCard}}</div>
                                    </div>
                                    <div class="info-row">
                                        <div class="info-item"><span class="label">身份证开始日期:</span> {{formatDate(rosterData.employee.idCardStartDate)}}</div>
                                        <div class="info-item"><span class="label">身份证结束日期:</span> {{formatDate(rosterData.employee.idCardEndDate)}}</div>
                                    </div>
                                    <div class="info-row">
                                        <div class="info-item"><span class="label">政治面貌:</span> {{rosterData.employee.politicsstatus ? rosterData.employee.politicsstatus.name : ''}}</div>
                                        <div class="info-item"><span class="label">户口类别:</span> (空)</div>
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
                                        <div class="info-item full-width"><span class="label">工作邮箱:</span> (空)</div>
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
                                        <div class="info-item full-width"><span class="label">培训经历:</span></div>
                                        <div class="text-content">{{rosterData.employee.trainingHistory || '(无)'}}</div>
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
                                        <div class="small-box">内部调动记录</div>
                                        <div class="small-box">晋升/降级记录</div>
                                        <div class="small-box">
                                            <div>评优</div>
                                            <div class="box-detail">月度之星: (空)</div>
                                        </div>
                                        <div class="small-box">
                                            <div>奖惩记录</div>
                                            <div class="box-detail">客户通报表扬</div>
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
                                        <div class="info-item"><span class="label">续签次数:</span> {{rosterData.contract ? rosterData.contract.signCount : ''}}</div>
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
                                            <div class="c-detail">合同终止日期:</div>
                                        </div>
                                        <div class="contract-row">
                                            <div class="c-num">03</div>
                                            <div class="c-detail">三次签订日期: {{rosterData.contract ? formatDate(rosterData.contract.thirdSignDate) : ''}}</div>
                                            <div class="c-detail">三次签订期限(年):</div>
                                            <div class="c-detail">合同终止日期:</div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Attendance -->
                            <div class="timeline-item">
                                <div class="timeline-left">
                                    <div class="timeline-icon">考勤<br>休假</div>
                                    <div class="timeline-line"></div>
                                </div>
                                <div class="timeline-content attendance-box-bg">
                                    <div class="info-row">
                                        <div class="info-item"><span class="label">迟到/早退:</span> (空)</div>
                                        <div class="info-item"><span class="label">加班(小时):</span> (空)</div>
                                        <div class="info-item"><span class="label">年假(天):</span> (空)</div>
                                        <div class="info-item"><span class="label">病假(天):</span> (空)</div>
                                    </div>
                                    <div class="info-row">
                                        <div class="info-item"><span class="label">事假(天):</span> (空)</div>
                                        <div class="info-item"><span class="label">婚假(天):</span> (空)</div>
                                        <div class="info-item"><span class="label">产检假(小时):</span> (空)</div>
                                        <div class="info-item"><span class="label">产假(天):</span> (空)</div>
                                    </div>
                                    <div class="info-row">
                                        <div class="info-item"><span class="label">陪产假(天):</span> (空)</div>
                                        <div class="info-item"><span class="label">育儿假(小时):</span> (空)</div>
                                        <div class="info-item"><span class="label">丧假(天):</span> (空)</div>
                                        <div class="info-item"><span class="label">调休(小时):</span> (空)</div>
                                    </div>
                                </div>
                            </div>

                            <!-- Performance -->
                            <div class="timeline-item">
                                <div class="timeline-left">
                                    <div class="timeline-icon">绩效<br>管理</div>
                                </div>
                                <div class="timeline-content performance-box-bg">
                                    <div class="perf-grid">
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

                            <!-- Interview Records -->
                            <div class="timeline-item">
                                <div class="timeline-left">
                                    <div class="timeline-icon">面谈<br>记录</div>
                                    <div class="timeline-line"></div>
                                </div>
                                <div class="timeline-content interview-box-bg">
                                    <div class="interview-block">
                                        <div class="interview-title">试用期3个月</div>
                                        <div class="interview-text">
                                            (暂无记录)
                                        </div>
                                    </div>
                                    <div class="interview-block mt-10">
                                        <div class="interview-title">转正前(5个月)</div>
                                        <div class="interview-empty-box"></div>
                                    </div>
                                    <div class="interview-block mt-10">
                                        <div class="interview-title">入职三年</div>
                                        <div class="interview-empty-box"></div>
                                    </div>
                                    <div class="interview-block mt-10">
                                        <div class="interview-title">入职六/八年</div>
                                        <div class="interview-empty-box"></div>
                                    </div>
                                </div>
                            </div>

                            <!-- Performance Interview -->
                            <div class="timeline-item">
                                <div class="timeline-left">
                                    <div class="timeline-icon">绩效<br>访谈</div>
                                </div>
                                <div class="timeline-content">
                                    <div class="interview-empty-box large"></div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Footer: Internal Training -->
                    <div class="roster-footer">
                        <div class="footer-left">
                            <div class="footer-icon">内部<br>培训</div>
                        </div>
                        <div class="footer-content">
                            <div class="training-header">2025年度参加培训场次: 0/0</div>
                            <div class="training-timeline">
                                <div class="t-cell" v-for="i in 10" :key="i">
                                    <div class="t-date">&nbsp;</div>
                                    <div class="t-status">&nbsp;</div>
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
    border: 3px solid #409EFF;
    border-radius: 10px;
    color: #409EFF;
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
    background: #409EFF; /* Gradient in image? Flat blue is safer */
    background: linear-gradient(to right, #6faefc, #409eff);
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
    background: #2c3e50; /* Dark blue/Navy */
    background: #409EFF;
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
    color: #409EFF;
    font-weight: bold;
    margin-right: 5px;
}
.mt-10 {
    margin-top: 10px;
}

/* Specific Boxes */
.education-box, .attendance-box-bg, .contract-box-bg, .interview-box-bg {
    background: #ecf5ff;
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
    background: #d9ecff;
    border-radius: 5px;
    padding: 10px;
    margin-bottom: 10px;
    text-align: center;
    font-size: 12px;
    font-weight: bold;
    color: #409EFF;
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
    background: #d9ecff;
    border-radius: 5px;
    padding: 5px;
    margin-bottom: 5px;
    display: flex;
    align-items: center;
    font-size: 10px;
}
.c-num {
    font-weight: bold;
    color: #409EFF;
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
    border: 1px solid #409EFF;
    border-radius: 5px;
    overflow: hidden;
}
.perf-cell {
    flex: 1; /* Equal width */
    border-right: 1px solid #409EFF;
    text-align: center;
}
.perf-cell:last-child {
    border-right: none;
}
.perf-month {
    background: #ecf5ff;
    color: #409EFF;
    font-size: 12px;
    padding: 2px 0;
    border-bottom: 1px solid #409EFF;
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
    background: #d9ecff;
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
    background: #ecf5ff;
}

/* Footer */
.roster-footer {
    display: flex;
    margin-top: 20px;
    border: 1px solid #409EFF; /* Or just timeline */
    background: #ecf5ff;
    border-radius: 10px;
    padding: 10px;
}
.footer-left {
    width: 80px;
    display: flex;
    justify-content: center;
    align-items: center;
    background: #2c3e50; /* Dark circle */
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
    color: #409EFF;
    margin-bottom: 5px;
}
.training-timeline {
    display: flex;
    border: 1px solid #409EFF;
    background: white;
}
.t-cell {
    flex: 1;
    border-right: 1px solid #409EFF;
    height: 40px;
}
.t-cell:last-child {
    border-right: none;
}
</style>
