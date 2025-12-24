<template>
    <div>
        <div>
            <el-input placeholder="搜索员工..." prefix-icon="el-icon-search" v-model="keyword" style="width: 300px;margin-right: 10px"></el-input>
            <el-button type="primary" icon="el-icon-search" @click="initStats">搜索</el-button>
        </div>
        <div style="margin-top: 10px">
            <el-table :data="stats" border style="width: 100%" height="calc(100vh - 150px)">
                <el-table-column prop="employee.name" label="姓名" width="120" sortable></el-table-column>
                <el-table-column prop="course.name" label="课程名称" sortable></el-table-column>
                <el-table-column prop="status" label="状态" width="100" sortable>
                    <template slot-scope="scope">
                        <el-tag :type="scope.row.status==='Finished'?'success':'warning'">{{scope.row.status==='Finished'?'已完成':'学习中'}}</el-tag>
                    </template>
                </el-table-column>
                <el-table-column prop="studyHours" label="学时(h)" width="100" sortable></el-table-column>
                <el-table-column prop="examScore" label="考试分数" width="100" sortable></el-table-column>
                <el-table-column prop="isPassed" label="通过" width="80">
                    <template slot-scope="scope">
                        <span v-if="scope.row.isPassed" style="color: green">是</span>
                        <span v-else style="color: red">否</span>
                    </template>
                </el-table-column>
            </el-table>
        </div>
    </div>
</template>

<script>
    export default {
        name: "PerTrainStats",
        data() {
            return {
                keyword: '',
                stats: []
            }
        },
        mounted() {
            this.initStats();
        },
        methods: {
            initStats() {
                this.getRequest("/personnel/train/stats?keywords=" + this.keyword).then(resp => {
                    if (resp) {
                        this.stats = resp;
                    }
                })
            }
        }
    }
</script>
