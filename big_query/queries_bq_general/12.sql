-- $ID$
-- TPC-H/TPC-R Shipping Modes and Order Priority Query (Q12)
-- Functional Query Definition
-- Approved February 1998

select
	l_shipmode,
	sum(case
		when o_orderpriority = '1-URGENT'
			or o_orderpriority = '2-HIGH'
			then 1
		else 0
	end) as high_line_count,
	sum(case
		when o_orderpriority <> '1-URGENT'
			and o_orderpriority <> '2-HIGH'
			then 1
		else 0
	end) as low_line_count
from
	`${PROJECT_ID}.${DATASET}.ORDERS`,
	`${PROJECT_ID}.${DATASET}.LINEITEM`
where
	o_orderkey = l_orderkey
	and l_shipmode in ('FOB', 'TRUCK')
	and l_commitdate < l_receiptdate
	and DATE(PARSE_DATE('%m/%d/%Y',  l_shipdate)) < DATE(PARSE_DATE('%m/%d/%Y',  l_commitdate))
	and DATE(PARSE_DATE('%m/%d/%Y',  l_receiptdate)) >= date '1995-01-01'
	and DATE(PARSE_DATE('%m/%d/%Y',  l_receiptdate)) < DATE_ADD(date '1995-01-01', interval 1 year)
group by
	l_shipmode
order by
	l_shipmode;

