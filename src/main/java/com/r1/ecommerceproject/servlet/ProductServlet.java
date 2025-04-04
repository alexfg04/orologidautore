package com.r1.ecommerceproject.servlet;

import com.r1.ecommerceproject.dao.ProductDaoImpl;
import com.r1.ecommerceproject.model.ProductBean;
import com.r1.ecommerceproject.dao.ProductDao;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class ProductControl
 */
public class ProductServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	static ProductDao model = new ProductDaoImpl();
	
	public ProductServlet() {
		super();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String action = request.getParameter("action");

		try {
			if (action != null) {
				if (action.equalsIgnoreCase("read")) {
					int id = Integer.parseInt(request.getParameter("id"));
					request.removeAttribute("product");
					request.setAttribute("product", model.doRetrieveByKey(id));
				} else if (action.equalsIgnoreCase("delete")) {
					int id = Integer.parseInt(request.getParameter("id"));
					model.doDelete(id);
				} else if (action.equalsIgnoreCase("insert")) {
					String name = request.getParameter("name");
					String description = request.getParameter("description");
					int price = Integer.parseInt(request.getParameter("price"));
					int quantity = Integer.parseInt(request.getParameter("quantity"));

					ProductBean bean = new ProductBean();
					bean.setName(name);
					bean.setDescription(description);
					bean.setPrice(price);
					bean.setQuantity(quantity);
					model.doSave(bean);
				}
			}
		} catch (SQLException e) {
			System.out.println("Error:" + e.getMessage());
		}

		String sort = request.getParameter("sort");

		try {
			request.removeAttribute("products");
			request.setAttribute("products", model.doRetrieveAll(sort));
		} catch (SQLException e) {
			System.out.println("Error:" + e.getMessage());
		}

		RequestDispatcher dispatcher = getServletContext().getRequestDispatcher("/ProductView.jsp");
		dispatcher.forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);
	}

}
