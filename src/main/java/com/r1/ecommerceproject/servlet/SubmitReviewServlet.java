package com.r1.ecommerceproject.servlet;

import com.r1.ecommerceproject.dao.ReviewDao;
import com.r1.ecommerceproject.dao.UserDao;
import com.r1.ecommerceproject.dao.impl.ReviewDaoImpl;
import com.r1.ecommerceproject.dao.impl.UserDaoImpl;
import com.r1.ecommerceproject.model.ReviewBean;
import com.r1.ecommerceproject.model.UserBean;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDateTime;

@WebServlet("/submitReview")
public class SubmitReviewServlet extends HttpServlet {

    private final ReviewDao reviewDao = new ReviewDaoImpl();
    private final UserDao userDao = new UserDaoImpl();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Long userId = (Long) session.getAttribute("userId");

        UserBean user;
        try {
            user = userDao.doRetrieveById(userId);
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Errore interno server");
            return;
        }

        String autoreEmail = user.getEmail();
        String commento = request.getParameter("commento");
        String valutazioneStr = request.getParameter("valutazione");
        String codiceProdottoStr = request.getParameter("codiceProdotto");
        System.out.println("valutazioneStr: " + valutazioneStr);
        System.out.println("codiceProdottoStr: " + codiceProdottoStr);
        System.out.println("autoreEmail: " + autoreEmail);
        int valutazione;
        long codiceProdotto;

        try {
            valutazione = Integer.parseInt(valutazioneStr);
            codiceProdotto = Long.parseLong(codiceProdottoStr);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Valutazione o codice prodotto non validi");
            return;
        }

        ReviewBean review = new ReviewBean();
        review.setAutore(autoreEmail);
        review.setCommento(commento);
        review.setValutazione(valutazione);
        review.setCodiceProdotto(codiceProdotto);
        review.setCreatedAt(LocalDateTime.now());

        try {
            boolean saved = reviewDao.insertReview(review);
            if (saved) {
                response.sendRedirect(request.getContextPath() + "/productDetail?codiceProdotto=" + codiceProdotto);
            } else {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Errore nel salvataggio recensione");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Errore SQL: " + e.getMessage());
        }
    }

}
