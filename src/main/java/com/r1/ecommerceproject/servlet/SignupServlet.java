package com.r1.ecommerceproject.servlet;

import com.r1.ecommerceproject.dao.UserDao;
import com.r1.ecommerceproject.dao.impl.UserDaoImpl;
import com.r1.ecommerceproject.model.UserBean;
import com.r1.ecommerceproject.utils.Security;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.Optional;


@WebServlet("/signup")
public class SignupServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final UserDao userDao = new UserDaoImpl();

    public SignupServlet() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String name = request.getParameter("name");
        String surname = request.getParameter("surname");
        String birthdateStr = request.getParameter("birthDate");

        Optional<String> hashedPassword = Security.hashPassword(password);

        boolean hasEmptyFields = email == null || email.trim().isEmpty() ||
                hashedPassword.isEmpty() ||
                name == null || name.trim().isEmpty() ||
                surname == null || surname.trim().isEmpty() ||
                birthdateStr == null || birthdateStr.trim().isEmpty();

        if (hasEmptyFields && !Security.validateEmail(email)) {
            request.setAttribute("errorMessage", "I campi vuoti o non validi");
            request.setAttribute("rp", true);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        LocalDate birthdate = LocalDate.parse(birthdateStr);

        try {
            if (userDao.userExist(email)) {
                request.getSession().setAttribute("flashMessage", "Sei già registrato, effettua il login."); //controlliamo se l'utente è già registrato
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }
        } catch (SQLException e) {                                                          //generiamo l'eccezione nel caso si verifichi un eccezione del tipo SQLExcetion
            throw new ServletException("Errore interno riprova più tardi", e);       //se si verifica l'eccezione la convertiamo in un eccezione del tipo ServletException
        }

        //creiamo un oggetto di tipo userBean
        UserBean user = new UserBean();

        //settiamo gli attributi relativi all'utente nell'oggetto "user"
        user.setEmail(email);
        user.setPassword(hashedPassword.get());
        user.setNome(name);
        user.setCognome(surname);
        user.setDataDiNascita(birthdate);
        user.setTipologia(UserBean.Role.UTENTE);
        try {
           /* if (userDao.doSave(user)) {
                request.getSession().setAttribute("flashMessage", "Registrazione avvenuta con successo.");
                response.sendRedirect(request.getContextPath() + "/login.jsp");
            }*/
            if (userDao.doSave(user)) {
                // Verifica che l'ID sia stato assegnato dopo il salvataggio
                long userId = user.getId();
                if (userId <= 0) {
                    throw new ServletException("Registrazione fallita: ID utente non valorizzato.");
                }

                request.getSession().setAttribute("flashMessage", "Registrazione avvenuta con successo.");
                response.sendRedirect(request.getContextPath() + "/login");
            }

        } catch (SQLException e) {
            throw new ServletException("Errore interno riprova più tardi", e);
        }
    }
}

