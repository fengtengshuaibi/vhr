<template>
    <div>
        <div style="display: flex; justify-content: space-between">
            <div>
                <el-input placeholder="请输入员工姓名进行搜索" prefix-icon="el-icon-search"
                          clearable
                          @clear="initAttendances"
                          style="width: 350px; margin-right: 10px" v-model="keyword"
                          @keydown.enter.native="initAttendances" :disabled="showAdvanceSearchView"></el-input>
                <el-button icon="el-icon-search" type="primary" @click="initAttendances" :disabled="showAdvanceSearchView">
                    搜索
                </el-button>
            </div>
            <div>
                <el-button type="success" @click="importData" icon="el-icon-upload2">
                    导入
                </el-button>
                <el-button type="success" @click="exportData" icon="el-icon-download">
                    导出
                </el-button>
                <el-button type="primary" icon="el-icon-plus" @click="showAddDialog">
                    添加考勤
                </el-button>
            </div>
        </div>
        <div style="margin-top: 10px">
            <el-table
                    :data="attendances"
                    border
                    v-loading="loading"
                    element-loading-text="正在加载..."
                    element-loading-spinner="el-icon-loading"
                    element-loading-background="rgba(0, 0, 0, 0.8)"
                    style="width: 100%">
                <el-table-column
                        type="selection"
                        width="55">
                </el-table-column>
                <el-table-column
                        prop="name"
                        fixed
                        align="left"
                        label="姓名"
                        width="90">
                </el-table-column>
                <el-table-column
                        prop="idCard"
                        align="left"
                        label="身份证号"
                        width="180">
                </el-table-column>
                <el-table-column
                        prop="year"
                        align="left"
                        label="年份"
                        width="60">
                </el-table-column>
                <el-table-column
                        prop="month"
                        align="left"
                        label="月份"
                        width="50">
                </el-table-column>
                <el-table-column label="考勤信息" align="center">
                    <el-table-column prop="lateEarlyLeaveTimes" label="迟到/早退(次)" width="100"></el-table-column>
                    <el-table-column prop="missingCardTimes" label="缺卡(次)" width="80"></el-table-column>
                    <el-table-column prop="overtimeHours" label="加班(h)" width="80"></el-table-column>
                    <el-table-column prop="compLeaveHours" label="调休(h)" width="80"></el-table-column>
                </el-table-column>
                <el-table-column label="休假信息(天/小时)" align="center">
                    <el-table-column prop="personalLeaveDays" label="事假(d)" width="70"></el-table-column>
                    <el-table-column prop="sickLeaveDays" label="病假(d)" width="70"></el-table-column>
                    <el-table-column prop="annualLeaveDays" label="年假(d)" width="70"></el-table-column>
                    <el-table-column prop="marriageLeaveDays" label="婚假(d)" width="70"></el-table-column>
                    <el-table-column prop="maternityLeaveDays" label="产假(d)" width="70"></el-table-column>
                    <el-table-column prop="paternityLeaveDays" label="陪产假(d)" width="80"></el-table-column>
                    <el-table-column prop="funeralLeaveDays" label="丧假(d)" width="70"></el-table-column>
                    <el-table-column prop="workInjuryLeaveDays" label="工伤假(d)" width="80"></el-table-column>
                    <el-table-column prop="prenatalCheckLeaveHours" label="产检假(h)" width="80"></el-table-column>
                    <el-table-column prop="breastfeedingLeaveHours" label="哺乳假(h)" width="80"></el-table-column>
                    <el-table-column prop="childcareLeaveHours" label="育儿假(h)" width="80"></el-table-column>
                </el-table-column>
                <el-table-column
                        fixed="right"
                        width="150"
                        label="操作">
                    <template slot-scope="scope">
                        <el-button @click="showEditDialog(scope.row)" style="padding: 3px" size="mini">编辑</el-button>
                        <el-button @click="deleteAttendance(scope.row)" style="padding: 3px" size="mini" type="danger">删除
                        </el-button>
                    </template>
                </el-table-column>
            </el-table>
            <div style="display: flex; justify-content: flex-end; margin-top: 10px">
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
                :title="title"
                :visible.sync="dialogVisible"
                width="80%">
            <div>
                <el-form :model="attendance" :rules="rules" ref="empForm">
                    <el-row>
                        <el-col :span="6">
                            <el-form-item label="员工姓名:" prop="name">
                                <el-select v-model="attendance.idCard" filterable remote reserve-keyword placeholder="请输入姓名搜索"
                                           :remote-method="remoteMethod" :loading="searchLoading" @change="handleEmpChange" style="width: 150px">
                                    <el-option
                                            v-for="item in employees"
                                            :key="item.idCard"
                                            :label="item.name + '(' + item.idCard + ')'"
                                            :value="item.idCard">
                                    </el-option>
                                </el-select>
                            </el-form-item>
                        </el-col>
                        <el-col :span="6">
                            <el-form-item label="身份证号:" prop="idCard">
                                <el-input size="mini" style="width: 180px" prefix-icon="el-icon-edit" v-model="attendance.idCard" disabled></el-input>
                            </el-form-item>
                        </el-col>
                        <el-col :span="6">
                            <el-form-item label="年份:" prop="year">
                                <el-input-number size="mini" v-model="attendance.year" :min="2000" :max="2099" style="width: 120px"></el-input-number>
                            </el-form-item>
                        </el-col>
                        <el-col :span="6">
                            <el-form-item label="月份:" prop="month">
                                <el-input-number size="mini" v-model="attendance.month" :min="1" :max="12" style="width: 120px"></el-input-number>
                            </el-form-item>
                        </el-col>
                    </el-row>
                    
                    <fieldset style="border: 1px solid #dcdfe6; padding: 10px; margin-bottom: 10px; border-radius: 5px;">
                        <legend style="margin-left: 10px; padding: 0 5px; color: #409eff;">考勤信息</legend>
                        <el-row>
                            <el-col :span="6">
                                <el-form-item label="迟到/早退(次):" prop="lateEarlyLeaveTimes">
                                    <el-input-number size="mini" v-model="attendance.lateEarlyLeaveTimes" :min="0" style="width: 100px"></el-input-number>
                                </el-form-item>
                            </el-col>
                            <el-col :span="6">
                                <el-form-item label="缺卡(次):" prop="missingCardTimes">
                                    <el-input-number size="mini" v-model="attendance.missingCardTimes" :min="0" style="width: 100px"></el-input-number>
                                </el-form-item>
                            </el-col>
                            <el-col :span="6">
                                <el-form-item label="加班(h):" prop="overtimeHours">
                                    <el-input-number size="mini" v-model="attendance.overtimeHours" :min="0" :precision="1" style="width: 100px"></el-input-number>
                                </el-form-item>
                            </el-col>
                            <el-col :span="6">
                                <el-form-item label="调休(h):" prop="compLeaveHours">
                                    <el-input-number size="mini" v-model="attendance.compLeaveHours" :min="0" :precision="1" style="width: 100px"></el-input-number>
                                </el-form-item>
                            </el-col>
                        </el-row>
                    </fieldset>

                    <fieldset style="border: 1px solid #dcdfe6; padding: 10px; border-radius: 5px;">
                        <legend style="margin-left: 10px; padding: 0 5px; color: #409eff;">休假信息</legend>
                        <el-row>
                            <el-col :span="6">
                                <el-form-item label="事假(天):" prop="personalLeaveDays">
                                    <el-input-number size="mini" v-model="attendance.personalLeaveDays" :min="0" :precision="1" style="width: 100px"></el-input-number>
                                </el-form-item>
                            </el-col>
                            <el-col :span="6">
                                <el-form-item label="病假(天):" prop="sickLeaveDays">
                                    <el-input-number size="mini" v-model="attendance.sickLeaveDays" :min="0" :precision="1" style="width: 100px"></el-input-number>
                                </el-form-item>
                            </el-col>
                            <el-col :span="6">
                                <el-form-item label="年假(天):" prop="annualLeaveDays">
                                    <el-input-number size="mini" v-model="attendance.annualLeaveDays" :min="0" :precision="1" style="width: 100px"></el-input-number>
                                </el-form-item>
                            </el-col>
                            <el-col :span="6">
                                <el-form-item label="婚假(天):" prop="marriageLeaveDays">
                                    <el-input-number size="mini" v-model="attendance.marriageLeaveDays" :min="0" :precision="1" style="width: 100px"></el-input-number>
                                </el-form-item>
                            </el-col>
                        </el-row>
                        <el-row>
                            <el-col :span="6">
                                <el-form-item label="产假(天):" prop="maternityLeaveDays">
                                    <el-input-number size="mini" v-model="attendance.maternityLeaveDays" :min="0" :precision="1" style="width: 100px"></el-input-number>
                                </el-form-item>
                            </el-col>
                            <el-col :span="6">
                                <el-form-item label="陪产假(天):" prop="paternityLeaveDays">
                                    <el-input-number size="mini" v-model="attendance.paternityLeaveDays" :min="0" :precision="1" style="width: 100px"></el-input-number>
                                </el-form-item>
                            </el-col>
                            <el-col :span="6">
                                <el-form-item label="丧假(天):" prop="funeralLeaveDays">
                                    <el-input-number size="mini" v-model="attendance.funeralLeaveDays" :min="0" :precision="1" style="width: 100px"></el-input-number>
                                </el-form-item>
                            </el-col>
                            <el-col :span="6">
                                <el-form-item label="工伤假(天):" prop="workInjuryLeaveDays">
                                    <el-input-number size="mini" v-model="attendance.workInjuryLeaveDays" :min="0" :precision="1" style="width: 100px"></el-input-number>
                                </el-form-item>
                            </el-col>
                        </el-row>
                        <el-row>
                            <el-col :span="8">
                                <el-form-item label="产检假(h):" prop="prenatalCheckLeaveHours">
                                    <el-input-number size="mini" v-model="attendance.prenatalCheckLeaveHours" :min="0" :precision="1" style="width: 100px"></el-input-number>
                                </el-form-item>
                            </el-col>
                            <el-col :span="8">
                                <el-form-item label="哺乳假(h):" prop="breastfeedingLeaveHours">
                                    <el-input-number size="mini" v-model="attendance.breastfeedingLeaveHours" :min="0" :precision="1" style="width: 100px"></el-input-number>
                                </el-form-item>
                            </el-col>
                            <el-col :span="8">
                                <el-form-item label="育儿假(h):" prop="childcareLeaveHours">
                                    <el-input-number size="mini" v-model="attendance.childcareLeaveHours" :min="0" :precision="1" style="width: 100px"></el-input-number>
                                </el-form-item>
                            </el-col>
                        </el-row>
                    </fieldset>
                </el-form>
            </div>
            <span slot="footer" class="dialog-footer">
                <el-button @click="dialogVisible = false">取 消</el-button>
                <el-button type="primary" @click="doAdd">确 定</el-button>
            </span>
        </el-dialog>
        
        <el-dialog
            title="上传考勤休假表"
            :visible.sync="uploadDialogVisible"
            width="30%">
            <div style="text-align: center">
                <el-upload
                    drag
                    action="/personnel/attendance/import"
                    :show-file-list="false"
                    :on-success="onSuccess"
                    :on-error="onError"
                    :before-upload="beforeUpload">
                    <i class="el-icon-upload"></i>
                    <div class="el-upload__text">将文件拖到此处，或<em>点击上传</em></div>
                    <div class="el-upload__tip" slot="tip">
                        <el-button type="text" @click="downloadTemplate">下载模板</el-button>
                    </div>
                </el-upload>
            </div>
        </el-dialog>
    </div>
