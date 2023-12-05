SELECT
    supp_nation,
    cust_nation,
    l_year,
    SUM(volume) AS revenue
FROM
    (
        SELECT
            n1.n_name AS supp_nation,
            n2.n_name AS cust_nation,
            EXTRACT(YEAR FROM 
			
				IF(REGEXP_CONTAINS(l_shipdate, r'\d{1,2}/\d{1,2}/\d{4}'), 
					DATE(PARSE_DATE('%m/%d/%Y', l_shipdate)),
					DATE('0001-01-01')  -- Replace with a date outside the desired range
				) 
				
			) AS l_year,
            l_extendedprice * (1 - l_discount) AS volume
        FROM
            `${PROJECT_ID}.${DATASET}.SUPPLIER`,
            `${PROJECT_ID}.${DATASET}.LINEITEM`,
            `${PROJECT_ID}.${DATASET}.ORDERS`,
            `${PROJECT_ID}.${DATASET}.CUSTOMER`,
            `${PROJECT_ID}.${DATASET}.NATION` n1,
            `${PROJECT_ID}.${DATASET}.NATION` n2
        WHERE
            s_suppkey = l_suppkey
            AND o_orderkey = l_orderkey
            AND c_custkey = o_custkey
            AND s_nationkey = n1.n_nationkey
            AND c_nationkey = n2.n_nationkey
            AND (
                (n1.n_name = 'FRANCE' AND n2.n_name = 'GERMANY')
                OR (n1.n_name = 'GERMANY' AND n2.n_name = 'FRANCE')
            )
            AND (
                IF(
                    REGEXP_CONTAINS(l_shipdate, r'\d{1,2}/\d{1,2}/\d{4}'), 
                    DATE(PARSE_DATE('%m/%d/%Y', l_shipdate)),
                    DATE('0001-01-01')  -- Replace with a date outside the desired range
                ) 
                BETWEEN DATE '1995-01-01' AND DATE '1996-12-31'
            )
    ) AS shipping
GROUP BY
    supp_nation,
    cust_nation,
    l_year
ORDER BY
    supp_nation,
    cust_nation,
    l_year;

