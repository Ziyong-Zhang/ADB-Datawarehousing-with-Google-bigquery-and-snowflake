# ADB-Dataware-housing-with-Google-bigquery-and-snowflake

This is the workspace of the group project Advanced Database

<aside>
    
👋 Topic: **Data warehousing with Google BigQuery and Snowflake**

- Course Project Website: [Course_Project](https://cs.ulb.ac.be/public/teaching/infoh415#project)

</aside>

## Group Member

1. [Min Zhang ](https://github.com/PhDnemo)
2. [Ziyong Zhang](https://github.com/Ziyong-Zhang)
3. [Yutao Chen](https://github.com/A-hungry-wolf)
4. [Xianyun Zhuang](https://github.com/zhuangxianyun)

</aside>

## Objective

---

1. Benchmark the proposed tool in relation to the database requirements of your application.

2. [Tools Introduction and Implementation Details](Tools.md)

## Requirements

---

1. For the dataset, either or:
    1. available datasets in the internet.
    2. data generators.
2. Determine the set of queries and updates that your application requires and do a benchmark with, e.g., 1K, 10K, 100K, and 1M “objects”. (Datasets)
    —> linear or exponential behavior
3. Execute n times and calculate average.

## Workflow

---

### **1. Data sets and benchmark selection:**

We use [TPC-H](https://www.tpc.org/tpch/) as our benchmark and utilise the data sets generated.

### **2. Queries and updates:**

### a. Query Operations:

- Design query operations (SQL) —> TPC-H toolkit generates.
- Record query execution times.

### b. Update Operations:

- Data update operations: insert, update, and delete. Record times, test the write performance of the data warehouse.


### **3. Benchmark:**


### a. Dataset Scale:

- Use datasets of different scales (0.5G, 1G, 2G, 3G) to test performance.

### b. Test Execution Count:

- For each query and update operation, execute 6 times and take the average.

### c. Performance Metrics:

- Record execution time.

### d. Linear or Exponential Behavior


### e. Average Calculation:

- Calculate the average execution time for each dataset scale and query/update operation to derive comprehensive performance insights.

### **4. Reporting and Analysis:**

### a. Results Summary:

- Summarize test results.

### b. Behavioral Analysis:

- Analyze how performance varies with changes in the dataset scale.

### c. Optimization Recommendations:

- Propose potential optimization recommendations based on test results.



###

## 测试流程再梳理
![698a4fb4435914279f47559e4448c0b](https://github.com/Ziyong-Zhang/ADB-Dataware-housing-with-Google-bigquery-and-snowflake/assets/149632845/9d0d6bca-944a-4040-b361-fdcd2446d68c)

Performance test 由两部分组成：
1. Power Test 和 2. Throughput Test
Performance test需要跑2次

Power Test流程： 
1.Run refresh function1  
2.Run 22 query
3.Run refresh function2
分别计算1，2，3的耗时

Throughput Test流程：
三个线程同时执行，实现：
1.用户1 Run 22 query
2.用户2 Run 22 query
3.用户3 Run refresh function1和2  
计算3个并行总耗时。

