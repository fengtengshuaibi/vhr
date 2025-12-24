<template>
    <div>
        <el-container>
            <el-header class="homeHeader">
                <div class="title">微人事</div>
                <div>
                    <el-button icon="el-icon-bell" type="text" style="margin-right: 8px;color: #000000;" size="normal" @click="toggleChat"></el-button>
                    <el-dropdown class="userInfo" @command="commandHandler">
  <span class="el-dropdown-link">
    {{user.name}}
    <span v-if="user.roles && user.roles.length > 0">
        <el-color-picker v-model="themeColor" @change="themeChange" size="mini" style="margin-left: 10px; margin-right: 5px; vertical-align: middle;"></el-color-picker>
    </span>
    <i><img :src="user.userface" alt="" @error="imgError"></i>
  </span>
                        <el-dropdown-menu slot="dropdown">
                            <el-dropdown-item command="userinfo">个人中心</el-dropdown-item>
                            <el-dropdown-item command="logout" divided>注销登录</el-dropdown-item>
                        </el-dropdown-menu>
                    </el-dropdown>
                </div>
            </el-header>
            <el-container>
                <el-aside width="200px">
                    <el-menu router unique-opened>
                        <!-- Top Level -->
                        <div v-for="(item,index) in routes" :key="index">
                             <!-- Submenu (Level 1) -->
                            <el-submenu :index="index+''" v-if="!item.hidden">
                                <template slot="title">
                                    <i style="color: #409eff;margin-right: 5px" :class="item.iconCls"></i>
                                    <span>{{item.name}}</span>
                                </template>
                                <!-- Level 2 -->
                                <div v-for="(child,indexj) in item.children" :key="indexj">
                                    <!-- If Level 2 has children (Level 3) -->
                                    <el-submenu :index="child.path" v-if="child.children && child.children.length > 0">
                                        <template slot="title">{{child.name}}</template>
                                        <!-- Level 3 Items -->
                                        <el-menu-item :index="grand.path" v-for="(grand,indexk) in child.children" :key="indexk">
                                            {{grand.name}}
                                        </el-menu-item>
                                    </el-submenu>
                                    <!-- Else Normal Item -->
                                    <el-menu-item :index="child.path" v-else>
                                        {{child.name}}
                                    </el-menu-item>
                                </div>
                            </el-submenu>
                        </div>
                    </el-menu>
                </el-aside>
                <el-main>
                    <el-breadcrumb separator-class="el-icon-arrow-right" v-if="this.$router.currentRoute.path!='/home'">
                        <el-breadcrumb-item :to="{ path: '/home' }">首页</el-breadcrumb-item>
                        <el-breadcrumb-item>{{this.$router.currentRoute.name}}</el-breadcrumb-item>
                    </el-breadcrumb>
                    <div class="homeWelcome" v-if="this.$router.currentRoute.path=='/home'">
                        欢迎来到微人事！
                    </div>
                    <router-view class="homeRouterView"/>
                </el-main>
            </el-container>
        </el-container>
        
        <el-dialog
                title="即时聊天"
                :visible.sync="chatVisible"
                width="60%"
                :close-on-click-modal="false"
                custom-class="chat-dialog">
            <friend-chat v-if="chatVisible"></friend-chat>
        </el-dialog>
    </div>
</template>

<script>
    import img from '../assets/logo.png';
    import FriendChat from './chat/FriendChat';
    export default {
        name: "Home",
        components: {FriendChat},
        data() {
            return {
                // user: JSON.parse(window.sessionStorage.getItem("user"))
                themeColor: '#409eff',
                chatVisible: false
            }
        },
        computed: {
            routes() {
                return this.$store.state.routes;
            },
            user() {
                return this.$store.state.currentHr;
            }
        },
        mounted() {
            let theme = localStorage.getItem('themeColor');
            if (theme) {
                this.themeColor = theme;
                this.themeChange(theme);
            }
        },
        methods: {
            themeChange(val) {
                this.themeColor = val;
                localStorage.setItem('themeColor', val);
                document.getElementsByClassName('homeHeader')[0].style.backgroundColor = val;
                
                // Inject style for other elements
                let styleTag = document.getElementById('dynamic-theme-style');
                if (!styleTag) {
                    styleTag = document.createElement('style');
                    styleTag.id = 'dynamic-theme-style';
                    document.head.appendChild(styleTag);
                }
                
                styleTag.innerHTML = `
                    .el-button--primary { background-color: ${val} !important; border-color: ${val} !important; }
                    .el-button--primary:hover { opacity: 0.8; }
                    .el-pagination.is-background .el-pager li:not(.disabled).active { background-color: ${val} !important; }
                    .el-radio-button__orig-radio:checked+.el-radio-button__inner { background-color: ${val} !important; border-color: ${val} !important; box-shadow: -1px 0 0 0 ${val} !important; }
                    .el-switch.is-checked .el-switch__core { border-color: ${val} !important; background-color: ${val} !important; }
                    .el-checkbox__input.is-checked .el-checkbox__inner, .el-checkbox__input.is-indeterminate .el-checkbox__inner { background-color: ${val} !important; border-color: ${val} !important; }
                    .el-checkbox__input.is-checked+.el-checkbox__label { color: ${val} !important; }
                    .el-tag { color: ${val} !important; }
                    .el-tag--success { color: #67c23a !important; }
                    .el-tag--danger { color: #f56c6c !important; }
                    .el-tag--warning { color: #e6a23c !important; }
                    .el-tag--info { color: #909399 !important; }
                    .homeWelcome { color: ${val} !important; }
                    .el-submenu__title i { color: ${val} !important; }
                `;
            },
            imgError(e) {
                e.target.src = img;
            },
            toggleChat() {
                this.chatVisible = !this.chatVisible;
            },
            commandHandler(cmd) {
                if (cmd == 'logout') {
                    this.$confirm('此操作将注销登录, 是否继续?', '提示', {
                        confirmButtonText: '确定',
                        cancelButtonText: '取消',
                        type: 'warning'
                    }).then(() => {
                        this.getRequest("/logout");
                        window.sessionStorage.removeItem("user")
                        this.$store.commit('initRoutes', []);
                        this.$router.replace("/");
                    }).catch(() => {
                        this.$message({
                            type: 'info',
                            message: '已取消操作'
                        });
                    });
                }else if (cmd == 'userinfo') {
                    this.$router.push('/hrinfo');
                }
            }
        }
    }
</script>

<style>
    .homeRouterView {
        margin-top: 10px;
    }

    .homeWelcome {
        text-align: center;
        font-size: 30px;
        font-family: 华文行楷;
        color: #409eff;
        padding-top: 50px;
    }

    .homeHeader {
        background-color: #409eff;
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 0px 15px;
        box-sizing: border-box;
    }

    .homeHeader .title {
        font-size: 30px;
        font-family: 华文行楷;
        color: #ffffff
    }

    .homeHeader .userInfo {
        cursor: pointer;
    }

    .el-dropdown-link img {
        width: 48px;
        height: 48px;
        border-radius: 24px;
        margin-left: 8px;
    }

    .el-dropdown-link {
        display: flex;
        align-items: center;
    }
    
    .chat-dialog .el-dialog__body {
        padding: 0;
        height: 600px;
    }
</style>
