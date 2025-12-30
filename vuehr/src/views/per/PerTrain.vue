<template>
    <div>
        <div>
            <div style="display: flex;justify-content: space-between">
                <div>
                    <el-input placeholder="请输入员工姓名进行搜索..." prefix-icon="el-icon-search"
                              clearable
                              @clear="initTrains"
                              style="width: 350px;margin-right: 10px" v-model="keyword"
                              @keydown.enter.native="initTrains"></el-input>
                    <el-button icon="el-icon-search" type="primary" @click="initTrains">
                        搜索
                    </el-button>
                </div>
                <div>
                    <el-button type="primary" icon="el-icon-plus" @click="showAddTrainView">
                        添加培训
                    </el-button>
                </div>
            </div>
        </div>
        <div style="margin-top: 10px">
            <el-table
                    :data="trains"
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
                        prop="traindate"
                        label="培训日期"
                        width="120">
                    <template slot-scope="scope">
                        {{ scope.row.traindate | formatDate }}
                    </template>
                </el-table-column>
                <el-table-column
                        prop="traincontent"
                        label="培训名称"
                        width="200">
                </el-table-column>
                <el-table-column
                        prop="score"
                        label="分数"
                        width="80">
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
                        <el-button @click="showEditTrainView(scope.row)" style="padding: 3px" size="mini">编辑</el-button>
                        <el-button @click="deleteTrain(scope.row)" style="padding: 3px" size="mini" type="danger">删除
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
                <el-form :model="train" :rules="rules" ref="trainForm">
                    <el-form-item label="员工姓名:" prop="eid">
                        <el-select
                            v-model="train.eid"
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
                        <span v-if="empOptions.length === 0 && keywordSelect !== '' && !loadingSelect" style="color: red; font-size: 12px; display: block;">
                            未找到该员工，请先录入员工信息
                        </span>
                    </el-form-item>
                    <el-form-item label="培训日期:" prop="traindate">
                        <el-date-picker
                                v-model="train.traindate"
                                size="mini"
                                type="date"
                                value-format="yyyy-MM-dd"
                                style="width: 100%;"
                                placeholder="培训日期">
                        </el-date-picker>
                    </el-form-item>
                    <el-form-item label="培训名称:" prop="traincontent">
                        <el-input size="mini" style="width: 100%" prefix-icon="el-icon-edit"
                                  v-model="train.traincontent" placeholder="请输入培训名称"></el-input>
                    </el-form-item>
                    <el-form-item label="分数:" prop="score">
                        <el-input size="mini" style="width: 100%" type="number"
                                  v-model="train.score" placeholder="请输入分数"></el-input>
                    </el-form-item>
                    <el-form-item label="备注:" prop="remark">
                        <el-input type="textarea" size="mini" style="width: 100%"
                                  v-model="train.remark" placeholder="备注"></el-input>
                    </el-form-item>
                </el-form>
            </div>
            <span slot="footer" class="dialog-footer">
                <el-button @click="dialogVisible = false">取 消</el-button>
                <el-button type="primary" @click="doAddTrain">确 定</el-button>
            </span>
        </el-dialog>
    </div>
</template>

<script>
    import moment from 'moment';

    export default {
        name: "PerTrain",
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
                trains: [],
                loading: false,
                dialogVisible: false,
                total: 0,
                page: 1,
                size: 10,
                title: '',
                train: {
                    eid: '',
                    traindate: '',
                    traincontent: '',
                    score: '',
                    remark: ''
                },
                rules: {
                    eid: [{required: true, message: '请选择员工', trigger: 'change'}],
                    traindate: [{required: true, message: '请选择培训日期', trigger: 'blur'}],
                    traincontent: [{required: true, message: '请输入培训名称', trigger: 'blur'}],
                    score: [{required: true, message: '请输入分数', trigger: 'blur'}]
                },
                loadingSelect: false,
                empOptions: [],
                keywordSelect: ''
            }
        },
        mounted() {
            this.initTrains();
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
                            // Map simple employee list to options (need idCard as value)
                            // The API /employee/basic/simple returns List<Employee>
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
            initTrains() {
                this.loading = true;
                let url = '/personnel/train/?page=' + this.page + '&size=' + this.size;
                if (this.keyword) {
                    // Check if keyword is for name or training content
                    // Backend supports emp.name via parameter
                    // We can pass it as generic keyword, but backend expects structure
                    // Let's assume searching by employee name
                    url += "&employee.name=" + this.keyword;
                }
                this.getRequest(url).then(resp => {
                    this.loading = false;
                    if (resp) {
                        this.trains = resp.data;
                        this.total = resp.total;
                    }
                });
            },
            sizeChange(currentSize) {
                this.size = currentSize;
                this.initTrains();
            },
            currentChange(currentPage) {
                this.page = currentPage;
                this.initTrains();
            },
            showAddTrainView() {
                this.train = {
                    eid: '',
                    traindate: '',
                    traincontent: '',
                    score: '',
                    remark: ''
                };
                this.title = '添加培训信息';
                this.dialogVisible = true;
                this.empOptions = []; 
            },
            showEditTrainView(data) {
                this.title = '编辑培训信息';
                this.train = Object.assign({}, data);
                // Pre-fill employee option
                this.empOptions = [{
                    idCard: data.eid,
                    name: data.employee.name
                }];
                this.dialogVisible = true;
            },
            deleteTrain(data) {
                this.$confirm('此操作将永久删除该记录, 是否继续?', '提示', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning'
                }).then(() => {
                    this.deleteRequest("/personnel/train/" + data.id).then(resp => {
                        if (resp) {
                            this.initTrains();
                        }
                    })
                }).catch(() => {
                    this.$message({
                        type: 'info',
                        message: '已取消删除'
                    });
                });
            },
            doAddTrain() {
                this.$refs['trainForm'].validate(valid => {
                    if (valid) {
                        if (this.train.id) {
                            this.putRequest("/personnel/train/", this.train).then(resp => {
                                if (resp) {
                                    this.dialogVisible = false;
                                    this.initTrains();
                                }
                            })
                        } else {
                            this.postRequest("/personnel/train/", this.train).then(resp => {
                                if (resp) {
                                    this.dialogVisible = false;
                                    this.initTrains();
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
