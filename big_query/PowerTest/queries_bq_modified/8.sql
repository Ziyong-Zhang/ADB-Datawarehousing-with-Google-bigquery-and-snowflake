-- $ID$
-- TPC-H/TPC-R National Market Share Query (Q8)
-- Functional Query Definition
-- Approved February 1998

select
	o_year,
	sum(case
		when nation = 'FRANCE' then volume
		else 0
	end) / sum(volume) as mkt_share
from
	(
		select
			extract(year from o_orderdate) as o_year,
			l_extendedprice * (1 - l_discount) as volume,
			n2.n_name as nation
		from
			`${PROJECT_ID}.${DATASET}.SUPPLIER`,
			`${PROJECT_ID}.${DATASET}.PART`,
			`${PROJECT_ID}.${DATASET}.REGION`,
			`${PROJECT_ID}.${DATASET}.CUSTOMER`,
			`${PROJECT_ID}.${DATASET}.LINEITEM`,
			`${PROJECT_ID}.${DATASET}.ORDERS`,
			`${PROJECT_ID}.${DATASET}.NATION` n1,
			`${PROJECT_ID}.${DATASET}.NATION` n2

		where
			p_partkey = l_partkey
			and s_suppkey = l_suppkey
			and l_orderkey = o_orderkey
			and o_custkey = c_custkey
			and c_nationkey = n1.n_nationkey
			and n1.n_regionkey = r_regionkey
			and r_name = 'EUROPE'
			and s_nationkey = n2.n_nationkey
			and o_orderdate between date '1995-01-01' and date '1996-12-31'
			and p_type = 'STANDARD ANODIZED BRASS'
	) as all_nations
group by
	o_year
order by
	o_year;
