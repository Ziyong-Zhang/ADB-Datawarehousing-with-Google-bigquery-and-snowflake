-- $ID$
-- TPC-H/TPC-R Minimum Cost Supplier Query (Q2)
-- Functional Query Definition
-- Approved February 1998

select
	s_acctbal,
	s_name,
	n_name,
	p_partkey,
	p_mfgr,
	s_address,
	s_phone,
	s_comment
from
	`${PROJECT_ID}.${DATASET}.part`,
	`${PROJECT_ID}.${DATASET}.supplier`,
	`${PROJECT_ID}.${DATASET}.partsupp`,
	`${PROJECT_ID}.${DATASET}.nation`,
	`${PROJECT_ID}.${DATASET}.region`
where
	p_partkey = ps_partkey
	and s_suppkey = ps_suppkey
	and p_size = 8
	and p_type like '%BRASS'
	and s_nationkey = n_nationkey
	and n_regionkey = r_regionkey
	and r_name = 'EUROPE'
	and ps_supplycost = (
		select
			min(ps_supplycost)
		from
			`${PROJECT_ID}.${DATASET}.supplier`,
			`${PROJECT_ID}.${DATASET}.partsupp`,
			`${PROJECT_ID}.${DATASET}.nation`,
			`${PROJECT_ID}.${DATASET}.region`

		where
			p_partkey = ps_partkey
			and s_suppkey = ps_suppkey
			and s_nationkey = n_nationkey
			and n_regionkey = r_regionkey
			and r_name = 'EUROPE'
	)
order by
	s_acctbal desc,
	n_name,
	s_name,
	p_partkey;
