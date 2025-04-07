package com.r1.ecommerceproject.model;

import java.io.Serializable;

public class ProductBean implements Serializable {

	private static final long serialVersionUID = 1L;

	
	int codiceProdotto;
	String materiale;
	String categoria;
	String taglia;
	String marca;
	double prezzo;
	Stato stato;
	String modello;
	String descrizione;
	String nome;
	
	public enum Stato{ attivato, disattivato}


    // Costruttore completo
    public ProductBean(int codiceProdotto, String materiale, String categoria, String taglia, String marca, double prezzo, String modello, String descrizione, String nome) {
        this.codiceProdotto = codiceProdotto;
        this.materiale = materiale;
        this.categoria = categoria;
        this.taglia = taglia;
        this.marca = marca;
        this.prezzo = prezzo;
        this.stato = Stato.attivato;
        this.modello = modello;
        this.descrizione = descrizione;
        this.nome = nome;
    }

    // Costruttore vuoto
    public ProductBean() {
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

	public double getPrezzo() {
		return prezzo;
	}

	public void setPrezzo(double prezzo) {
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

}
