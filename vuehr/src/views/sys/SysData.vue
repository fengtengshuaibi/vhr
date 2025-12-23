<template>
    <div>
        <div style="margin-bottom: 10px; display: flex; justify-content: space-between;">
            <div>
                <el-button type="primary" @click="exportData" :disabled="!selectedTable">导出选中表数据</el-button>
                <el-upload
                        class="upload-demo"
                        action="/system/data/import"
                        :show-file-list="false"
                        :on-success="onSuccess"
                        :on-error="onError"
                        style="display: inline-block; margin-left: 10px">
                    <el-button type="success">导入数据(.sql)</el-button>
                </el-upload>
            </div>
        </div>
        <el-table
                :data="tables"
                highlight-current-row
                @current-change="handleCurrentChange"
                style="width: 100%">
            <el-table-column
                    prop="name"
                    label="表名"
                    width="180">
            </el-table-column>
            <el-table-column
                    prop="rows"
                    label="数据量"
                    width="100">
            </el-table-column>
            <el-table-column
                    prop="comment"
                    label="注释">
            </el-table-column>
        </el-table>
    </div>
</template>

<script>
    export default {
        name: "SysData",
        data() {
            return {
                tables: [],
                selectedTable: null
            }
        },
        mounted() {
            this.initTables();
        },
        methods: {
            initTables() {
                this.getRequest("/system/data/tables").then(resp => {
                    if (resp) {
                        this.tables = resp;
                    }
                })
            },
            handleCurrentChange(val) {
                this.selectedTable = val;
            },
            exportData() {
                if (this.selectedTable) {
                    // Check row count first? Or backend handles it?
                    // Let's check row count via backend or add row count to table list
                    // For now, assuming user knows, but requirements say "if table data is 0, prompt user"
                    // We need to add row count to table info
                    if (this.selectedTable.rows === 0) {
                        this.$message.warning("该表无数据，无法导出");
                        return;
                    }

                    // Use axios to download blob to allow file naming
                    this.getRequest("/system/data/export/" + this.selectedTable.name, null, {responseType: 'blob'}).then(resp => {
                        if (resp) {
                            // Let user choose save location?
                            // Browser security limits "Save As" dialog control.
                            // But we can trigger a download with a name.
                            const url = window.URL.createObjectURL(new Blob([resp]));
                            const link = document.createElement('a');
                            link.href = url;
                            link.setAttribute('download', this.selectedTable.name + '.sql'); // Default name
                            document.body.appendChild(link);
                            link.click();
                            document.body.removeChild(link);
                        }
                    })
                }
            },
            onSuccess(response, file, fileList) {
                this.$message.success("导入成功!");
            },
            onError(err, file, fileList) {
                this.$message.error("导入失败!");
            }
        }
    }
</script>

<style scoped>

</style>
