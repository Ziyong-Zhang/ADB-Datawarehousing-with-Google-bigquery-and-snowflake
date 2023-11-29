select
	l_orderkey,
	sum(l_extendedprice * (1 - l_discount)) as revenue,
	o_orderdate,
	o_shippriority
from
	`${PROJECT_ID}.${DATASET}.CUSTOMER`,
	`${PROJECT_ID}.${DATASET}.LINEITEM`,
	`${PROJECT_ID}.${DATASET}.ORDERS`
where
	c_mktsegment = 'BUILDING'
	and c_custkey = o_custkey
	and l_orderkey = o_orderkey
	and o_orderdate < date '1994-06-13'
	and DATE(PARSE_DATE('%m/%d/%Y',  l_shipdate)) > date '1994-09-30'
group by
	l_orderkey,
	o_orderdate,
	o_shippriority
order by
	revenue desc,
	o_orderdate;
