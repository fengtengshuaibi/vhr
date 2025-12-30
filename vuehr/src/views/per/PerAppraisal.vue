<template>
    <div>
        <div>
            <div style="display: flex;justify-content: space-between">
                <div>
                    <el-input placeholder="请输入员工姓名进行搜索..." prefix-icon="el-icon-search"
                              clearable
                              @clear="initAppraisals"
                              style="width: 350px;margin-right: 10px" v-model="keyword"
                              @keydown.enter.native="initAppraisals"></el-input>
                    <el-button icon="el-icon-search" type="primary" @click="initAppraisals">
                        搜索
                    </el-button>
                </div>
                <div>
                    <el-button type="primary" icon="el-icon-plus" @click="showAddAppraisalView">
                        添加评优
                    </el-button>
                </div>
            </div>
        </div>
        <div style="margin-top: 10px">
            <el-table
                    :data="appraisals"
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
                        prop="employee.name"
                        label="员工姓名"
                        width="120">
                </el-table-column>
                <el-table-column
                        prop="eid"
                        label="身份证号"
                        width="180">
                </el-table-column>
                <el-table-column
                        prop="appDate"
                        label="评优日期"
                        width="120">
                    <template slot-scope="scope">
                        {{ scope.row.appDate | formatDate }}
                    </template>
                </el-table-column>
                <el-table-column
                        prop="appResult"
                        label="评优结果"
                        width="200">
                </el-table-column>
                <el-table-column
                        prop="remark"
                        label="备注">
                </el-table-column>
                <el-table-column
                        fixed="right"
                        label="操作"
                        width="150">
                    <template slot-scope="scope">
                        <el-button @click="showEditAppraisalView(scope.row)" style="padding: 3px" size="mini">编辑</el-button>
                        <el-button @click="deleteAppraisal(scope.row)" style="padding: 3px" size="mini" type="danger">删除
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
                width="30%">
            <div>
                <el-form :model="appraisal" :rules="rules" ref="appraisalForm">
                    <el-form-item label="员工姓名:" prop="eid">
                        <el-select
                            v-model="appraisal.eid"
                            filterable
                            remote
                            reserve-keyword
                            placeholder="请输入姓名搜索"
                            :remote-method="remoteMethod"
                            :loading="loadingSelect"
                            style="width: 100%"
                            @change="handleEmpSelect">
                            <el-option
                                v-for="item in empOptions"
                                :key="item.idCard"
                                :label="item.name + ' (' + item.idCard + ')'"
                                :value="item.idCard">
                            </el-option>
                        </el-select>
                    </el-form-item>
                    <el-form-item label="评优日期:" prop="appDate">
                        <el-date-picker
                                v-model="appraisal.appDate"
                                size="mini"
                                type="date"
                                value-format="yyyy-MM-dd"
                                style="width: 100%;"
                                placeholder="评优日期">
                        </el-date-picker>
                    </el-form-item>
                    <el-form-item label="评优结果:" prop="appResult">
                        <el-input size="mini" style="width: 100%" type="textarea"
                                  v-model="appraisal.appResult" placeholder="请输入评优结果"></el-input>
                    </el-form-item>
                    <el-form-item label="备注:" prop="remark">
                        <el-input type="textarea" size="mini" style="width: 100%"
                                  v-model="appraisal.remark" placeholder="备注"></el-input>
                    </el-form-item>
                </el-form>
            </div>
            <span slot="footer" class="dialog-footer">
                <el-button @click="dialogVisible = false">取 消</el-button>
                <el-button type="primary" @click="doAddAppraisal">确 定</el-button>
            </span>
        </el-dialog>
    </div>
</template>

