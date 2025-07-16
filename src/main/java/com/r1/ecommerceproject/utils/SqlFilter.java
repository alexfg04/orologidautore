package com.r1.ecommerceproject.utils;

import java.util.List;

public interface SqlFilter {
    /**
     * Aggiunge allo StringBuilder la clausola WHERE/AND e
     * popola la lista dei parametri.
     * @param sb            StringBuilder sul quale appendere
     * @param whereExists   true se ho già messo almeno un WHERE
     * @param params        lista dei parametri da popolare
     * @return true se dopo questa chiamata c'è già un WHERE
     */
    boolean apply(StringBuilder sb, boolean whereExists, List<Object> params);
}