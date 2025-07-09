package com.r1.ecommerceproject.servlet;

import com.itextpdf.io.font.constants.StandardFonts;
import com.itextpdf.kernel.colors.DeviceGray;
import com.itextpdf.kernel.colors.ColorConstants;
import com.itextpdf.kernel.font.PdfFont;
import com.itextpdf.kernel.font.PdfFontFactory;
import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.layout.Document;
import com.itextpdf.layout.borders.Border;
import com.itextpdf.layout.borders.SolidBorder;
import com.itextpdf.layout.element.Cell;
import com.itextpdf.layout.element.Paragraph;
import com.itextpdf.layout.element.Table;
import com.itextpdf.layout.properties.HorizontalAlignment;
import com.itextpdf.layout.properties.TextAlignment;
import com.itextpdf.layout.properties.UnitValue;
import com.r1.ecommerceproject.dao.OrderDao;
import com.r1.ecommerceproject.dao.UserDao;
import com.r1.ecommerceproject.dao.impl.OrderDaoImpl;
import com.r1.ecommerceproject.dao.impl.UserDaoImpl;
import com.r1.ecommerceproject.model.AddressBean;
import com.r1.ecommerceproject.model.OrderBean;
import com.r1.ecommerceproject.model.ProductBean;
import com.r1.ecommerceproject.model.UserBean;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;

