<template>
    <div>
        <div style="display: flex; justify-content: space-between">
            <div>
                <el-input placeholder="请输入职位名称进行搜索..." prefix-icon="el-icon-search"
                          clearable
                          @clear="initPositions"
                          style="width: 300px;margin-right: 10px" v-model="keyword"
                          @keydown.enter.native="initPositions"></el-input>
                <el-button icon="el-icon-search" type="primary" @click="initPositions">搜索</el-button>
            </div>
            <div>
                <el-input
                        size="small"
                        class="addPosInput"
                        v-loading="loading"
                        element-loading-text="正在加载..."
                        element-loading-spinner="el-icon-loading"
                        element-loading-background="rgba(0, 0, 0, 0.8)"
                        placeholder="添加职位..."
                        prefix-icon="el-icon-plus"
                        @keydown.enter.native="addPosition"
                        v-model="pos.name">
                </el-input>
                <el-select v-model="pos.reportTo" filterable placeholder="汇报上级(必填)" size="small" style="width: 200px; margin-right: 8px;">
                    <el-option
                            v-for="item in employees"
                            :key="item.idCard"
                            :label="item.name"
                            :value="item.idCard">
                        <span style="float: left">{{ item.name }}</span>
                        <span style="float: right; color: #8492a6; font-size: 13px">{{ item.idCard }}</span>
                    </el-option>
                </el-select>
                <el-button icon="el-icon-plus" size="small" type="primary" @click="addPosition">添加</el-button>
            </div>
        </div>
        <div class="posManaMain">
            <el-table
                    :data="positions"
                    border
                    @selection-change="handleSelectionChange"
                    size="small"
                    stripe
                    style="width: 100%">
                <el-table-column
                        type="selection"
                        width="55">
                </el-table-column>
                <el-table-column
                        prop="id"
                        label="编号"
                        width="55">
                </el-table-column>
                <el-table-column
                        prop="name"
                        label="职位名称"
                        width="180">
                </el-table-column>
                <el-table-column
                        label="汇报上级"
                        width="180">
                    <template slot-scope="scope">
                        {{ getEmpName(scope.row.reportTo) }}
                    </template>
                </el-table-column>
                <el-table-column
                        prop="createDate"
                        width="150"
                        label="创建时间">
                </el-table-column>
                <el-table-column
                        label="是否启用">
                    <template slot-scope="scope">
                        <el-tag size="small" type="success" v-if="scope.row.enabled">已启用</el-tag>
                        <el-tag size="small" type="danger" v-else>未启用</el-tag>
                    </template>
                </el-table-column>
                <el-table-column label="操作">
                    <template slot-scope="scope">
                        <el-button
                                size="mini"
                                @click="showEditView(scope.$index, scope.row)">编辑
                        </el-button>
                        <el-button
                                size="mini"
                                type="danger"
                                @click="handleDelete(scope.$index, scope.row)">删除
                        </el-button>
                    </template>
                </el-table-column>
            </el-table>
            <el-button @click="deleteMany" type="danger" size="small" style="margin-top: 8px"
                       :disabled="multipleSelection.length==0">批量删除
            </el-button>
            <div style="display: flex;justify-content: flex-end;margin-top: 10px">
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
                title="修改职位"
                :visible.sync="dialogVisible"
                width="30%">
            <div>
                <div style="margin-bottom: 10px;">
                    <el-tag>职位名称</el-tag>
                    <el-input class="updatePosInput" size="small" v-model="updatePos.name"></el-input>
                </div>
                <div style="margin-bottom: 10px;">
                    <el-tag>汇报上级</el-tag>
                    <el-select v-model="updatePos.reportTo" filterable placeholder="请选择汇报上级" size="small" style="width: 200px; margin-left: 8px;">
                        <el-option
                            v-for="item in employees"
                            :key="item.idCard"
                            :label="item.name"
                            :value="item.idCard">
                            <span style="float: left">{{ item.name }}</span>
                            <span style="float: right; color: #8492a6; font-size: 13px">{{ item.idCard }}</span>
                        </el-option>
                    </el-select>
                </div>
                <div>
                    <el-tag>是否启用</el-tag>
                    <el-switch
                            v-model="updatePos.enabled"
                            active-text="启用"
                            inactive-text="禁用">
                    </el-switch>
                </div>
            </div>
            <span slot="footer" class="dialog-footer">
    <el-button size="small" @click="dialogVisible = false">取 消</el-button>
    <el-button size="small" type="primary" @click="doUpdate">确 定</el-button>
  </span>
        </el-dialog>
    </div>