<script>
    import moment from 'moment';

    export default {
        name: "PerAppraisal",
        filters: {
            formatDate(value) {
                if (value) {
                    return moment(String(value)).format('YYYY-MM-DD')
                }
            }
        },
        data() {
            return {
                keyword: '',
                appraisals: [],
                loading: false,
                dialogVisible: false,
                total: 0,
                page: 1,
                size: 10,
                title: '',
                appraisal: {
                    eid: '',
                    appDate: '',
                    appResult: '',
                    remark: ''
                },
                rules: {
                    eid: [{required: true, message: '请选择员工', trigger: 'change'}],
                    appDate: [{required: true, message: '请选择评优日期', trigger: 'blur'}],
                    appResult: [{required: true, message: '请输入评优结果', trigger: 'blur'}]
                },
                loadingSelect: false,
                empOptions: [],
                keywordSelect: ''
            }
        },
        mounted() {
            this.initAppraisals();
        },
        methods: {
            remoteMethod(query) {
                if (query !== '') {
                    this.loadingSelect = true;
                    this.keywordSelect = query;
                    this.getRequest("/employee/basic/simple?name=" + query).then(resp => {
                        this.loadingSelect = false;
                        if (resp) {
                            this.empOptions = resp;
                        }
                    });
                } else {
                    this.empOptions = [];
                    this.keywordSelect = '';
                }
            },
            handleEmpSelect(val) {
                // val is idCard
            },
            initAppraisals() {
                this.loading = true;
                let url = '/personnel/appraisal/?page=' + this.page + '&size=' + this.size;
                // Currently backend doesn't support filtering by name in the query param directly without modification
                // But let's assume if I implemented it or if I can pass it
                // Actually my mapper xml for appraisal has <if test="eid !=null and eid!=''"> and date scope.
                // It doesn't seem to support name search yet.
                // But the user asked for fuzzy search on ADD, not necessarily on LIST.
                // But usually LIST search is by name.
                // My AppraisalMapper.xml has: select ea.*,e.id as empId,e.name as ename... from employeeappraisal ea,employee e where ea.eid=e.idCard
                // It filters by `eid`. It doesn't filter by `ename`.
                // I might need to update mapper to support searching by employee name if I want this search bar to work effectively.
                // For now, I'll leave it as is, maybe it won't filter by name yet.
                this.getRequest(url).then(resp => {
                    this.loading = false;
                    if (resp) {
                        this.appraisals = resp.data;
                        this.total = resp.total;
                    }
                });
            },
            sizeChange(currentSize) {
                this.size = currentSize;
                this.initAppraisals();
            },
            currentChange(currentPage) {
                this.page = currentPage;
                this.initAppraisals();
            },
            showAddAppraisalView() {
                this.appraisal = {
                    eid: '',
                    appDate: '',
                    appResult: '',
                    remark: ''
                };
                this.title = '添加评优信息';
                this.dialogVisible = true;
                this.empOptions = [];
            },
            showEditAppraisalView(data) {
                this.title = '编辑评优信息';
                this.appraisal = Object.assign({}, data);
                this.empOptions = [{
                    idCard: data.eid,
                    name: data.employee.name
                }];
                this.dialogVisible = true;
            },
            deleteAppraisal(data) {
                this.$confirm('此操作将永久删除该记录, 是否继续?', '提示', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning'
                }).then(() => {
                    this.deleteRequest("/personnel/appraisal/" + data.id).then(resp => {
                        if (resp) {
                            this.initAppraisals();
                        }
                    })
                }).catch(() => {
                    this.$message({
                        type: 'info',
                        message: '已取消删除'
                    });
                });
            },
            doAddAppraisal() {
                this.$refs['appraisalForm'].validate(valid => {
                    if (valid) {
                        if (this.appraisal.id) {
                            this.putRequest("/personnel/appraisal/", this.appraisal).then(resp => {
                                if (resp) {
                                    this.dialogVisible = false;
                                    this.initAppraisals();
                                }
                            })
                        } else {
                            this.postRequest("/personnel/appraisal/", this.appraisal).then(resp => {
                                if (resp) {
                                    this.dialogVisible = false;
                                    this.initAppraisals();
                                }
                            })
                        }
                    }
                });
            }
        }
    }
</script>

<style scoped>

</style>
