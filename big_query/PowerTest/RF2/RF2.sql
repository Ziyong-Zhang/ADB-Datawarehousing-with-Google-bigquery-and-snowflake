	delete from `advanceddb-405622.TPCH_3G.LINEITEM` where L_ORDERKEY in (select O_ORDERKEY from `advanceddb-405622.TPCH_3G.delete_orders`);
	delete from `advanceddb-405622.TPCH_3G.ORDERS` where O_ORDERKEY in (select O_ORDERKEY from `advanceddb-405622.TPCH_3G.delete_orders`);
