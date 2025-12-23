<template>
  <div>
    <div>
      <div style="display: flex;justify-content: space-between">
        <div>
          <el-input placeholder="请输入员工名进行搜索，可以直接回车..." prefix-icon="el-icon-search"
                    clearable
                    @clear="initPerformances"
                    style="width: 300px;margin-right: 10px" v-model="keyword"
                    @keydown.enter.native="initPerformances" :disabled="showAdvanceSearchView"></el-input>
          <el-input placeholder="请输入年份" prefix-icon="el-icon-date"
                    clearable
                    style="width: 150px;margin-right: 10px" v-model="year"
                    @keydown.enter.native="initPerformances"></el-input>
          <el-date-picker
            v-model="dateScope"
            type="daterange"
            unlink-panels
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
            value-format="yyyy-MM-dd"
            style="margin-right: 10px"
          >
          </el-date-picker>
          <el-button icon="el-icon-search" type="primary" @click="initPerformances" :disabled="showAdvanceSearchView">
            搜索
          </el-button>
        </div>
        <div>
          <el-upload
              :show-file-list="false"
              :before-upload="beforeUpload"
              :on-success="onSuccess"
              :on-error="onError"
              :disabled="importDataDisabled"
              style="display: inline-flex;margin-right: 8px"
              action="/personnel/performance/import">
            <el-button :disabled="importDataDisabled" type="success" :icon="importDataBtnIcon">
              {{importDataBtnText}}
            </el-button>
          </el-upload>
          <el-button type="success" @click="exportData" icon="el-icon-download">
            导出数据
          </el-button>
           <el-button type="info" @click="downloadTemplate" icon="el-icon-download">
            下载模板
          </el-button>
          <el-button type="primary" icon="el-icon-plus" @click="showAddPerformanceView">
            添加绩效
          </el-button>
        </div>
      </div>
    </div>
    <div style="margin-top: 10px">
      <el-table :data="performances" border v-loading="loading" element-loading-text="正在加载..." element-loading-spinner="el-icon-loading" element-loading-background="rgba(0, 0, 0, 0.8)" style="width: 100%">
        <el-table-column prop="employee.name" fixed align="left" label="姓名" width="90"></el-table-column>
        <el-table-column prop="eid" label="身份证号" width="150"></el-table-column>
        <el-table-column prop="year" label="年份" width="80"></el-table-column>
        <el-table-column prop="month1" label="1月" width="60"></el-table-column>
        <el-table-column prop="month2" label="2月" width="60"></el-table-column>
        <el-table-column prop="month3" label="3月" width="60"></el-table-column>
        <el-table-column prop="month4" label="4月" width="60"></el-table-column>
        <el-table-column prop="month5" label="5月" width="60"></el-table-column>
        <el-table-column prop="month6" label="6月" width="60"></el-table-column>
        <el-table-column prop="month7" label="7月" width="60"></el-table-column>
        <el-table-column prop="month8" label="8月" width="60"></el-table-column>
        <el-table-column prop="month9" label="9月" width="60"></el-table-column>
        <el-table-column prop="month10" label="10月" width="60"></el-table-column>
        <el-table-column prop="month11" label="11月" width="60"></el-table-column>
        <el-table-column prop="month12" label="12月" width="60"></el-table-column>
        <el-table-column label="合计" width="80">
            <template slot-scope="scope">
                {{ calculateTotal(scope.row) }}
            </template>
        </el-table-column>
        <el-table-column label="平均" width="80">
            <template slot-scope="scope">
                {{ calculateAvg(scope.row) }}
            </template>
        </el-table-column>
        <el-table-column fixed="right" width="200" label="操作">
          <template slot-scope="scope">
            <el-button @click="showEditPerformanceView(scope.row)" style="padding: 3px" size="mini">编辑</el-button>
            <el-button @click="deletePerformance(scope.row)" style="padding: 3px" size="mini" type="danger">删除</el-button>
            <el-button @click="showChartView(scope.row)" style="padding: 3px" size="mini" type="primary">图表</el-button>
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
    
    <el-dialog :title="title" :visible.sync="dialogVisible" width="50%">
      <div>
        <el-form :model="performance" :rules="rules" ref="empForm" status-icon>
          <el-row>
            <el-col :span="12">
              <el-form-item label="员工姓名:" prop="eid">
                 <el-select v-model="performance.eid" filterable remote placeholder="请输入员工姓名" 
                    :remote-method="remoteMethod" :loading="loadingEmp" no-data-text="请先录入该员工基本信息"
                    :disabled="!!performance.id">
                    <el-option
                        v-for="item in employeeList"
                        :key="item.idCard"
                        :label="item.name"
                        :value="item.idCard">
                    </el-option>
                 </el-select>
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="年份:" prop="year">
                 <el-input size="mini" style="width: 150px" prefix-icon="el-icon-edit" v-model="performance.year" placeholder="请输入年份"></el-input>
              </el-form-item>
            </el-col>
          </el-row>
           <el-row v-for="i in 3" :key="i">
            <el-col :span="6" v-for="j in 4" :key="j">
                <el-form-item :label="((i-1)*4+j) + '月:'" :prop="'month' + ((i-1)*4+j)">
                   <el-input size="mini" style="width: 80px" v-model="performance['month'+((i-1)*4+j)]"></el-input>
                </el-form-item>
            </el-col>
          </el-row>
        </el-form>
      </div>
      <span slot="footer" class="dialog-footer">
        <el-button @click="dialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="doAddPerformance">确 定</el-button>
      </span>
    </el-dialog>
    
    <el-dialog title="月度绩效变化" :visible.sync="chartVisible" width="60%">
        <div id="chart" style="width: 100%; height: 400px;"></div>
    </el-dialog>
  </div>
