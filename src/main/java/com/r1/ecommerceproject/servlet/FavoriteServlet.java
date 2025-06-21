package com.r1.ecommerceproject.servlet;

import com.r1.ecommerceproject.dao.ProductDaoImpl;
import com.r1.ecommerceproject.utils.UserSession;

import com.r1.ecommerceproject.model.ProductBean;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Collection;

@WebServlet("/favorite")
public class FavoriteServlet extends HttpServlet {
    private ProductDaoImpl favoriteDao;

    @Override
    public void init() throws ServletException {
        favoriteDao = new ProductDaoImpl(); // Assicurati di avere questa DAO
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            // non c’è sessione valida → rimanda al login
            response.setContentType("application/json");
            // set redirect with json
            response.getWriter().write("{\"redirect\": \"login.jsp\"}");
            return;
        }

        UserSession userSession = new UserSession(session);
        long userId = userSession.getUserId();

        try {
            long productId = Long.parseLong(request.getParameter("productId"));        //prendiamo il codice del prodotto che vogliamo inserire
            boolean alreadyInFavorites = favoriteDao.isFavorite(userId, productId);            //controlliamo se il prodotto è nei preferiti

            response.setContentType("application/json");

            if (alreadyInFavorites) {
                favoriteDao.removeFavorite(userId, productId);                       //se il prodotto è  nei preferiti allora vogliamo rimuoverlo
                userSession.removeFavorite(productId);
                response.getWriter().write("{\"success\": true, \"removed\": true}");
            } else {
                favoriteDao.addFavorite(userId, productId);                           //se il prodotto non è nei preferiti , allora vogliamo inserirlo
                userSession.addFavorite(productId);
                response.getWriter().write("{\"success\": true}");

            }
            response.getWriter().flush();

        }catch (SQLException e) {
            response.setContentType("application/json");
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"status\": \"error\", \"message\": \"" + e.getMessage() + "\"}");
        }
    }
}
