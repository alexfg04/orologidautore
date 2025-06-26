package com.r1.ecommerceproject.servlet;

import com.r1.ecommerceproject.dao.AddressDaoImpl;
import com.r1.ecommerceproject.model.AddressBean;
import com.r1.ecommerceproject.model.UserBean;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/address") // Questa è l'annotazione che mappa la servlet all'URL /address
public class AddressManagementServlet extends HttpServlet {

    private AddressDaoImpl addressDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        addressDAO = new AddressDaoImpl();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            // Se l'utente non è autenticato, reindirizza alla pagina di login
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        UserBean currentUser = (UserBean) session.getAttribute("currentUser");
        long userId = currentUser.getId();

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
                default:
                    // Azione non valida
                    response.sendRedirect(request.getContextPath() + "/error.jsp?msg=Azione non valida.");
                    break;
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Logga l'errore per il debug
            // In caso di errore SQL, reindirizza a una pagina di errore
            response.sendRedirect(request.getContextPath() + "/error.jsp?msg=Errore del database durante l'operazione: " + e.getMessage());
        } catch (NumberFormatException e) {
            e.printStackTrace(); // Logga l'errore
            // In caso di ID indirizzo non valido
            response.sendRedirect(request.getContextPath() + "/error.jsp?msg=ID indirizzo non valido.");
        } catch (IllegalArgumentException e) {
            e.printStackTrace(); // Logga l'errore
            // In caso di tipo di indirizzo non valido
            response.sendRedirect(request.getContextPath() + "/error.jsp?msg=Tipo di indirizzo non valido.");
        }

        // Dopo aver completato l'operazione (o in caso di successo), reindirizza alla pagina di riepilogo ordine
        response.sendRedirect(request.getContextPath() + "/checkout");
    }

    private void saveAddress(HttpServletRequest request, HttpServletResponse response, long userId) throws SQLException, IllegalArgumentException {
        // Estrai i parametri dal form della JSP
        AddressBean newAddress = new AddressBean();
        newAddress.setVia(request.getParameter("via"));
        newAddress.setCitta(request.getParameter("citta"));
        newAddress.setCAP(request.getParameter("cap"));
        // Assicurati che il tipo sia valido
        newAddress.setTipologia(AddressBean.Tipo.valueOf(request.getParameter("tipologia").toUpperCase()));

        // Chiama il DAO per salvare il nuovo indirizzo associandolo all'utente
        addressDAO.doSave(newAddress, userId);
        // Nessuna risposta JSON, si affida al reindirizzamento finale
    }

    private void updateAddress(HttpServletRequest request, HttpServletResponse response) throws SQLException, IllegalArgumentException, NumberFormatException {
        // Estrai l'ID dell'indirizzo da modificare
        long addressId = Long.parseLong(request.getParameter("addressId"));
        AddressBean existingAddress = addressDAO.doRetrieveAddressById(addressId);

        if (existingAddress == null) {
            // Se l'indirizzo non è stato trovato, lancia un'eccezione o gestisci l'errore
            // Qui lanciamo un'eccezione che verrà catturata dal blocco try-catch superiore
            throw new SQLException("Indirizzo con ID " + addressId + " non trovato per l'aggiornamento.");
        }

        // Aggiorna i campi dell'indirizzo esistente con i nuovi valori dal form
        existingAddress.setVia(request.getParameter("via"));
        existingAddress.setCitta(request.getParameter("citta"));
        existingAddress.setCAP(request.getParameter("cap"));
        existingAddress.setTipologia(AddressBean.Tipo.valueOf(request.getParameter("tipologia").toUpperCase()));

        // Chiama il DAO per aggiornare l'indirizzo nel database
        addressDAO.doUpdate(existingAddress);
        // Nessuna risposta JSON, si affida al reindirizzamento finale
    }
}