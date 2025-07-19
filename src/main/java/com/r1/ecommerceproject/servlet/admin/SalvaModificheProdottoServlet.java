package com.r1.ecommerceproject.servlet.admin;

import com.r1.ecommerceproject.dao.ProductDao;
import com.r1.ecommerceproject.dao.impl.ProductDaoImpl;
import com.r1.ecommerceproject.model.ProductBean;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/admin/salvaModificheProdotto")
public class SalvaModificheProdottoServlet extends HttpServlet {

    private ProductDao productDao;

    @Override
    public void init() throws ServletException {
        System.out.println("[INIT] Inizializzazione servlet SalvaModificheProdottoServlet");
        productDao = new ProductDaoImpl();
    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "GET non supportato. Usa POST.");
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            System.out.println("[POST] Ricevuta richiesta POST per salvare modifiche prodotto");

            long id = Long.parseLong(request.getParameter("id"));
            String nome = request.getParameter("nome");
            String marca = request.getParameter("marca");
            String categoria = request.getParameter("categoria");
            String prezzoStr = request.getParameter("prezzo");
            String modello = request.getParameter("modello");
            String descrizione = request.getParameter("descrizione");
            String taglia = request.getParameter("taglia");
            String materiale = request.getParameter("materiale");

            System.out.println("[DEBUG] Parametri ricevuti:");
            System.out.println("ID: " + id);
            System.out.println("Nome: " + nome);
            System.out.println("Marca: " + marca);
            System.out.println("Categoria/Genere: " + categoria);
            System.out.println("Prezzo (stringa): " + prezzoStr);
            System.out.println("Modello: " + modello);
            System.out.println("Descrizione: " + descrizione);
            System.out.println("Taglia: " + taglia);
            System.out.println("Materiale: " + materiale);

            BigDecimal prezzo = new BigDecimal(prezzoStr);

            ProductBean prodotto = productDao.doRetrieveById(id);
            if (prodotto == null) {
                System.out.println("[ERRORE] Prodotto con ID " + id + " non trovato.");
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Prodotto non trovato");
                return;
            }

            prodotto.setNome(nome);
            prodotto.setMarca(marca);
            prodotto.setGenere(categoria);
            prodotto.setPrezzo(prezzo);
            prodotto.setModello(modello);
            prodotto.setDescrizione(descrizione);
            prodotto.setTaglia(taglia);
            prodotto.setMateriale(materiale);

            System.out.println("[INFO] Prodotto aggiornato, ora lo salvo nel database...");
            productDao.doUpdate(prodotto);

            System.out.println("[SUCCESSO] Modifiche salvate con successo. Redirect alla dashboard.");
            response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp");

        } catch (Exception e) {
            System.out.println("[EXCEPTION] Errore durante il salvataggio delle modifiche:");
            e.printStackTrace();

            request.setAttribute("errore", "Errore durante la modifica del prodotto: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/error.jsp").forward(request, response);
        }
    }
}
