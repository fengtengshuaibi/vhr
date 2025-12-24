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
                    <div class="roster-header">
                        <div class="user-info">
                            <i class="fa fa-user-circle"></i> {{rosterData.employee.name}}
                        </div>
                    </div>
                    
                    <div class="roster-content">
                        <!-- Column 1 -->
                        <div class="roster-column">
                        <div class="section-header">
                            <span class="section-num">01</span>
                            <span class="section-title">入职前信息(招聘与入职阶段)</span>
                        </div>
                        
                        <div class="sub-section">
                            <div class="sub-title"><span class="icon"></span>基础信息</div>
                            <div class="field-row">
                                <div class="field"><span>姓名:</span> {{rosterData.employee.name}}</div>
                                <div class="field"><span>性别:</span> {{rosterData.employee.gender}}</div>
                            </div>
                            <div class="field-row">
                                <div class="field"><span>身份证:</span> {{rosterData.employee.idCard}}</div>
                            </div>
                            <div class="field-row">
                                <div class="field"><span>出生日期:</span> {{formatDate(rosterData.employee.birthday)}}</div>
                                <div class="field"><span>民族:</span> {{rosterData.employee.nation ? rosterData.employee.nation.name : ''}}</div>
                            </div>
                            <div class="field-row">
                                <div class="field"><span>政治面貌:</span> {{rosterData.employee.politicsstatus ? rosterData.employee.politicsstatus.name : ''}}</div>
                            </div>
                            <div class="field-row">
                                <div class="field"><span>籍贯:</span> {{rosterData.employee.nativePlace}}</div>
                            </div>
                            <div class="field-row">
                                <div class="field"><span>联系方式:</span> {{rosterData.employee.phone}}</div>
                            </div>
                            <div class="field-row">
                                <div class="field"><span>邮箱:</span> {{rosterData.employee.email}}</div>
                            </div>
                            <div class="field-row">
                                <div class="field"><span>居住地址:</span> {{rosterData.employee.address}}</div>
                            </div>
                            <div class="field-row">
                                <div class="field"><span>紧急联系人:</span> {{rosterData.employee.emergencyContact}}</div>
                                <div class="field"><span>紧急电话:</span> {{rosterData.employee.emergencyContactPhone}}</div>
                            </div>
                        </div>

                        <div class="sub-section">
                            <div class="sub-title"><span class="icon"></span>敏感信息</div>
                            <div class="field-row">
                                <div class="field"><span>婚姻状况:</span> {{rosterData.employee.wedlock}}</div>
                                <div class="field"><span>生育状况:</span> {{rosterData.employee.fertilityStatus}}</div>
                            </div>
                            <div class="field-row">
                                <div class="field"><span>子女信息:</span> {{rosterData.employee.childrenInfo}}</div>
                            </div>
                        </div>

                        <div class="sub-section">
                            <div class="sub-title"><span class="icon"></span>教育资质</div>
                            <div class="field-row">
                                <div class="field"><span>最高学历:</span> {{rosterData.employee.tiptopDegree}}</div>
                                <div class="field"><span>毕业院校:</span> {{rosterData.employee.school}}</div>
                            </div>
                            <div class="field-row">
                                <div class="field"><span>专业:</span> {{rosterData.employee.specialty}}</div>
                            </div>
                            <div class="field-row">
                                <div class="field"><span>毕业时间:</span> {{formatDate(rosterData.employee.graduationDate)}}</div>
                            </div>
                            <div class="field-row">
                                <div class="field"><span>资格证书:</span> {{rosterData.employee.certificate}}</div>
                            </div>
                            <div class="field-row">
                                <div class="field"><span>培训经历:</span> {{rosterData.employee.trainingHistory}}</div>
                            </div>
                        </div>

                        <div class="sub-section">
                            <div class="sub-title"><span class="icon"></span>工作经历</div>
                            <div class="field-row">
                                <div class="field"><span>原单位:</span> {{rosterData.employee.previousCompany}}</div>
                            </div>
                            <div class="field-row">
                                <div class="field"><span>原职位:</span> {{rosterData.employee.previousPosition}}</div>
                            </div>
                            <div class="field-row">
                                <div class="field"><span>起止时间:</span> {{rosterData.employee.previousStartEnd}}</div>
                            </div>
                            <div class="field-row">
                                <div class="field"><span>离职原因:</span> {{rosterData.employee.previousResignationReason}}</div>
                            </div>
                            <div class="field-row">
                                <div class="field"><span>证明人:</span> {{rosterData.employee.reference}}</div>
                                <div class="field"><span>电话:</span> {{rosterData.employee.referencePhone}}</div>
                            </div>
                        </div>

                        <div class="sub-section">
                            <div class="sub-title"><span class="icon"></span>人才测评</div>
                            <div class="field-row">
                                <div class="field"><span>测评结果:</span> {{rosterData.employee.assessmentResult}}</div>
                            </div>
                        </div>
                    </div>

                    <!-- Column 2 -->
                    <div class="roster-column">
                        <div class="section-header">
                            <span class="section-num">02</span>
                            <span class="section-title">入职后信息(在职阶段)</span>
                        </div>

                        <div class="sub-section">
                            <div class="sub-title"><span class="icon"></span>岗位信息</div>
                            <div class="field-row">
                                <div class="field"><span>部门:</span> {{rosterData.employee.department ? rosterData.employee.department.name : ''}}</div>
                                <div class="field"><span>职位:</span> {{rosterData.employee.position ? rosterData.employee.position.name : ''}}</div>
                            </div>
                            <div class="field-row">
                                <div class="field"><span>工作地点:</span> {{rosterData.employee.workLocation}}</div>
                                <div class="field"><span>入职日期:</span> {{formatDate(rosterData.employee.beginDate)}}</div>
                            </div>
                            <div class="field-row">
                                <div class="field"><span>工龄:</span> {{rosterData.employee.workAge}}年</div>
                                <div class="field"><span>试用期:</span> {{rosterData.employee.probation}}个月</div>
                            </div>
                            <div class="field-row">
                                <div class="field"><span>转正日期:</span> {{formatDate(rosterData.employee.conversionTime)}}</div>
                                <div class="field"><span>转正评分:</span> {{rosterData.employee.conversionScore}}</div>
                            </div>
                            <div class="field-row">
                                <div class="field"><span>状态:</span> {{rosterData.employee.workState}}</div>
                            </div>
                        </div>

                        <div class="sub-section">
                            <div class="sub-title"><span class="icon"></span>合同信息</div>
                            <div v-if="rosterData.contract">
                                <div class="field-row">
                                    <div class="field"><span>用工类型:</span> {{rosterData.contract.employmentType}}</div>
                                    <div class="field"><span>合同类型:</span> {{rosterData.contract.contractType}}</div>
                                </div>
                                <div class="field-row">
                                    <div class="field"><span>签订次数:</span> {{rosterData.contract.signCount}}</div>
                                    <div class="field"><span>截止日期:</span> {{formatDate(rosterData.contract.endDate)}}</div>
                                </div>
                                <div class="field-row">
                                    <div class="field"><span>首次签订:</span> {{formatDate(rosterData.contract.firstSignDate)}} ({{rosterData.contract.firstSignTerm}}年)</div>
                                </div>
                                <div class="field-row">
                                    <div class="field"><span>二次签订:</span> {{formatDate(rosterData.contract.secondSignDate)}} ({{rosterData.contract.secondSignTerm}}年)</div>
                                </div>
                                <div class="field-row">
                                    <div class="field"><span>三次签订:</span> {{formatDate(rosterData.contract.thirdSignDate)}}</div>
                                </div>
                            </div>
                            <div v-else>暂无合同信息</div>
                        </div>

                        <div class="sub-section">
                            <div class="sub-title"><span class="icon"></span>考勤休假</div>
                            <div class="field-row">
                                <div class="field"><span>迟到/早退:</span> (空)</div>
                                <div class="field"><span>加班(小时):</span> (空)</div>
                            </div>
                            <div class="field-row">
                                <div class="field"><span>年假(天):</span> (空)</div>
                                <div class="field"><span>病假(天):</span> (空)</div>
                            </div>
                        </div>

                        <div class="sub-section">
                            <div class="sub-title"><span class="icon"></span>绩效管理</div>
                            <div v-if="rosterData.performance">
                                <div class="field-row"><div class="field">1月:{{rosterData.performance.month1}} 2月:{{rosterData.performance.month2}} 3月:{{rosterData.performance.month3}} 4月:{{rosterData.performance.month4}}</div></div>
                                <div class="field-row"><div class="field">5月:{{rosterData.performance.month5}} 6月:{{rosterData.performance.month6}} 7月:{{rosterData.performance.month7}} 8月:{{rosterData.performance.month8}}</div></div>
                                <div class="field-row"><div class="field">9月:{{rosterData.performance.month9}} 10月:{{rosterData.performance.month10}} 11月:{{rosterData.performance.month11}} 12月:{{rosterData.performance.month12}}</div></div>
                            </div>
                            <div v-else>暂无绩效</div>
                            <div v-if="rosterData.execPerformance" style="margin-top: 5px">
                                <div class="field-row"><div class="field"><span>内部评分:</span> Q1:{{rosterData.execPerformance.quarter1}} Q2:{{rosterData.execPerformance.quarter2}} Q3:{{rosterData.execPerformance.quarter3}} Q4:{{rosterData.execPerformance.quarter4}}</div></div>
                            </div>
                        </div>

                        <div class="sub-section">
                            <div class="sub-title"><span class="icon"></span>内部培训</div>
                            <div class="field-row"><div class="field"><span>培训记录:</span> (空)</div></div>
                        </div>
                    </div>

                    <!-- Column 3 -->
                    <div class="roster-column">
                        <div class="section-header">
                            <span class="section-num">03</span>
                            <span class="section-title">离职阶段信息</span>
                        </div>

                        <div class="sub-section">
                            <div class="sub-title"><span class="icon"></span>离职日期</div>
                            <div class="field-row"><div class="field">{{formatDate(rosterData.employee.notWorkDate)}}</div></div>
                        </div>

                        <div class="sub-section">
                            <div class="sub-title"><span class="icon"></span>离职原因</div>
                            <div class="field-row"><div class="field">{{rosterData.employee.resignationReason}}</div></div>
                        </div>

                        <div class="sub-section">
                            <div class="sub-title"><span class="icon"></span>面谈记录</div>
                            <div class="field-row"><div class="field" style="height: 60px">(空)</div></div>
                        </div>

                        <div class="sub-section">
                            <div class="sub-title"><span class="icon"></span>交接记录</div>
                            <div class="field-row"><div class="field" style="height: 60px">(空)</div></div>
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
                // Assume dateStr is yyyy-MM-dd or timestamp
                // Simple slice if string matches format
                if (typeof dateStr === 'string' && dateStr.length >= 10) {
                    return dateStr.substring(0, 10);
                }
                return dateStr;
            }
        }
    }
