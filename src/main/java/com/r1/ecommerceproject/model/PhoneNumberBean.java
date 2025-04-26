package com.r1.ecommerceproject.model;

public class PhoneNumberBean {

    private long id;
    private String prefisso;
    private String numero;


    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getPrefisso() {
        return prefisso;
    }

    public void setPrefisso(String prefisso) {
        this.prefisso = prefisso;
    }

    public String getNumero() {
        return numero;
    }

    public void setNumero(String numero) {
        this.numero = numero;
    }

    @Override
    public String toString() {
        return "TelefonoBean [Id_Telefono=" + id + ", prefisso=" + prefisso + ", numero=" + numero + "]";
    }

}