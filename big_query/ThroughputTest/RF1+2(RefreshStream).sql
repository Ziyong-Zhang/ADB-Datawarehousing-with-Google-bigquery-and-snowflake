--insert data
INSERT INTO `advanceddb-405622.TPCH_2G.ORDERS`
SELECT * FROM `advanceddb-405622.TPCH_2G.add_orders` ;

INSERT INTO `advanceddb-405622.TPCH_2G.LINEITEM`
SELECT * FROM `advanceddb-405622.TPCH_2G.add_lineitem`;


--remove data
-- delete_orders is tmp table
	delete from `advanceddb-405622.TPCH_2G.LINEITEM` where L_ORDERKEY in (select O_ORDERKEY from `advanceddb-405622.TPCH_2G.delete_orders`);
	delete from `advanceddb-405622.TPCH_2G.ORDERS` where O_ORDERKEY in (select O_ORDERKEY from `advanceddb-405622.TPCH_2G.delete_orders`);
