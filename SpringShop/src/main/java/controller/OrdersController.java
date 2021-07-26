package controller;

import org.springframework.stereotype.Controller;

import dao.OrdersDAO;

@Controller
public class OrdersController {
	
	OrdersDAO orders_dao;
	public void setOrders_dao(OrdersDAO orders_dao) {
		this.orders_dao = orders_dao;
	}

}
