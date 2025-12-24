<template>
    <div class="learn-container">
        <!-- Dashboard Header -->
        <div class="dashboard-header">
            <el-row :gutter="20">
                <el-col :span="16">
                    <el-card shadow="hover" class="info-card">
                        <div slot="header" class="clearfix">
                            <span><i class="el-icon-data-line"></i> 我的学习概况</span>
                        </div>
                        <div class="info-content">
                            <div class="info-item">
                                <div class="info-value">{{info.completedCount || 0}}</div>
                                <div class="info-label">已修课程</div>
                            </div>
                            <div class="info-item">
                                <div class="info-value">{{info.totalHours || 0}}</div>
                                <div class="info-label">累计学时(h)</div>
                            </div>
                            <div class="info-item">
                                <div class="info-value">{{info.totalScore || 0}}</div>
                                <div class="info-label">获得学分</div>
                            </div>
                        </div>
                    </el-card>
                </el-col>
                <el-col :span="8">
                    <el-card shadow="hover" class="rank-card">
                        <div slot="header" class="clearfix">
                            <span><i class="el-icon-trophy"></i> 学分排行榜</span>
                        </div>
                        <div class="rank-list">
                            <div v-for="(r, index) in info.rankList" :key="index" class="rank-item">
                                <span class="rank-index" :class="'rank-' + (index+1)">{{index+1}}</span>
                                <span class="rank-name">{{r.employee.name}}</span>
                                <span class="rank-score">{{r.examScore}}分</span>
                            </div>
                            <div v-if="!info.rankList || info.rankList.length === 0" style="text-align: center; color: #999">
                                暂无排名
                            </div>
                        </div>
                    </el-card>
                </el-col>
            </el-row>
        </div>

        <!-- Course Tabs -->
        <div class="course-section">
            <el-tabs v-model="activeTab" type="card">
                <el-tab-pane label="我的选修课" name="选修">
                    <span slot="label"><i class="el-icon-reading"></i> 我的选修课</span>
                </el-tab-pane>
                <el-tab-pane label="我的必修课" name="必修">
                    <span slot="label"><i class="el-icon-collection"></i> 我的必修课</span>
                </el-tab-pane>
            </el-tabs>

            <div v-if="filteredCourses.length === 0" class="empty-state">
                <el-empty description="暂无课程"></el-empty>
            </div>

            <div class="course-grid" v-else>
                <el-card v-for="ec in filteredCourses" :key="ec.id" class="course-card" :body-style="{ padding: '0px' }" shadow="hover" @click.native="startLearn(ec)">
                    <div class="course-cover-wrapper">
                        <img :src="ec.course.coverUrl || 'https://via.placeholder.com/300x150?text=No+Image'" class="course-cover">
                        <div class="course-status-badge" :class="ec.status">
                            {{ec.status === 'Finished' ? '已完成' : '学习中'}}
                        </div>
                    </div>
                    <div class="course-info">
                        <h3 class="course-title" :title="ec.course.name">{{ec.course.name}}</h3>
                        <div class="course-meta">
                            <span><i class="el-icon-time"></i> {{ec.course.hours || 0}} 学时</span>
                            <span><i class="el-icon-s-flag"></i> {{ec.course.hasExam ? '有考试' : '无考试'}}</span>
                        </div>
                        <div class="course-progress">
                            <el-progress :percentage="calcProgress(ec)" :status="ec.status === 'Finished' ? 'success' : ''"></el-progress>
                        </div>
                    </div>
                </el-card>
            </div>
        </div>

        <!-- Learning Dialog -->
        <el-dialog :title="currentEc ? currentEc.course.name : '课程学习'" :visible.sync="learnVisible" width="80%" top="5vh" :before-close="handleClose" custom-class="learn-dialog">
            <div v-if="currentEc" class="learn-content">
                <div class="video-section">
                    <video id="videoPlayer" width="100%" height="450px" controls controlsList="nodownload" @timeupdate="onTimeUpdate" @ended="onVideoEnded" style="background: #000; border-radius: 4px;">
                        <source :src="videoUrl(currentEc.course.videoUrl)" type="video/mp4">
                        Your browser does not support the video tag.
                    </video>
                    <div class="video-controls">
                        <span>播放速度: </span>
                        <el-radio-group v-model="playbackRate" size="small" @change="setSpeed">
                            <el-radio-button :label="1.0">1.0x</el-radio-button>
                            <el-radio-button :label="1.25">1.25x</el-radio-button>
                            <el-radio-button :label="1.5">1.5x</el-radio-button>
                            <el-radio-button :label="2.0">2.0x</el-radio-button>
                        </el-radio-group>
                    </div>
                </div>
                <div class="step-section">
                    <el-card shadow="never">
                        <div slot="header">
                            <span>学习进度</span>
                        </div>
                        <el-steps direction="vertical" :active="learnStep" finish-status="success">
                            <el-step title="视频学习" description="观看完整视频"></el-step>
                            <el-step title="课程考试" :description="currentEc.course.hasExam ? '通过考试以获取学分' : '本课程无考试'"></el-step>
                            <el-step title="完成" description="获得学分"></el-step>
                        </el-steps>
                        
                        <div class="action-area">
                            <div v-if="!videoFinished" class="status-msg warning">
                                <i class="el-icon-lock"></i> 请先完整观看视频
                            </div>
                            <div v-else-if="currentEc.course.hasExam && !examPassed">
                                <div class="status-msg info">
                                    <i class="el-icon-edit-outline"></i> 视频已看完，请参加考试
                                </div>
                                <el-button type="primary" class="exam-btn" @click="startExam">开始考试</el-button>
                                <p class="exam-attempts">已尝试 {{currentEc.examAttempts}} / {{currentEc.course.examLimit}} 次</p>
                            </div>
                            <div v-else class="status-msg success">
                                <i class="el-icon-circle-check"></i> 课程已完成！
                            </div>
                        </div>
                    </el-card>
                </div>
            </div>
        </el-dialog>

        <!-- Exam Dialog -->
        <el-dialog title="在线考试" :visible.sync="examVisible" width="600px" :close-on-click-modal="false">
            <div class="exam-container">
                <div v-for="(q, index) in questions" :key="index" class="question-item">
                    <div class="question-title">
                        <span class="q-index">{{index+1}}.</span>
                        <span class="q-type">[{{q.type}}]</span>
                        {{q.content}}
                        <span class="q-score">({{q.score}}分)</span>
                    </div>
                    <div class="question-options">
                        <div v-if="q.type==='单选'">
                            <el-radio-group v-model="answers[index].correctAnswer" vertical>
                                <el-radio v-for="opt in parseOptions(q.options)" :key="opt" :label="opt.split('.')[0]" class="option-item">{{opt}}</el-radio>
                            </el-radio-group>
                        </div>
                        <div v-else-if="q.type==='多选'">
                             <!-- Simple handling for multi-select, assuming user inputs string like 'A,B' or logic handled elsewhere. For now using checkbox but mapping to string is tricky without v-model binding to array. -->
                             <!-- To simplify, treating as string input or just single select for demo unless we update data model. Let's use Checkbox Group and join values. -->
                             <el-checkbox-group v-model="answers[index].tempArray" @change="val => updateMultiAnswer(index, val)">
                                <el-checkbox v-for="opt in parseOptions(q.options)" :key="opt" :label="opt.split('.')[0]" class="option-item">{{opt}}</el-checkbox>
                             </el-checkbox-group>
                        </div>
                        <div v-else>
                            <el-input v-model="answers[index].correctAnswer" type="textarea" :rows="2" placeholder="请输入答案"></el-input>
                        </div>
                    </div>
                </div>
            </div>
            <span slot="footer">
                <el-button @click="examVisible = false">取 消</el-button>
                <el-button type="primary" @click="submitExam">交 卷</el-button>
            </span>
        </el-dialog>
    </div>
