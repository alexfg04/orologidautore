package com.r1.ecommerceproject.model;

import java.time.LocalDateTime;

public class ReviewBean {

    private long idRecensione;
    private String commento;
    private String autore;
    private int valutazione;
    private long codiceProdotto;
    private LocalDateTime createdAt;

    // getter e setter
    public long getIdRecensione() {
        return idRecensione;
    }

    public void setIdRecensione(long idRecensione) {
        this.idRecensione = idRecensione;
    }

    public String getCommento() {
        return commento;
    }

    public void setCommento(String commento) {
        this.commento = commento;
    }

    public String getAutore() {
        return autore;
    }

    public void setAutore(String autore) {
        this.autore = autore;
    }

    public int getValutazione() {
        return valutazione;
    }

    public void setValutazione(int valutazione) {
        this.valutazione = valutazione;
    }

    public long getCodiceProdotto() {
        return codiceProdotto;
    }

    public void setCodiceProdotto(long codiceProdotto) {
        this.codiceProdotto = codiceProdotto;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
