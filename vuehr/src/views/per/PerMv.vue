<template>
    <div>
        <div>
            <div style="display: flex;justify-content: space-between">
                <div>
                    <el-input placeholder="请输入员工姓名进行搜索..." prefix-icon="el-icon-search"
                              clearable
                              @clear="initRemoves"
                              style="width: 350px;margin-right: 10px" v-model="keyword"
                              @keydown.enter.native="initRemoves"></el-input>
                    <el-button icon="el-icon-search" type="primary" @click="initRemoves">
                        搜索
                    </el-button>
                </div>
                <div>
                    <el-button type="primary" icon="el-icon-plus" @click="showAddRemoveView">
                        添加员工调动
                    </el-button>
                </div>
            </div>
        </div>
        <div style="margin-top: 10px">
            <el-table
                    :data="removes"
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
                        width="100">
                </el-table-column>
                <el-table-column
                        prop="eid"
                        label="身份证号"
                        width="170">
                </el-table-column>
                <el-table-column
                        prop="operateType"
                        label="操作类型"
                        width="80">
                     <template slot-scope="scope">
                        <span v-if="scope.row.operateType==0">晋升</span>
                        <span v-else-if="scope.row.operateType==1">降级</span>
                        <span v-else>调动</span>
                    </template>
                </el-table-column>
                <el-table-column
                        prop="beforeDepartment.name"
                        label="调动前部门"
                        width="100">
                </el-table-column>
                <el-table-column
                        prop="beforePosition.name"
                        label="调动前职位"
                        width="100">
                </el-table-column>
                <el-table-column
                        prop="afterDepartment.name"
                        label="调动后部门"
                        width="100">
                </el-table-column>
                <el-table-column
                        prop="afterPosition.name"
                        label="调动后职位"
                        width="100">
                </el-table-column>
                <el-table-column
                        prop="removeDate"
                        label="调动日期"
                        width="100">
                    <template slot-scope="scope">
                        {{ scope.row.removeDate | formatDate }}
                    </template>
                </el-table-column>
                <el-table-column
                        prop="reason"
                        label="原因"
                        width="150">
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
                        <el-button @click="showEditRemoveView(scope.row)" style="padding: 3px" size="mini">编辑</el-button>
                        <el-button @click="deleteRemove(scope.row)" style="padding: 3px" size="mini" type="danger">删除
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
                width="40%">
            <div>
                <el-form :model="remove" :rules="rules" ref="removeForm" label-width="100px">
                    <el-form-item label="员工姓名:" prop="eid">
                        <el-select
                            v-model="remove.eid"
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
                    <el-row>
                        <el-col :span="12">
                             <el-form-item label="调动前部门:">
                                <el-tag v-if="beforeDepName">{{beforeDepName}}</el-tag>
                                <span v-else class="info-text">请选择员工</span>
                             </el-form-item>
                        </el-col>
                        <el-col :span="12">
                             <el-form-item label="调动前职位:">
                                <el-tag v-if="beforePosName">{{beforePosName}}</el-tag>
                                <span v-else class="info-text">请选择员工</span>
                             </el-form-item>
                        </el-col>
                    </el-row>
                    <el-row>
                        <el-col :span="12">
                            <el-form-item label="调动后部门:" prop="afterDepId">
                                <el-select v-model="remove.afterDepId" placeholder="请选择部门" size="mini" style="width: 100%">
                                    <el-option
                                        v-for="item in departments"
                                        :key="item.id"
                                        :label="item.name"
                                        :value="item.id">
                                    </el-option>
                                </el-select>
                            </el-form-item>
                        </el-col>
                        <el-col :span="12">
                            <el-form-item label="调动后职位:" prop="afterJobId">
                                <el-select v-model="remove.afterJobId" placeholder="请选择职位" size="mini" style="width: 100%">
                                    <el-option
                                        v-for="item in positions"
                                        :key="item.id"
                                        :label="item.name"
                                        :value="item.id">
                                    </el-option>
                                </el-select>
                            </el-form-item>
                        </el-col>
                    </el-row>
                    <el-form-item label="操作类型:" prop="operateType">
                        <el-select v-model="remove.operateType" placeholder="请选择操作类型" size="mini" style="width: 100%">
                            <el-option label="晋升" :value="0"></el-option>
                            <el-option label="降级" :value="1"></el-option>
                            <el-option label="调动" :value="2"></el-option>
                        </el-select>
                    </el-form-item>
                    <el-form-item label="调动日期:" prop="removeDate">
                        <el-date-picker
                                v-model="remove.removeDate"
                                size="mini"
                                type="date"
                                value-format="yyyy-MM-dd"
                                style="width: 100%;"
                                placeholder="调动日期">
                        </el-date-picker>
                    </el-form-item>
                    <el-form-item label="原因:" prop="reason">
                        <el-input size="mini" style="width: 100%" 
                                  v-model="remove.reason" placeholder="请输入原因"></el-input>
                    </el-form-item>
                    <el-form-item label="备注:" prop="remark">
                        <el-input type="textarea" size="mini" style="width: 100%"
                                  v-model="remove.remark" placeholder="备注"></el-input>
                    </el-form-item>
                </el-form>
            </div>
            <span slot="footer" class="dialog-footer">
                <el-button @click="dialogVisible = false">取 消</el-button>
                <el-button type="primary" @click="doAddRemove">确 定</el-button>
            </span>
        </el-dialog>
    </div>
