package com.r1.ecommerceproject.servlet.admin;

import com.r1.ecommerceproject.model.ProductDao;
import com.r1.ecommerceproject.model.impl.ProductDaoImpl;
import com.r1.ecommerceproject.model.ProductBean;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;

@WebServlet("/admin/testFormProdotto")
public class SalvaModificheProdottoServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8"); // Per supportare caratteri speciali

        // Recupera i parametri dal form
        String  idd = request.getParameter("id");
        Integer id = Integer.valueOf(idd);
        String nome = request.getParameter("nome");
        String marca = request.getParameter("marca");
        String categoria = request.getParameter("categoria");
        String prezz = request.getParameter("prezzo");
        BigDecimal prezzo = BigDecimal.valueOf(Double.parseDouble(prezz));
        String modello = request.getParameter("modello");
        String descrizione = request.getParameter("descrizione");
        String taglia = request.getParameter("taglia");
        String materiale = request.getParameter("materiale");
        String iv = request.getParameter("iva");
        BigDecimal iva = new BigDecimal(iv);

        // Popola il bean
        ProductBean prodotto = new ProductBean();
        prodotto.setCodiceProdotto(id);
        prodotto.setNome(nome);
        prodotto.setMarca(marca);
        prodotto.setGenere(categoria);
        prodotto.setIvaPercentuale(iva);
        prodotto.setPrezzo(prezzo);
        prodotto.setModello(modello);
        prodotto.setDescrizione(descrizione);
        prodotto.setTaglia(taglia);
        prodotto.setMateriale(materiale);

        // DAO call
        ProductDao productDao = new ProductDaoImpl();
        try {
            productDao.updateProduct(prodotto);
            response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp#tableProdotti");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
