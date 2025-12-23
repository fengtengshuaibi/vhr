<template>
    <div style="display: flex;justify-content: space-around">
        <div style="width: 30%">
            <el-input
                    placeholder="输入菜单名称搜索"
                    v-model="filterText">
            </el-input>
            <el-tree
                    class="filter-tree"
                    :data="menus"
                    :props="defaultProps"
                    default-expand-all
                    :filter-node-method="filterNode"
                    ref="tree"
                    draggable
                    :allow-drop="allowDrop"
                    :allow-drag="allowDrag"
                    @node-drop="handleDrop"
                    @node-click="handleNodeClick">
            </el-tree>
            <div style="margin-top: 10px">
                <el-button type="primary" size="mini" @click="showAddMenu">添加菜单</el-button>
            </div>
        </div>
        <div style="width: 65%" v-if="selectedMenu">
            <el-card class="box-card">
                <div slot="header" class="clearfix">
                    <span>{{selectedMenu.name}} - 菜单管理</span>
                    <el-button style="float: right; padding: 3px 0" type="text" @click="saveConfigs">保存配置</el-button>
                </div>
                <div style="padding: 20px;">
                    <el-form label-width="120px">
                        <el-form-item label="选择脱敏字段">
                            <el-select v-model="selectedFields" multiple placeholder="请选择需要脱敏的字段" style="width: 100%">
                                <el-option
                                        v-for="item in fieldOptions"
                                        :key="item.value"
                                        :label="item.label"
                                        :value="item.value">
                                </el-option>
                            </el-select>
                        </el-form-item>
                    </el-form>
                    <div style="margin-top: 20px; color: #666; font-size: 14px;">
                        <p>脱敏规则说明：</p>
                        <p>1. 姓名：脱敏第2位 (如: 张*三)</p>
                        <p>2. 身份证：脱敏出生日期 (如: 110101********1234)</p>
                        <p>3. 电话：脱敏全部 (如: ***********)</p>
                        <p>4. 地址：脱敏全部 (如: ******************)</p>
                        <p>5. 其他：脱敏全部</p>
                    </div>
                </div>
            </el-card>
            <el-card class="box-card" style="margin-top: 20px">
                <div slot="header" class="clearfix">
                    <span>菜单信息修改</span>
                    <el-button style="float: right; padding: 3px 0; color: #f56c6c; margin-left: 10px;" type="text" @click="deleteMenu">删除菜单</el-button>
                    <el-button style="float: right; padding: 3px 0" type="text" @click="updateMenuInfo">保存修改</el-button>
                </div>
                <el-form label-width="80px" :model="selectedMenu">
                    <el-form-item label="菜单名称">
                        <el-input v-model="selectedMenu.name"></el-input>
                    </el-form-item>
                    <!-- 路径和组件通常由开发人员配置，业务人员无需修改 -->

                    <div style="margin-left: 80px; margin-top: 10px; color: #909399; font-size: 13px;">
                        <i class="el-icon-info"></i> 提示：直接在左侧树形菜单中拖拽节点，即可调整菜单的所属层级和位置。
                    </div>
                </el-form>
            </el-card>
        </div>

        <el-dialog title="添加脱敏规则" :visible.sync="dialogVisible" width="30%">
            <el-form :model="newConfig">
                <el-form-item label="字段名" label-width="100px">
                    <el-input v-model="newConfig.fieldName" autocomplete="off"></el-input>
                </el-form-item>
                <el-form-item label="脱敏类型" label-width="100px">
                    <el-select v-model="newConfig.maskingType" placeholder="请选择">
                        <el-option label="名字脱敏(第2位)" value="NAME"></el-option>
                        <el-option label="身份证脱敏(生日)" value="IDCARD"></el-option>
                        <el-option label="全部脱敏" value="ALL"></el-option>
                    </el-select>
                </el-form-item>
            </el-form>
            <div slot="footer" class="dialog-footer">
                <el-button @click="dialogVisible = false">取 消</el-button>
                <el-button type="primary" @click="doAddConfig">确 定</el-button>
            </div>
        </el-dialog>

        <el-dialog title="添加菜单" :visible.sync="menuDialogVisible" width="30%">
            <el-form :model="newMenu">
                <el-form-item label="菜单名称" label-width="100px">
                    <el-input v-model="newMenu.name" autocomplete="off"></el-input>
                </el-form-item>
                <!-- 路径和组件通常由开发人员配置，业务人员无需修改 -->

                <div style="margin-left: 100px; margin-top: 10px; color: #909399; font-size: 13px;">
                    <i class="el-icon-info"></i> 提示：系统将自动生成路径和组件配置。
                </div>
            </el-form>
            <div slot="footer" class="dialog-footer">
                <el-button @click="menuDialogVisible = false">取 消</el-button>
                <el-button type="primary" @click="doAddMenu">确 定</el-button>
            </div>
        </el-dialog>
    </div>
</template>

