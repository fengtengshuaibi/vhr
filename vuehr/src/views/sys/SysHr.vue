<template>
    <div>
        <div style="margin-top: 10px;display: flex;justify-content: center">
            <el-input v-model="keywords" placeholder="通过用户名搜索用户..." prefix-icon="el-icon-search"
                      style="width: 400px;margin-right: 10px" @keydown.enter.native="doSearch"></el-input>
            <el-button icon="el-icon-search" type="primary" @click="doSearch">搜索</el-button>
            <el-button icon="el-icon-plus" type="primary" @click="showAddHrView" v-if="isAdmin">添加用户</el-button>
        </div>
        <div class="hr-container">
            <el-card class="hr-card" v-for="(hr,index) in hrs" :key="index">
                <div slot="header" class="clearfix">
                    <span>{{hr.name}}</span>
                    <el-button style="float: right; padding: 3px 0;color: #e30007;" type="text"
                               icon="el-icon-delete" @click="deleteHr(hr)"></el-button>
                </div>
                <div>
                    <div class="img-container">
                        <img :src="hr.userface" :alt="hr.name" :title="hr.name" class="userface-img" @error="imgError">
                    </div>
                    <div class="userinfo-container">
                        <div>用户名：{{hr.name}}</div>
                        <div>手机号码：{{hr.phone}}</div>
                        <div>电话号码：{{hr.telephone}}</div>
                        <div>地址：{{hr.address}}</div>
                        <div>用户状态：
                            <el-switch
                                    v-model="hr.enabled"
                                    active-text="启用"
                                    @change="enabledChange(hr)"
                                    active-color="#13ce66"
                                    inactive-color="#ff4949"
                                    inactive-text="禁用">
                            </el-switch>
                        </div>
                        <div>用户角色：
                            <el-tag type="success" style="margin-right: 4px" v-for="(role,indexj) in hr.roles"
                                    :key="indexj">{{role.nameZh}}
                            </el-tag>
                            <el-popover
                                    placement="right"
                                    title="角色列表"
                                    @show="showPop(hr)"
                                    @hide="hidePop(hr)"
                                    width="200"
                                    trigger="click">
                                <el-select v-model="selectedRoles" multiple placeholder="请选择">
                                    <el-option
                                            v-for="(r,indexk) in allroles"
                                            :key="indexk"
                                            :label="r.nameZh"
                                            :value="r.id">
                                    </el-option>
                                </el-select>
                                <el-button slot="reference" icon="el-icon-more" type="text"></el-button>
                            </el-popover>
                        </div>
                        <div>备注：{{hr.remark}}</div>
                    </div>
                </div>
            </el-card>
        </div>
        <el-dialog
                title="添加用户"
                :visible.sync="dialogVisible"
                width="30%">
            <div>
                <el-form :model="hr" status-icon :rules="rules" ref="hrForm" label-width="100px" class="demo-ruleForm">
                    <el-form-item label="关联员工">
                        <el-select
                            v-model="hr.employeeId"
                            filterable
                            remote
                            reserve-keyword
                            placeholder="请输入员工名"
                            :remote-method="remoteMethod"
                            :loading="loading"
                            @change="handleEmpSelect"
                            style="width: 100%">
                            <el-option
                                v-for="item in employees"
                                :key="item.id"
                                :label="item.name + ' (' + item.workID + ')'"
                                :value="item.id">
                            </el-option>
                        </el-select>
                    </el-form-item>
                    <el-form-item label="用户名" prop="name">
                        <el-input v-model="hr.name"></el-input>
                    </el-form-item>
                    <el-form-item label="手机号码" prop="phone">
                        <el-input v-model="hr.phone"></el-input>
                    </el-form-item>
                    <el-form-item label="电话号码" prop="telephone">
                        <el-input v-model="hr.telephone"></el-input>
                    </el-form-item>
                    <el-form-item label="地址" prop="address">
                        <el-input v-model="hr.address"></el-input>
                    </el-form-item>
                    <el-form-item label="备注" prop="remark">
                        <el-input v-model="hr.remark"></el-input>
                    </el-form-item>
                    <el-form-item label="登录名" prop="username">
                        <el-input v-model="hr.username"></el-input>
                    </el-form-item>
                    <el-form-item label="密码" prop="password">
                        <el-input type="password" v-model="hr.password" autocomplete="off"></el-input>
                    </el-form-item>
                    <el-form-item label="是否启用" prop="enabled">
                        <el-switch
                                v-model="hr.enabled"
                                active-text="启用"
                                active-color="#13ce66"
                                inactive-color="#ff4949"
                                inactive-text="禁用">
                        </el-switch>
                    </el-form-item>
                    <el-form-item label="角色">
                        <el-select v-model="selectedRoles" multiple placeholder="请选择">
                            <el-option
                                    v-for="(r,indexk) in allroles"
                                    :key="indexk"
                                    :label="r.nameZh"
                                    :value="r.id">
                            </el-option>
                        </el-select>
                    </el-form-item>
                </el-form>
            </div>
            <span slot="footer" class="dialog-footer">
    <el-button @click="dialogVisible = false">取 消</el-button>
    <el-button type="primary" @click="doAddHr">确 定</el-button>
  </span>
        </el-dialog>
    </div>
</template>

