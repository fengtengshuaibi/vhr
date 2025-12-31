<template>
    <div>
        <div>
            <div style="display: flex;justify-content: space-between">
                <div>
                    <el-input placeholder="请输入员工姓名" prefix-icon="el-icon-search"
                              clearable
                              @clear="initInterviews"
                              style="width: 200px;margin-right: 10px" v-model="keyword"
                              @keydown.enter.native="initInterviews"></el-input>
                    <el-select v-model="typeSearch" placeholder="访谈类型" clearable style="width: 150px;margin-right: 10px">
                        <el-option label="试用期访谈" :value="0"></el-option>
                        <el-option label="合同续签访谈" :value="1"></el-option>
                        <el-option label="绩效访谈" :value="2"></el-option>
                    </el-select>
                    <el-input placeholder="请输入年份"
                              clearable
                              style="width: 100px;margin-right: 10px" v-model="yearSearch"
                              type="number"></el-input>
                    <el-button icon="el-icon-search" type="primary" @click="initInterviews">
                        搜索
                    </el-button>
                </div>
                <div>
                    <el-button type="primary" icon="el-icon-plus" @click="showAddDialog">
                        添加访谈
                    </el-button>
                </div>
            </div>
        </div>
        <div style="margin-top: 10px">
            <el-table
                    :data="interviews"
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
                <el-table-column prop="employee.name" fixed align="left" label="姓名" width="120"></el-table-column>
                <el-table-column prop="year" label="年份" align="left" width="80"></el-table-column>
                <el-table-column prop="interviewDate" width="120" align="left" label="访谈日期">
                    <template slot-scope="scope">{{formatDate(scope.row.interviewDate)}}</template>
                </el-table-column>
                <el-table-column prop="type" label="访谈类型" width="150">
                    <template slot-scope="scope">
                        <span v-if="scope.row.type==0">试用期访谈</span>
                        <span v-else-if="scope.row.type==1">合同续签访谈</span>
                        <span v-else-if="scope.row.type==2">绩效访谈</span>
                    </template>
                </el-table-column>
                <el-table-column label="访谈内容" width="150">
                    <template slot-scope="scope">
                        <el-button @click="showContent(scope.row.content)" type="text">查看内容</el-button>
                    </template>
                </el-table-column>
                <el-table-column label="附件">
                    <template slot-scope="scope">
                        <el-popover
                            placement="left"
                            width="300"
                            trigger="click">
                            <div>
                                <div v-if="!scope.row.attachmentUrl || parseAttachments(scope.row.attachmentUrl).length === 0">暂无附件</div>
                                <div v-else v-for="(file, index) in parseAttachments(scope.row.attachmentUrl)" :key="index" style="margin-bottom: 5px; display: flex; justify-content: space-between; align-items: center;">
                                    <span style="overflow: hidden; text-overflow: ellipsis; white-space: nowrap; max-width: 200px;" :title="file.name">{{ file.name }}</span>
                                    <el-button type="text" size="mini" @click="downloadFile(file.name)">下载</el-button>
                                </div>
                            </div>
                            <el-button slot="reference" type="text" size="mini" v-if="scope.row.attachmentUrl && parseAttachments(scope.row.attachmentUrl).length > 0">查看附件</el-button>
                            <span slot="reference" v-else>无</span>
                        </el-popover>
                    </template>
                </el-table-column>
                <el-table-column fixed="right" width="200" label="操作">
                    <template slot-scope="scope">
                        <el-button @click="showEditDialog(scope.row)" style="padding: 3px" size="mini">编辑</el-button>
                        <el-button @click="deleteInterview(scope.row)" style="padding: 3px" size="mini" type="danger">删除</el-button>
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
        
        <!-- Add/Edit Dialog -->
        <el-dialog
                :title="title"
                :visible.sync="dialogVisible"
                width="50%">
            <div>
                <el-form :model="interview" ref="empForm">
                    <el-row>
                        <el-col :span="12">
                            <el-form-item label="员工姓名:" prop="eid">
                                <!-- Remote Search for Employee -->
                                <el-select v-model="interview.eid" filterable remote reserve-keyword placeholder="请输入员工姓名"
                                           :remote-method="remoteMethod" :loading="searchLoading">
                                    <el-option
                                            v-for="item in employees"
                                            :key="item.idCard"
                                            :label="item.name + ' (' + item.idCard + ')'"
                                            :value="item.idCard">
                                    </el-option>
                                </el-select>
                            </el-form-item>
                        </el-col>
                        <el-col :span="12">
                            <el-form-item label="访谈类型:" prop="type">
                                <el-select v-model="interview.type" placeholder="访谈类型" style="width: 200px;">
                                    <el-option label="试用期访谈" :value="0"></el-option>
                                    <el-option label="合同续签访谈" :value="1"></el-option>
                                    <el-option label="绩效访谈" :value="2"></el-option>
                                </el-select>
                            </el-form-item>
                        </el-col>
                    </el-row>
                    <el-row>
                        <el-col :span="12">
                            <el-form-item label="年份:" prop="year">
                                <el-input v-model="interview.year" type="number" style="width: 200px;"></el-input>
                            </el-form-item>
                        </el-col>
                        <el-col :span="12">
                            <el-form-item label="访谈日期:" prop="interviewDate">
                                <el-date-picker
                                        v-model="interview.interviewDate"
                                        type="date"
                                        value-format="yyyy-MM-dd"
                                        placeholder="选择日期"
                                        style="width: 200px;">
                                </el-date-picker>
                            </el-form-item>
                        </el-col>
                    </el-row>
                    <el-row>
                        <el-col :span="24">
                            <el-form-item label="访谈内容:" prop="content">
                                <el-input type="textarea" :rows="4" v-model="interview.content" maxlength="500" show-word-limit></el-input>
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
                                        action="/per/interview/upload"
                                        :on-success="handleUploadSuccess"
                                        :on-error="handleUploadError"
                                        :before-upload="beforeUpload"
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
                <el-button type="primary" @click="doAddInterview">确 定</el-button>
            </span>
        </el-dialog>

        <!-- Content Dialog -->
        <el-dialog
                title="访谈内容"
                :visible.sync="contentDialogVisible"
                width="30%">
            <div>{{contentView}}</div>
            <span slot="footer" class="dialog-footer">
                <el-button type="primary" @click="contentDialogVisible = false">确 定</el-button>
            </span>
        </el-dialog>
    </div>
