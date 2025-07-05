package com.r1.ecommerceproject.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Objects;

public class ProductBean implements Serializable {

	private static final long serialVersionUID = 1L;

	
	int codiceProdotto;
	String materiale;
	String categoria;
	String taglia;
	String marca;
	BigDecimal prezzo;
	Stato stato;
	String modello;
	String descrizione;
	String nome;

	String immagine;
	
	public enum Stato{ ATTIVATO, DISATTIVATO}

    // Costruttore vuoto
    public ProductBean() {
    }

	public String getImmagine() {
		return immagine;
	}

	public void setImmagine(String immagine) {
		this.immagine = immagine;
	}
    
    //metodi setter e getter
    public int getCodiceProdotto() {
		return codiceProdotto;
	}

	public void setCodiceProdotto(int codiceProdotto) {
		this.codiceProdotto = codiceProdotto;
	}

	public String getMateriale() {
		return materiale;
	}

	public void setMateriale(String materiale) {
		this.materiale = materiale;
	}

	public String getCategoria() {
		return categoria;
	}

	public void setCategoria(String categoria) {
		this.categoria = categoria;
	}

	public String getTaglia() {
		return taglia;
	}

	public void setTaglia(String taglia) {
		this.taglia = taglia;
	}

	public String getMarca() {
		return marca;
	}

	public void setMarca(String marca) {
		this.marca = marca;
	}

	public BigDecimal getPrezzo() {
		return prezzo;
	}

	public void setPrezzo(BigDecimal prezzo) {
		this.prezzo = prezzo;
	}

	public Stato getStato() {
		return stato;
	}

	public void setStato(Stato stato) {
		this.stato = stato;
	}

	public String getModello() {
		return modello;
	}

	public void setModello(String modello) {
		this.modello = modello;
	}

	public String getDescrizione() {
		return descrizione;
	}

	public void setDescrizione(String descrizione) {
		this.descrizione = descrizione;
	}

	public String getNome() {
		return nome;
	}

	public void setNome(String nome) {
		this.nome = nome;
	}
    //metodo toString
	@Override
    public String toString() {
        return "Prodotto{" +
                "codiceProdotto=" + codiceProdotto +
                ", materiale='" + materiale + '\'' +
                ", categoria='" + categoria + '\'' +
                ", taglia='" + taglia + '\'' +
                ", marca='" + marca + '\'' +
                ", prezzo=" + prezzo +
                ", stato=" + stato +
                ", modello='" + modello + '\'' +
                ", descrizione='" + descrizione + '\'' +
                ", nome='" + nome + '\'' +
                '}';
    }

	@Override
	public boolean equals(Object o) {
		if (this == o) return true;
		if (o == null || getClass() != o.getClass()) return false;

		ProductBean that = (ProductBean) o;

		return getCodiceProdotto() == that.getCodiceProdotto()
				&& getPrezzo().compareTo(that.getPrezzo()) == 0
				&& Objects.equals(getMateriale(), that.getMateriale())
				&& Objects.equals(getCategoria(), that.getCategoria())
				&& Objects.equals(getTaglia(), that.getTaglia())
				&& Objects.equals(getMarca(), that.getMarca())
				&& getStato() == that.getStato()
				&& Objects.equals(getModello(), that.getModello())
				&& Objects.equals(getDescrizione(), that.getDescrizione())
				&& Objects.equals(getNome(), that.getNome())
				&& Objects.equals(getImmagine(), that.getImmagine());
	}


	@Override
	public int hashCode() {
		return Objects.hash(getCodiceProdotto(), getMateriale(), getCategoria(), getTaglia(), getMarca(), getPrezzo(), getStato(), getModello(), getDescrizione(), getNome(), getImmagine());
	}
}
