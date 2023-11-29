-- $ID$
-- TPC-H/TPC-R Forecasting Revenue Change Query (Q6)
-- Functional Query Definition
-- Approved February 1998

select
	sum(l_extendedprice * l_discount) as revenue
from
	lineitem
where
    l_shipdate >= date '1997-11-11'
    and l_shipdate < dateadd(YEAR, 1, DATE'1997-11-11')
    and l_discount between 0.07 - 0.01 and 0.07 + 0.01
    and l_quantity < 50;