<script>
    import img from '../../assets/logo.png';
    export default {
        name: "SysHr",
        data() {
            return {
                keywords: '',
                hrs: [],
                selectedRoles: [],
                allroles: [],
                dialogVisible: false,
                hr: {
                    name: '',
                    phone: '',
                    telephone: '',
                    address: '',
                    enabled: true,
                    username: '',
                    password: '',
                    remark: '',
                    userface: '',
                    employeeId: null
                },
                employees: [],
                loading: false,
                rules: {
                    name: [{required: true, message: '请输入用户名', trigger: 'blur'}],
                    phone: [{required: true, message: '请输入手机号码', trigger: 'blur'}],
                    telephone: [{required: true, message: '请输入电话号码', trigger: 'blur'}],
                    address: [{required: true, message: '请输入地址', trigger: 'blur'}],
                    enabled: [{required: true, message: '请输入用户状态', trigger: 'blur'}],
                    username: [{required: true, message: '请输入登录名', trigger: 'blur'}],
                    password: [{required: true, message: '请输入密码', trigger: 'blur'}]
                }
            }
        },
        computed: {
            isAdmin() {
                let roles = this.$store.state.currentHr.roles;
                let result = false;
                roles.forEach(role => {
                    if (role.name === 'ROLE_admin') {
                        result = true;
                    }
                });
                return result;
            }
        },
        mounted() {
            this.initHrs();
        },
        methods: {
            imgError(e) {
                e.target.src = img;
            },
            remoteMethod(query) {
                if (query !== '') {
                    this.loading = true;
                    this.getRequest('/employee/basic/?page=1&size=20&name=' + query).then(resp => {
                        this.loading = false;
                        if (resp && resp.data) {
                            this.employees = resp.data;
                        }
                    });
                } else {
                    this.employees = [];
                }
            },
            handleEmpSelect(val) {
                let emp = this.employees.find(e => e.id === val);
                if (emp) {
                    this.hr.name = emp.name;
                    this.hr.phone = emp.phone;
                    this.hr.telephone = emp.phone;
                    this.hr.address = emp.address;
                    // Optional: set username to ID Card or something unique if needed
                    // this.hr.username = emp.idCard; 
                }
            },
            showAddHrView() {
                this.dialogVisible = true;
                this.initAllRoles();
                this.hr = {
                    name: '',
                    phone: '',
                    telephone: '',
                    address: '',
                    enabled: true,
                    username: '',
                    password: '',
                    remark: '',
                    userface: '',
                    employeeId: null
                };
                this.selectedRoles = [];
                this.employees = [];
            },
            doAddHr() {
                if (this.selectedRoles.length == 0) {
                    this.$message.error('请选择用户角色');
                    return;
                }
                this.$refs['hrForm'].validate(valid => {
                    if (valid) {
                        this.postRequest("/system/hr/", this.hr).then(resp => {
                            if (resp) {
                                let hrid = resp.obj.id;
                                let url = '/system/hr/role?hrid=' + hrid;
                                this.selectedRoles.forEach(sr => {
                                    url += '&rids=' + sr;
                                });
                                this.putRequest(url).then(resp => {
                                    if (resp) {
                                        this.dialogVisible = false;
                                        this.initHrs();
                                    }
                                });
                            }
                        })
                    }
                })
            },
            deleteHr(hr) {
                this.$confirm('此操作将永久删除【'+hr.name+'】, 是否继续?', '提示', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning'
                }).then(() => {
                    this.deleteRequest("/system/hr/"+hr.id).then(resp=>{
                        if (resp) {
                            this.initHrs();
                        }
                    })
                }).catch(() => {
                    this.$message({
                        type: 'info',
                        message: '已取消删除'
                    });
                });
            },
            doSearch() {
                this.initHrs();
            },
            hidePop(hr) {
                let roles = [];
                Object.assign(roles, hr.roles);
                let flag = false;
                if (roles.length != this.selectedRoles.length) {
                    flag = true;
                } else {
                    for (let i = 0; i < roles.length; i++) {
                        let role = roles[i];
                        for (let j = 0; j < this.selectedRoles.length; j++) {
                            let sr = this.selectedRoles[j];
                            if (role.id == sr) {
                                roles.splice(i, 1);
                                i--;
                                break;
                            }
                        }
                    }
                    if (roles.length != 0) {
                        flag = true;
                    }
                }
                if (flag) {
                    let url = '/system/hr/role?hrid=' + hr.id;
                    this.selectedRoles.forEach(sr => {
                        url += '&rids=' + sr;
                    });
                    this.putRequest(url).then(resp => {
                        if (resp) {
                            this.initHrs();
                        }
                    });
                }
            },
            showPop(hr) {
                this.initAllRoles();
                let roles = hr.roles;
                this.selectedRoles = [];
                roles.forEach(r => {
                    this.selectedRoles.push(r.id);
                })
            },
            enabledChange(hr) {
                delete hr.roles;
                this.putRequest("/system/hr/", hr).then(resp => {
                    if (resp) {
                        this.initHrs();
                    }
                })
            },
            initAllRoles() {
                this.getRequest("/system/hr/roles").then(resp => {
                    if (resp) {
                        this.allroles = resp;
                    }
                })
            },
            initHrs() {
                this.getRequest("/system/hr/?keywords="+this.keywords).then(resp => {
                    if (resp) {
                        this.hrs = resp;
                    }
                })
            }
        }
    }
</script>

<style>
    .userinfo-container div {
        font-size: 12px;
        color: #409eff;
    }

    .userinfo-container {
        margin-top: 20px;
    }

    .img-container {
        width: 100%;
        display: flex;
        justify-content: center;
    }

    .userface-img {
        width: 72px;
        height: 72px;
        border-radius: 72px;
    }

    .hr-container {
        margin-top: 10px;
        display: flex;
        flex-wrap: wrap;
        justify-content: space-around;
    }

    .hr-card {
        width: 350px;
        margin-bottom: 20px;
    }
</style>