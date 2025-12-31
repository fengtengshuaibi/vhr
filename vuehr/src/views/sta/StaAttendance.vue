<template>
    <div class="sta-attendance-container">
        <!-- Header / Filter -->
        <div class="filter-container">
            <span class="title">员工考勤与休假统计</span>
            <div class="filter-inputs">
                <el-select
                    v-model="selectedEmpId"
                    filterable
                    remote
                    reserve-keyword
                    placeholder="请输入员工姓名"
                    :remote-method="remoteMethod"
                    :loading="loading"
                    @change="handleEmpChange"
                    style="width: 200px; margin-right: 15px;">
                    <el-option
                        v-for="item in employees"
                        :key="item.idCard"
                        :label="item.name + '(' + item.idCard + ')'"
                        :value="item.idCard">
                    </el-option>
                </el-select>
                
                <el-date-picker
                    v-model="selectedYear"
                    type="year"
                    placeholder="选择年份"
                    value-format="yyyy"
                    style="width: 150px; margin-right: 15px;"
                    @change="fetchData">
                </el-date-picker>

                <el-button type="primary" icon="el-icon-search" @click="fetchData" :disabled="!selectedEmpId">查询</el-button>
            </div>
        </div>

        <!-- Content -->
        <div v-if="hasData" class="charts-container">
            <!-- Summary Cards -->
            <el-row :gutter="20" style="margin-bottom: 20px;">
                <el-col :span="6">
                    <div class="card-box bg-blue">
                        <div class="card-title">迟到/早退</div>
                        <div class="card-num">{{summary.lateEarly}} <span class="unit">次</span></div>
                    </div>
                </el-col>
                <el-col :span="6">
                    <div class="card-box bg-orange">
                        <div class="card-title">缺卡</div>
                        <div class="card-num">{{summary.missing}} <span class="unit">次</span></div>
                    </div>
                </el-col>
                <el-col :span="6">
                    <div class="card-box bg-green">
                        <div class="card-title">加班</div>
                        <div class="card-num">{{summary.overtime}} <span class="unit">小时</span></div>
                    </div>
                </el-col>
                <el-col :span="6">
                    <div class="card-box bg-purple">
                        <div class="card-title">休假总计</div>
                        <div class="card-num">{{summary.leave}} <span class="unit">天</span></div>
                    </div>
                </el-col>
            </el-row>

            <el-row :gutter="20">
                <!-- Monthly Attendance Chart -->
                <el-col :span="14">
                    <div class="chart-box">
                        <div id="attendanceChart" style="width: 100%; height: 400px;"></div>
                    </div>
                </el-col>
                <!-- Leave Distribution Chart -->
                <el-col :span="10">
                    <div class="chart-box">
                        <div id="leaveChart" style="width: 100%; height: 400px;"></div>
                    </div>
                </el-col>
            </el-row>
        </div>
        
        <div v-else class="empty-state">
            <i class="el-icon-data-analysis" style="font-size: 60px; color: #ccc;"></i>
            <p>请选择员工和年份查看统计数据</p>
        </div>
    </div>
</template>

