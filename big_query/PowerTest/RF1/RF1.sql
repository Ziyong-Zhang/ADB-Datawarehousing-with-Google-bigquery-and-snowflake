--insert data

INSERT INTO `advanceddb-405622.TPCH_3G.ORDERS`
SELECT * FROM `advanceddb-405622.TPCH_3G.add_orders` ;

INSERT INTO `advanceddb-405622.TPCH_3G.LINEITEM`
SELECT * FROM `advanceddb-405622.TPCH_3G.add_lineitem`;


