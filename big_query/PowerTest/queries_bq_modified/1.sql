-- $ID$
-- TPC-H/TPC-R Pricing Summary Report Query (Q1)
-- Functional Query Definition
-- Approved February 1998
-- :x
-- :o
SELECT
    l_returnflag,
    l_linestatus,
    SUM(l_quantity) AS sum_qty,
    SUM(l_extendedprice) AS sum_base_price,
    SUM(l_extendedprice * (1 - l_discount)) AS sum_disc_price,
    SUM(l_extendedprice * (1 - l_discount) * (1 + l_tax)) AS sum_charge,
    AVG(l_quantity) AS avg_qty,
    AVG(l_extendedprice) AS avg_price,
    AVG(l_discount) AS avg_disc,
    COUNT(*) AS count_order
FROM
    `${PROJECT_ID}.${DATASET}.LINEITEM`
WHERE
    CASE
        WHEN REGEXP_CONTAINS(l_shipdate, r'\d{1,2}/\d{1,2}/\d{4}') THEN
            DATE(PARSE_DATE('%m/%d/%Y', l_shipdate)) <= DATE_ADD(DATE '1993-12-04', INTERVAL 3 DAY)
        ELSE
            FALSE
    END
GROUP BY
    l_returnflag,
    l_linestatus
ORDER BY
    l_returnflag,
    l_linestatus;

-- :n -1
