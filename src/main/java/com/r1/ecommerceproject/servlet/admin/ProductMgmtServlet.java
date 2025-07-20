package com.r1.ecommerceproject.servlet.admin;

import com.r1.ecommerceproject.model.impl.ProductDaoImpl;
import com.r1.ecommerceproject.model.ProductBean;
import com.r1.ecommerceproject.model.ProductDao;

import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

/**
 * Servlet implementation class ProductMgmtServlet
 */
@WebServlet("/admin/add-product")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50)
// 50MB
public class ProductMgmtServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    static String SAVE_DIR = "/assets/img/products";
    static ProductDao model = new ProductDaoImpl();

    public ProductMgmtServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        try {
            if (action != null) {
                if (action.equalsIgnoreCase("delete")) {
                    Long id = Long.parseLong(request.getParameter("product_id"));
                    model.doDelete(id);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error:" + e.getMessage());
        }

        // Non più forward, ma redirect con ancoraggio alla tabella
        response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp#tableProdotti");
    }


    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String appPath = request.getServletContext().getRealPath("/");
        String contextPath = request.getContextPath();
        String urlPath = contextPath + SAVE_DIR;
        String savePath = appPath + SAVE_DIR;

        File fileSaveDir = new File(savePath);
        if (!fileSaveDir.exists()) {
            fileSaveDir.mkdirs();
        }

        Part filePart = request.getPart("image");
        String fileName = extractFileName(filePart);

        if(!fileName.isEmpty()) {
            String ext = fileName.substring(fileName.lastIndexOf(".")).toLowerCase();
            String newFileName = UUID.randomUUID() + ext;
            filePart.write( savePath + File.separator + newFileName);

            try {
                String materiale = request.getParameter("materiale");
                String categoria = request.getParameter("categoria");
                String taglia = request.getParameter("taglia");
                String marca = request.getParameter("marca");
                BigDecimal prezzo = new BigDecimal(request.getParameter("prezzo"));
                String modello = request.getParameter("modello");
                String tipo = request.getParameter("tipo");
                String descrizione = request.getParameter("descrizione");
                String nome = request.getParameter("nome");
                BigDecimal iva = new BigDecimal(request.getParameter("iva"));

                ProductBean bean = new ProductBean();
                bean.setMateriale(materiale);
                bean.setGenere(categoria);
                bean.setTaglia(taglia);
                bean.setMarca(marca);
                bean.setIvaPercentuale(iva);
                bean.setPrezzo(prezzo);
                bean.setModello(modello);
                bean.setTipo(tipo);
                bean.setDescrizione(descrizione);
                bean.setNome(nome);
                String imagePath = urlPath + "/" + newFileName;
                bean.setImmagine(imagePath);
                model.doSave(bean);
                request.setAttribute("message", "Prodotto inserito con successo");

            } catch (SQLException e) {
                System.out.println("Error:" + e.getMessage());
                request.setAttribute("message", "Errore durante l'inserimento");
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp#tableProdotti");

    }

    private String extractFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] items = contentDisp.split(";");
        for (String s : items) {
            if (s.trim().startsWith("filename")) {
                return s.substring(s.indexOf("=") + 2, s.length() - 1);
            }
        }
        return "";
    }
}
