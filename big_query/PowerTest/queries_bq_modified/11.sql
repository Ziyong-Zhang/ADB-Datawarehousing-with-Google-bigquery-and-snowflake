-- $ID$
-- TPC-H/TPC-R Important Stock Identification Query (Q11)
-- Functional Query Definition
-- Approved February 1998

select
	ps_partkey,
	sum(ps_supplycost * ps_availqty) as value
from
	`${PROJECT_ID}.${DATASET}.PARTSUPP`,
	`${PROJECT_ID}.${DATASET}.SUPPLIER`,
	`${PROJECT_ID}.${DATASET}.NATION`
where
	ps_suppkey = s_suppkey
	and s_nationkey = n_nationkey
	and n_name = 'FRANCE'
group by
	ps_partkey having
		sum(ps_supplycost * ps_availqty) > (
			select
				sum(ps_supplycost * ps_availqty) * 0.8
			from
				`${PROJECT_ID}.${DATASET}.PARTSUPP`,
				`${PROJECT_ID}.${DATASET}.SUPPLIER`,
				`${PROJECT_ID}.${DATASET}.NATION`
			where
				ps_suppkey = s_suppkey
				and s_nationkey = n_nationkey
				and n_name = 'FRANCE'
		)
order by
	value desc;

