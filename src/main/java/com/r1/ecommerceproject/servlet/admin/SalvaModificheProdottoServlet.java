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
        BigDecimal iva = BigDecimal.valueOf(Double.parseDouble(iv));

        response.setContentType("text/html;charset=UTF-8");

        PrintWriter out = response.getWriter();
        out.println("<html><head><title>Test Parametri Form</title></head><body>");
        out.println("<h2>Parametri ricevuti:</h2>");
        out.println("<ul>");
        out.println("<li>Nome: " + id + "</li>");
        out.println("<li>Nome: " + nome + "</li>");
        out.println("<li>Marca: " + marca + "</li>");
        out.println("<li>Categoria: " + categoria + "</li>");
        out.println("<li>Prezzo: " + prezzo + "</li>");
        out.println("<li>Modello: " + modello + "</li>");
        out.println("<li>Descrizione: " + descrizione + "</li>");
        out.println("<li>Taglia: " + taglia + "</li>");
        out.println("<li>Materiale: " + materiale + "</li>");
        out.println("<li>Iva: " + iva + "</li>");
        out.println("</ul>");
        out.println("</body></html>");


        // Popola il bean
        ProductBean prodotto = new ProductBean();
        prodotto.setCodiceProdotto(id);
        prodotto.setNome(nome);
        prodotto.setMarca(marca);
        prodotto.setGenere(categoria);
        prodotto.setPrezzo(prezzo);
        prodotto.setModello(modello);
        prodotto.setDescrizione(descrizione);
        prodotto.setTaglia(taglia);
        prodotto.setMateriale(materiale);

        // Stampa a schermo
        PrintWriter ou = response.getWriter();
        ou.println("<html><head><title>Bean Ricevuto</title></head><body>");
        ou.println("<h1>Valori del ProductBean:</h1>");
        ou.println("<ul>");
        ou.println("<li><strong>Id:</strong> " + prodotto.getCodiceProdotto() + "</li>");
        ou.println("<li><strong>Nome:</strong> " + prodotto.getNome() + "</li>");
        ou.println("<li><strong>Marca:</strong> " + prodotto.getMarca() + "</li>");
        ou.println("<li><strong>Genere (Categoria):</strong> " + prodotto.getGenere() + "</li>");
        ou.println("<li><strong>Prezzo:</strong> " + prodotto.getPrezzo() + "</li>");
        ou.println("<li><strong>Modello:</strong> " + prodotto.getModello() + "</li>");
        ou.println("<li><strong>Descrizione:</strong> " + prodotto.getDescrizione() + "</li>");
        ou.println("<li><strong>Taglia:</strong> " + prodotto.getTaglia() + "</li>");
        ou.println("<li><strong>Materiale:</strong> " + prodotto.getMateriale() + "</li>");
        ou.println("</ul>");

        // DAO call
        ProductDao productDao = new ProductDaoImpl();
        try {
            productDao.updateProduct(prodotto);
            out.println("<p style='color: green;'>Prodotto aggiornato correttamente nel database.</p>");
        } catch (Exception e) {
            out.println("<p style='color: red;'>Errore durante l'aggiornamento: " + e.getMessage() + "</p>");
        }

        out.println("</body></html>");

    }
}
