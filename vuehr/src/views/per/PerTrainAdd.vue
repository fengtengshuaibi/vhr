<template>
    <div>
        <div style="display: flex; justify-content: space-between">
            <div>
                <el-input placeholder="搜索课程..." prefix-icon="el-icon-search" v-model="keyword" style="width: 300px;margin-right: 10px"></el-input>
                <el-button type="primary" icon="el-icon-search" @click="initCourses">搜索</el-button>
            </div>
            <el-button type="primary" icon="el-icon-plus" @click="showAddCourse">添加课程</el-button>
        </div>
        
        <div style="margin-top: 20px">
            <el-tabs v-model="activeTab" @tab-click="initCourses">
                <el-tab-pane label="全部" name="all"></el-tab-pane>
                <el-tab-pane label="选修" name="选修"></el-tab-pane>
                <el-tab-pane label="必修" name="必修"></el-tab-pane>
            </el-tabs>
            <div style="display: flex; flex-wrap: wrap; gap: 20px;">
                <el-card v-for="c in courses" :key="c.id" style="width: 300px; cursor: pointer;" @click.native="playPreview(c)">
                    <img :src="c.coverUrl || 'https://via.placeholder.com/300x150'" style="width: 100%; height: 150px; object-fit: cover;">
                    <div style="padding: 14px;">
                        <span style="font-weight: bold">{{c.name}}</span>
                        <div style="margin-top: 10px; color: #999; font-size: 12px;">
                            <div>分类: {{c.category}}</div>
                            <div>类型: {{c.type}}</div>
                            <div>时长: {{formatDuration(c.duration)}}</div>
                            <div>考试: {{c.hasExam ? '有' : '无'}}</div>
                        </div>
                    </div>
                </el-card>
            </div>
        </div>

        <el-dialog title="添加课程" :visible.sync="dialogVisible" width="70%">
            <el-steps :active="step" finish-status="success" simple>
                <el-step title="课程信息"></el-step>
                <el-step title="考试配置"></el-step>
            </el-steps>
            
            <div style="margin-top: 20px;">
                <el-form v-if="step===0" :model="course" label-width="100px">
                    <el-form-item label="课程名称">
                        <el-input v-model="course.name"></el-input>
                    </el-form-item>
                    <el-form-item label="视频文件">
                        <el-upload
                            action="/personnel/train/upload"
                            :on-success="handleUploadSuccess"
                            :before-upload="beforeUploadVideo"
                            :on-progress="uploadProgress"
                            :show-file-list="false">
                            <el-button size="small" type="primary">点击上传</el-button>
                            <span v-if="uploadPercent > 0 && uploadPercent < 100" style="margin-left: 10px">上传中: {{uploadPercent}}%</span>
                            <span v-if="course.videoUrl" style="margin-left: 10px; color: green;">上传成功</span>
                        </el-upload>
                        <div style="font-size: 12px; color: #999;">支持MP4格式</div>
                    </el-form-item>
                    <el-form-item label="封面图片">
                        <el-upload
                            action="/personnel/train/upload"
                            :on-success="handleCoverSuccess"
                            :show-file-list="false">
                             <img v-if="course.coverUrl" :src="course.coverUrl" class="avatar" style="width: 100px; height: 100px; object-fit: cover;">
                             <i v-else class="el-icon-plus avatar-uploader-icon" style="border: 1px dashed #d9d9d9; padding: 20px;"></i>
                        </el-upload>
                    </el-form-item>
                    <el-form-item label="课程时长(小时)">
                        <el-input-number v-model="course.duration" :precision="1" :step="0.1" :min="0"></el-input-number>
                    </el-form-item>
                    <el-form-item label="课程说明">
                        <el-input type="textarea" v-model="course.description"></el-input>
                    </el-form-item>
                    <el-form-item label="课程分类">
                        <el-input v-model="course.category"></el-input>
                    </el-form-item>
                    <el-form-item label="课程类型">
                        <el-select v-model="course.type">
                            <el-option label="选修" value="选修"></el-option>
                            <el-option label="必修" value="必修"></el-option>
                        </el-select>
                    </el-form-item>
                    <el-form-item label="所属部门" v-if="course.type==='必修'">
                        <el-select v-model="course.departmentId" placeholder="请选择部门">
                            <el-option v-for="item in depts" :key="item.id" :label="item.name" :value="item.id"></el-option>
                        </el-select>
                    </el-form-item>
                    <el-form-item label="是否有考试">
                        <el-switch v-model="course.hasExam"></el-switch>
                    </el-form-item>
                </el-form>

                <div v-if="step===1">
                    <el-form label-width="100px">
                        <el-form-item label="考试次数">
                            <el-input-number v-model="course.examLimit" :min="1"></el-input-number>
                        </el-form-item>
                    </el-form>
                    <el-divider content-position="left">题目列表</el-divider>
                    <div v-for="(q, index) in questions" :key="index" style="border: 1px dashed #ccc; padding: 10px; margin-bottom: 10px;">
                        <el-form :model="q" label-width="80px" inline size="small">
                            <el-form-item label="题型">
                                <el-select v-model="q.type" style="width: 100px">
                                    <el-option value="单选" label="单选"></el-option>
                                    <el-option value="多选" label="多选"></el-option>
                                    <el-option value="填空" label="填空"></el-option>
                                </el-select>
                            </el-form-item>
                            <el-form-item label="分值">
                                <el-input-number v-model="q.score" :min="1" style="width: 100px"></el-input-number>
                            </el-form-item>
                            <el-button type="text" style="color: red" @click="questions.splice(index, 1)">删除</el-button>
                            <br>
                            <el-form-item label="题目" style="width: 100%">
                                <el-input v-model="q.content" style="width: 500px"></el-input>
                            </el-form-item>
                            <div v-if="q.type!=='填空'">
                                <el-form-item label="选项(JSON)">
                                    <el-input v-model="q.options" placeholder='["A. x", "B. y"]' style="width: 300px"></el-input>
                                </el-form-item>
                            </div>
                            <el-form-item label="正确答案">
                                <el-input v-model="q.correctAnswer" placeholder="如: A 或 无"></el-input>
                            </el-form-item>
                        </el-form>
                    </div>
                    <el-button type="primary" plain @click="addQuestion" style="width: 100%">+ 添加题目</el-button>
                </div>
            </div>

            <span slot="footer" class="dialog-footer">
                <el-button @click="dialogVisible = false">取 消</el-button>
                <el-button v-if="step===0" type="primary" @click="nextStep">下一步</el-button>
                <el-button v-if="step===1" @click="step=0">上一步</el-button>
                <el-button v-if="step===1" type="primary" @click="saveCourse">保 存</el-button>
            </span>
        </el-dialog>

        <!-- Preview Dialog -->
        <el-dialog title="课程预览" :visible.sync="previewVisible" width="60%">
            <video v-if="previewUrl" :src="previewUrl" controls width="100%" height="400px"></video>
        </el-dialog>
    </div>