<script>
    import * as echarts from 'echarts';

    export default {
        name: "StaAttendance",
        data() {
            return {
                loading: false,
                employees: [],
                selectedEmpId: '',
                selectedYear: new Date().getFullYear().toString(),
                attendanceData: [],
                hasData: false,
                summary: {
                    lateEarly: 0,
                    missing: 0,
                    overtime: 0,
                    leave: 0
                }
            }
        },
        methods: {
            remoteMethod(query) {
                if (query !== '') {
                    this.loading = true;
                    this.getRequest("/employee/basic/simple?name=" + query).then(resp => {
                         this.loading = false;
                         if (resp) {
                             this.employees = resp;
                         }
                    });
                } else {
                    this.employees = [];
                }
            },
            handleEmpChange(val) {
                this.fetchData();
            },
            fetchData() {
                if (!this.selectedEmpId || !this.selectedYear) return;
                
                // Fetch roster data which includes attendance
                // Or use a more direct endpoint if available. 
                // EmployeeRosterController's /roster/data/{eid} returns attendanceLeaves list.
                // We can reuse that or filter the list client side.
                // Assuming we use the roster endpoint for now as it's readily available and verified.
                
                this.getRequest("/personnel/emp/roster/data/" + this.selectedEmpId).then(resp => {
                    if (resp && resp.attendanceLeaves) {
                        // Filter by year
                        this.attendanceData = resp.attendanceLeaves.filter(item => item.year == this.selectedYear);
                        this.hasData = true;
                        this.calculateSummary();
                        this.$nextTick(() => {
                            this.initCharts();
                        });
                    } else {
                        this.attendanceData = [];
                        this.hasData = true; // Still show empty charts or zeroed data
                        this.calculateSummary();
                        this.$nextTick(() => {
                            this.initCharts();
                        });
                    }
                });
            },
            calculateSummary() {
                let lateEarly = 0;
                let missing = 0;
                let overtime = 0;
                let leave = 0;
                
                this.attendanceData.forEach(item => {
                    lateEarly += (item.lateEarlyLeaveTimes || 0);
                    missing += (item.missingCardTimes || 0);
                    overtime += (item.overtimeHours || 0);
                    
                    // Sum up leaves (days)
                    leave += (item.personalLeaveDays || 0) + 
                             (item.sickLeaveDays || 0) + 
                             (item.annualLeaveDays || 0) + 
                             (item.marriageLeaveDays || 0) + 
                             (item.maternityLeaveDays || 0) + 
                             (item.paternityLeaveDays || 0) + 
                             (item.funeralLeaveDays || 0) + 
                             (item.workInjuryLeaveDays || 0);
                    // Ignore hourly leaves for day summary for simplicity or convert? 
                    // Let's just sum days for the "Total Leave Days" card.
                });
                
                this.summary = {
                    lateEarly,
                    missing,
                    overtime: overtime.toFixed(1),
                    leave: leave.toFixed(1)
                };
            },
            initCharts() {
                this.initAttendanceChart();
                this.initLeaveChart();
            },
            initAttendanceChart() {
                let chart = echarts.init(document.getElementById('attendanceChart'));
                
                // Prepare data for 12 months
                let months = Array.from({length: 12}, (_, i) => i + 1 + '月');
                let lateData = new Array(12).fill(0);
                let missingData = new Array(12).fill(0);
                let overtimeData = new Array(12).fill(0);
                
                this.attendanceData.forEach(item => {
                    if (item.month >= 1 && item.month <= 12) {
                        lateData[item.month - 1] = item.lateEarlyLeaveTimes || 0;
                        missingData[item.month - 1] = item.missingCardTimes || 0;
                        overtimeData[item.month - 1] = item.overtimeHours || 0;
                    }
                });
                
                let option = {
                    title: { text: '月度考勤异常与加班趋势' },
                    tooltip: { trigger: 'axis' },
                    legend: { data: ['迟到/早退(次)', '缺卡(次)', '加班(小时)'] },
                    grid: { left: '3%', right: '4%', bottom: '3%', containLabel: true },
                    xAxis: { type: 'category', boundaryGap: false, data: months },
                    yAxis: { type: 'value' },
                    series: [
                        { name: '迟到/早退(次)', type: 'line', data: lateData, smooth: true, itemStyle: {color: '#409EFF'} },
                        { name: '缺卡(次)', type: 'line', data: missingData, smooth: true, itemStyle: {color: '#E6A23C'} },
                        { name: '加班(小时)', type: 'bar', data: overtimeData, barWidth: '30%', itemStyle: {color: '#67C23A', opacity: 0.6} }
                    ]
                };
                chart.setOption(option);
            },
            initLeaveChart() {
                let chart = echarts.init(document.getElementById('leaveChart'));
                
                let leaveTypes = {
                    '事假': 0, '病假': 0, '年假': 0, '婚假': 0, 
                    '产假': 0, '陪产假': 0, '丧假': 0, '工伤假': 0
                };
                
                this.attendanceData.forEach(item => {
                    leaveTypes['事假'] += item.personalLeaveDays || 0;
                    leaveTypes['病假'] += item.sickLeaveDays || 0;
                    leaveTypes['年假'] += item.annualLeaveDays || 0;
                    leaveTypes['婚假'] += item.marriageLeaveDays || 0;
                    leaveTypes['产假'] += item.maternityLeaveDays || 0;
                    leaveTypes['陪产假'] += item.paternityLeaveDays || 0;
                    leaveTypes['丧假'] += item.funeralLeaveDays || 0;
                    leaveTypes['工伤假'] += item.workInjuryLeaveDays || 0;
                });
                
                let data = [];
                for (let key in leaveTypes) {
                    if (leaveTypes[key] > 0) {
                        data.push({ value: leaveTypes[key], name: key });
                    }
                }
                
                if (data.length === 0) {
                     data.push({value: 0, name: '无休假记录'});
                }

                let option = {
                    title: { text: '年度休假类型分布', subtext: '单位：天', left: 'center' },
                    tooltip: { trigger: 'item', formatter: '{a} <br/>{b} : {c} ({d}%)' },
                    legend: { orient: 'vertical', left: 'left', top: 'bottom' },
                    series: [
                        {
                            name: '休假类型',
                            type: 'pie',
                            radius: '50%',
                            data: data,
                            emphasis: {
                                itemStyle: {
                                    shadowBlur: 10,
                                    shadowOffsetX: 0,
                                    shadowColor: 'rgba(0, 0, 0, 0.5)'
                                }
                            }
                        }
                    ]
                };
                chart.setOption(option);
            }
        }
    }
