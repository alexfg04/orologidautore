package com.r1.ecommerceproject.model;

import java.sql.Time;
import java.sql.Timestamp;
import java.time.LocalDate;

public class OrderBean {
    private String id;
    private String note;
    private Timestamp dataOrdine;
    private Timestamp dataArrivo;
    private double totale;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

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

    public double getTotale() {
        return totale;
    }

    public void setTotale(double totale) {
        this.totale = totale;
    }
}
