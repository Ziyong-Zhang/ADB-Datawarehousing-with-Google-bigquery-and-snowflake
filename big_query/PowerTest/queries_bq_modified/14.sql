-- $ID$
-- TPC-H/TPC-R Promotion Effect Query (Q14)
-- Functional Query Definition
-- Approved February 1998

select
	100.00 * sum(case
		when p_type like 'PROMO%'
			then l_extendedprice * (1 - l_discount)
		else 0
	end) / sum(l_extendedprice * (1 - l_discount)) as promo_revenue
from
	`${PROJECT_ID}.${DATASET}.LINEITEM`,
	`${PROJECT_ID}.${DATASET}.PART`
where
	l_partkey = p_partkey
	and 
	
	(
        CASE
            WHEN REGEXP_CONTAINS(l_shipdate, r'\d{1,2}/\d{1,2}/\d{4}') THEN
                DATE(PARSE_DATE('%m/%d/%Y', l_shipdate))  >= date '1995-01-01'
            ELSE
                FALSE
        END
    )
	and 
	(
        CASE
            WHEN REGEXP_CONTAINS(l_shipdate, r'\d{1,2}/\d{1,2}/\d{4}') THEN
                DATE(PARSE_DATE('%m/%d/%Y', l_shipdate))  < DATE_ADD(date '1995-01-01', INTERVAL 1 MONTH)
            ELSE
                FALSE
        END
    )