@WebServlet("/receipt")
public class ReceiptServlet extends HttpServlet {
    private final OrderDao orderDao = new OrderDaoImpl();
    private final UserDao userDao   = new UserDaoImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String orderNumber = req.getParameter("orderNumber");
        if (orderNumber == null || orderNumber.isBlank()) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing orderNumber");
            return;
        }

        try {
            // Recupera ordine completo
            OrderBean order = orderDao.doRetrieveById(orderNumber);
            UserBean cliente = userDao.doRetrieveById(order.getUserId());
            order.setCliente(cliente);
            AddressBean addr = orderDao.doRetrieveAddress(orderNumber);
            order.setIndirizzo(addr);
            var prodotti = orderDao.doRetrieveAllProductsInOrder(orderNumber);
            order.setProdotti(prodotti);

            // Imposta risposta PDF
            resp.setContentType("application/pdf");
            resp.setHeader("Content-Disposition",
                    "inline; filename=fattura-" + orderNumber + ".pdf");

            PdfWriter writer = new PdfWriter(resp.getOutputStream());
            PdfDocument pdf   = new PdfDocument(writer);
            Document document = new Document(pdf);

            PdfFont bold    = PdfFontFactory.createFont(StandardFonts.HELVETICA_BOLD);
            PdfFont regular = PdfFontFactory.createFont(StandardFonts.HELVETICA);

            // --- INTESTAZIONE AZIENDA ---
            Table header = new Table(UnitValue.createPercentArray(2)).useAllAvailableWidth();
            header.addCell(new Cell().setBorder(Border.NO_BORDER)
                    .add(new Paragraph("Tech Solutions S.r.l.").setFont(bold).setFontSize(14))
                    .add(new Paragraph("Via delle Innovazioni, 123"))
                    .add(new Paragraph("20100 Milano (MI) – Italia"))
                    .add(new Paragraph("P.IVA: 12345678901"))
            );
            Table invInfo = new Table(UnitValue.createPercentArray(2)).useAllAvailableWidth();
            invInfo.addCell(new Cell().setBorder(Border.NO_BORDER)
                    .add(new Paragraph("FATTURA N°").setFont(bold)));
            invInfo.addCell(new Cell().setBorder(Border.NO_BORDER)
                    .add(new Paragraph(order.getNumeroOrdine())));
            invInfo.addCell(new Cell().setBorder(Border.NO_BORDER)
                    .add(new Paragraph("Data:").setFont(bold)));
            invInfo.addCell(new Cell().setBorder(Border.NO_BORDER)
                    .add(new Paragraph(order.getDataOrdine()
                            .toLocalDateTime().toLocalDate().toString())));
            header.addCell(new Cell().setBorder(Border.NO_BORDER).add(invInfo));
            document.add(header);
            document.add(new Paragraph("\n"));

            // --- DATI CLIENTE ---
            Table client = new Table(UnitValue.createPercentArray(2)).useAllAvailableWidth();
            client.addCell(new Cell().setBorder(Border.NO_BORDER)
                    .add(new Paragraph("Cliente:").setFont(bold)));
            StringBuilder sb = new StringBuilder()
                    .append(cliente.getNome()).append(" ").append(cliente.getCognome());
            if (addr != null) {
                sb.append("\n").append(addr.getVia())
                        .append("\n").append(addr.getCap()).append(" ").append(addr.getCitta());
            }
            client.addCell(new Cell().setBorder(Border.NO_BORDER)
                    .add(new Paragraph(sb.toString())));
            document.add(client);
            document.add(new Paragraph("\n"));

            // --- TABELLA PRODOTTI ---
            Table table = new Table(UnitValue.createPercentArray(new float[]{4,1,1,1,1,1}))
                    .useAllAvailableWidth()
                    .setMarginTop(5);
            String[] hdr = {
                    "Descrizione",
                    "Prezzo netto (€)",
                    "Qtà",
                    "IVA %",
                    "Subtot. netto (€)",
                    "Tot. lordo (€)"
            };
            for (String h : hdr) {
                table.addHeaderCell(new Cell()
                        .add(new Paragraph(h).setFont(bold).setFontSize(10))
                        .setBackgroundColor(new DeviceGray(0.75f))
                        .setTextAlignment(TextAlignment.CENTER));
            }

            BigDecimal imponibile = BigDecimal.ZERO;
            BigDecimal totaleIva  = BigDecimal.ZERO;
            for (ProductBean p : order.getProdotti()) {
                BigDecimal netto    = p.getPrezzoNetto();
                BigDecimal subNetto = p.getSubtotaleNetto();
                BigDecimal ivaVal   = p.getIvaValore();
                BigDecimal subLordo = p.getTotaleLordo();

                imponibile = imponibile.add(subNetto);
                totaleIva  = totaleIva.add(ivaVal);

                table.addCell(new Cell().add(new Paragraph(p.getNome())).setFont(regular));
                table.addCell(new Cell().add(new Paragraph(netto.toString()))
                        .setTextAlignment(TextAlignment.RIGHT));
                table.addCell(new Cell().add(new Paragraph(String.valueOf(p.getQuantity())))
                        .setTextAlignment(TextAlignment.CENTER));
                table.addCell(new Cell().add(new Paragraph(
                                p.getIvaPercentuale().setScale(2, RoundingMode.HALF_UP).toString()))
                        .setTextAlignment(TextAlignment.CENTER));
                table.addCell(new Cell().add(new Paragraph(subNetto.toString()))
                        .setTextAlignment(TextAlignment.RIGHT));
                table.addCell(new Cell().add(new Paragraph(subLordo.toString()))
                        .setTextAlignment(TextAlignment.RIGHT));
            }
            document.add(table);
            document.add(new Paragraph("\n"));

            // --- RIEPILOGO ---
            BigDecimal totaleFattura = imponibile.add(totaleIva)
                    .setScale(2, RoundingMode.HALF_UP);

            Table sum = new Table(UnitValue.createPercentArray(new float[]{3,1}))
                    .useAllAvailableWidth()
                    .setHorizontalAlignment(HorizontalAlignment.RIGHT);

            sum.addCell(new Cell().setBorder(Border.NO_BORDER)
                    .add(new Paragraph("Tot. imponibile (netto):").setFont(bold))
                    .setTextAlignment(TextAlignment.RIGHT));
            sum.addCell(new Cell().setBorder(Border.NO_BORDER)
                    .add(new Paragraph(imponibile.setScale(2, RoundingMode.HALF_UP).toString()))
                    .setTextAlignment(TextAlignment.RIGHT));

            sum.addCell(new Cell().setBorder(Border.NO_BORDER)
                    .add(new Paragraph("Tot. IVA:").setFont(bold))
                    .setTextAlignment(TextAlignment.RIGHT));
            sum.addCell(new Cell().setBorder(Border.NO_BORDER)
                    .add(new Paragraph(totaleIva.setScale(2, RoundingMode.HALF_UP).toString()))
                    .setTextAlignment(TextAlignment.RIGHT));

            sum.addCell(new Cell().setBorderTop(new SolidBorder(ColorConstants.BLACK, 1))
                    .add(new Paragraph("Totale fattura (lordo):").setFont(bold))
                    .setTextAlignment(TextAlignment.RIGHT));
            sum.addCell(new Cell().setBorderTop(new SolidBorder(ColorConstants.BLACK, 1))
                    .add(new Paragraph(totaleFattura.toString()))
                    .setTextAlignment(TextAlignment.RIGHT));

            document.add(sum);
            document.close();
        } catch (Exception e) {
            throw new ServletException("Errore generazione PDF", e);
        }
    }
}
