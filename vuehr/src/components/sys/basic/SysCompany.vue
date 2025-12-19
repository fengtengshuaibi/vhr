<template>
    <div>
        <div style="display: flex; justify-content: space-between">
            <div>
                <el-input placeholder="请输入公司名称进行搜索..." prefix-icon="el-icon-search"
                          clearable
                          @clear="initCompanies"
                          style="width: 300px;margin-right: 10px" v-model="keyword"
                          @keydown.enter.native="initCompanies"></el-input>
                <el-button icon="el-icon-search" type="primary" @click="initCompanies">搜索</el-button>
                <el-button icon="el-icon-plus" type="primary" @click="showAddView">添加公司</el-button>
            </div>
        </div>
        <div class="posManaMain">
            <el-table
                    :data="companies"
                    border
                    size="small"
                    stripe
                    style="width: 100%">
                <el-table-column
                        prop="id"
                        label="编号"
                        width="55">
                </el-table-column>
                <el-table-column
                        prop="name"
                        label="公司名称"
                        width="180">
                </el-table-column>
                <el-table-column
                        label="关联部门"
                        width="300">
                    <template slot-scope="scope">
                        <el-tag v-for="(name,index) in formatDepNames(scope.row.departmentIds)" :key="index" size="mini" style="margin-right: 5px; margin-bottom: 5px;">{{name}}</el-tag>
                    </template>
                </el-table-column>
                <el-table-column
                        label="关联职位"
                        width="300">
                    <template slot-scope="scope">
                        <el-tag v-for="(name,index) in formatPosNames(scope.row.posIds)" :key="index" size="mini" type="success" style="margin-right: 5px; margin-bottom: 5px;">{{name}}</el-tag>
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
                :title="dialogTitle"
                :visible.sync="dialogVisible"
                width="50%">
            <div>
                <div style="margin-bottom: 10px;">
                    <el-tag>公司名称</el-tag>
                    <el-input class="updatePosInput" size="small" v-model="company.name"></el-input>
                </div>
                <div style="margin-bottom: 10px;">
                    <el-tag>关联部门</el-tag>
                    <div style="border: 1px solid #eee; padding: 5px; border-radius: 4px; max-height: 200px; overflow: auto;">
                        <el-tree
                                :data="departments"
                                show-checkbox
                                node-key="id"
                                ref="depTree"
                                :props="defaultProps">
                        </el-tree>
                    </div>
                </div>
                <div>
                    <el-tag>关联职位</el-tag>
                    <el-select v-model="selectedPosIds" multiple placeholder="请选择职位" style="width: 100%; margin-top: 5px;">
                        <el-option
                                v-for="item in positions"
                                :key="item.id"
                                :label="item.name"
                                :value="item.id">
                        </el-option>
                    </el-select>
                </div>
            </div>
            <span slot="footer" class="dialog-footer">
                <el-button size="small" @click="dialogVisible = false">取 消</el-button>
                <el-button size="small" type="primary" @click="doAddOrUpdate">确 定</el-button>
            </span>
        </el-dialog>
    </div>
</template>

<script>
    export default {
        name: "SysCompany",
        computed: {
            depMap() {
                let map = {};
                const traverse = (deps) => {
                    deps.forEach(dep => {
                        map[dep.id] = dep.name;
                        if (dep.children && dep.children.length > 0) {
                            traverse(dep.children);
                        }
                    });
                };
                traverse(this.departments);
                return map;
            },
            posMap() {
                let map = {};
                this.positions.forEach(pos => {
                    map[pos.id] = pos.name;
                });
                return map;
            }
        },
        data() {
            return {
                company: {
                    name: '',
                    departmentIds: '',
                    posIds: ''
                },
                dialogVisible: false,
                dialogTitle: '添加公司',
                loading: false,
                companies: [],
                departments: [],
                positions: [],
                selectedPosIds: [],
                defaultProps: {
                    children: 'children',
                    label: 'name'
                },
                total: 0,
                page: 1,
                size: 10,
                keyword: ''
            }
        },
        mounted() {
            this.initCompanies();
            this.initData();
        },
        methods: {
            sizeChange(currentSize) {
                this.size = currentSize;
                this.initCompanies();
            },
            currentChange(currentPage) {
                this.page = currentPage;
                this.initCompanies();
            },
            initData() {
                this.getRequest("/employee/basic/deps").then(resp => {
                    if (resp) {
                        this.departments = resp;
                    }
                });
                this.getRequest("/employee/basic/positions").then(resp => {
                    if (resp) {
                        this.positions = resp;
                    }
                });
            },
            formatDepNames(ids) {
                if (!ids) return [];
                return ids.split(',').map(id => this.depMap[id]).filter(name => name);
            },
            formatPosNames(ids) {
                if (!ids) return [];
                return ids.split(',').map(id => this.posMap[id]).filter(name => name);
            },
            showAddView() {
                this.company = {
                    name: '',
                    departmentIds: '',
                    posIds: ''
                };
                this.selectedPosIds = [];
                this.dialogTitle = '添加公司';
                this.dialogVisible = true;
                this.$nextTick(() => {
                    if (this.$refs.depTree) {
                        this.$refs.depTree.setCheckedKeys([]);
                    }
                });
            },
            showEditView(index, data) {
                Object.assign(this.company, data);
                this.dialogTitle = '编辑公司';
                this.dialogVisible = true;
                this.selectedPosIds = data.posIds ? data.posIds.split(',').map(Number) : [];
                this.$nextTick(() => {
                    if (this.$refs.depTree) {
                        this.$refs.depTree.setCheckedKeys(data.departmentIds ? data.departmentIds.split(',').map(Number) : []);
                    }
                });
            },
            doAddOrUpdate() {
                if (this.company.name) {
                    this.company.posIds = this.selectedPosIds.join(',');
                    this.company.departmentIds = this.$refs.depTree.getCheckedKeys().join(',');
                    if (this.company.id) {
                        this.putRequest("/system/basic/company/", this.company).then(resp => {
                            if (resp) {
                                this.initCompanies();
                                this.dialogVisible = false;
                            }
                        })
                    } else {
                        this.postRequest("/system/basic/company/", this.company).then(resp => {
                            if (resp) {
                                this.initCompanies();
                                this.dialogVisible = false;
                            }
                        })
                    }
                } else {
                    this.$message.error('公司名称不可以为空');
                }
            },
            handleDelete(index, data) {
                this.$confirm('此操作将永久删除【' + data.name + '】, 是否继续?', '提示', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning'
                }).then(() => {
                    this.deleteRequest("/system/basic/company/" + data.id).then(resp => {
                        if (resp) {
                            this.initCompanies();
                        }
                    })
                }).catch(() => {
                    this.$message({
                        type: 'info',
                        message: '已取消删除'
                    });
                });
            },
            initCompanies() {
                this.loading = true;
                let url = '/system/basic/company/?page=' + this.page + '&size=' + this.size;
                if (this.keyword) {
                    url += '&name=' + this.keyword;
                }
                this.getRequest(url).then(resp => {
                    this.loading = false;
                    if (resp) {
                        this.companies = resp.data;
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
