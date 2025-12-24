<template>
    <div v-if="hr">
        <el-card class="box-card" style="width: 600px; margin: 0 auto;">
            <div slot="header" class="clearfix">
                <span>个人中心</span>
            </div>
            <div>
                <div style="display: flex;justify-content: center; margin-bottom: 20px;">
                    <el-upload
                            :show-file-list="false"
                            :on-success="onSuccess"
                            :data="hr"
                            action="/hr/userface">
                        <img title="点击修改用户图像" :src="hr.userface" style="width: 100px;height: 100px;border-radius: 50px"
                             alt="">
                    </el-upload>
                </div>
                
                <div class="info-row">
                    <span class="label">实名信息：</span>
                    <span class="value">{{ hr.employee ? hr.employee.name : '未绑定' }}</span>
                </div>
                <div class="info-row">
                    <span class="label">用户姓名：</span>
                    <span class="value">{{ hr.name }}</span>
                    <el-button type="text" icon="el-icon-edit" @click="showUpdateHrInfoView" style="margin-left: 10px; padding: 0;">修改</el-button>
                </div>
                <div class="info-row">
                    <span class="label">手机号码：</span>
                    <span class="value">{{ hr.phone | maskPhone }}</span>
                </div>
                <div class="info-row">
                    <span class="label">居住地址：</span>
                    <span class="value">{{ hr.address }}</span>
                </div>
                <div class="info-row">
                    <span class="label">身份证号：</span>
                    <span class="value">{{ hr.employee ? (hr.employee.idCard ? $options.filters.maskIdCard(hr.employee.idCard) : '无') : '未绑定' }}</span>
                </div>
                
                <div class="info-row">
                    <span class="label">用户标签：</span>
                    <span class="value">
                         <el-tag type="success" size="mini" style="margin-right: 5px" v-for="(r,index) in hr.roles" :key="index">
                            {{r.nameZh}}
                        </el-tag>
                    </span>
                </div>

                <el-divider></el-divider>
                
                <!-- Binding Section -->
                <div v-if="!hr.employeeId">
                    <el-alert title="未实名绑定，请绑定员工档案" type="warning" :closable="false" show-icon style="margin-bottom: 15px"></el-alert>
                    
                    <el-form :model="bindForm" :rules="bindRules" ref="bindForm" label-width="80px" size="small">
                        <el-form-item label="员工姓名" prop="employeeId">
                             <el-select v-model="bindForm.employeeId" filterable remote placeholder="请输入员工姓名搜索" 
                                :remote-method="remoteMethod" :loading="loadingEmp" no-data-text="未找到该员工，请联系管理员添加"
                                @change="handleEmpChange"
                                style="width: 100%">
                                <el-option
                                    v-for="item in employeeList"
                                    :key="item.id"
                                    :label="item.name + ' (' + item.workID + ')'"
                                    :value="item.id">
                                    <span style="float: left">{{ item.name }}</span>
                                    <span style="float: right; color: #8492a6; font-size: 13px">{{ item.workID }}</span>
                                </el-option>
                             </el-select>
                        </el-form-item>
                        
                        <div v-if="selectedEmp" class="emp-preview">
                            <div class="preview-title">确认绑定以下信息：</div>
                            <div class="preview-item"><span>姓名：</span>{{selectedEmp.name}}</div>
                            <div class="preview-item"><span>工号：</span>{{selectedEmp.workID}}</div>
                            <div class="preview-item"><span>身份证：</span>{{selectedEmp.idCard | maskIdCard}}</div>
                            <div class="preview-item"><span>手机号：</span>{{selectedEmp.phone | maskPhone}}</div>
                            <div class="preview-item"><span>地址：</span>{{selectedEmp.address}}</div>
                            <div class="preview-tip"><i class="el-icon-info"></i> 绑定后手机号和地址将同步更新到用户信息</div>
                        </div>

                        <el-button type="primary" @click="submitBind" style="width: 100%" :disabled="!selectedEmp">立即绑定</el-button>
                    </el-form>
                </div>
                <div v-else>
                     <el-alert title="已完成实名绑定" type="success" :closable="false" show-icon></el-alert>
                </div>

                <div style="display: flex;justify-content: center;margin-top: 20px;">
                    <el-button type="danger" size="small" @click="showUpdatePasswdView">修改密码</el-button>
                </div>
            </div>
        </el-card>

        <!-- Modify Info Dialog -->
        <el-dialog
                title="修改用户信息"
                :visible.sync="dialogVisible"
                width="400px">
            <el-form :model="hr2" label-width="80px" size="small">
                <el-form-item label="用户姓名">
                    <el-input v-model="hr2.name"></el-input>
                </el-form-item>
                <el-form-item label="手机号码">
                    <el-input v-model="hr2.phone"></el-input>
                </el-form-item>
                <el-form-item label="居住地址">
                    <el-input v-model="hr2.address"></el-input>
                </el-form-item>
            </el-form>
            <span slot="footer" class="dialog-footer">
                <el-button @click="dialogVisible = false" size="small">取 消</el-button>
                <el-button type="primary" @click="updateHrInfo" size="small">确 定</el-button>
            </span>
        </el-dialog>

        <!-- Change Password Dialog -->
        <el-dialog
                title="修改密码"
                :visible.sync="passwdDialogVisible"
                width="400px">
            <div>
                <el-form :model="ruleForm" status-icon :rules="rules" ref="ruleForm" label-width="100px"
                         class="demo-ruleForm">
                    <el-form-item label="旧密码" prop="oldpass">
                        <el-input type="password" v-model="ruleForm.oldpass" autocomplete="off"></el-input>
                    </el-form-item>
                    <el-form-item label="新密码" prop="pass">
                        <el-input type="password" v-model="ruleForm.pass" autocomplete="off"></el-input>
                    </el-form-item>
                    <el-form-item label="确认密码" prop="checkPass">
                        <el-input type="password" v-model="ruleForm.checkPass" autocomplete="off"></el-input>
                    </el-form-item>
                    <el-form-item>
                        <el-button type="primary" @click="submitForm('ruleForm')">提交</el-button>
                        <el-button @click="resetForm('ruleForm')">重置</el-button>
                    </el-form-item>
                </el-form>
            </div>
        </el-dialog>
    </div>
