select
	o_orderpriority,
	count(*) as order_count
from
	`${PROJECT_ID}.${DATASET}.ORDERS`
where
	o_orderdate >= date '1997-11-11'
	and o_orderdate < DATE_ADD(DATE '1997-11-11', INTERVAL 3 MONTH)
	and exists (
		select
			*
		from
			`${PROJECT_ID}.${DATASET}.LINEITEM`
		where
			l_orderkey = o_orderkey
			and l_commitdate < l_receiptdate
	)
group by
	o_orderpriority
order by
	o_orderpriority;