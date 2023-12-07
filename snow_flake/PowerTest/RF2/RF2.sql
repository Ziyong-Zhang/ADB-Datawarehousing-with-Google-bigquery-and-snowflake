	delete from LINEITEM where L_ORDERKEY in (select O_ORDERKEY from delete_orders);
	delete from PUBLIC.ORDERS where O_ORDERKEY in (select O_ORDERKEY from delete_orders);
