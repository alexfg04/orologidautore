package com.r1.ecommerceproject.model;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.Collection;

public class OrderBean {

    private String numeroOrdine;
    private String note;
    private Timestamp dataOrdine;
    private Timestamp dataArrivo;
    private BigDecimal totale;

    // nuovi campi
    private long userId;
    private UserBean cliente;
    private AddressBean indirizzo;
    private Collection<ProductBean> prodotti;

    // getter/setter esistenti...
    public String getNumeroOrdine() { return numeroOrdine; }
    public void setNumeroOrdine(String numeroOrdine) { this.numeroOrdine = numeroOrdine; }
    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }
    public Timestamp getDataOrdine() { return dataOrdine; }
    public void setDataOrdine(Timestamp dataOrdine) { this.dataOrdine = dataOrdine; }
    public Timestamp getDataArrivo() { return dataArrivo; }
    public void setDataArrivo(Timestamp dataArrivo) { this.dataArrivo = dataArrivo; }
    public BigDecimal getTotale() { return totale; }
    public void setTotale(BigDecimal totale) { this.totale = totale; }

    // nuovi getter/setter
    public long getUserId() { return userId; }
    public void setUserId(long userId) { this.userId = userId; }

    public UserBean getCliente() { return cliente; }
    public void setCliente(UserBean cliente) { this.cliente = cliente; }

    public AddressBean getIndirizzo() { return indirizzo; }
    public void setIndirizzo(AddressBean indirizzo) { this.indirizzo = indirizzo; }

    public Collection<ProductBean> getProdotti() { return prodotti; }
    public void setProdotti(Collection<ProductBean> prodotti) { this.prodotti = prodotti; }
}