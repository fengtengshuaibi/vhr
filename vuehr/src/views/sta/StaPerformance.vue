<template>
  <div>
    <div>
      <div style="display: flex;justify-content: space-between">
        <div>
          <el-input placeholder="请输入员工名进行搜索..." prefix-icon="el-icon-search"
                    clearable
                    @clear="initPerformances"
                    style="width: 300px;margin-right: 10px" v-model="keyword"
                    @keydown.enter.native="initPerformances"></el-input>
          <el-input placeholder="请输入年份" prefix-icon="el-icon-date"
                    clearable
                    style="width: 150px;margin-right: 10px" v-model="year"
                    @keydown.enter.native="initPerformances"></el-input>
          <el-date-picker
            v-model="dateScope"
            type="daterange"
            unlink-panels
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
            value-format="yyyy-MM-dd"
            style="margin-right: 10px"
          >
          </el-date-picker>
          <el-button icon="el-icon-search" type="primary" @click="initPerformances">
            搜索
          </el-button>
        </div>
        <div>
          <el-button type="success" @click="exportData" icon="el-icon-download">
            导出数据
          </el-button>
        </div>
      </div>
    </div>
    <div style="margin-top: 10px">
      <el-table :data="performances" border v-loading="loading" element-loading-text="正在加载..." element-loading-spinner="el-icon-loading" element-loading-background="rgba(0, 0, 0, 0.8)" style="width: 100%" height="calc(100vh - 160px)">
        <el-table-column prop="employee.name" fixed align="left" label="姓名" width="90" sortable></el-table-column>
        <el-table-column prop="eid" label="身份证号" width="150" sortable></el-table-column>
        <el-table-column prop="year" label="年份" width="80" sortable></el-table-column>
        <el-table-column prop="month1" label="1月" width="60" sortable></el-table-column>
        <el-table-column prop="month2" label="2月" width="60" sortable></el-table-column>
        <el-table-column prop="month3" label="3月" width="60" sortable></el-table-column>
        <el-table-column prop="month4" label="4月" width="60" sortable></el-table-column>
        <el-table-column prop="month5" label="5月" width="60" sortable></el-table-column>
        <el-table-column prop="month6" label="6月" width="60" sortable></el-table-column>
        <el-table-column prop="month7" label="7月" width="60" sortable></el-table-column>
        <el-table-column prop="month8" label="8月" width="60" sortable></el-table-column>
        <el-table-column prop="month9" label="9月" width="60" sortable></el-table-column>
        <el-table-column prop="month10" label="10月" width="60" sortable></el-table-column>
        <el-table-column prop="month11" label="11月" width="60" sortable></el-table-column>
        <el-table-column prop="month12" label="12月" width="60" sortable></el-table-column>
        <el-table-column label="合计" width="80" sortable :sort-method="sortByTotal">
            <template slot-scope="scope">
                {{ calculateTotal(scope.row) }}
            </template>
        </el-table-column>
        <el-table-column label="平均" sortable :sort-method="sortByAvg">
            <template slot-scope="scope">
                {{ calculateAvg(scope.row) }}
            </template>
        </el-table-column>
      </el-table>
      <div style="display: flex;justify-content: flex-end">
        <el-pagination
            background
            @current-change="currentChange"
            @size-change="sizeChange"
            layout="sizes, prev, pager, next, jumper, ->, total, slot"
            :total="total">
        </el-pagination>
      </div>
    </div>
  </div>
</template>
<script>
export default {
    name: "StaPerformance",
    data() {
        return {
            performances: [],
            loading: false,
            total: 0,
            page: 1,
            size: 10,
            keyword: '',
            year: '',
            dateScope: null
        }
    },
    mounted() {
        this.initPerformances();
    },
    methods: {
        calculateTotal(row) {
            let sum = 0;
            for(let i=1; i<=12; i++) {
                if(row['month'+i]) sum += parseFloat(row['month'+i]);
            }
            return sum.toFixed(2);
        },
        calculateAvg(row) {
            let sum = 0;
            let count = 0;
            for(let i=1; i<=12; i++) {
                if(row['month'+i]) {
                    sum += parseFloat(row['month'+i]);
                    count++;
                }
            }
            return count > 0 ? (sum / count).toFixed(2) : 0;
        },
        sortByTotal(a, b) {
            return this.calculateTotal(a) - this.calculateTotal(b);
        },
        sortByAvg(a, b) {
            return this.calculateAvg(a) - this.calculateAvg(b);
        },
        initPerformances() {
            this.loading = true;
            let url = '/statistics/performance/?page=' + this.page + '&size=' + this.size;
            url += "&empName=" + this.keyword;
            if(this.year) url += '&year=' + this.year;
            if(this.dateScope) url += '&beginDate=' + this.dateScope[0] + '&endDate=' + this.dateScope[1];
            
            this.getRequest(url).then(resp => {
                this.loading = false;
                if (resp) {
                    this.performances = resp.data;
                    this.total = resp.total;
                }
            });
        },
        exportData() {
            window.open('/statistics/performance/export?empName=' + this.keyword + '&year=' + (this.year||'') + (this.dateScope ? '&beginDate=' + this.dateScope[0] + '&endDate=' + this.dateScope[1] : ''), '_parent');
        },
        currentChange(currentChange) {
            this.page = currentChange;
            this.initPerformances();
        },
        sizeChange(sizeChange) {
            this.size = sizeChange;
            this.initPerformances();
        }
    }
}
</script>
