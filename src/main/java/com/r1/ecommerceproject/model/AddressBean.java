package com.r1.ecommerceproject.model;

public class AddressBean {

    public enum Tipo {FATTURAZIONE, SPEDIZIONE, ENTRAMBI};

    private long id;
    private String via;
    private String citta;
    private String cap;
    private Tipo tipologia;
    private boolean isDefault = false;

    public boolean isDefault() {
        return isDefault;
    }

    public void setDefault(boolean aDefault) {
        isDefault = aDefault;
    }

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

    public void setCap(String cAP) {
        cap = cAP;
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

    public String getCap() {
        return cap;
    }

    public Tipo getTipologia() {
        return tipologia;
    }

    @Override
    public String toString() {
        return "IndirizzoBean [Id_indirizzo=" + id + ", via=" + via + ", citta=" + citta + ", CAP=" + cap
                + ", tipologia=" + tipologia + "]";
    }
}