</template>

<script>
    export default {
        name: "PerInterview",
        data() {
            return {
                interviews: [],
                loading: false,
                total: 0,
                page: 1,
                size: 10,
                keyword: '',
                typeSearch: null,
                yearSearch: null,
                dialogVisible: false,
                contentDialogVisible: false,
                title: '',
                interview: {
                    eid: '',
                    year: new Date().getFullYear(),
                    interviewDate: '',
                    type: null,
                    content: '',
                    attachmentUrl: ''
                },
                contentView: '',
                employees: [],
                searchLoading: false,
                fileList: []
            }
        },
        mounted() {
            this.initInterviews();
        },
        methods: {
            sizeChange(currentSize) {
                this.size = currentSize;
                this.initInterviews();
            },
            currentChange(currentPage) {
                this.page = currentPage;
                this.initInterviews();
            },
            initInterviews() {
                this.loading = true;
                let url = '/per/interview/?page=' + this.page + '&size=' + this.size;
                if (this.keyword) url += "&empName=" + this.keyword;
                if (this.typeSearch !== null && this.typeSearch !== '') url += "&type=" + this.typeSearch;
                if (this.yearSearch) url += "&year=" + this.yearSearch;
                
                this.getRequest(url).then(resp => {
                    this.loading = false;
                    if (resp) {
                        this.interviews = resp.data;
                        this.total = resp.total;
                    }
                });
            },
            showAddDialog() {
                this.title = '添加访谈';
                this.interview = {
                    eid: '',
                    year: new Date().getFullYear(),
                    interviewDate: '',
                    type: null,
                    content: '',
                    attachmentUrl: ''
                };
                this.fileList = [];
                this.dialogVisible = true;
            },
            showEditDialog(data) {
                this.title = '编辑访谈';
                this.interview = Object.assign({}, data);
                // Need to set employee name for select
                this.employees = [{idCard: data.eid, name: data.employee.name, workID: data.employee.workID}];
                this.fileList = this.parseAttachments(data.attachmentUrl);
                this.dialogVisible = true;
            },
            deleteInterview(data) {
                this.$confirm('此操作将永久删除该访谈记录, 是否继续?', '提示', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning'
                }).then(() => {
                    this.deleteRequest("/per/interview/" + data.id).then(resp => {
                        if (resp) {
                            this.initInterviews();
                        }
                    })
                }).catch(() => {
                    this.$message({
                        type: 'info',
                        message: '已取消删除'
                    });
                });
            },
            doAddInterview() {
                if (this.interview.id) {
                    this.putRequest("/per/interview/", this.interview).then(resp => {
                        if (resp) {
                            this.dialogVisible = false;
                            this.initInterviews();
                        }
                    })
                } else {
                    this.postRequest("/per/interview/", this.interview).then(resp => {
                        if (resp) {
                            this.dialogVisible = false;
                            this.initInterviews();
                        }
                    })
                }
            },
            showContent(content) {
                this.contentView = content;
                this.contentDialogVisible = true;
            },
            downloadFile(fileName) {
                window.open('/per/interview/download/' + fileName, '_parent');
            },
            remoteMethod(query) {
                if (query !== '') {
                    this.searchLoading = true;
                    // Need an endpoint to search employees by name. 
                    // Using /employee/basic/simple to avoid data masking which might mask the ID Card used as value
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
            handleUploadSuccess(response, file, fileList) {
                if (response.status === 200) {
                    let fileObj = JSON.parse(response.obj);
                    // Use a temporary date or today's date if we don't know the exact folder on server yet
                    // But backend returns full URL, we can parse date from it if needed, or just store URL
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
                        this.deleteRequest("/per/interview/file?fileName=" + file.name + "&date=" + date).then(resp => {
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
                // Not used with custom list
            },
            updateAttachmentUrl() {
                // Store as JSON array string: [{"name":"abc.txt","url":"..."}]
                this.interview.attachmentUrl = JSON.stringify(this.fileList);
            },
            handleUploadError(err, file, fileList) {
                this.$message.error('上传失败');
            },
            beforeUpload(file) {
                const isLt10M = file.size / 1024 / 1024 < 10;
                if (!isLt10M) {
                    this.$message.error('上传文件大小不能超过 10MB!');
                }
                return isLt10M;
            },
            formatDate(dateStr) {
                if (!dateStr) return '';
                if (typeof dateStr === 'string' && dateStr.length >= 10) {
                    return dateStr.substring(0, 10);
                }
                return dateStr;
            },
            parseAttachments(urlStr) {
                if (!urlStr) return [];
                try {
                    // Check if it's a JSON array
                    if (urlStr.startsWith('[')) {
                        return JSON.parse(urlStr);
                    } else {
                        // Backward compatibility for single URL string
                        // Try to extract filename from URL
                        let name = urlStr.substring(urlStr.lastIndexOf('/') + 1);
                        return [{name: name, url: urlStr}];
                    }
                } catch (e) {
                    return [];
                }
            }
        }
    }
</script>

<style scoped>

</style>
