package com.r1.ecommerceproject.utils;

import com.paypal.core.PayPalEnvironment;
import com.paypal.core.PayPalHttpClient;

public class PayPalClient {
    private static final String CLIENT_ID = "AcO8UtjKGoOmhnB6AMJvH4fHC8N337YndFwEVaYWubBss4gduwBGE-9xpgUg8DUMJpn6b1E3pd8XgPTQ";
    private static final String CLIENT_SECRET = "EM3f3vzx6gvu2zFLwtM2nMjRlFFT11k8vUZ6z-1kvAXlH1k5j1HvysJ5R4NPeV78_wydm3uqGcq7Q5-a";

    // Ambiente sandbox
    private static final PayPalEnvironment environment =
            new PayPalEnvironment.Sandbox(CLIENT_ID, CLIENT_SECRET);

    // Client condiviso per tutte le chiamate
    public static PayPalHttpClient client = new PayPalHttpClient(environment);

}
