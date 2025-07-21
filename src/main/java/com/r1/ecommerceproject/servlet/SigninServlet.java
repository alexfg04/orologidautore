package com.r1.ecommerceproject.servlet;

import com.r1.ecommerceproject.model.UserDao;
import com.r1.ecommerceproject.model.impl.UserDaoImpl;
import com.r1.ecommerceproject.model.UserBean;
import com.r1.ecommerceproject.utils.Security;
import com.r1.ecommerceproject.utils.UserSession;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/signin")
public class SigninServlet extends HttpServlet {
    private final UserDao model = new UserDaoImpl();

    public SigninServlet() {
        super();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        UserBean user;
        UserSession userSession = new UserSession(request.getSession());

        // Se l'utente è già loggato, lo mandiamo alla pagina corretta
        if (userSession.isLoggedIn()) {
            // Potremmo recuperare il ruolo dalla sessione, ma qui semplifichiamo
            response.sendRedirect(request.getContextPath() + "/catalog");
            return;
        }

        try {
            user = model.doRetrieveByEmail(email);
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Errore interno: " + e.getMessage());
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        if (user == null || !Security.verifyPassword(password, user.getPassword())) {
            request.setAttribute("errorMessage", "Email o password non validi");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        // Imposta la sessione utente
        userSession.setUser(user.getId());
        userSession.setFirstName(user.getNome());
        userSession.setLastName(user.getCognome());
        userSession.setEmail(user.getEmail());
        userSession.putAllFavoritesToSession();

        if(user.getTipologia() == UserBean.Role.ADMIN) {
            userSession.setAdmin(true);
        }

        // ✅ Redirezione in base alla tipologia
        if (user.getTipologia() == UserBean.Role.ADMIN) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp");
        } else {
            response.sendRedirect(request.getContextPath() + "/catalog");
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Puoi reindirizzare o mostrare un messaggio
        resp.sendRedirect(req.getContextPath() + "/login.jsp");
    }

}
