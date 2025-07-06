package com.r1.ecommerceproject.utils;

import com.paypal.core.PayPalEnvironment;
import com.paypal.core.PayPalHttpClient;

public class PayPalClient {
    private static final String CLIENT_ID = System.getenv("PAYPAL_CLIENT_ID");
    private static final String CLIENT_SECRET = System.getenv("PAYPAL_CLIENT_SECRET");

    // Ambiente sandbox
    private static final PayPalEnvironment environment =
            new PayPalEnvironment.Sandbox(CLIENT_ID, CLIENT_SECRET);

    // Client condiviso per tutte le chiamate
    public static PayPalHttpClient client = new PayPalHttpClient(environment);

}