</template>

<script>
    export default {
        name: "PosMana",
        data() {
            return {
                pos: {
                    name: '',
                    reportTo: ''
                },
                dialogVisible: false,
                loading: false,
                updatePos: {
                    name: '',
                    enabled: false,
                    reportTo: ''
                },
                multipleSelection: [],
                positions: [],
                employees: [],
                total: 0,
                page: 1,
                size: 10,
                keyword: '',
                empMap: {}
            }
        },
        mounted() {
            this.initPositions();
            this.initEmployees();
        },
        methods: {
            getEmpName(idCard) {
                if (!idCard) return '无';
                const emp = this.employees.find(e => e.idCard === idCard);
                return emp ? emp.name : idCard;
            },
            sizeChange(currentSize) {
                this.size = currentSize;
                this.initPositions();
            },
            currentChange(currentPage) {
                this.page = currentPage;
                this.initPositions();
            },
            initEmployees() {
                // Reuse export interface to get all employees as it is the easiest way to get full list without paging or add new API
                // Or better, use a new simple API if I added one. I didn't add one yet. 
                // Let's use the /employee/basic/export approach but that returns file. 
                // Let's use getEmployeeByPage with large size or iterate?
                // Actually I will add a simple API in EmpBasicController now.
                this.getRequest("/employee/basic/simple").then(resp => {
                     if (resp) {
                         this.employees = resp;
                     }
                });
            },
            deleteMany() {
                this.$confirm('此操作将永久删除【' + this.multipleSelection.length + '】条记录, 是否继续?', '提示', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning'
                }).then(() => {
                    let ids = '?';
                    this.multipleSelection.forEach(item => {
                        ids += 'ids=' + item.id + '&';
                    })
                    this.deleteRequest("/system/basic/pos/" + ids).then(resp => {
                        if (resp) {
                            this.initPositions();
                        }
                    })
                }).catch(() => {
                    this.$message({
                        type: 'info',
                        message: '已取消删除'
                    });
                });
            },
            handleSelectionChange(val) {
                this.multipleSelection = val;
            },
            addPosition() {
                if (this.pos.name && this.pos.reportTo) {
                    this.postRequest("/system/basic/pos/", this.pos).then(resp => {
                        if (resp) {
                            this.initPositions();
                            this.pos.name = '';
                            this.pos.reportTo = '';
                        }
                    })
                } else {
                    this.$message.error('职位名称和汇报上级不可以为空');
                }
            },
            showEditView(index, data) {
                Object.assign(this.updatePos, data);
                this.dialogVisible = true;
            },
            doUpdate() {
                this.putRequest("/system/basic/pos/", this.updatePos).then(resp => {
                    if (resp) {
                        this.initPositions();
                        this.updatePos.name = '';
                        this.dialogVisible = false;
                    }
                })
            },
            handleDelete(index, data) {
                this.$confirm('此操作将永久删除【' + data.name + '】职位, 是否继续?', '提示', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning'
                }).then(() => {
                    this.deleteRequest("/system/basic/pos/" + data.id).then(resp => {
                        if (resp) {
                            this.initPositions();
                        }
                    })
                }).catch(() => {
                    this.$message({
                        type: 'info',
                        message: '已取消删除'
                    });
                });
            },
            initPositions() {
                this.loading = true;
                let url = '/system/basic/pos/?page=' + this.page + '&size=' + this.size;
                if (this.keyword) {
                    url += '&name=' + this.keyword;
                }
                this.getRequest(url).then(resp => {
                    this.loading = false;
                    if (resp) {
                        this.positions = resp.data;
                        this.total = resp.total;
                    }
                })
            }
        }
    }
</script>

<style>
    .addPosInput {
        width: 300px;
        margin-right: 8px
    }

    .updatePosInput {
        width: 200px;
        margin-left: 8px;
    }

    .posManaMain {
        margin-top: 10px;
    }
</style>