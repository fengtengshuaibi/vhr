<template>
    <div>
        <div>
            <div style="display: flex;justify-content: space-between">
                <div>
                    <el-input placeholder="请输入员工名进行搜索..." prefix-icon="el-icon-search"
                              clearable
                              @clear="initContracts"
                              style="width: 300px;margin-right: 10px" v-model="searchValue.name"
                              @keydown.enter.native="initContracts" :disabled="showAdvanceSearchView"></el-input>
                    <el-button icon="el-icon-search" type="primary" @click="initContracts" :disabled="showAdvanceSearchView">
                        搜索
                    </el-button>
                    <el-button type="primary" @click="showAdvanceSearchView = !showAdvanceSearchView">
                        <i :class="showAdvanceSearchView?'fa fa-angle-double-up':'fa fa-angle-double-down'"
                           aria-hidden="true"></i>
                        高级搜索
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
                            action="/personnel/contract/import">
                        <el-button :disabled="importDataDisabled" type="success" :icon="importDataBtnIcon">
                            {{importDataBtnText}}
                        </el-button>
                    </el-upload>
                    <el-button type="success" @click="downloadTemplate" icon="el-icon-download">
                        下载模板
                    </el-button>
                    <el-button type="success" @click="exportData" icon="el-icon-download">
                        导出数据
                    </el-button>
                    <el-button type="primary" icon="el-icon-plus" @click="showAddEmpView">
                        添加合同
                    </el-button>
                </div>
            </div>
            <transition name="slide-fade">
                <div v-show="showAdvanceSearchView"
                     style="border: 1px solid #409eff;border-radius: 5px;box-sizing: border-box;padding: 5px;margin: 10px 0px;">
                    <el-row>
                        <el-col :span="5">
                            合同类型:
                            <el-select v-model="searchValue.contractType" placeholder="合同类型" size="mini"
                                       style="width: 130px;">
                                <el-option label="固定期限" value="固定期限"></el-option>
                                <el-option label="无固定期限" value="无固定期限"></el-option>
                            </el-select>
                        </el-col>
                        <el-col :span="5">
                            用工形式:
                            <el-select v-model="searchValue.employmentType" placeholder="用工形式" size="mini"
                                       style="width: 130px;">
                                <el-option label="全日制" value="全日制"></el-option>
                                <el-option label="非全日制" value="非全日制"></el-option>
                            </el-select>
                        </el-col>
                        <el-col :span="5">
                            签订次数:
                            <el-select v-model="searchValue.signCount" placeholder="签订次数" size="mini"
                                       style="width: 130px;">
                                <el-option label="1" :value="1"></el-option>
                                <el-option label="2" :value="2"></el-option>
                                <el-option label="3" :value="3"></el-option>
                            </el-select>
                        </el-col>
                        <el-col :span="5">
                            到期天数(<=):
                            <el-input size="mini" style="width: 130px" prefix-icon="el-icon-edit"
                                      v-model="searchValue.daysToExpiry" placeholder="到期天数"></el-input>
                        </el-col>
                        <el-col :span="4">
                            <el-button size="mini" @click="cancelSearch">取消</el-button>
                            <el-button size="mini" icon="el-icon-search" type="primary" @click="initContracts('advanced')">搜索</el-button>
                        </el-col>
                    </el-row>
                </div>
            </transition>
        </div>
        <div style="margin-top: 10px">
            <el-table
                    :data="contracts"
                    stripe
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
                        width="150"
                        align="left"
                        label="身份证号">
                </el-table-column>
                <el-table-column
                        prop="employmentType"
                        label="用工形式"
                        align="left"
                        width="85">
                </el-table-column>
                <el-table-column
                        prop="contractType"
                        label="合同类型"
                        align="left"
                        width="85">
                </el-table-column>
                <el-table-column
                        prop="firstSignDate"
                        width="100"
                        align="left"
                        label="首次签订日期">
                </el-table-column>
                <el-table-column
                        prop="firstSignTerm"
                        width="100"
                        align="left"
                        label="首次期限(年)">
                </el-table-column>
                <el-table-column
                        prop="secondSignDate"
                        width="100"
                        align="left"
                        label="二签日期">
                </el-table-column>
                <el-table-column
                        prop="secondSignTerm"
                        width="100"
                        align="left"
                        label="二签期限(年)">
                </el-table-column>
                <el-table-column
                        prop="thirdSignDate"
                        width="100"
                        align="left"
                        label="三签日期">
                </el-table-column>
                <el-table-column
                        prop="signCount"
                        width="70"
                        align="left"
                        label="签订次数">
                </el-table-column>
                <el-table-column
                        prop="endDate"
                        width="100"
                        align="left"
                        label="最新合同终止日期">
                </el-table-column>
                <el-table-column
                        prop="daysToExpiry"
                        width="100"
                        align="left"
                        label="到期天数">
                        <template slot-scope="scope">
                            <span v-if="scope.row.daysToExpiry <= 30" style="color: red; font-weight: bold">{{ scope.row.daysToExpiry }}</span>
                            <span v-else>{{ scope.row.daysToExpiry }}</span>
                        </template>
                </el-table-column>
                <el-table-column
                        min-width="150"
                        align="center"
                        label="附件">
                    <template slot-scope="scope">
                        <el-popover
                            placement="left"
                            width="300"
                            trigger="click">
                            <div>
                                <div v-if="!scope.row.attachments || parseAttachments(scope.row.attachments).length === 0">暂无附件</div>
                                <div v-else v-for="(file, index) in parseAttachments(scope.row.attachments)" :key="index" style="margin-bottom: 5px; display: flex; justify-content: space-between; align-items: center;">
                                    <span style="overflow: hidden; text-overflow: ellipsis; white-space: nowrap; max-width: 200px;" :title="file.name">{{ file.name }}</span>
                                    <el-button type="text" size="mini" @click="downloadFile(file.url)">下载</el-button>
                                </div>
                            </div>
                            <el-button slot="reference" type="text" size="mini" v-if="scope.row.attachments && parseAttachments(scope.row.attachments).length > 0">查看附件</el-button>
                            <span slot="reference" v-else>无</span>
                        </el-popover>
                    </template>
                </el-table-column>
                <el-table-column
                        fixed="right"
                        width="200"
                        label="操作">
                    <template slot-scope="scope">
                        <el-button @click="showEditEmpView(scope.row)" style="padding: 3px" size="mini">编辑</el-button>
                        <el-button @click="deleteEmp(scope.row)" style="padding: 3px" size="mini" type="danger">删除
                        </el-button>
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
                :title="title"
                :visible.sync="dialogVisible"
                width="80%">
            <div>
                <el-form :model="contract" :rules="rules" ref="empForm">
                    <el-row>
                        <el-col :span="6">
                            <el-form-item label="姓名:" prop="name">
                                <el-input size="mini" style="width: 150px" prefix-icon="el-icon-edit" v-model="contract.name"
                                          placeholder="请输入员工姓名" :disabled="true"></el-input>
                            </el-form-item>
                        </el-col>
                        <el-col :span="6">
                            <el-form-item label="身份证号:" prop="idCard">
                                <el-select v-model="contract.idCard" filterable placeholder="请选择员工" size="mini" style="width: 150px;" :disabled="!!contract.idCard && title == '编辑合同'" @change="handleEmpChange">
                                    <el-option
                                        v-for="item in employees"
                                        :key="item.idCard"
                                        :label="item.name"
                                        :value="item.idCard">
                                        <span style="float: left">{{ item.name }}</span>
                                        <span style="float: right; color: #8492a6; font-size: 13px">{{ item.idCard }}</span>
                                    </el-option>
                                </el-select>
                            </el-form-item>
                        </el-col>
                        <el-col :span="6">
                            <el-form-item label="用工形式:" prop="employmentType">
                                <el-select v-model="contract.employmentType" placeholder="用工形式" size="mini" style="width: 150px;">
                                    <el-option label="全日制" value="全日制"></el-option>
                                    <el-option label="非全日制" value="非全日制"></el-option>
                                </el-select>
                            </el-form-item>
                        </el-col>
                        <el-col :span="6">
                            <el-form-item label="合同类型:" prop="contractType">
                                <el-select v-model="contract.contractType" placeholder="合同类型" size="mini" style="width: 150px;">
                                    <el-option label="固定期限" value="固定期限"></el-option>
                                    <el-option label="无固定期限" value="无固定期限"></el-option>
                                </el-select>
                            </el-form-item>
                        </el-col>
                    </el-row>
                    <el-row>
                        <el-col :span="6">
                            <el-form-item label="首次签订日期:" prop="firstSignDate">
                                <el-date-picker
                                        v-model="contract.firstSignDate"
                                        size="mini"
                                        type="date"
                                        value-format="yyyy-MM-dd"
                                        style="width: 150px;"
                                        placeholder="首次签订日期">
                                </el-date-picker>
                            </el-form-item>
                        </el-col>
                        <el-col :span="6">
                            <el-form-item label="首次期限(年):" prop="firstSignTerm">
                                <el-input size="mini" style="width: 150px" prefix-icon="el-icon-edit"
                                          v-model="contract.firstSignTerm" placeholder="首次期限"></el-input>
                            </el-form-item>
                        </el-col>
                        <el-col :span="6">
                            <el-form-item label="二签日期:" prop="secondSignDate">
                                <el-date-picker
                                        v-model="contract.secondSignDate"
                                        size="mini"
                                        type="date"
                                        value-format="yyyy-MM-dd"
                                        style="width: 150px;"
                                        placeholder="二签日期">
                                </el-date-picker>
                            </el-form-item>
                        </el-col>
                        <el-col :span="6">
                            <el-form-item label="二签期限(年):" prop="secondSignTerm">
                                <el-input size="mini" style="width: 150px" prefix-icon="el-icon-edit"
                                          v-model="contract.secondSignTerm" placeholder="二签期限"></el-input>
                            </el-form-item>
                        </el-col>
                    </el-row>
                    <el-row>
                        <el-col :span="6">
                            <el-form-item label="三签日期:" prop="thirdSignDate">
                                <el-date-picker
                                        v-model="contract.thirdSignDate"
                                        size="mini"
                                        type="date"
                                        value-format="yyyy-MM-dd"
                                        style="width: 150px;"
                                        placeholder="三签日期">
                                </el-date-picker>
                            </el-form-item>
                        </el-col>
                        <el-col :span="6">
                            <el-form-item label="签订次数:" prop="signCount">
                                <el-select v-model="contract.signCount" placeholder="签订次数" size="mini" style="width: 150px;">
                                    <el-option label="1" :value="1"></el-option>
                                    <el-option label="2" :value="2"></el-option>
                                    <el-option label="3" :value="3"></el-option>
                                </el-select>
                            </el-form-item>
                        </el-col>
                        <el-col :span="6">
                            <el-form-item label="截止日期:" prop="endDate">
                                <el-date-picker
                                        v-model="contract.endDate"
                                        size="mini"
                                        type="date"
                                        value-format="yyyy-MM-dd"
                                        style="width: 150px;"
                                        placeholder="截止日期">
                                </el-date-picker>
                            </el-form-item>
                        </el-col>
                    </el-row>
                    <el-row>
                        <el-col :span="24">
                            <el-form-item label="附件:">
                                <div v-for="(file, index) in fileList" :key="index" style="display: flex; align-items: center; margin-bottom: 5px;">
                                    <span style="margin-right: 10px;">{{file.name}}</span>
                                    <el-button type="text" icon="el-icon-delete" style="color: #f56c6c;" @click="removeFile(file, index)"></el-button>
                                </div>
                                <el-upload
                                        class="upload-demo"
                                        action="/personnel/contract/upload"
                                        :on-success="handleUploadSuccess"
                                        :on-error="handleUploadError"
                                        :before-upload="beforeUploadFile"
                                        multiple
                                        :show-file-list="false">
                                    <el-button size="small" type="primary">点击上传</el-button>
                                    <div slot="tip" class="el-upload__tip">只能上传文件，且不超过10MB</div>
                                </el-upload>
                            </el-form-item>
                        </el-col>
                    </el-row>
                </el-form>
            </div>
            <span slot="footer" class="dialog-footer">
                <el-button @click="dialogVisible = false">取 消</el-button>
                <el-button type="primary" @click="doAddEmp">确 定</el-button>
            </span>
        </el-dialog>
    </div>
