package com.r1.ecommerceproject.servlet;

import com.r1.ecommerceproject.dao.ProductDaoImpl;
import com.r1.ecommerceproject.model.ProductBean;
import com.r1.ecommerceproject.dao.ProductDao;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class ProductControl
 */
@WebServlet("/product")
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
					Long id = Long.parseLong(request.getParameter("id"));
					request.removeAttribute("product");
					request.setAttribute("product", model.doRetrieveById(id));
				} else if (action.equalsIgnoreCase("delete")) {
					Long id = Long.parseLong(request.getParameter("id"));
					model.doDelete(id);
				} else if (action.equalsIgnoreCase("insert")) {
					String materiale = request.getParameter("materiale");
					String categoria = request.getParameter("categoria");
					String taglia = request.getParameter("taglia");
					String marca = request.getParameter("marca");
					double prezzo = Double.parseDouble(request.getParameter("prezzo"));
					String modello = request.getParameter("modello");
					String descrizione = request.getParameter("descrizione");
					String nome = request.getParameter("nome");


					ProductBean bean = new ProductBean();
					bean.setMateriale(materiale);
					bean.setCategoria(categoria);
					bean.setTaglia(taglia);
					bean.setMarca(marca);
					bean.setPrezzo(prezzo);
					bean.setModello(modello);
					bean.setDescrizione(descrizione);
					bean.setNome(nome);
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
