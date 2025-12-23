<template>
    <div>
        <el-table
                :data="logs"
                stripe
                border
                style="width: 100%">
            <el-table-column
                    prop="id"
                    label="编号"
                    width="80">
            </el-table-column>
            <el-table-column
                    prop="adddate"
                    label="操作日期"
                    width="180">
            </el-table-column>
            <el-table-column
                    prop="operate"
                    label="操作内容">
            </el-table-column>
            <el-table-column
                    prop="hrName"
                    label="操作员"
                    width="150">
            </el-table-column>
        </el-table>
    </div>
</template>

<script>
    export default {
        name: "SysLog",
        data() {
            return {
                logs: []
            }
        },
        mounted() {
            this.initLogs();
        },
        methods: {
            initLogs() {
                this.getRequest("/system/log/").then(resp => {
                    if (resp) {
                        this.logs = resp;
                    }
                })
            }
        }
    }
</script>

<style scoped>

</style>
