package com.r1.ecommerceproject;

import com.r1.ecommerceproject.utils.DataSourceConnectionPool;
import org.w3c.dom.stylesheets.LinkStyle;

import java.io.*;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.http.*;
import javax.servlet.annotation.*;

@WebServlet(name = "testServlet", value = "/test-servlet")
public class TestServlet extends HttpServlet {

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // Test the connection to the DataSource
        try (Connection conn = DataSourceConnectionPool.getConnection()) {
            response.getWriter().println("✅ Connessione al DataSource riuscita!");
        } catch (Exception e) {
            response.getWriter().println("❌ Errore nella connessione al DataSource:");
            e.printStackTrace(response.getWriter());
        }
    }
}