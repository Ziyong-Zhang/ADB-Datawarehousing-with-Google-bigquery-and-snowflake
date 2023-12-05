-- $ID$
-- TPC-H/TPC-R Potential Part Promotion Query (Q20)
-- Function Query Definition
-- Approved February 1998

select
	s_name,
	s_address
from
	`${PROJECT_ID}.${DATASET}.SUPPLIER`,
	`${PROJECT_ID}.${DATASET}.NATION`
where
	s_suppkey in (
		select
			ps_suppkey
		from
			`${PROJECT_ID}.${DATASET}.PARTSUPP`
		where
			ps_partkey in (
				select
					p_partkey
				from
					`${PROJECT_ID}.${DATASET}.PART`
				where
					p_name like 'green%'
			)
			and ps_availqty > (
				select
					0.5 * sum(l_quantity)
				from
					`${PROJECT_ID}.${DATASET}.LINEITEM`
				where
					l_partkey = ps_partkey
					and l_suppkey = ps_suppkey
					and  
					
					
					 (
        CASE
            WHEN REGEXP_CONTAINS(l_shipdate, r'\d{1,2}/\d{1,2}/\d{4}') THEN
                DATE(PARSE_DATE('%m/%d/%Y', l_shipdate)) >= date '1994-09-30'
            ELSE
                FALSE
        END
    )
					and  
					
					(
        CASE
            WHEN REGEXP_CONTAINS(l_shipdate, r'\d{1,2}/\d{1,2}/\d{4}') THEN
                DATE(PARSE_DATE('%m/%d/%Y', l_shipdate)) < DATE_ADD(date '1994-09-30', INTERVAL 1 YEAR)
            ELSE
                FALSE
        END
    )
					
					
			)
	)
	and s_nationkey = n_nationkey
	and n_name = 'FRANCE'
order by
	s_name;