</template>
<script>
import * as echarts from 'echarts';

export default {
    name: "PerPerformance",
    data() {
        return {
            title: '',
            importDataBtnText: '导入数据',
            importDataBtnIcon: 'el-icon-upload2',
            importDataDisabled: false,
            showAdvanceSearchView: false,
            performances: [],
            loading: false,
            total: 0,
            page: 1,
            size: 10,
            keyword: '',
            year: '',
            dateScope: null,
            dialogVisible: false,
            chartVisible: false,
            loadingEmp: false,
            employeeList: [],
            performance: {
                eid: '',
                year: '',
                month1: '', month2: '', month3: '', month4: '', month5: '', month6: '',
                month7: '', month8: '', month9: '', month10: '', month11: '', month12: ''
            },
            rules: {
                eid: [{required: true, message: '请选择员工', trigger: 'blur'}],
                year: [{required: true, message: '请输入年份', trigger: 'blur'}],
                month1: [{pattern: /^(\d+(\.\d{1,2})?)?$/, message: '输入数据格式错误，请核对后再试', trigger: ['blur', 'change']}],
                month2: [{pattern: /^(\d+(\.\d{1,2})?)?$/, message: '输入数据格式错误，请核对后再试', trigger: ['blur', 'change']}],
                month3: [{pattern: /^(\d+(\.\d{1,2})?)?$/, message: '输入数据格式错误，请核对后再试', trigger: ['blur', 'change']}],
                month4: [{pattern: /^(\d+(\.\d{1,2})?)?$/, message: '输入数据格式错误，请核对后再试', trigger: ['blur', 'change']}],
                month5: [{pattern: /^(\d+(\.\d{1,2})?)?$/, message: '输入数据格式错误，请核对后再试', trigger: ['blur', 'change']}],
                month6: [{pattern: /^(\d+(\.\d{1,2})?)?$/, message: '输入数据格式错误，请核对后再试', trigger: ['blur', 'change']}],
                month7: [{pattern: /^(\d+(\.\d{1,2})?)?$/, message: '输入数据格式错误，请核对后再试', trigger: ['blur', 'change']}],
                month8: [{pattern: /^(\d+(\.\d{1,2})?)?$/, message: '输入数据格式错误，请核对后再试', trigger: ['blur', 'change']}],
                month9: [{pattern: /^(\d+(\.\d{1,2})?)?$/, message: '输入数据格式错误，请核对后再试', trigger: ['blur', 'change']}],
                month10: [{pattern: /^(\d+(\.\d{1,2})?)?$/, message: '输入数据格式错误，请核对后再试', trigger: ['blur', 'change']}],
                month11: [{pattern: /^(\d+(\.\d{1,2})?)?$/, message: '输入数据格式错误，请核对后再试', trigger: ['blur', 'change']}],
                month12: [{pattern: /^(\d+(\.\d{1,2})?)?$/, message: '输入数据格式错误，请核对后再试', trigger: ['blur', 'change']}]
            },
            chartInstance: null
        }
    },
    mounted() {
        this.initPerformances();
    },
    methods: {
        remoteMethod(query) {
            if (query !== '') {
                this.loadingEmp = true;
                this.getRequest("/employee/basic/simple?name=" + query).then(resp => {
                    this.loadingEmp = false;
                    if (resp) {
                        this.employeeList = resp;
                    }
                });
            } else {
                this.employeeList = [];
            }
        },
        calculateTotal(row) {
            let sum = 0;
            for(let i=1; i<=12; i++) {
                if(row['month'+i]) sum += parseFloat(row['month'+i]);
            }
            return sum.toFixed(2);
        },
        calculateAvg(row) {
            let sum = 0;
            let count = 0;
            for(let i=1; i<=12; i++) {
                if(row['month'+i]) {
                    sum += parseFloat(row['month'+i]);
                    count++;
                }
            }
            return count > 0 ? (sum / count).toFixed(2) : 0;
        },
        initPerformances(type) {
            this.loading = true;
            let url = '/personnel/performance/?page=' + this.page + '&size=' + this.size;
            if (type && type == 'advanced') {
                if (this.keyword) {
                    url += '&empName=' + this.keyword;
                }
                if (this.year) {
                    url += '&year=' + this.year;
                }
                if (this.dateScope) {
                    url += '&beginDate=' + this.dateScope[0] + '&endDate=' + this.dateScope[1];
                }
            } else {
                url += "&empName=" + this.keyword;
                if(this.year) url += '&year=' + this.year;
                if(this.dateScope) url += '&beginDate=' + this.dateScope[0] + '&endDate=' + this.dateScope[1];
            }
            this.getRequest(url).then(resp => {
                this.loading = false;
                if (resp) {
                    this.performances = resp.data;
                    this.total = resp.total;
                }
            });
        },
        showAddPerformanceView() {
            this.title = '添加绩效';
            this.performance = {
                eid: '',
                year: new Date().getFullYear(),
                month1: '', month2: '', month3: '', month4: '', month5: '', month6: '',
                month7: '', month8: '', month9: '', month10: '', month11: '', month12: ''
            };
            this.dialogVisible = true;
        },
        showEditPerformanceView(data) {
            this.title = '编辑绩效';
            this.performance = Object.assign({}, data); // Copy
            // Pre-populate employeeList so the remote select can display the name
            if (data.employee) {
                this.employeeList = [{
                    name: data.employee.name,
                    idCard: data.eid
                }];
            }
            this.dialogVisible = true;
        },
        deletePerformance(data) {
            this.$confirm('此操作将永久删除【' + data.employee.name + '】的绩效记录, 是否继续?', '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            }).then(() => {
                this.deleteRequest("/personnel/performance/" + data.id).then(resp => {
                    if (resp) {
                        this.initPerformances();
                    }
                })
            }).catch(() => {
                this.$message({
                    type: 'info',
                    message: '已取消删除'
                });
            });
        },
        doAddPerformance() {
            this.$refs['empForm'].validate(valid => {
                if (valid) {
                    if (this.performance.id) {
                        this.putRequest("/personnel/performance/", this.performance).then(resp => {
                            if (resp) {
                                this.dialogVisible = false;
                                this.initPerformances();
                            }
                        })
                    } else {
                        this.postRequest("/personnel/performance/", this.performance).then(resp => {
                            if (resp) {
                                this.dialogVisible = false;
                                this.initPerformances();
                            }
                        })
                    }
                }
            });
        },
        exportData() {
            window.open('/personnel/performance/export?empName=' + this.keyword + '&year=' + (this.year||'') + (this.dateScope ? '&beginDate=' + this.dateScope[0] + '&endDate=' + this.dateScope[1] : ''), '_parent');
        },
        downloadTemplate() {
             window.open('/personnel/performance/template', '_parent');
        },
        beforeUpload() {
            this.importDataBtnText = '正在导入';
            this.importDataBtnIcon = 'el-icon-loading';
            this.importDataDisabled = true;
        },
        onSuccess(response, file, fileList) {
            this.importDataBtnText = '导入数据';
            this.importDataBtnIcon = 'el-icon-upload2';
            this.importDataDisabled = false;
            this.initPerformances();
            if(response.status == 200) {
                 this.$message.success(response.msg);
            } else {
                 this.$message.error(response.msg);
            }
        },
        onError(err, file, fileList) {
            this.importDataBtnText = '导入数据';
            this.importDataBtnIcon = 'el-icon-upload2';
            this.importDataDisabled = false;
        },
        currentChange(currentChange) {
            this.page = currentChange;
            this.initPerformances();
        },
        sizeChange(sizeChange) {
            this.size = sizeChange;
            this.initPerformances();
        },
        showChartView(row) {
            this.chartVisible = true;
            this.$nextTick(() => {
                if(!this.chartInstance) {
                    this.chartInstance = echarts.init(document.getElementById('chart'));
                } else {
                    this.chartInstance.clear();
                }
                let months = [];
                let scores = [];
                for(let i=1; i<=12; i++) {
                    months.push(i+'月');
                    scores.push(row['month'+i] || 0);
                }
                let option = {
                    title: { text: row.employee.name + ' ' + row.year + '年 绩效' },
                    tooltip: {},
                    xAxis: {
                        data: months
                    },
                    yAxis: {},
                    series: [{
                        name: '绩效',
                        type: 'line',
                        data: scores
                    }]
                };
                this.chartInstance.setOption(option);
            });
        }
    }
}
</script>
