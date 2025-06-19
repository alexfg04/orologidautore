package com.r1.ecommerceproject.filter;

import com.r1.ecommerceproject.model.UserBean;

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
            UserBean.Role role = (UserBean.Role) session.getAttribute("userRole");
            if(role == UserBean.Role.ADMIN) {
                // Utente admin, lascia passare
                chain.doFilter(request, response);
                return;
            }
        }

        // Non admin o non loggato -> reindirizza al login o pagina errore
        res.sendRedirect(req.getContextPath() + "/index.jsp");
    }
}