<script>
    export default {
        name: "SysCfg",
        data() {
            return {
                filterText: '',
                menus: [],
                defaultProps: {
                    children: 'children',
                    label: 'name'
                },
                selectedMenu: null,
                configs: [],
                selectedFields: [],
                fieldOptions: [
                    {value: 'name', label: '姓名'},
                    {value: 'idCard', label: '身份证'},
                    {value: 'phone', label: '电话'},
                    {value: 'address', label: '地址'},
                    {value: 'remark', label: '备注'},
                    {value: 'email', label: '邮箱'}
                ],
                dialogVisible: false,
                menuDialogVisible: false,
                newConfig: {
                    fieldName: '',
                    maskingType: 'ALL'
                },
                newMenu: {
                    name: '',
                    path: '',
                    component: ''
                }
            };
        },
        watch: {
            filterText(val) {
                this.$refs.tree.filter(val);
            }
        },
        mounted() {
            this.initMenus();
        },
        methods: {
            initMenus() {
                this.getRequest("/system/data-masking/menus").then(resp => {
                    if (resp) {
                        this.menus = resp;
                    }
                })
            },
            filterNode(value, data) {
                if (!value) return true;
                return data.name.indexOf(value) !== -1;
            },
            handleNodeClick(data) {
                this.selectedMenu = data;
                this.initConfigs();
            },
            initConfigs() {
                if (!this.selectedMenu) return;
                this.selectedFields = [];
                this.getRequest("/system/data-masking/config/" + this.selectedMenu.id).then(resp => {
                    if (resp) {
                        this.configs = resp;
                        this.configs.forEach(config => {
                            if (config.enabled) {
                                this.selectedFields.push(config.fieldName);
                            }
                        });
                    }
                })
            },
            saveConfigs() {
                if (!this.selectedMenu) return;
                
                // First delete all existing configs for this menu (to handle unselected ones)
                // Actually, backend update might be better, but let's iterate.
                // Or better: Send the list of selected fields to backend, backend replaces all configs for this menu.
                // Current backend supports add/update/delete single.
                // I will implement a batch update on frontend for now:
                // 1. Delete all configs for this menu? No, that's risky if API fails.
                // 2. Diff: Find added, find removed.
                
                // Simplify: Delete all first, then add new ones. 
                // Or: Loop through selectedFields, check if exists in configs.
                
                // Let's use a robust way:
                // Calculate configs to add
                let promises = [];
                
                // Delete configs that are NOT in selectedFields
                this.configs.forEach(config => {
                    if (!this.selectedFields.includes(config.fieldName)) {
                        promises.push(this.deleteRequest("/system/data-masking/config/" + config.id));
                    }
                });
                
                // Add configs that are NEW
                this.selectedFields.forEach(field => {
                    let exists = this.configs.find(c => c.fieldName === field);
                    if (!exists) {
                        let type = 'ALL';
                        if (field === 'name') type = 'NAME';
                        else if (field === 'idCard') type = 'IDCARD';
                        
                        let newConfig = {
                            menuId: this.selectedMenu.id,
                            fieldName: field,
                            maskingType: type,
                            enabled: true
                        };
                        promises.push(this.postRequest("/system/data-masking/config", newConfig));
                    }
                });
                
                Promise.all(promises).then(() => {
                    this.$message.success("配置已保存");
                    this.initConfigs();
                });
            },
            allowDrop(draggingNode, dropNode, type) {
                return true;
            },
            allowDrag(draggingNode) {
                return true;
            },
            handleDrop(draggingNode, dropNode, dropType, ev) {
                // Handle drag drop logic to update parentId
                let menu = draggingNode.data;
                let parentId = -1;
                if (dropType == 'inner') {
                    parentId = dropNode.data.id;
                } else {
                    parentId = dropNode.data.parentId;
                }
                menu.parentId = parentId;
                this.putRequest("/system/data-masking/menu", menu).then(resp => {
                    if (resp) {
                        this.initMenus();
                    }
                })
            },
            showAddConfig() {
                this.newConfig = {fieldName: '', maskingType: 'ALL'};
                this.dialogVisible = true;
            },
            doAddConfig() {
                this.newConfig.menuId = this.selectedMenu.id;
                this.newConfig.enabled = true;
                this.postRequest("/system/data-masking/config", this.newConfig).then(resp => {
                    if (resp) {
                        this.dialogVisible = false;
                        this.initConfigs();
                    }
                })
            },
            deleteConfig(row) {
                this.$confirm('此操作将永久删除该规则, 是否继续?', '提示', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning'
                }).then(() => {
                    this.deleteRequest("/system/data-masking/config/" + row.id).then(resp => {
                        if (resp) {
                            this.initConfigs();
                        }
                    })
                }).catch(() => {
                });
            },
            updateConfig(row) {
                this.putRequest("/system/data-masking/config", row).then(resp => {
                })
            },
            updateMenuInfo() {
                this.putRequest("/system/data-masking/menu", this.selectedMenu).then(resp => {
                    if (resp) {
                        this.initMenus();
                    }
                })
            },
            showAddMenu() {
                this.menuDialogVisible = true;
                this.newMenu = {name: '', path: '', component: ''};
            },
            doAddMenu() {
                if (this.selectedMenu) {
                    this.newMenu.parentId = this.selectedMenu.id;
                } else {
                    this.newMenu.parentId = 1; // Default to root
                }
                // 自动生成路径和组件，避免空值报错
                if (!this.newMenu.path) {
                    this.newMenu.path = '/' + Math.random().toString(36).substr(2, 6);
                }
                if (!this.newMenu.component) {
                    this.newMenu.component = 'SysCfg'; // 暂时指向一个存在的组件作为占位符
                }
                this.postRequest("/system/data-masking/menu", this.newMenu).then(resp => {
                    if (resp) {
                        this.menuDialogVisible = false;
                        this.initMenus();
                    }
                })
            },
            deleteMenu() {
                this.$confirm('此操作将永久删除该菜单及其所有子菜单, 是否继续?', '提示', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning'
                }).then(() => {
                    this.deleteRequest("/system/data-masking/menu/" + this.selectedMenu.id).then(resp => {
                        if (resp) {
                            this.selectedMenu = null;
                            this.initMenus();
                        }
                    })
                }).catch(() => {
                });
            }
        }
    };
</script>
