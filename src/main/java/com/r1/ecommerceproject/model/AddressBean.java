package com.r1.ecommerceproject.model;

public class AddressBean {

    public enum Tipo {FATTURAZIONE, SPEDIZIONE, ENTRAMBI};

    private long id;
    private String via;
    private String citta;
    private String CAP;
    private Tipo tipologia;


    public long getId() {
        return id;
    }

    public void setId(long Id) {
        this.id = Id;
    }

    public void setVia(String via) {
        this.via = via;
    }

    public void setCitta(String citta) {
        this.citta = citta;
    }

    public void setCAP(String cAP) {
        CAP = cAP;
    }

    public void setTipologia(Tipo tipologia) {
        this.tipologia = tipologia;
    }

    public String getVia() {
        return via;
    }

    public String getCitta() {
        return citta;
    }

    public String getCAP() {
        return CAP;
    }

    public Tipo getTipologia() {
        return tipologia;
    }

    @Override
    public String toString() {
        return "IndirizzoBean [Id_indirizzo=" + id + ", via=" + via + ", citta=" + citta + ", CAP=" + CAP
                + ", tipologia=" + tipologia + "]";
    }
}