</template>

<script>
    export default {
        name: "HrInfo",
        data() {
            var validatePass = (rule, value, callback) => {
                if (value === '') {
                    callback(new Error('请输入密码'));
                } else {
                    if (this.ruleForm.checkPass !== '') {
                        this.$refs.ruleForm.validateField('checkPass');
                    }
                    callback();
                }
            };
            var validatePass2 = (rule, value, callback) => {
                if (value === '') {
                    callback(new Error('请再次输入密码'));
                } else if (value !== this.ruleForm.pass) {
                    callback(new Error('两次输入密码不一致!'));
                } else {
                    callback();
                }
            };
            return {
                ruleForm: {
                    oldpass: '',
                    pass: '',
                    checkPass: ''
                },
                rules: {
                    oldpass: [
                        {validator: validatePass, trigger: 'blur'}
                    ],
                    pass: [
                        {validator: validatePass, trigger: 'blur'}
                    ],
                    checkPass: [
                        {validator: validatePass2, trigger: 'blur'}
                    ]
                },
                hr: null,
                hr2: {},
                dialogVisible: false,
                passwdDialogVisible: false,
                bindForm: {
                    employeeId: null
                },
                bindRules: {
                    employeeId: [{required: true, message: '请选择员工', trigger: 'change'}]
                },
                employeeList: [],
                loadingEmp: false,
                selectedEmp: null
            }
        },
        filters: {
            maskPhone(val) {
                if (!val) return '无';
                return val.replace(/(\d{3})\d{4}(\d{4})/, '$1****$2');
            },
            maskIdCard(val) {
                if (!val) return '无';
                if (val.length === 18) {
                    return val.replace(/(\d{6})\d{8}(\d{4})/, '$1********$2');
                }
                return val;
            }
        },
        mounted() {
            this.initHr();
        },
        methods: {
            onSuccess() {
                this.initHr();
            },
            updateHrInfo() {
                this.putRequest("/hr/info", this.hr2).then(resp => {
                    if (resp) {
                        this.dialogVisible = false;
                        this.initHr();
                    }
                })
            },
            showUpdateHrInfoView() {
                this.hr2 = Object.assign({}, this.hr);
                this.dialogVisible = true;
            },
            submitForm(formName) {
                this.$refs[formName].validate((valid) => {
                    if (valid) {
                        this.ruleForm.hrid = this.hr.id;
                        this.putRequest("/hr/pass", this.ruleForm).then(resp => {
                            if (resp) {
                                this.getRequest("/logout");
                                window.sessionStorage.removeItem("user")
                                this.$store.commit('initRoutes', []);
                                this.$router.replace("/");
                            }
                        })
                    } else {
                        return false;
                    }
                });
            },
            resetForm(formName) {
                this.$refs[formName].resetFields();
            },
            showUpdatePasswdView() {
                this.passwdDialogVisible = true;
            },
            initHr() {
                this.getRequest('/hr/info').then(resp => {
                    if (resp) {
                        this.hr = resp;
                        // Don't auto-copy hr2 here, do it on open dialog
                        window.sessionStorage.setItem("user", JSON.stringify(resp));
                        this.$store.commit('INIT_CURRENTHR', resp);
                    }
                })
            },
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
            handleEmpChange(val) {
                this.selectedEmp = this.employeeList.find(e => e.id === val);
            },
            submitBind() {
                this.$refs.bindForm.validate(valid => {
                    if (valid) {
                        this.postRequest("/hr/bind", { employeeId: this.bindForm.employeeId }).then(resp => {
                            if (resp) {
                                this.initHr();
                            }
                        })
                    }
                })
            }
        }
    }
</script>

<style scoped>
    .info-row {
        margin-bottom: 15px;
        font-size: 14px;
        color: #606266;
    }
    .info-row .label {
        display: inline-block;
        width: 80px;
        text-align: right;
        margin-right: 10px;
        font-weight: bold;
    }
    .info-row .value {
        color: #303133;
    }
    
    .emp-preview {
        background-color: #f5f7fa;
        padding: 15px;
        border-radius: 4px;
        margin-bottom: 15px;
        font-size: 13px;
        line-height: 1.8;
    }
    .preview-title {
        font-weight: bold;
        margin-bottom: 5px;
        color: #409EFF;
    }
    .preview-item span {
        color: #909399;
        display: inline-block;
        width: 60px;
        text-align: right;
    }
    .preview-tip {
        margin-top: 10px;
        color: #E6A23C;
    }
</style>
