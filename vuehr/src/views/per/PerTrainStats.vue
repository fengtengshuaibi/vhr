<template>
    <div>
        <div>
            <el-input placeholder="搜索员工..." prefix-icon="el-icon-search" v-model="keyword" style="width: 300px;margin-right: 10px"></el-input>
            <el-button type="primary" icon="el-icon-search" @click="initStats">搜索</el-button>
        </div>
        <div style="margin-top: 10px">
            <el-table :data="stats" border style="width: 100%" height="calc(100vh - 150px)">
                <el-table-column prop="name" label="姓名" width="120" sortable></el-table-column>
                <el-table-column prop="finishedCount" label="已修课程数量" sortable></el-table-column>
                <el-table-column prop="totalHours" label="总学时(h)" width="120" sortable>
                     <template slot-scope="scope">
                        {{parseFloat(Number(scope.row.totalHours).toFixed(4))}}
                     </template>
                </el-table-column>
                <el-table-column prop="totalScore" label="总学分" width="120" sortable></el-table-column>
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
