<template>
    <div>
        <div style="display: flex; justify-content: center; align-items: center; height: 100px;">
            <el-button type="danger" @click="initDb">初始化数据库</el-button>
        </div>
        <div style="padding: 20px; color: #666;">
            注意：初始化数据库将清除所有现有数据并恢复到初始状态（Flyway初始化状态），请谨慎操作！
        </div>
    </div>
</template>

<script>
    export default {
        name: "SysInit",
        methods: {
            initDb() {
                this.$confirm('此操作将永久清除所有数据, 是否继续?', '提示', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning'
                }).then(() => {
                    this.postRequest("/system/init/").then(resp => {
                        if (resp) {
                            this.$message.success("初始化成功!");
                        }
                    })
                }).catch(() => {
                });
            }
        }
    }
</script>

<style scoped>

</style>