</script>

<style scoped>
    .sta-attendance-container {
        padding: 20px;
        background-color: #f5f7fa;
        min-height: calc(100vh - 80px);
    }
    .filter-container {
        display: flex;
        justify-content: space-between;
        align-items: center;
        background: #fff;
        padding: 20px;
        border-radius: 8px;
        box-shadow: 0 2px 12px 0 rgba(0,0,0,0.05);
        margin-bottom: 20px;
    }
    .title {
        font-size: 20px;
        font-weight: bold;
        color: #303133;
        border-left: 5px solid #409EFF;
        padding-left: 10px;
    }
    .card-box {
        color: #fff;
        padding: 20px;
        border-radius: 8px;
        box-shadow: 0 2px 12px 0 rgba(0,0,0,0.1);
        text-align: center;
        transition: all 0.3s;
    }
    .card-box:hover {
        transform: translateY(-5px);
        box-shadow: 0 5px 15px 0 rgba(0,0,0,0.2);
    }
    .card-title {
        font-size: 16px;
        margin-bottom: 10px;
        opacity: 0.9;
    }
    .card-num {
        font-size: 28px;
        font-weight: bold;
    }
    .unit {
        font-size: 14px;
        font-weight: normal;
        margin-left: 5px;
    }
    .bg-blue { background: linear-gradient(135deg, #36D1DC, #5B86E5); }
    .bg-orange { background: linear-gradient(135deg, #FF9966, #FF5E62); }
    .bg-green { background: linear-gradient(135deg, #56ab2f, #a8e063); }
    .bg-purple { background: linear-gradient(135deg, #8E2DE2, #4A00E0); }
    
    .chart-box {
        background: #fff;
        padding: 20px;
        border-radius: 8px;
        box-shadow: 0 2px 12px 0 rgba(0,0,0,0.05);
    }
    .empty-state {
        text-align: center;
        padding: 100px 0;
        color: #909399;
    }
</style>