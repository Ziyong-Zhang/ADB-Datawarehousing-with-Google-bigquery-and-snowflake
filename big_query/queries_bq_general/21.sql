-- $ID$
-- TPC-H/TPC-R Suppliers Who Kept Orders Waiting Query (Q21)
-- Functional Query Definition
-- Approved February 1998

select
	s_name,
	count(*) as numwait
from
	`${PROJECT_ID}.${DATASET}.SUPPLIER`,
	`${PROJECT_ID}.${DATASET}.LINEITEM` l1,
	`${PROJECT_ID}.${DATASET}.ORDERS`,
	`${PROJECT_ID}.${DATASET}.NATION`
where
	s_suppkey = l1.l_suppkey
	and o_orderkey = l1.l_orderkey
	and o_orderstatus = 'F'
	and l1.l_receiptdate > l1.l_commitdate
	and exists (
		select
			*
		from
			`${PROJECT_ID}.${DATASET}.LINEITEM` l2
		where
			l2.l_orderkey = l1.l_orderkey
			and l2.l_suppkey <> l1.l_suppkey
	)
	and not exists (
		select
			*
		from
			`${PROJECT_ID}.${DATASET}.LINEITEM` l3
		where
			l3.l_orderkey = l1.l_orderkey
			and l3.l_suppkey <> l1.l_suppkey
			and l3.l_receiptdate > l3.l_commitdate
	)
	and s_nationkey = n_nationkey
	and n_name = 'FRANCE'
group by
	s_name
order by
	numwait desc,
	s_name;