</template>

<script>
    export default {
        name: "PerContract",
        data() {
            return {
                searchValue: {
                    name: null,
                    contractType: null,
                    employmentType: null,
                    signCount: null,
                    daysToExpiry: null
                },
                title: '',
                importDataBtnText: '导入数据',
                importDataBtnIcon: 'el-icon-upload2',
                importDataDisabled: false,
                showAdvanceSearchView: false,
                allDeps: [],
                contracts: [],
                loading: false,
                popVisible: false,
                popVisible2: false,
                dialogVisible: false,
                total: 0,
                page: 1,
                keyword: '',
                size: 10,
                nations: [],
                joblevels: [],
                politicsstatus: [],
                positions: [],
                tiptopDegrees: ['本科', '大专', '硕士', '博士', '高中', '初中', '小学', '其他'],
                options: [{
                    value: '选项1',
                    label: '黄金糕'
                }, {
                    value: '选项2',
                    label: '双皮奶'
                }, {
                    value: '选项3',
                    label: '蚵仔煎'
                }, {
                    value: '选项4',
                    label: '龙须面'
                }, {
                    value: '选项5',
                    label: '北京烤鸭'
                }],
                contract: {
                    name: "javaboy",
                    idCard: "610122199001011256",
                    employmentType: "全日制",
                    contractType: "固定期限",
                    firstSignDate: "2018-01-01",
                    firstSignTerm: 3.0,
                    secondSignDate: null,
                    secondSignTerm: null,
                    thirdSignDate: null,
                    signCount: 1,
                    endDate: "2020-12-31",
                    attachments: ""
                },
                employees: [],
                fileList: [],
                rules: {
                    idCard: [{required: true, message: '请输入身份证号', trigger: 'blur'}],
                    employmentType: [{required: true, message: '请输入用工形式', trigger: 'blur'}],
                    contractType: [{required: true, message: '请输入合同类型', trigger: 'blur'}]
                }
            }
        },
        mounted() {
            this.initContracts();
            this.initData();
        },
        methods: {
            downloadTemplate() {
                window.open('/personnel/contract/import/template', '_parent');
            },
            downloadFile(fileName) {
                window.open('/personnel/contract/download/' + fileName, '_parent');
            },
            handleUploadSuccess(response, file, fileList) {
                if (response && response.status == 200) {
                    this.fileList.push({name: response.obj, url: ''});
                    this.updateAttachments();
                } else {
                    this.$message.error('上传失败');
                }
            },
            handleRemove(file, fileList) {
                this.fileList = fileList;
                this.updateAttachments();
            },
            updateAttachments() {
                let attachments = [];
                this.fileList.forEach(file => {
                    attachments.push(file.name);
                });
                this.contract.attachments = attachments.join(',');
            },
            handleEmpChange(idCard) {
                if (idCard) {
                    const emp = this.employees.find(e => e.idCard === idCard);
                    if (emp) {
                        this.contract.name = emp.name;
                    }
                }
            },
            searvhViewHandleNodeClick(data) {
                this.inputDepName = data.name;
                this.searchValue.departmentId = data.id;
                this.popVisible2 = !this.popVisible2
            },
            handleUploadSuccess(response, file, fileList) {
                if (response.status === 200) {
                    let fileObj = JSON.parse(response.obj);
                    // Use a temporary date or today's date if we don't know the exact folder on server yet
                    // URL format: .../download/YYYYMMDD/filename
                    let urlParts = fileObj.url.split('/');
                    let date = urlParts[urlParts.length - 2];
                    this.fileList.push({name: fileObj.name, url: fileObj.url, date: date});
                    this.updateAttachmentUrl();
                    this.$message.success('上传成功');
                } else {
                    this.$message.error(response.msg);
                }
            },
            removeFile(file, index) {
                this.$confirm('此操作将永久删除该文件, 是否继续?', '提示', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning'
                }).then(() => {
                    // Try to extract date from URL if not present in object
                    let date = file.date;
                    if (!date && file.url) {
                        let urlParts = file.url.split('/');
                        date = urlParts[urlParts.length - 2];
                    }
                    if (date && file.name) {
                        this.deleteRequest("/personnel/contract/file?fileName=" + file.name + "&date=" + date).then(resp => {
                            if (resp) {
                                this.fileList.splice(index, 1);
                                this.updateAttachmentUrl();
                            }
                        });
                    } else {
                        // Fallback for legacy data or error
                        this.fileList.splice(index, 1);
                        this.updateAttachmentUrl();
                    }
                }).catch(() => {
                    this.$message({
                        type: 'info',
                        message: '已取消删除'
                    });
                });
            },
            handleRemove(file, fileList) {
                // Not used
            },
            updateAttachmentUrl() {
                // Store as JSON array string: [{"name":"abc.txt","url":"..."}]
                this.contract.attachments = JSON.stringify(this.fileList);
            },
            handleUploadError(err, file, fileList) {
                this.$message.error('上传失败');
            },
            beforeUploadFile(file) {
                const isLt10M = file.size / 1024 / 1024 < 10;
                if (!isLt10M) {
                    this.$message.error('上传文件大小不能超过 10MB!');
                }
                return isLt10M;
            },
            downloadFile(url) {
                window.open(url, '_blank');
            },
            parseAttachments(urlStr) {
                if (!urlStr) return [];
                try {
                    // Check if it's a JSON array
                    if (urlStr.startsWith('[')) {
                        return JSON.parse(urlStr);
                    } else {
                        // Backward compatibility or legacy string handling if needed
                        return [];
                    }
                } catch (e) {
                    return [];
                }
            },
            onError(err, file, fileList) {
                this.importDataBtnText = '导入数据';
                this.importDataBtnIcon = 'el-icon-upload2';
                this.importDataDisabled = false;
            },
            onSuccess(response, file, fileList) {
                this.importDataBtnText = '导入数据';
                this.importDataBtnIcon = 'el-icon-upload2';
                this.importDataDisabled = false;
                this.initContracts();
            },
            beforeUpload() {
                this.importDataBtnText = '正在导入';
                this.importDataBtnIcon = 'el-icon-loading';
                this.importDataDisabled = true;
            },
            exportData() {
                window.open('/personnel/contract/export', '_parent');
            },
            emptyEmp() {
                this.fileList = [];
                this.contract = {
                    name: "",
                    idCard: "",
                    employmentType: "",
                    contractType: "",
                    firstSignDate: "",
                    firstSignTerm: null,
                    secondSignDate: null,
                    secondSignTerm: null,
                    thirdSignDate: null,
                    signCount: null,
                    endDate: "",
                    attachments: ""
                }
            },
            showEditEmpView(data) {
                this.title = '编辑合同';
                this.contract = Object.assign({}, data);
                this.fileList = this.parseAttachments(data.attachments);
                this.dialogVisible = true;
            },
            deleteEmp(data) {
                this.$confirm('此操作将永久删除【' + data.name + '】的合同, 是否继续?', '提示', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning'
                }).then(() => {
                    this.deleteRequest("/personnel/contract/" + data.idCard).then(resp => {
                        if (resp) {
                            this.initContracts();
                        }
                    })
                }).catch(() => {
                    this.$message({
                        type: 'info',
                        message: '已取消删除'
                    });
                });
            },
            doAddEmp() {
                if (this.contract.idCard) {
                    this.$refs['empForm'].validate(valid => {
                        if (this.title == '编辑合同') {
                            this.putRequest("/personnel/contract/", this.contract).then(resp => {
                                if (resp) {
                                    this.dialogVisible = false;
                                    this.initContracts();
                                }
                            })
                        } else if (this.title == '添加合同') {
                            this.postRequest("/personnel/contract/", this.contract).then(resp => {
                                if (resp) {
                                    this.dialogVisible = false;
                                    this.initContracts();
                                }
                            })
                        }
                    });
                }
            },
            initData() {
                this.getRequest("/employee/basic/simple").then(resp => {
                    if (resp) {
                        this.employees = resp;
                    }
                });
            },
            sizeChange(currentSize) {
                this.size = currentSize;
                this.initContracts();
            },
            currentChange(currentPage) {
                this.page = currentPage;
                this.initContracts();
            },
            showAddEmpView() {
                this.emptyEmp();
                this.title = '添加合同';
                this.dialogVisible = true;
            },
            cancelSearch() {
                this.showAdvanceSearchView = false;
                this.searchValue = {
                    name: null,
                    contractType: null,
                    employmentType: null,
                    signCount: null,
                    daysToExpiry: null
                };
                this.initContracts();
            },
            initContracts(type) {
                this.loading = true;
                let url = '/personnel/contract/?page=' + this.page + '&size=' + this.size;
                if (type && type == 'advanced') {
                    if (this.searchValue.contractType) {
                        url += '&contractType=' + this.searchValue.contractType;
                    }
                    if (this.searchValue.employmentType) {
                        url += '&employmentType=' + this.searchValue.employmentType;
                    }
                    if (this.searchValue.signCount) {
                        url += '&signCount=' + this.searchValue.signCount;
                    }
                    if (this.searchValue.daysToExpiry) {
                        url += '&daysToExpiry=' + this.searchValue.daysToExpiry;
                    }
                } else {
                    if (this.searchValue.name) {
                        url += "&name=" + this.searchValue.name;
                    }
                }
                this.getRequest(url).then(resp => {
                    this.loading = false;
                    if (resp) {
                        this.contracts = resp.data;
                        this.total = resp.total;
                    }
                });
            }
        }
    }
</script>

<style>
    /* 可以添加样式 */
    .slide-fade-enter-active {
        transition: all .8s ease;
    }

    .slide-fade-leave-active {
        transition: all .8s cubic-bezier(1.0, 0.5, 0.8, 1.0);
    }

    .slide-fade-enter, .slide-fade-leave-to
        /* .slide-fade-leave-active for below version 2.1.8 */
    {
        transform: translateX(10px);
        opacity: 0;
    }
</style>