</script>

<style scoped>
.roster-container {
    background: white;
    padding: 20px;
    /* width: 1400px; Remove fixed width */
    min-width: 1200px; /* Ensure minimum width for layout */
    margin: 0 auto;
    font-family: "SimHei", "Microsoft YaHei", sans-serif;
    color: #333;
}
.roster-header {
    display: flex;
    justify-content: flex-end;
    margin-bottom: 20px;
    border-bottom: 2px solid #409EFF;
    padding-bottom: 10px;
}
.user-info {
    font-size: 24px;
    color: #409EFF;
    font-weight: bold;
}
.roster-content {
    display: flex;
    justify-content: space-between;
}
.roster-column {
    width: 32%;
    background: #fff;
}
.section-header {
    background: #409EFF;
    color: white;
    padding: 10px 20px;
    border-radius: 30px;
    display: flex;
    align-items: center;
    margin-bottom: 20px;
}
.section-num {
    font-size: 40px;
    font-weight: bold;
    margin-right: 15px;
}
.section-title {
    font-size: 18px;
    font-weight: bold;
}
.sub-section {
    margin-bottom: 20px;
}
.sub-title {
    display: flex;
    align-items: center;
    font-size: 16px;
    font-weight: bold;
    color: #409EFF;
    margin-bottom: 10px;
    background: #ecf5ff;
    padding: 5px 10px;
    border-radius: 4px;
}
.sub-title .icon {
    width: 10px;
    height: 10px;
    background: #409EFF;
    border-radius: 50%;
    margin-right: 10px;
    display: inline-block;
}
.field-row {
    display: flex;
    margin-bottom: 8px;
    font-size: 14px;
    padding-left: 10px;
}
.field {
    flex: 1;
}
.field span {
    font-weight: bold;
    color: #606266;
    margin-right: 5px;
}
</style>
