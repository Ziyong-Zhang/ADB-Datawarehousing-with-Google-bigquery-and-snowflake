-- $ID$
-- TPC-H/TPC-R Returned Item Reporting Query (Q10)
-- Functional Query Definition
-- Approved February 1998

select
	c_custkey,
	c_name,
	sum(l_extendedprice * (1 - l_discount)) as revenue,
	c_acctbal,
	n_name,
	c_address,
	c_phone,
	c_comment
from
	`${PROJECT_ID}.${DATASET}.NATION`,
	`${PROJECT_ID}.${DATASET}.CUSTOMER`,
	`${PROJECT_ID}.${DATASET}.LINEITEM`,
	`${PROJECT_ID}.${DATASET}.ORDERS`

where
	c_custkey = o_custkey
	and l_orderkey = o_orderkey
	and o_orderdate >= date '1995-06-01'
	and o_orderdate < DATE_ADD(DATE'1995-06-01', INTERVAL 3 MONTH)
	and l_returnflag = 'R'
	and c_nationkey = n_nationkey
group by
	c_custkey,
	c_name,
	c_acctbal,
	c_phone,
	n_name,
	c_address,
	c_comment
order by
	revenue desc;

