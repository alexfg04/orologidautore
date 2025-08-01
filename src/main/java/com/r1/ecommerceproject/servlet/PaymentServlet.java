package com.r1.ecommerceproject.servlet;

import com.paypal.orders.Order;
import com.paypal.orders.OrderRequest;
import com.paypal.orders.OrdersCaptureRequest;
import com.r1.ecommerceproject.model.OrderDao;
import com.r1.ecommerceproject.model.impl.OrderDaoImpl;
import com.r1.ecommerceproject.model.PaymentBean;
import com.r1.ecommerceproject.utils.PayPalClient;
import com.r1.ecommerceproject.utils.UserSession;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/payment")
public class PaymentServlet extends HttpServlet {
    private final OrderDao orderDao = new OrderDaoImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String token = req.getParameter("token"); // order ID
        if (token == null) {
            resp.getWriter().println("Pagamento cancellato o errore.");
            return;
        }
        long orderId = Long.parseLong(req.getParameter("orderId"));

        OrdersCaptureRequest request = new OrdersCaptureRequest(token);
        request.requestBody(new OrderRequest());

        try {
            Order order = PayPalClient.client.execute(request).result();

            // Se il pagamento è andato a buon fine
            if ("COMPLETED".equals(order.status())) {
                // Ottiene il totale pagato e il tipo di moneta dal pagamento
                String amount = order
                        .purchaseUnits().get(0)
                        .payments().captures().get(0)
                        .amount().value();

                String currency = order
                        .purchaseUnits().get(0)
                        .payments().captures().get(0)
                        .amount().currencyCode();

                // Salva dati del pagamento
                PaymentBean payment = new PaymentBean();
                payment.setAmount(new BigDecimal(amount));
                payment.setCurrency(currency);
                payment.setEmailPayer(order.payer().email());
                payment.setToken(token);
                orderDao.savePayment(payment, orderId);

                // svuota il carrello
                UserSession userSession = new UserSession(req.getSession(false));
                userSession.clearCart();

                String orderNumber = orderDao.getOrderNumber(orderId);
                req.setAttribute("orderNumber", orderNumber);
                req.setAttribute("amount", amount);
                req.getRequestDispatcher("/checkout_success.jsp").forward(req, resp);

            } else {
                resp.sendRedirect(req.getContextPath() + "checkout_failure.jsp");
            }

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}

