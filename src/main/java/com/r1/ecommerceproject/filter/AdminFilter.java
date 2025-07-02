/*package com.r1.ecommerceproject.filter;

import com.r1.ecommerceproject.model.UserBean;
import com.r1.ecommerceproject.utils.UserSession;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/admin/*")
public class AdminFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);
        if(session != null) {
            UserSession userSession = new UserSession(session);
            if(userSession.isLoggedIn() && userSession.isAdmin()) {
                // Utente admin, lascia passare
                chain.doFilter(request, response);
                return;
            }
        }

        // Non admin o non loggato -> reindirizza al login o pagina errore
        res.sendRedirect(req.getContextPath() + "/index.jsp");
    }
}
*/