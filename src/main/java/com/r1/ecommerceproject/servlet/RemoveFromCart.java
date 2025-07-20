package com.r1.ecommerceproject.servlet;

import com.r1.ecommerceproject.utils.UserSession;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/removeFromCart")
public class RemoveFromCart extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Long id = Long.parseLong(request.getParameter("productId"));
        UserSession userSession = new UserSession(request.getSession());
        userSession.removeProductFromCart(id);

        int cartSize = userSession.getCart().size();

        Gson gson = new Gson();
        JsonObject json = new JsonObject();
        json.addProperty("success", true);
        json.addProperty("itemCount", cartSize);
        json.addProperty("totaleNetto", userSession.getCartTotaleNetto());
        json.addProperty("totaleLordo", userSession.getCartTotaleLordo());
        json.addProperty("iva", userSession.getCartTotaleNetto().multiply(new java.math.BigDecimal("0.22")));

        response.setContentType("application/json");
        response.getWriter().write(gson.toJson(json));
        response.getWriter().flush();
    }
}
