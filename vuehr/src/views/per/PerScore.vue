<template>
  <div>
    <div>
      <div style="display: flex;justify-content: space-between;flex-wrap: wrap;">
        <div style="margin-bottom: 10px;display: flex;align-items: center;flex-wrap: wrap;">
          <el-input placeholder="请输入员工名进行搜索..." prefix-icon="el-icon-search"
                    clearable
                    @clear="initScores"
                    style="width: 300px;margin-right: 10px;margin-bottom: 5px;" v-model="keyword"
                    @keydown.enter.native="initScores" :disabled="showAdvanceSearchView"></el-input>
          <el-input placeholder="请输入年份" prefix-icon="el-icon-date"
                    clearable
                    style="width: 150px;margin-right: 10px;margin-bottom: 5px;" v-model="year"
                    @keydown.enter.native="initScores"></el-input>
          <el-date-picker
            v-model="dateScope"
            type="daterange"
            unlink-panels
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
            value-format="yyyy-MM-dd"
            style="margin-right: 10px;margin-bottom: 5px;"
          >
          </el-date-picker>
          <el-button icon="el-icon-search" type="primary" @click="initScores" :disabled="showAdvanceSearchView" style="margin-bottom: 5px;">
            搜索
          </el-button>
        </div>
        <div style="margin-bottom: 10px;display: flex;align-items: center;flex-wrap: wrap;">
          <el-upload
              :show-file-list="false"
              :before-upload="beforeUpload"
              :on-success="onSuccess"
              :on-error="onError"
              :disabled="importDataDisabled"
              style="display: inline-flex;margin-right: 8px"
              action="/personnel/score/import">
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
          <el-button type="primary" icon="el-icon-plus" @click="showAddScoreView">
            添加评分
          </el-button>
        </div>
      </div>
    </div>
    <div style="margin-top: 10px">
      <el-table :data="scores" border v-loading="loading" element-loading-text="正在加载..." element-loading-spinner="el-icon-loading" element-loading-background="rgba(0, 0, 0, 0.8)" style="width: 100%">
        <el-table-column prop="employee.name" fixed align="left" label="姓名" width="90"></el-table-column>
        <el-table-column prop="eid" label="身份证号" width="150"></el-table-column>
        <el-table-column prop="year" label="年份" width="80"></el-table-column>
        <el-table-column prop="quarter1" label="第一季度" width="100"></el-table-column>
        <el-table-column prop="quarter2" label="第二季度" width="100"></el-table-column>
        <el-table-column prop="quarter3" label="第三季度" width="100"></el-table-column>
        <el-table-column prop="quarter4" label="第四季度" width="100"></el-table-column>
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
            <el-button @click="showEditScoreView(scope.row)" style="padding: 3px" size="mini">编辑</el-button>
            <el-button @click="deleteScore(scope.row)" style="padding: 3px" size="mini" type="danger">删除</el-button>
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
        <el-form :model="score" :rules="rules" ref="empForm" status-icon>
          <el-row>
            <el-col :span="12">
              <el-form-item label="员工姓名:" prop="eid">
                 <el-select v-model="score.eid" filterable remote placeholder="请输入员工姓名" 
                    :remote-method="remoteMethod" :loading="loadingEmp" no-data-text="请先录入该员工基本信息"
                    :disabled="!!score.id">
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
                 <el-input size="mini" style="width: 150px" prefix-icon="el-icon-edit" v-model="score.year" placeholder="请输入年份"></el-input>
              </el-form-item>
            </el-col>
          </el-row>
           <el-row>
             <el-col :span="6">
                 <el-form-item label="第一季度:" prop="quarter1">
                    <el-input size="mini" style="width: 80px" v-model="score.quarter1"></el-input>
                 </el-form-item>
             </el-col>
             <el-col :span="6">
                 <el-form-item label="第二季度:" prop="quarter2">
                    <el-input size="mini" style="width: 80px" v-model="score.quarter2"></el-input>
                 </el-form-item>
             </el-col>
             <el-col :span="6">
                 <el-form-item label="第三季度:" prop="quarter3">
                    <el-input size="mini" style="width: 80px" v-model="score.quarter3"></el-input>
                 </el-form-item>
             </el-col>
             <el-col :span="6">
                 <el-form-item label="第四季度:" prop="quarter4">
                    <el-input size="mini" style="width: 80px" v-model="score.quarter4"></el-input>
                 </el-form-item>
             </el-col>
           </el-row>
        </el-form>
      </div>
      <span slot="footer" class="dialog-footer">
        <el-button @click="dialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="doAddScore">确 定</el-button>
      </span>
    </el-dialog>
    
    <el-dialog title="季度绩效变化" :visible.sync="chartVisible" width="60%">
        <div id="chart" style="width: 100%; height: 400px;"></div>
    </el-dialog>
  </div>
</template>
<script>
import * as echarts from 'echarts';

