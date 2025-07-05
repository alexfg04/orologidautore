package com.r1.ecommerceproject.model;

import java.math.BigDecimal;
import java.sql.Time;
import java.sql.Timestamp;
import java.time.LocalDate;

public class OrderBean {

    private String numeroOrdine;
    private String note;
    private Timestamp dataOrdine;
    private Timestamp dataArrivo;
    private BigDecimal totale;


    public String getNumeroOrdine() { return numeroOrdine; }

    public void setNumeroOrdine(String numeroOrdine) { this.numeroOrdine = numeroOrdine; }


    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public Timestamp getDataOrdine() {
        return dataOrdine;
    }

    public void setDataOrdine(Timestamp dataOrdine) {
        this.dataOrdine = dataOrdine;
    }

    public Timestamp getDataArrivo() {
        return dataArrivo;
    }

    public void setDataArrivo(Timestamp dataArrivo) {
        this.dataArrivo = dataArrivo;
    }

    public BigDecimal getTotale() {
        return totale;
    }

    public void setTotale(BigDecimal totale) {
        this.totale = totale;
    }


}
