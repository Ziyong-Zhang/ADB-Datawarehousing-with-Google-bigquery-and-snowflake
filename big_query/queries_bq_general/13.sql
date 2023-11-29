-- $ID$
-- TPC-H/TPC-R Customer Distribution Query (Q13)
-- Functional Query Definition
-- Approved February 1998

WITH c_orders AS (
  SELECT
    c_custkey,
    COUNT(o_orderkey) AS c_count
  FROM
    `${PROJECT_ID}.${DATASET}.CUSTOMER`
    LEFT OUTER JOIN `${PROJECT_ID}.${DATASET}.ORDERS` ON
      c_custkey = o_custkey
      AND o_comment NOT LIKE '%regular%deposit%'
  GROUP BY
    c_custkey
)

SELECT
  c_count,
  COUNT(*) AS custdist
FROM
  c_orders
GROUP BY
  c_count
ORDER BY
  custdist DESC,
  c_count DESC;