</template>

<script>
    export default {
        name: "PerAttendance",
        data() {
            return {
                title: '',
                importDataBtnText: '导入数据',
                importDataBtnIcon: 'el-icon-upload2',
                importDataDisabled: false,
                showAdvanceSearchView: false,
                attendances: [],
                loading: false,
                dialogVisible: false,
                uploadDialogVisible: false,
                total: 0,
                page: 1,
                keyword: '',
                size: 10,
                employees: [],
                searchLoading: false,
                attendance: {
                    name: '',
                    idCard: '',
                    year: new Date().getFullYear(),
                    month: new Date().getMonth() + 1,
                    lateEarlyLeaveTimes: 0,
                    missingCardTimes: 0,
                    overtimeHours: 0,
                    compLeaveHours: 0,
                    personalLeaveDays: 0,
                    sickLeaveDays: 0,
                    annualLeaveDays: 0,
                    marriageLeaveDays: 0,
                    maternityLeaveDays: 0,
                    paternityLeaveDays: 0,
                    funeralLeaveDays: 0,
                    workInjuryLeaveDays: 0,
                    prenatalCheckLeaveHours: 0,
                    breastfeedingLeaveHours: 0,
                    childcareLeaveHours: 0
                },
                rules: {
                    idCard: [{required: true, message: '请选择员工', trigger: 'blur'}],
                    year: [{required: true, message: '请输入年份', trigger: 'blur'}],
                    month: [{required: true, message: '请输入月份', trigger: 'blur'}]
                }
            }
        },
        mounted() {
            this.initAttendances();
        },
        methods: {
            remoteMethod(query) {
                if (query !== '') {
                    this.searchLoading = true;
                    this.getRequest("/employee/basic/simple?name=" + query).then(resp => {
                         this.searchLoading = false;
                         if (resp) {
                             this.employees = resp;
                         }
                    });
                } else {
                    this.employees = [];
                }
            },
            handleEmpChange(idCard) {
                let emp = this.employees.find(item => item.idCard === idCard);
                if (emp) {
                    this.attendance.name = emp.name;
                    this.attendance.idCard = emp.idCard;
                }
            },
            downloadTemplate() {
                window.open('/personnel/attendance/import/template', '_parent');
            },
            onSuccess(response, file, fileList) {
                this.uploadDialogVisible = false;
                if (response.status == 200) {
                    this.$message({type: 'success', message: response.msg});
                    if (response.obj && response.obj.length > 0) {
                        // Show errors
                        let html = '<div>';
                        response.obj.forEach(err => {
                            html += '<div>' + err + '</div>';
                        });
                        html += '</div>';
                        this.$notify({
                            title: '导入部分失败',
                            dangerouslyUseHTMLString: true,
                            message: html,
                            duration: 0,
                            type: 'warning'
                        });
                    }
                    this.initAttendances();
                } else {
                    this.$message.error(response.msg);
                }
            },
            onError(err, file, fileList) {
                this.uploadDialogVisible = false;
                this.$message.error("上传失败");
            },
            beforeUpload(file) {
                // Check file size/type if needed
            },
            exportData() {
                window.open('/personnel/attendance/export', '_parent');
            },
            importData() {
                this.uploadDialogVisible = true;
            },
            sizeChange(currentSize) {
                this.size = currentSize;
                this.initAttendances();
            },
            currentChange(currentPage) {
                this.page = currentPage;
                this.initAttendances();
            },
            showAddDialog() {
                this.emptyAttendance();
                this.title = '添加考勤信息';
                this.dialogVisible = true;
            },
            showEditDialog(data) {
                this.title = '编辑考勤信息';
                this.attendance = Object.assign({}, data);
                // Pre-populate select options with current employee so it shows correctly
                this.employees = [{name: data.name, idCard: data.idCard}];
                this.dialogVisible = true;
            },
            deleteAttendance(data) {
                this.$confirm('此操作将永久删除【' + data.name + '】的考勤记录, 是否继续?', '提示', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning'
                }).then(() => {
                    this.deleteRequest("/personnel/attendance/" + data.id).then(resp => {
                        if (resp) {
                            this.initAttendances();
                        }
                    })
                }).catch(() => {
                    this.$message({
                        type: 'info',
                        message: '已取消删除'
                    });
                });
            },
            doAdd() {
                this.$refs['empForm'].validate(valid => {
                    if (valid) {
                        if (this.attendance.id) {
                            this.putRequest("/personnel/attendance/", this.attendance).then(resp => {
                                if (resp) {
                                    this.dialogVisible = false;
                                    this.initAttendances();
                                }
                            })
                        } else {
                            this.postRequest("/personnel/attendance/", this.attendance).then(resp => {
                                if (resp) {
                                    this.dialogVisible = false;
                                    this.initAttendances();
                                }
                            })
                        }
                    }
                });
            },
            initAttendances() {
                this.loading = true;
                let url = '/personnel/attendance/?page=' + this.page + '&size=' + this.size;
                if (this.keyword) {
                    url += "&keyword=" + this.keyword;
                }
                this.getRequest(url).then(resp => {
                    this.loading = false;
                    if (resp) {
                        this.attendances = resp.data;
                        this.total = resp.total;
                    }
                });
            },
            emptyAttendance() {
                this.attendance = {
                    name: '',
                    idCard: '',
                    year: new Date().getFullYear(),
                    month: new Date().getMonth() + 1,
                    lateEarlyLeaveTimes: 0,
                    missingCardTimes: 0,
                    overtimeHours: 0,
                    compLeaveHours: 0,
                    personalLeaveDays: 0,
                    sickLeaveDays: 0,
                    annualLeaveDays: 0,
                    marriageLeaveDays: 0,
                    maternityLeaveDays: 0,
                    paternityLeaveDays: 0,
                    funeralLeaveDays: 0,
                    workInjuryLeaveDays: 0,
                    prenatalCheckLeaveHours: 0,
                    breastfeedingLeaveHours: 0,
                    childcareLeaveHours: 0
                };
                this.employees = [];
            }
        }
    }
</script>

<style scoped>

</style>
