<template>
    <div>
        <div style="margin-bottom: 20px;">
            <el-input placeholder="搜索课程..." prefix-icon="el-icon-search" v-model="keyword" style="width: 300px;margin-right: 10px"></el-input>
            <el-button type="primary" icon="el-icon-search" @click="initCourses">搜索</el-button>
        </div>
        <div style="display: flex; flex-wrap: wrap; gap: 20px;">
            <el-card v-for="c in courses" :key="c.id" style="width: 300px;">
                <img :src="c.coverUrl" style="width: 100%; height: 150px; object-fit: cover;">
                <div style="padding: 14px;">
                    <span style="font-weight: bold">{{c.name}}</span>
                    <div style="margin-top: 10px; color: #999; font-size: 12px;">
                        <div>分类: {{c.category}}</div>
                        <div>类型: {{c.type}}</div>
                        <div>时长: {{c.duration || 0}} 小时</div>
                    </div>
                    <div style="margin-top: 10px; text-align: right;">
                        <el-button type="primary" size="small" @click="addCourse(c.id)" :disabled="c.added">
                            {{c.added ? '已添加' : '加入选修'}}
                        </el-button>
                    </div>
                </div>
            </el-card>
        </div>
    </div>
</template>

<script>
    export default {
        name: "EmpTrainFind",
        data() {
            return {
                keyword: '',
                courses: [],
                myCourses: []
            }
        },
        computed: {
            user() {
                return this.$store.state.currentHr;
            }
        },
        mounted() {
            this.initMyCourses();
        },
        methods: {
            initMyCourses() {
                this.getRequest("/emp/train/list").then(resp => {
                    if (resp) {
                        this.myCourses = resp;
                        this.initCourses();
                    }
                })
            },
            initCourses() {
                this.getRequest("/emp/train/all?keywords=" + this.keyword).then(resp => {
                    if (resp) {
                        this.courses = resp.map(c => {
                            let exist = this.myCourses.find(mc => mc.courseId === c.id);
                            c.added = !!exist;
                            return c;
                        });
                    }
                })
            },
            addCourse(cid) {
                // Check if employee bound
                if (!this.user.employeeId) {
                    this.$confirm('您尚未绑定员工档案，无法选课。是否前往个人中心绑定？', '提示', {
                        confirmButtonText: '去绑定',
                        cancelButtonText: '取消',
                        type: 'warning'
                    }).then(() => {
                        this.$router.push('/hrinfo');
                    }).catch(() => {});
                    return;
                }
                
                this.postRequest("/emp/train/add?courseId=" + cid).then(resp => {
                    if (resp) {
                        this.initMyCourses();
                    }
                })
            }
        }
    }
</script>
