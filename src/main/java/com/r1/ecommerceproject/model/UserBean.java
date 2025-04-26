package com.r1.ecommerceproject.model;

import java.time.LocalDate;

public class UserBean {

    public enum Role{ADMIN, UTENTE};

    private long Id;
    private String nome;
    private String cognome;
    private String email;
    private String password;
    private LocalDate dataDiNascita;
    private Role tipologia;


    public void setId(long Id){
        this.Id = Id;
    }

    public long getId(){
        return Id;
    }

    public void setNome(String nome){
        this.nome=nome;
    }

    public String getNome(){
        return nome;
    }

    public void setCognome(String cognome){
        this.cognome=cognome;
    }

    public String getCognome(){
        return cognome;
    }

    public void setEmail(String email){
        this.email=email;
    }

    public String getEmail(){
        return email;
    }

    public void setPassword(String password){
        this.password = password;
    }

    public String getPassword(){
        return password;
    }

    public void setDataDiNascita(LocalDate dataDiNascita){
        this.dataDiNascita = dataDiNascita;
    }

    public LocalDate getDataDiNascita(){
        return dataDiNascita;
    }

    public void setTipologia(Role tipologia){
        this.tipologia=tipologia;
    }

    public Role getTipologia(){
        return tipologia;
    }

    @Override
    public String toString(){
        return "Id utente: "+ Id +
                "Nome: "+nome+
                "Cognome: "+cognome+
                "E-mail: "+email+
                "Password: "+password+
                "Data di nascita: "+ dataDiNascita +
                "Tipologia: "+tipologia;
    }
}