export default {
    name: "PerScore",
    data() {
        return {
            title: '',
            importDataBtnText: '导入数据',
            importDataBtnIcon: 'el-icon-upload2',
            importDataDisabled: false,
            showAdvanceSearchView: false,
            scores: [],
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
            score: {
                eid: '',
                year: '',
                quarter1: '', quarter2: '', quarter3: '', quarter4: ''
            },
            rules: {
                eid: [{required: true, message: '请选择员工', trigger: 'blur'}],
                year: [{required: true, message: '请输入年份', trigger: 'blur'}],
                quarter1: [{pattern: /^(\d+(\.\d{1,2})?)?$/, message: '输入数据格式错误，请核对后再试', trigger: ['blur', 'change']}],
                quarter2: [{pattern: /^(\d+(\.\d{1,2})?)?$/, message: '输入数据格式错误，请核对后再试', trigger: ['blur', 'change']}],
                quarter3: [{pattern: /^(\d+(\.\d{1,2})?)?$/, message: '输入数据格式错误，请核对后再试', trigger: ['blur', 'change']}],
                quarter4: [{pattern: /^(\d+(\.\d{1,2})?)?$/, message: '输入数据格式错误，请核对后再试', trigger: ['blur', 'change']}]
            },
            chartInstance: null
        }
    },
    mounted() {
        this.initScores();
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
            for(let i=1; i<=4; i++) {
                if(row['quarter'+i]) sum += parseFloat(row['quarter'+i]);
            }
            return sum.toFixed(2);
        },
        calculateAvg(row) {
            let sum = 0;
            let count = 0;
            for(let i=1; i<=4; i++) {
                if(row['quarter'+i]) {
                    sum += parseFloat(row['quarter'+i]);
                    count++;
                }
            }
            return count > 0 ? (sum / count).toFixed(2) : 0;
        },
        initScores(type) {
            this.loading = true;
            let url = '/personnel/score/?page=' + this.page + '&size=' + this.size;
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
                    this.scores = resp.data;
                    this.total = resp.total;
                }
            });
        },
        showAddScoreView() {
            this.title = '添加评分';
            this.score = {
                eid: '',
                year: new Date().getFullYear(),
                quarter1: '', quarter2: '', quarter3: '', quarter4: ''
            };
            this.dialogVisible = true;
        },
        showEditScoreView(data) {
            this.title = '编辑评分';
            this.score = Object.assign({}, data); // Copy
            // Pre-populate employeeList so the remote select can display the name
            if (data.employee) {
                this.employeeList = [{
                    name: data.employee.name,
                    idCard: data.eid
                }];
            }
            this.dialogVisible = true;
        },
        deleteScore(data) {
            this.$confirm('此操作将永久删除【' + data.employee.name + '】的评分记录, 是否继续?', '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            }).then(() => {
                this.deleteRequest("/personnel/score/" + data.id).then(resp => {
                    if (resp) {
                        this.initScores();
                    }
                })
            }).catch(() => {
                this.$message({
                    type: 'info',
                    message: '已取消删除'
                });
            });
        },
        doAddScore() {
            this.$refs['empForm'].validate(valid => {
                if (valid) {
                    if (this.score.id) {
                        this.putRequest("/personnel/score/", this.score).then(resp => {
                            if (resp) {
                                this.dialogVisible = false;
                                this.initScores();
                            }
                        })
                    } else {
                        this.postRequest("/personnel/score/", this.score).then(resp => {
                            if (resp) {
                                this.dialogVisible = false;
                                this.initScores();
                            }
                        })
                    }
                }
            });
        },
        exportData() {
            window.open('/personnel/score/export?empName=' + this.keyword + '&year=' + (this.year||'') + (this.dateScope ? '&beginDate=' + this.dateScope[0] + '&endDate=' + this.dateScope[1] : ''), '_parent');
        },
        downloadTemplate() {
             window.open('/personnel/score/template', '_parent');
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
            this.initScores();
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
            this.initScores();
        },
        sizeChange(sizeChange) {
            this.size = sizeChange;
            this.initScores();
        },
        showChartView(row) {
            this.chartVisible = true;
            this.$nextTick(() => {
                if(!this.chartInstance) {
                    this.chartInstance = echarts.init(document.getElementById('chart'));
                } else {
                    this.chartInstance.clear();
                }
                let quarters = ['Q1', 'Q2', 'Q3', 'Q4'];
                let scores = [];
                for(let i=1; i<=4; i++) {
                    scores.push(row['quarter'+i] || 0);
                }
                let option = {
                    title: { text: row.employee.name + ' ' + row.year + '年 季度评分' },
                    tooltip: {},
                    xAxis: {
                        data: quarters
                    },
                    yAxis: {},
                    series: [{
                        name: '评分',
                        type: 'bar', // Use bar for quarters
                        data: scores
                    }]
                };
                this.chartInstance.setOption(option);
            });
        }
    }
}
</script>
