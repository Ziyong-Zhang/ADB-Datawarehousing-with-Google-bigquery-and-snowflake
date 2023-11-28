# ADB-Dataware-housing-with-Google-bigquery-and-snowflake

This is the workspace of the group project Advanced Database

<aside>
    
👋 Topic: **Data warehousing with Google BigQuery and Snowflake**

- Overleaf link invitation: [overleaf](https://www.overleaf.com/4131969233szkcgcnjhxkq#df4862)
- Deadline: **Monday, December 11, 2023**
- Website: [Course_Project](https://cs.ulb.ac.be/public/teaching/infoh415#project)

</aside>

## 分工
1. 文档部分：Chapter1:Introduction, Chapter2: Data warehouse 介绍
2. **ziyong：** Setting up + throughput test + power test 文档部分 
3. **xianyun：** Maintainess test执行 + 文档部分
4. 结果可视化 + conclusion + ppt

</aside>

## Objective

---

1. Benchmark the proposed tool in relation to the database requirements of your application.

2. [Tools](Tools.md)

## Requirements

---

1. For the dataset, either or:
    1. available datasets in the internet.
    2. data generators.
2. Determine the set of queries and updates that your application requires and do a benchmark with, e.g., 1K, 10K, 100K, and 1M “objects”. (Datasets) 
    1. —> linear or exponential behavior
3. Execute n times and calculate average.

## Workflow

---

### **1. 选择数据集：**

### a. available datasets in the internet：

- Kaggle

### b. data generators：

- TPC-H.

### **2. Queries and updates 定义查询和更新操作：**

### a. 查询操作：

- 设计查询操作(sql)，包括简单查询、聚合查询、连接查询等。—-》TPC-H工具包自动生成
- 查询时间记录。

### b. 更新操作：

- 数据更新操作：插入、更新和删除。记录时间，测试数据仓库的写入性能。

### **3. 基准测试：**

### a. 数据集规模：

- 使用不同规模的数据集（如1K, 10K, 100K, 1M ）来测试性能。

### b. 测试执行次数：

- 对每个查询和更新操作，执行多次，取平均值。

### c. 性能指标：

- 记录每个操作的执行时间、资源消耗（如CPU、内存）等性能指标。

### d. 线性或指数行为：

- 观察性能随数据集规模增长的趋势，确定是线性还是指数级别的行为。

### e. 平均计算：

- 对每个数据集规模和查询/更新操作的执行时间进行平均计算，以得出综合性能。

### **4. 报告和分析：**

### a. 结果汇总：

- 汇总测试结果，包括平均执行时间、资源消耗等。

### b. 行为分析：

- 性能随数据集的规模变化。

### c. 优化建议：

- 根据测试结果提出可能的优化建议，例如索引优化、查询重写等。

### **5. 注意事项：**

### a. 保持一致性：

- 在测试过程中保持环境一致，确保测试结果的可比性。

### b. 考虑成本：

- 不同规模下的成本，特别是在云服务上使用这些数据仓库。

###
