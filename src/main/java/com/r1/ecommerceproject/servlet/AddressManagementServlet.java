package com.r1.ecommerceproject.servlet;

import com.r1.ecommerceproject.dao.impl.AddressDaoImpl;
import com.r1.ecommerceproject.model.AddressBean;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;
import java.util.List;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.r1.ecommerceproject.utils.UserSession;

@WebServlet("/address") // Questa è l'annotazione che mappa la servlet all'URL /address
public class AddressManagementServlet extends HttpServlet {

    private AddressDaoImpl addressDAO;

    @Override
    public void init() throws ServletException {
        addressDAO = new AddressDaoImpl();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        /*
        if (request.getSession(false) == null) {
            sendJsonError(response, HttpServletResponse.SC_UNAUTHORIZED, "User not authenticated");
            return;
        }

         */

        UserSession userSession = new UserSession(request.getSession(false));
        if (!userSession.isLoggedIn()) {
            sendJsonError(response, HttpServletResponse.SC_UNAUTHORIZED, "User not authenticated");
            return;
        }
        long userId = userSession.getUserId();

        String action = request.getParameter("action");
        if (action == null || action.isEmpty()) {
            // Azione non specificata, reindirizza a una pagina di errore o alla pagina precedente
            response.sendRedirect(request.getContextPath() + "/error.jsp?msg=Azione non specificata.");
            return;
        }

        try {
            switch (action) {
                case "save": // Azione per aggiungere un nuovo indirizzo
                    saveAddress(request, response, userId);
                    break;
                case "update": // Azione per modificare un indirizzo esistente
                    updateAddress(request, response);
                    break;
                // Le azioni 'delete' e 'setDefault' le ho rimosse per la semplificazione,
                // ma puoi aggiungerle in modo simile se necessario.
                case "setDefault":
                    changeDefaultAddress(request, response, userId);
                    break;


                default:
                    // Azione non valida
                    response.sendRedirect(request.getContextPath() + "/error.jsp?msg=" + URLEncoder.encode("Azione non valida.", StandardCharsets.UTF_8));
                    System.out.println("Azione non valida.");
                    break;
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Logga l'errore per il debug
            // In caso di errore SQL, reindirizza a una pagina di errore
            response.sendRedirect(request.getContextPath() + "/error.jsp?msg=" + URLEncoder.encode("Errore del database durante l'operazione: " + e.getMessage(), StandardCharsets.UTF_8));
        } catch (NumberFormatException e) {
            e.printStackTrace(); // Logga l'errore
            // In caso di ID indirizzo non valido
            response.sendRedirect(request.getContextPath() + "/error.jsp?msg=" + URLEncoder.encode("ID indirizzo non valido.", StandardCharsets.UTF_8));
        } catch (IllegalArgumentException e) {
            e.printStackTrace(); // Logga l'errore
            // In caso di tipo di indirizzo non valido 
            response.sendRedirect(request.getContextPath() + "/error.jsp?msg=" + URLEncoder.encode("Tipo di indirizzo non valido.", StandardCharsets.UTF_8));
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        UserSession userSession = new UserSession(request.getSession(false));
        if (!userSession.isLoggedIn()) {
            sendJsonError(response, HttpServletResponse.SC_UNAUTHORIZED, "User not authenticated");
            return;
        }

        long userId = userSession.getUserId();

        try {
            List<AddressBean> addresses = addressDAO.doRetrieveAddressesByUserId(userId);
            Gson gson = new Gson();
            String jsonAddresses = gson.toJson(addresses);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(jsonAddresses);
        } catch (SQLException e) {
            sendJsonError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        }
    }

    private void sendJsonError(HttpServletResponse response, int status, String message) throws IOException {
        JsonObject error = new JsonObject();
        error.addProperty("error", message);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.setStatus(status);
        response.getWriter().write(error.toString());
    }

    private void saveAddress(HttpServletRequest request, HttpServletResponse response, long userId) throws SQLException, IllegalArgumentException, IOException {
        // Estrai i parametri dal form della JSP
        AddressBean newAddress = new AddressBean();
        newAddress.setVia(request.getParameter("via"));
        newAddress.setCitta(request.getParameter("citta"));
        newAddress.setCap(request.getParameter("cap"));
        // Assicurati che il tipo sia valido
        newAddress.setTipologia(AddressBean.Tipo.valueOf(request.getParameter("tipologia").toUpperCase()));

        // Chiama il DAO per salvare il nuovo indirizzo associandolo all'utente
        addressDAO.doSave(newAddress, userId);
        Gson gson = new Gson();
        String jsonAddress = gson.toJson(newAddress);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(jsonAddress);
    }

    private void updateAddress(HttpServletRequest request, HttpServletResponse response) throws SQLException, IllegalArgumentException, NumberFormatException, IOException {
        // Estrai l'ID dell'indirizzo da modificare
        long addressId = Long.parseLong(request.getParameter("addressId"));
        AddressBean existingAddress = addressDAO.doRetrieveById(addressId);

        if (existingAddress == null) {
            // Se l'indirizzo non è stato trovato, lancia un'eccezione o gestisci l'errore
            // Qui lanciamo un'eccezione che verrà catturata dal blocco try-catch superiore
            throw new SQLException("Indirizzo con ID " + addressId + " non trovato per l'aggiornamento.");
        }

        // Aggiorna i campi dell'indirizzo esistente con i nuovi valori dal form
        existingAddress.setVia(request.getParameter("via"));
        existingAddress.setCitta(request.getParameter("citta"));
        existingAddress.setCap(request.getParameter("cap"));
        existingAddress.setTipologia(AddressBean.Tipo.valueOf(request.getParameter("tipologia").toUpperCase()));

        // Chiama il DAO per aggiornare l'indirizzo nel database
        addressDAO.doUpdate(existingAddress);

        Gson gson = new Gson();
        String jsonAddress = gson.toJson(existingAddress);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(jsonAddress);
    }

    private void changeDefaultAddress(HttpServletRequest request, HttpServletResponse response, long userId) throws SQLException, IllegalArgumentException, NumberFormatException, IOException {
        long addressId = Long.parseLong(request.getParameter("addressId"));

        // Cambia l'indirizzo di default nel db
        addressDAO.changeDefaultAddress(addressId, userId);

        // Restituisce l'indirizzo
        AddressBean address = addressDAO.doRetrieveById(addressId);
        System.out.println("Address: " + address);
        Gson gson = new Gson();
        String jsonAddress = gson.toJson(address);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(jsonAddress);

    }
}