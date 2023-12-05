-- $ID$
-- TPC-H/TPC-R Large Volume Customer Query (Q18)
-- Function Query Definition
-- Approved February 1998

select
	c_name,
	c_custkey,
	o_orderkey,
	o_orderdate,
	o_totalprice,
	sum(l_quantity)
from
	`${PROJECT_ID}.${DATASET}.CUSTOMER`,
	`${PROJECT_ID}.${DATASET}.LINEITEM`,
	`${PROJECT_ID}.${DATASET}.ORDERS`
where
	o_orderkey in (
		select
			l_orderkey
		from
			`${PROJECT_ID}.${DATASET}.LINEITEM`
		group by
			l_orderkey having
				sum(l_quantity) > 300
	)
	and c_custkey = o_custkey
	and o_orderkey = l_orderkey
group by
	c_name,
	c_custkey,
	o_orderkey,
	o_orderdate,
	o_totalprice
order by
	o_totalprice desc,
	o_orderdate;

