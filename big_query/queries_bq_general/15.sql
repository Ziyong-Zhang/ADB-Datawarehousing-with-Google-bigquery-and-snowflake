-- $ID$
-- TPC-H/TPC-R Top Supplier Query (Q15)
-- Functional Query Definition
-- Approved February 1998

SELECT
    --Query15
    s_suppkey,
    s_name,
    s_address,
    s_phone,
    total_revenue
FROM
    `${PROJECT_ID}.${DATASET}.SUPPLIER`,
    (
        SELECT
            l_suppkey AS supplier_no,
            SUM(l_extendedprice * (1 - l_discount)) AS total_revenue
        FROM
            `${PROJECT_ID}.${DATASET}.LINEITEM`
        WHERE
            DATE(PARSE_DATE('%m/%d/%Y',  l_shipdate)) >= CAST('1996-01-01' AS date)
            AND DATE(PARSE_DATE('%m/%d/%Y',  l_shipdate)) < CAST('1996-04-01' AS date)
        GROUP BY
            supplier_no
    ) revenue0
WHERE
    s_suppkey = supplier_no
    AND total_revenue = (
        SELECT
            MAX(total_revenue)
        FROM
            (
                SELECT
                    l_suppkey AS supplier_no,
                    SUM(l_extendedprice * (1 - l_discount)) AS total_revenue
                FROM
                    `${PROJECT_ID}.${DATASET}.LINEITEM`
                WHERE
                    DATE(PARSE_DATE('%m/%d/%Y',  l_shipdate)) >= CAST('1996-01-01' AS date)
                    AND DATE(PARSE_DATE('%m/%d/%Y',  l_shipdate)) < CAST('1996-04-01' AS date)
                GROUP BY
                    supplier_no
            ) revenue1
    )
ORDER BY
    s_suppkey;