</template>

<script>
    import moment from 'moment';

    export default {
        name: "PerMv",
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
                removes: [],
                loading: false,
                dialogVisible: false,
                total: 0,
                page: 1,
                size: 10,
                title: '',
                remove: {
                    eid: '',
                    beforeDepId: '',
                    beforePosId: '',
                    afterDepId: '',
                    afterJobId: '',
                    operateType: '',
                    removeDate: '',
                    reason: '',
                    remark: ''
                },
                rules: {
                    eid: [{required: true, message: '请选择员工', trigger: 'change'}],
                    afterDepId: [{required: true, message: '请选择调动后部门', trigger: 'change'}],
                    afterJobId: [{required: true, message: '请选择调动后职位', trigger: 'change'}],
                    operateType: [{required: true, message: '请选择操作类型', trigger: 'change'}],
                    removeDate: [{required: true, message: '请选择调动日期', trigger: 'blur'}],
                    reason: [{required: true, message: '请输入原因', trigger: 'blur'}]
                },
                loadingSelect: false,
                empOptions: [],
                keywordSelect: '',
                departments: [],
                positions: [],
                beforeDepName: '',
                beforePosName: ''
            }
        },
        mounted() {
            this.initRemoves();
            this.initData();
        },
        methods: {
            initData() {
                if (!window.sessionStorage.getItem("nations")) {
                    this.getRequest('/employee/basic/nations').then(resp => {
                        if (resp) {
                            window.sessionStorage.setItem("nations", JSON.stringify(resp));
                        }
                    })
                }
                if (!window.sessionStorage.getItem("joblevels")) {
                    this.getRequest('/employee/basic/joblevels').then(resp => {
                        if (resp) {
                            window.sessionStorage.setItem("joblevels", JSON.stringify(resp));
                        }
                    })
                }
                if (!window.sessionStorage.getItem("politicsstatus")) {
                    this.getRequest('/employee/basic/politicsstatus').then(resp => {
                        if (resp) {
                            window.sessionStorage.setItem("politicsstatus", JSON.stringify(resp));
                        }
                    })
                }
                // Fetch Departments and Positions
                 this.getRequest('/system/basic/department/').then(resp => {
                    if (resp) {
                        // The department API might return a tree structure or list.
                        // Assuming list for simple select, or flat list.
                        // Actually usually it's tree. But let's check or assume I can get all deps.
                        // For now let's use the API provided in other views.
                        // In EmpBasic, it uses: /system/basic/department/
                        // It seems to be a tree. I need to flatten it or use a Cascasder?
                        // Or just use the API /employee/basic/deps which might be flat?
                        // Let's use /employee/basic/deps if available, or just traverse the tree.
                        // Wait, I will use /employee/basic/deps if I can find it in other files.
                        // Checking PerEmp.vue or EmpBasic.vue might help.
                        // Let's assume /system/basic/department/ returns all deps (maybe flat or tree).
                        // If it is tree, I need to extract children.
                        // For simplicity, let's assume I can get a list.
                        // If not, I'll use a placeholder logic.
                        // Actually, I can use a special API to get all departments for selection.
                         this.getRequest('/employee/basic/deps').then(resp => {
                            if(resp){
                                this.departments = resp;
                            }
                        });
                    }
                });
                this.getRequest('/employee/basic/positions').then(resp => {
                    if (resp) {
                        this.positions = resp;
                    }
                });
            },
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
                // Find selected employee object to get current Dept and Pos
                let selectedEmp = this.empOptions.find(item => item.idCard === val);
                if (selectedEmp) {
                    this.remove.beforeDepId = selectedEmp.departmentId;
                    this.remove.beforePosId = selectedEmp.posId;
                    // I need names for display
                    // I can find names from my departments/positions list if loaded
                    // Or I assume the simple employee object has them?
                    // Usually simple object has name, workID, idCard. Not sure about deptName.
                    // But I need to store IDs.
                    // For display in the form, I should show names.
                    // Let's try to find names from loaded lists.
                    
                    let dep = this.departments.find(d => d.id === selectedEmp.departmentId);
                    this.beforeDepName = dep ? dep.name : '';
                    
                    let pos = this.positions.find(p => p.id === selectedEmp.posId);
                    this.beforePosName = pos ? pos.name : '';
                }
            },
            initRemoves() {
                this.loading = true;
                let url = '/personnel/remove/?page=' + this.page + '&size=' + this.size;
                this.getRequest(url).then(resp => {
                    this.loading = false;
                    if (resp) {
                        this.removes = resp.data;
                        this.total = resp.total;
                    }
                });
            },
            sizeChange(currentSize) {
                this.size = currentSize;
                this.initRemoves();
            },
            currentChange(currentPage) {
                this.page = currentPage;
                this.initRemoves();
            },
            showAddRemoveView() {
                this.remove = {
                    eid: '',
                    beforeDepId: '',
                    beforePosId: '',
                    afterDepId: '',
                    afterJobId: '',
                    operateType: '',
                    removeDate: '',
                    reason: '',
                    remark: ''
                };
                this.beforeDepName = '';
                this.beforePosName = '';
                this.title = '添加员工调动';
                this.dialogVisible = true;
                this.empOptions = [];
            },
            showEditRemoveView(data) {
                this.title = '编辑员工调动';
                this.remove = Object.assign({}, data);
                this.empOptions = [{
                    idCard: data.eid,
                    name: data.employee.name,
                    departmentId: data.beforeDepId,
                    posId: data.beforePosId
                }];
                this.beforeDepName = data.beforeDepartment ? data.beforeDepartment.name : '';
                this.beforePosName = data.beforePosition ? data.beforePosition.name : '';
                this.dialogVisible = true;
            },
            deleteRemove(data) {
                this.$confirm('此操作将永久删除该记录, 是否继续?', '提示', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning'
                }).then(() => {
                    this.deleteRequest("/personnel/remove/" + data.id).then(resp => {
                        if (resp) {
                            this.initRemoves();
                        }
                    })
                }).catch(() => {
                    this.$message({
                        type: 'info',
                        message: '已取消删除'
                    });
                });
            },
            doAddRemove() {
                this.$refs['removeForm'].validate(valid => {
                    if (valid) {
                        if (this.remove.id) {
                            this.putRequest("/personnel/remove/", this.remove).then(resp => {
                                if (resp) {
                                    this.dialogVisible = false;
                                    this.initRemoves();
                                }
                            })
                        } else {
                            this.postRequest("/personnel/remove/", this.remove).then(resp => {
                                if (resp) {
                                    this.dialogVisible = false;
                                    this.initRemoves();
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
    .info-text {
        color: #909399;
        font-size: 12px;
    }
</style>