</template>

<script>
    export default {
        name: "PerTrainAdd",
        data() {
            return {
                keyword: '',
                activeTab: 'all',
                courses: [],
                dialogVisible: false,
                step: 0,
                course: {
                    name: '', videoUrl: '', coverUrl: '', description: '', category: '', type: '选修', departmentId: null, hasExam: false, examLimit: 1, duration: 0.0
                },
                questions: [],
                depts: [],
                uploadPercent: 0,
                previewVisible: false,
                previewUrl: ''
            }
        },
        mounted() {
            this.initCourses();
            this.initDepts();
        },
        methods: {
            initCourses() {
                this.getRequest("/personnel/train/list?keywords=" + this.keyword).then(resp => {
                    if (resp) {
                        if (this.activeTab !== 'all') {
                            this.courses = resp.filter(c => c.type === this.activeTab);
                        } else {
                            this.courses = resp;
                        }
                    }
                })
            },
            initDepts() {
                this.getRequest("/system/basic/department/").then(resp => {
                    if (resp) {
                        this.depts = resp;
                    }
                })
            },
            showAddCourse() {
                this.course = {
                    name: '', videoUrl: '', coverUrl: '', description: '', category: '', type: '选修', departmentId: null, hasExam: false, examLimit: 1, duration: 0.0
                };
                this.questions = [];
                this.step = 0;
                this.uploadPercent = 0;
                this.dialogVisible = true;
            },
            beforeUploadVideo(file) {
                if (file.type !== 'video/mp4') {
                    this.$message.error('只能上传mp4格式的视频');
                    return false;
                }
                return true;
            },
            uploadProgress(event, file, fileList) {
                this.uploadPercent = Math.floor(event.percent);
            },
            handleUploadSuccess(resp) {
                if (resp && resp.status == 200) {
                    this.course.videoUrl = resp.obj; 
                    this.uploadPercent = 100;
                    this.$message.success("视频上传成功");
                } else {
                    this.$message.error("上传失败");
                }
            },
            handleCoverSuccess(resp) {
                if (resp && resp.status == 200) {
                    // Assuming upload endpoint returns filename, we need full URL if it's served statically or from FastDFS
                    // If backend returns just filename, we might need to prepend path. 
                    // Based on TrainingController it returns 'newName'. 
                    // And frontend usually appends prefix when displaying.
                    // But here let's assume we store the filename and display logic handles it.
                    // Or if FastDFS, it returns full path? 
                    // TrainingController uses local file system (vhr.video.path).
                    // So we store filename.
                    // To display preview immediately, we might need a way to construct URL.
                    // Since I don't know the exact static resource mapping, I'll assume '/video/' + filename works if configured.
                    this.course.coverUrl = '/video/' + resp.obj; 
                }
            },
            nextStep() {
                if (!this.course.name || !this.course.videoUrl) {
                    this.$message.error("请填写完整课程信息并上传视频");
                    return;
                }
                if (this.course.hasExam) {
                    this.step = 1;
                } else {
                    this.saveCourse();
                }
            },
            addQuestion() {
                this.questions.push({
                    type: '单选', content: '', options: '', correctAnswer: '', score: 5
                });
            },
            saveCourse() {
                this.course.questions = this.questions;
                this.postRequest("/personnel/train/course", this.course).then(resp => {
                    if (resp) {
                        this.dialogVisible = false;
                        this.initCourses();
                    }
                })
            },
            playPreview(c) {
                this.previewUrl = c.videoUrl;
                if (!this.previewUrl.startsWith('http') && !this.previewUrl.startsWith('//')) {
                    this.previewUrl = '/video/' + c.videoUrl;
                }
                this.previewVisible = true;
            },
            formatDuration(hours) {
                if (!hours) return '00:00';
                let h = Math.floor(hours);
                let m = Math.round((hours - h) * 60);
                if (m === 60) { h++; m = 0; }
                return (h < 10 ? '0' + h : h) + ':' + (m < 10 ? '0' + m : m);
            }
        }
    }
</script>
<style scoped>
</style>
