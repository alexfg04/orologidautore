package com.r1.ecommerceproject.servlet;

import com.r1.ecommerceproject.dao.UserDao;
import com.r1.ecommerceproject.dao.UserDaoImpl;
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

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        Optional<String> hashedPassword = Security.hashPassword(password);

        //controlliamo se l'email e la password non sono stringhe vuote o null
        if(email == null || email.trim().isEmpty()
                || hashedPassword.isEmpty()){

            request.setAttribute("errorMessage","I campi non possono essere vuoti");
            request.getRequestDispatcher("/registrazione.jsp").forward(request, response);
            return;
        }

        try{
            if(userDao.userExist(email)){             //controlliamo se l'utente è già registrato
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }else{
                request.setAttribute("errorMessage", "Questa combinazione di email e password è già utilizzata");
            }
        }catch(SQLException e){                                                          //generiamo l'eccezione nel caso si verifichi un èeccezione del tipo SQLExcetion
            throw new ServletException("Errore interno riprova più tardi", e);        //se si verifica l'eccezione la convertiamo in un eccezione del tipo ServletException
        }

        UserBean user = new UserBean();               //creiamo un oggetto di tipo userBean

        String nome = request.getParameter("nome");                                   //prendiamo il valore inserito nel campo "nome" del form
        String cognome = request.getParameter("cognome");                            //prendiamo il valore inserito nel campo "cognome" del form
        LocalDate data_nascita = LocalDate.parse(request.getParameter("data_di_nascita"));   //prendiamo il valore inserito nel campo "data di nascita nel form"

        user.setEmail(email);                                                                      //settiamo gli attributi relativi all'utente nell'oggetto "user"
        user.setPassword(hashedPassword.get());
        user.setNome(nome);
        user.setCognome(cognome);
        user.setDataDiNascita(data_nascita);
        user.setTipologia(UserBean.Role.UTENTE);
        try{
            if(userDao.doSave(user)){
                request.getRequestDispatcher("/login").forward(request, response);
            }

        }catch(SQLException e){
            throw new ServletException("Errore interno riprova più tardi", e);
        }
    }
}
