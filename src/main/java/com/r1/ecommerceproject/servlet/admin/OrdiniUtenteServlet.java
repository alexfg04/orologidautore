
package  com.r1.ecommerceproject.servlet.admin;
import com.r1.ecommerceproject.model.OrderDao;
import com.r1.ecommerceproject.model.impl.OrderDaoImpl;
import com.r1.ecommerceproject.model.OrderBean;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin/ordiniUtente")
public class OrdiniUtenteServlet extends HttpServlet {

    private final OrderDao orderDao = new OrderDaoImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idUtenteParam = request.getParameter("idUtente");
        if (idUtenteParam == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID utente mancante");
            return;
        }

        try {
            int idUtente = Integer.parseInt(idUtenteParam);
            List<OrderBean> ordini = orderDao.getOrdiniByUtenteId(idUtente);
            request.setAttribute("ordini", ordini);
            request.setAttribute("idUtente", idUtente);
            request.getRequestDispatcher("/WEB-INF/views/admin/ordiniUtente.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID utente non valido");
        } catch (SQLException e) {
            e.printStackTrace(); // per debug in console
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Errore durante il recupero degli ordini");
        }
    }
}
