package com.r1.ecommerceproject.model;

import java.math.BigDecimal;

public class PaymentBean {
    private String token;
    private String emailPayer;
    private String currency;
    private BigDecimal amount;

    public String getToken() {
        return token;
    }
    public void setToken(String token) {
        this.token = token;
    }
    public String getEmailPayer() {
        return emailPayer;
    }

    public void setEmailPayer(String emailPayer) {
        this.emailPayer = emailPayer;
    }
    public String getCurrency() {
        return currency;
    }
    public void setCurrency(String currency) {
        this.currency = currency;
    }

    public BigDecimal getAmount() {
        return amount;
    }
    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }
    @Override
    public String toString() {
        return "PaymentBean [token=" + token + ", emailPayer=" + emailPayer + ", currency=" + currency + ", amount="
                + amount + "]";
    }
}