</template>

<script>
    export default {
        name: "EmpTrainLearn",
        data() {
            return {
                activeTab: '选修',
                myCourses: [],
                info: {},
                learnVisible: false,
                currentEc: null,
                videoFinished: false,
                examPassed: false,
                learnStep: 0,
                examVisible: false,
                questions: [],
                answers: [],
                playbackRate: 1.0
            }
        },
        computed: {
            filteredCourses() {
                if (!this.myCourses) return [];
                return this.myCourses.filter(ec => ec.course && ec.course.type === this.activeTab);
            }
        },
        mounted() {
            this.initData();
            document.addEventListener("visibilitychange", this.handleVisibilityChange);
        },
        destroyed() {
            document.removeEventListener("visibilitychange", this.handleVisibilityChange);
        },
        methods: {
            initData() {
                this.getRequest("/emp/train/list").then(resp => { if(resp) this.myCourses = resp; });
                this.getRequest("/emp/train/info").then(resp => { if(resp) this.info = resp; });
            },
            videoUrl(url) {
                // Assuming video is served from static or specific endpoint
                // If it's a full URL, return it. If filename, append prefix.
                if (url && (url.startsWith('http') || url.startsWith('//'))) return url;
                return '/video/' + url; 
            },
            startLearn(ec) {
                this.currentEc = ec;
                this.videoFinished = ec.isVideoFinished;
                this.examPassed = ec.isPassed;
                this.learnStep = ec.isPassed ? 3 : (ec.isVideoFinished ? 1 : 0);
                this.learnVisible = true;
                this.playbackRate = 1.0;
                this.$nextTick(() => {
                    let v = document.getElementById("videoPlayer");
                    if (v && ec.videoProgress) {
                        v.currentTime = ec.videoProgress;
                    }
                });
            },
            handleVisibilityChange() {
                if (document.hidden && this.learnVisible) {
                    let v = document.getElementById("videoPlayer");
                    if (v) v.pause();
                    this.$message.warning("检测到切屏，视频已暂停");
                }
            },
            setSpeed(rate) {
                let v = document.getElementById("videoPlayer");
                if (v) v.playbackRate = rate;
            },
            onTimeUpdate(e) {
                // Could throttle this update
            },
            onVideoEnded() {
                this.videoFinished = true;
                this.learnStep = 1;
                this.updateProgress(true);
            },
            handleClose(done) {
                let v = document.getElementById("videoPlayer");
                if (v && !this.videoFinished) {
                    this.updateProgress(false, v.currentTime);
                }
                done();
            },
            updateProgress(finished, time) {
                let hours = 0;
                if (finished) {
                     let v = document.getElementById("videoPlayer");
                     if (v) hours = (v.duration / 3600).toFixed(1);
                }
                this.postRequest("/emp/train/progress", {
                    ecId: this.currentEc.id,
                    videoProgress: time ? Math.floor(time) : 0,
                    finished: finished,
                    hours: hours
                }).then(resp => {
                    this.initData();
                })
            },
            startExam() {
                this.getRequest("/emp/train/exam/" + this.currentEc.courseId).then(resp => {
                    if (resp) {
                        this.questions = resp;
                        this.answers = resp.map(q => ({
                            id: q.id, 
                            correctAnswer: '', 
                            tempArray: [] // For checkbox group
                        }));
                        this.examVisible = true;
                    }
                })
            },
            updateMultiAnswer(index, val) {
                // Sort to ensure consistency "A,B" vs "B,A" if needed, or just join
                this.answers[index].correctAnswer = val.sort().join(',');
            },
            submitExam() {
                this.postRequest("/emp/train/submitExam", {
                    ecId: this.currentEc.id,
                    answers: this.answers
                }).then(resp => {
                    if (resp && resp.status === 200) {
                        this.examVisible = false;
                        this.initData();
                        this.learnVisible = false;
                        this.$alert(resp.msg, "考试结果", {
                            confirmButtonText: '确定'
                        });
                    }
                })
            },
            parseOptions(json) {
                try {
                    return JSON.parse(json);
                } catch (e) {
                    return [];
                }
            },
            calcProgress(ec) {
                if (ec.status === 'Finished') return 100;
                if (ec.isVideoFinished && !ec.course.hasExam) return 100;
                if (ec.isVideoFinished) return 60; // Video done, exam pending
                return 10; // Started
            }
        }
    }
