SELECT
    l_orderkey,
    SUM(l_extendedprice * (1 - l_discount)) AS revenue,
    o_orderdate,
    o_shippriority
FROM
    `${PROJECT_ID}.${DATASET}.CUSTOMER`,
    `${PROJECT_ID}.${DATASET}.LINEITEM`,
    `${PROJECT_ID}.${DATASET}.ORDERS`
WHERE
    c_mktsegment = 'BUILDING'
    AND c_custkey = o_custkey
    AND l_orderkey = o_orderkey
    AND o_orderdate < DATE '1994-06-13'
    AND (
        CASE
            WHEN REGEXP_CONTAINS(l_shipdate, r'\d{1,2}/\d{1,2}/\d{4}') THEN
                DATE(PARSE_DATE('%m/%d/%Y', l_shipdate)) > DATE '1994-09-30'
            ELSE
                FALSE
        END
    )
GROUP BY
    l_orderkey,
    o_orderdate,
    o_shippriority
ORDER BY
    revenue DESC,
    o_orderdate;

