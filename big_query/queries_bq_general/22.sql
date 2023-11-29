-- $ID$
-- TPC-H/TPC-R Global Sales Opportunity Query (Q22)
-- Functional Query Definition
-- Approved February 1998

select
	cntrycode,
	count(*) as numcust,
	sum(c_acctbal) as totacctbal
from
	(
		select
			substring(c_phone,1,2) as cntrycode,
			c_acctbal
		from
			`${PROJECT_ID}.${DATASET}.CUSTOMER`
		where
			substring(c_phone,1,2) in
				('30', '31', '32', '33', '34', '35', '36')
			and c_acctbal > (
				select
					avg(c_acctbal)
				from
					`${PROJECT_ID}.${DATASET}.CUSTOMER`
				where
					c_acctbal > 0.00
					and substring(c_phone,1,2) in
						('30', '31', '32', '33', '34', '35', '36')
			)
			and not exists (
				select
					*
				from
					`${PROJECT_ID}.${DATASET}.ORDERS`
				where
					o_custkey = c_custkey
			)
	) as custsale
group by
	cntrycode
order by
	cntrycode;

