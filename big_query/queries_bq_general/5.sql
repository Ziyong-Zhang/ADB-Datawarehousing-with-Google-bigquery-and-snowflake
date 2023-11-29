-- $ID$
-- TPC-H/TPC-R Local Supplier Volume Query (Q5)
-- Functional Query Definition
-- Approved February 1998

select
	n_name,
	sum(l_extendedprice * (1 - l_discount)) as revenue
from
	`advanceddb-405622.PUBLIC.SUPPLIER`,
	`advanceddb-405622.PUBLIC.NATION`,
	`advanceddb-405622.PUBLIC.REGION`,
	`advanceddb-405622.PUBLIC.CUSTOMER`,
	`advanceddb-405622.PUBLIC.LINEITEM`,
	`advanceddb-405622.PUBLIC.ORDERS`

where
	c_custkey = o_custkey
	and l_orderkey = o_orderkey
	and l_suppkey = s_suppkey
	and c_nationkey = s_nationkey
	and s_nationkey = n_nationkey
	and n_regionkey = r_regionkey
	and r_name = 'EUROPE'
	and o_orderdate >= date '1997-11-11'
	and o_orderdate < DATE_ADD(DATE'1997-11-11', INTERVAL 1 YEAR)
group by
	n_name
order by
	revenue desc;