</script>

<style scoped>
    .learn-container {
        padding: 10px;
    }
    .dashboard-header {
        margin-bottom: 20px;
    }
    .info-card, .rank-card {
        height: 250px;
    }
    .info-content {
        display: flex;
        justify-content: space-around;
        align-items: center;
        height: 150px;
    }
    .info-item {
        text-align: center;
    }
    .info-value {
        font-size: 32px;
        font-weight: bold;
        color: #409EFF;
        margin-bottom: 10px;
    }
    .info-label {
        color: #909399;
    }
    .rank-list {
        height: 180px;
        overflow-y: auto;
    }
    .rank-item {
        display: flex;
        align-items: center;
        padding: 8px 0;
        border-bottom: 1px solid #EBEEF5;
    }
    .rank-index {
        width: 24px;
        height: 24px;
        line-height: 24px;
        text-align: center;
        background: #f0f2f5;
        border-radius: 50%;
        margin-right: 10px;
        font-size: 12px;
        color: #909399;
    }
    .rank-1 { background: #F56C6C; color: #fff; }
    .rank-2 { background: #E6A23C; color: #fff; }
    .rank-3 { background: #409EFF; color: #fff; }
    .rank-name {
        flex: 1;
        font-weight: 500;
    }
    .rank-score {
        color: #67C23A;
        font-weight: bold;
    }

    .course-section {
        margin-top: 20px;
    }
    .course-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
        gap: 20px;
        margin-top: 20px;
    }
    .course-card {
        transition: transform 0.2s;
        cursor: pointer;
    }
    .course-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 4px 12px rgba(0,0,0,0.1);
    }
    .course-cover-wrapper {
        position: relative;
        height: 160px;
        overflow: hidden;
    }
    .course-cover {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }
    .course-status-badge {
        position: absolute;
        top: 10px;
        right: 10px;
        padding: 4px 8px;
        border-radius: 4px;
        font-size: 12px;
        color: #fff;
    }
    .course-status-badge.Finished {
        background-color: #67C23A;
    }
    .course-status-badge.Learning {
        background-color: #E6A23C;
    }
    .course-info {
        padding: 15px;
    }
    .course-title {
        margin: 0 0 10px 0;
        font-size: 16px;
        color: #303133;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
    }
    .course-meta {
        display: flex;
        justify-content: space-between;
        color: #909399;
        font-size: 13px;
        margin-bottom: 10px;
    }
    .course-progress {
        margin-top: 10px;
    }

    .video-section {
        background: #000;
        padding: 10px;
        border-radius: 4px;
        text-align: center;
    }
    .video-controls {
        margin-top: 10px;
        color: #fff;
    }
    .step-section {
        margin-left: 20px;
        flex: 1;
        min-width: 300px;
    }
    .learn-content {
        display: flex;
        flex-wrap: wrap;
    }
    .action-area {
        margin-top: 30px;
        text-align: center;
        padding: 20px;
        background: #f9fafc;
        border-radius: 4px;
    }
    .status-msg {
        font-size: 16px;
        margin-bottom: 15px;
    }
    .status-msg.warning { color: #E6A23C; }
    .status-msg.info { color: #409EFF; }
    .status-msg.success { color: #67C23A; }
    .exam-attempts {
        font-size: 12px;
        color: #999;
        margin-top: 5px;
    }
    
    .question-item {
        margin-bottom: 25px;
        padding-bottom: 15px;
        border-bottom: 1px dashed #eee;
    }
    .question-title {
        font-size: 16px;
        font-weight: bold;
        margin-bottom: 15px;
    }
    .q-index { color: #409EFF; margin-right: 5px; }
    .q-type { color: #909399; font-size: 14px; margin-right: 5px; font-weight: normal;}
    .q-score { color: #F56C6C; font-size: 14px; margin-left: 5px; font-weight: normal;}
    .option-item {
        display: block;
        margin-bottom: 10px;
        margin-left: 0 !important;
    }
</style>
