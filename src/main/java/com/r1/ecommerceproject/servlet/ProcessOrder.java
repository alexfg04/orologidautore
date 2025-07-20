package com.r1.ecommerceproject.servlet;

import com.paypal.orders.*;
import com.r1.ecommerceproject.model.OrderDao;
import com.r1.ecommerceproject.model.impl.OrderDaoImpl;
import com.r1.ecommerceproject.model.impl.ProductDaoImpl;
import com.r1.ecommerceproject.model.OrderBean;
import com.r1.ecommerceproject.model.ProductBean;
import com.r1.ecommerceproject.utils.PayPalClient;
import com.r1.ecommerceproject.utils.UserSession;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.Collections;
import java.util.HashMap;

@WebServlet("/processOrder")
public class ProcessOrder extends HttpServlet {
    private final OrderDao orderDao = new OrderDaoImpl();
    private final ProductDaoImpl productDao = new ProductDaoImpl();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        BigDecimal total = new BigDecimal(req.getParameter("total"));
        long addressId = Long.parseLong(req.getParameter("addressId"));
        String note = req.getParameter("note");
        long orderId;

        try {
            UserSession userSession = new UserSession(req.getSession(false));
            /* Creazione Ordine */
            OrderBean orderBean = new OrderBean();
            orderBean.setTotale(total);
            orderBean.setNote(note);
            // Salva ordine nel db e restituisce l'id dell'ordine
            orderId = orderDao.doSave(orderBean, addressId, userSession.getUserId());

            // Salva tutti i prodotti del carrello nel db relativo all'ordine
            HashMap<ProductBean, Integer> products = productDao.doGetCartAsProducts(userSession.getCart());
            for( ProductBean product : products.keySet() ) {
                int quantity = products.get(product);
                orderDao.doSaveOrderProduct(orderId, product, quantity);
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }

        // Creazione richiesta di pagamento con PayPal
        OrderRequest orderRequest = new OrderRequest();
        orderRequest.checkoutPaymentIntent("CAPTURE");

        // Imposta il valore e la valuta
        AmountWithBreakdown amount = new AmountWithBreakdown()
                .currencyCode("EUR")
                .value(total.toPlainString());

        PurchaseUnitRequest purchaseUnit = new PurchaseUnitRequest()
                .amountWithBreakdown(amount);
        orderRequest.purchaseUnits(Collections.singletonList(purchaseUnit));

        // Configura i link di redirect
        String baseUrl = req.getScheme()
                + "://"
                + req.getServerName()
                + ":"
                + req.getServerPort()
                + req.getContextPath();

        ApplicationContext applicationContext = new ApplicationContext()
                .returnUrl(baseUrl + "/payment?orderId=" + orderId)
                .cancelUrl(baseUrl + "/cancel?orderId=" + orderId);
        orderRequest.applicationContext(applicationContext);

        OrdersCreateRequest request = new OrdersCreateRequest()
                .requestBody(orderRequest);

        try {
            Order order = PayPalClient.client.execute(request).result();
            // Prendi l’URL di approvazione e reindirizza l’utente
            String approveUrl = order.links().stream()
                    .filter(link -> "approve".equals(link.rel()))
                    .findFirst()
                    .orElseThrow(() -> new ServletException("No approval link"))
                    .href();
            resp.sendRedirect(approveUrl);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
