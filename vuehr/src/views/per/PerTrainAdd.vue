<template>
    <div>
        <div style="display: flex; justify-content: space-between">
            <div>
                <el-input placeholder="搜索课程..." prefix-icon="el-icon-search" v-model="keyword" style="width: 300px;margin-right: 10px"></el-input>
                <el-button type="primary" icon="el-icon-search" @click="initCourses">搜索</el-button>
            </div>
            <el-button type="danger" icon="el-icon-delete" :disabled="selectedCourses.length==0" @click="deleteMany">批量删除</el-button>
            <el-button type="primary" icon="el-icon-plus" @click="showAddCourse">添加课程</el-button>
        </div>
        
        <div style="margin-top: 20px">
            <el-tabs v-model="activeTab" @tab-click="initCourses">
                <el-tab-pane label="全部" name="all"></el-tab-pane>
                <el-tab-pane label="选修" name="选修"></el-tab-pane>
                <el-tab-pane label="必修" name="必修"></el-tab-pane>
            </el-tabs>
            <div style="display: flex; flex-wrap: wrap; gap: 20px;">
                <el-card v-for="c in courses" :key="c.id" style="width: 300px; cursor: pointer; position: relative;" @click.native="playPreview(c)">
                    <div style="position: absolute; top: 10px; right: 10px; z-index: 10;" @click.stop>
                        <el-checkbox v-model="selectedCourses" :label="c.id">&nbsp;</el-checkbox>
                    </div>
                    <img :src="c.coverUrl || 'https://via.placeholder.com/300x150'" style="width: 100%; height: 150px; object-fit: cover;">
                    <div style="padding: 14px;">
                        <span style="font-weight: bold">{{c.name}}</span>
                        <div style="margin-top: 10px; color: #999; font-size: 12px;">
                            <div>分类: {{c.category}}</div>
                            <div>类型: {{c.type}}</div>
                            <div>时长: {{formatDuration(c.duration)}}</div>
                            <div>学分: {{c.credit || 0}}</div>
                            <div>考试: {{c.hasExam ? '有' : '无'}}</div>
                        </div>
                        <div style="margin-top: 10px; border-top: 1px solid #eee; padding-top: 10px; display: flex; justify-content: flex-end;">
                            <el-button type="text" size="small" icon="el-icon-edit" @click.stop="showEditView(c)">编辑</el-button>
                            <el-button type="text" size="small" icon="el-icon-delete" style="color: #F56C6C" @click.stop="deleteCourse(c)">删除</el-button>
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
                    <el-form-item label="课程学分" v-if="!course.hasExam">
                        <el-input-number v-model="course.credit" :min="0" style="width: 200px"></el-input-number>
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
                            <el-button type="text" style="color: red" @click="questions.splice(index, 1)">删除</el-button>
                            <br>
                            <el-form-item label="题目" style="width: 100%">
                                <el-input v-model="q.content" style="width: 500px"></el-input>
                            </el-form-item>
                            <div v-if="q.type!=='填空'">
                                <el-form-item label="选项配置">
                                    <div v-for="(opt, oIdx) in q.tempOptions" :key="oIdx" style="margin-bottom: 5px;">
                                        <el-tag size="small" style="margin-right: 5px; width: 30px; text-align: center;">{{opt.label}}</el-tag>
                                        <el-input v-model="opt.text" placeholder="请输入选项内容" style="width: 300px; margin-right: 5px;" size="small"></el-input>
                                        <el-button type="text" icon="el-icon-delete" style="color: #F56C6C" @click="removeOption(q, oIdx)"></el-button>
                                    </div>
                                    <el-button type="dashed" size="small" icon="el-icon-plus" @click="addOption(q)">添加选项</el-button>
                                </el-form-item>
                            </div>
                            <el-form-item label="正确答案" v-if="q.type!=='填空'">
                                <el-select v-model="q.correctAnswer" placeholder="请选择" style="width: 150px" :multiple="q.type==='多选'">
                                    <el-option v-for="opt in q.tempOptions" :key="opt.label" :label="opt.label" :value="opt.label"></el-option>
                                </el-select>
                            </el-form-item>
                            <div v-if="q.type==='填空'">
                                <el-form-item label="有无标准答案">
                                    <el-switch v-model="q.hasStandardAnswer" active-text="有" inactive-text="无"></el-switch>
                                </el-form-item>
                                <el-form-item label="标准答案" v-if="q.hasStandardAnswer">
                                    <el-input v-model="q.correctAnswer" placeholder="请输入标准答案" style="width: 300px"></el-input>
                                </el-form-item>
                            </div>
                            <el-form-item label="分值">
                                <el-input-number v-model="q.score" :min="1" style="width: 100px"></el-input-number>
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
        <el-dialog title="课程预览" :visible.sync="previewVisible" width="60%" destroy-on-close @close="previewUrl=''">
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
                selectedCourses: [],
                dialogVisible: false,
                step: 0,
                course: {
                    name: '', videoUrl: '', coverUrl: '', description: '', category: '', type: '选修', departmentId: null, hasExam: false, examLimit: 1, duration: 0.0
                },
                questions: [],
                depts: [],
                uploadPercent: 0,
                previewVisible: false,
                previewUrl: '',
                maxFileSize: '10MB',
                lastUploadedVideo: '',
                lastUploadedCover: ''
            }
        },
        mounted() {
            this.initCourses();
            this.initDepts();
            this.getUploadLimit();
        },
        methods: {
            getUploadLimit() {
                this.getRequest("/system/config/upload-limit").then(resp => {
                    if (resp && resp.obj) {
                        this.maxFileSize = resp.obj;
                    }
                })
            },
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
                    name: '', videoUrl: '', coverUrl: '', description: '', category: '', type: '选修', departmentId: null, hasExam: false, examLimit: 1, duration: 0.0, credit: 0
                };
                this.questions = [];
                this.step = 0;
                this.uploadPercent = 0;
                this.dialogVisible = true;
                this.lastUploadedVideo = '';
                this.lastUploadedCover = '';
            },
            beforeUploadVideo(file) {
                if (file.type !== 'video/mp4') {
                    this.$message.error('只能上传mp4格式的视频');
                    return false;
                }
                let limit = this.parseSize(this.maxFileSize);
                if (file.size > limit) {
                    this.$message.error('上传文件大小不能超过 ' + this.maxFileSize);
                    return false;
                }
                return true;
            },
            parseSize(sizeStr) {
                if (!sizeStr) return 10 * 1024 * 1024;
                let unit = sizeStr.slice(-2).toUpperCase();
                let val = parseFloat(sizeStr);
                if (unit === 'MB') return val * 1024 * 1024;
                if (unit === 'KB') return val * 1024;
                if (unit === 'GB') return val * 1024 * 1024 * 1024;
                return val;
            },
            uploadProgress(event, file, fileList) {
                this.uploadPercent = Math.floor(event.percent);
            },
            handleUploadSuccess(resp, file) {
                if (resp && resp.status == 200) {
                    if (this.lastUploadedVideo && this.lastUploadedVideo !== resp.obj) {
                         this.postRequest("/personnel/train/delete-file?fileName=" + this.lastUploadedVideo);
                    }
                    this.lastUploadedVideo = resp.obj;
                    
                    this.course.videoUrl = resp.obj; 
                    this.uploadPercent = 100;
                    this.$message.success("视频上传成功");
                    
                    if (file.raw) {
                        let video = document.createElement('video');
                        video.preload = 'metadata';
                        video.style.display = 'none';
                        document.body.appendChild(video);
                        video.onloadedmetadata = () => {
                            let duration = video.duration;
                            this.course.duration = parseFloat((duration / 3600).toFixed(1));
                            this.$set(this.course, 'duration', this.course.duration);
                            document.body.removeChild(video);
                            window.URL.revokeObjectURL(video.src);
                        }
                        video.src = URL.createObjectURL(file.raw);
                    }
                } else {
                    this.$message.error("上传失败");
                }
            },
            handleCoverSuccess(resp) {
                if (resp && resp.status == 200) {
                    if (this.lastUploadedCover && this.lastUploadedCover !== resp.obj) {
                         this.postRequest("/personnel/train/delete-file?fileName=" + this.lastUploadedCover);
                    }
                    this.lastUploadedCover = resp.obj;
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
                    type: '单选', content: '', options: '', correctAnswer: '', score: 5, hasStandardAnswer: true,
                    tempOptions: [
                        {label: 'A', text: ''}, {label: 'B', text: ''}, {label: 'C', text: ''}, {label: 'D', text: ''}
                    ]
                });
            },
            addOption(q) {
                if (!q.tempOptions) this.$set(q, 'tempOptions', []);
                const labels = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];
                const nextLabel = labels[q.tempOptions.length] || '?';
                q.tempOptions.push({label: nextLabel, text: ''});
            },
            removeOption(q, idx) {
                q.tempOptions.splice(idx, 1);
                const labels = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];
                q.tempOptions.forEach((o, i) => o.label = labels[i] || '?');
            },
            saveCourse() {
                if (this.course.hasExam) {
                    if (!this.questions || this.questions.length === 0) {
                        this.$message.error("请设置考试题目后再试");
                        return;
                    }
                    let total = 0;
                    this.questions.forEach(q => total += (q.score || 0));
                    this.course.credit = total;
                } else {
                    this.questions = [];
                }
                
                let cleanQuestions = [];
                if (this.course.hasExam) {
                    cleanQuestions = this.questions.map(q => {
                        let optionsStr = q.options;
                        if (q.type !== '填空' && q.tempOptions) {
                            let arr = q.tempOptions.map(o => o.label + ". " + o.text);
                            optionsStr = JSON.stringify(arr);
                        }
                        
                        let correctAns = q.correctAnswer;
                        if (q.type === '多选' && Array.isArray(q.correctAnswer)) {
                            correctAns = q.correctAnswer.join(',');
                        }
                        if (q.type === '填空' && !q.hasStandardAnswer) {
                            correctAns = '';
                        }
                        
                        return {
                            id: q.id,
                            courseId: this.course.id,
                            type: q.type,
                            content: q.content,
                            options: optionsStr,
                            correctAnswer: correctAns,
                            score: q.score
                        };
                    });
                }
                this.course.questions = cleanQuestions;

                if (this.course.id) {
                    this.putRequest("/personnel/train/course/", this.course).then(resp => {
                        if (resp) {
                            this.dialogVisible = false;
                            this.initCourses();
                        }
                    })
                } else {
                    this.postRequest("/personnel/train/course", this.course).then(resp => {
                        if (resp) {
                            this.dialogVisible = false;
                            this.initCourses();
                        }
                    })
                }
            },
            showEditView(c) {
                this.course = Object.assign({credit: 0, duration: 0.0}, c);
                // Ensure boolean for switch
                this.course.hasExam = !!this.course.hasExam;
                this.questions = []; 
                this.lastUploadedVideo = '';
                this.lastUploadedCover = '';
                this.getRequest("/personnel/train/course/" + c.id + "/questions").then(resp => {
                    if (resp) {
                         this.questions = resp.map(q => {
                             let tempOptions = [];
                             if (q.options) {
                                 try {
                                     let arr = JSON.parse(q.options);
                                     arr.forEach(str => {
                                         let parts = str.split('. ');
                                         if (parts.length >= 2) {
                                             tempOptions.push({label: parts[0], text: parts.slice(1).join('. ')});
                                         } else {
                                             tempOptions.push({label: '?', text: str});
                                         }
                                     });
                                 } catch(e) {}
                             }
                             if (q.type === '多选' && typeof q.correctAnswer === 'string') {
                                 q.correctAnswer = q.correctAnswer.split(',');
                             }
                             if (q.type === '填空') {
                                 q.hasStandardAnswer = !!(q.correctAnswer && q.correctAnswer.trim());
                             } else {
                                 q.hasStandardAnswer = true;
                             }
                             return {...q, tempOptions};
                         });
                    }
                });
                this.step = 0;
                this.dialogVisible = true;
            },
            deleteCourse(c) {
                this.$confirm('此操作将永久删除该课程[' + c.name + '], 是否继续?', '提示', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning'
                }).then(() => {
                    this.deleteRequest("/personnel/train/course/" + c.id).then(resp => {
                        if (resp) {
                            this.initCourses();
                        }
                    })
                }).catch(() => {
                    this.$message({
                        type: 'info',
                        message: '已取消删除'
                    });          
                });
            },
            deleteMany() {
                this.$confirm('此操作将永久删除[' + this.selectedCourses.length + ']项, 是否继续?', '提示', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning'
                }).then(() => {
                    this.deleteRequest("/personnel/train/course/?ids=" + this.selectedCourses.join(",")).then(resp => {
                        if (resp) {
                            this.initCourses();
                            this.selectedCourses = [];
                        }
                    })
                }).catch(() => {
                    this.$message({
                        type: 'info',
                        message: '已取消删除'
                    });          
                });
            },
            playPreview(c) {
                this.previewUrl = c.videoUrl;
                if (!this.previewUrl.startsWith('http') && !this.previewUrl.startsWith('//')) {
                    this.previewUrl = '/video/' + c.videoUrl;
                }
                this.previewVisible = true;
            },
            formatDuration(hours) {
                if (!hours) return '00:00:00';
                let totalSeconds = Math.round(hours * 3600);
                let h = Math.floor(totalSeconds / 3600);
                let m = Math.floor((totalSeconds % 3600) / 60);
                let s = totalSeconds % 60;
                return (h < 10 ? '0' + h : h) + ':' + (m < 10 ? '0' + m : m) + ':' + (s < 10 ? '0' + s : s);
            }
        }
    }
</script>
<style scoped>
</style>
