package com.r1.ecommerceproject.utils;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.LinkedHashMap;
import java.util.Map;

public class ProductFilter {
    private String[] types;
    private String[] colors;
    private String[] sizes;
    private Double priceMax;
    private String orderBy;

    // Whitelist per i campi di ordinamento validi e le direzioni
    private static final Map<String, String> ALLOWED_ORDER_BY_FIELDS = new LinkedHashMap<>();
    static {
        ALLOWED_ORDER_BY_FIELDS.put("prezzo_asc", "prezzo ASC");
        ALLOWED_ORDER_BY_FIELDS.put("prezzo_desc", "prezzo DESC");
        // Aggiungere altri campi/direzioni consentiti se necessario
        ALLOWED_ORDER_BY_FIELDS.put("nome_asc", "nome ASC");
    }

    public void setOrderBy(String orderBy) {
        // Valida e imposta l'orderBy solo se è nella whitelist
        if (orderBy != null && ALLOWED_ORDER_BY_FIELDS.containsKey(orderBy.toLowerCase())) {
            this.orderBy = ALLOWED_ORDER_BY_FIELDS.get(orderBy.toLowerCase());
        } else {
            this.orderBy = null;
        }
    }

    public void setTypes(String[] types) {
        this.types = (types != null) ? Arrays.copyOf(types, types.length) : null;
    }

    public void setColors(String[] colors) {
        this.colors = (colors != null) ? Arrays.copyOf(colors, colors.length) : null;
    }

    public void setSizes(String[] sizes) {
        this.sizes = (sizes != null) ? Arrays.copyOf(sizes, sizes.length) : null;
    }

    public void setPriceMax(Double priceMax) {
        this.priceMax = priceMax;
    }

    /**
     * Restituisce una lista di oggetti parametro nell'ordine in cui devono essere impostati
     * nel PreparedStatement.
     * @return Lista di valori per i filtri.
     */
    public List<Object> getParameterValues() {
        List<Object> values = new ArrayList<>();
        if (types != null && types.length > 0) {
            Collections.addAll(values, types);
        }
        if (colors != null && colors.length > 0) {
            Collections.addAll(values, colors);
        }
        if (sizes != null && sizes.length > 0) {
            Collections.addAll(values, sizes);
        }
        if (priceMax != null && priceMax > 0) {
            values.add(priceMax);
        }
        return values;
    }

    /**
     * Costruisce la parte WHERE e ORDER BY della query SQL basata sui filtri impostati.
     * @return Stringa contenente le clausole SQL.
     */
    public String getQueryCondition() {
        StringBuilder queryBuilder = new StringBuilder();
        boolean hasWhereClause = false;

        if (types != null && types.length > 0) {
            appendWhereOrAnd(queryBuilder, hasWhereClause);
            hasWhereClause = true;
            queryBuilder.append("categoria IN (") // Assumendo che 'type' nel filtro corrisponda a 'categoria' nel DB
                    .append(String.join(",", Collections.nCopies(types.length, "?")))
                    .append(") ");
        }
        if (colors != null && colors.length > 0) {
            appendWhereOrAnd(queryBuilder, hasWhereClause);
            hasWhereClause = true;
            queryBuilder.append("colore IN (") // Assumendo che 'colore' sia un campo nel DB
                    .append(String.join(",", Collections.nCopies(colors.length, "?")))
                    .append(") ");
        }
        if (sizes != null && sizes.length > 0) {
            appendWhereOrAnd(queryBuilder, hasWhereClause);
            hasWhereClause = true;
            queryBuilder.append("taglia IN (")
                    .append(String.join(",", Collections.nCopies(sizes.length, "?")))
                    .append(") ");
        }
        if (priceMax != null && priceMax > 0) {
            appendWhereOrAnd(queryBuilder, hasWhereClause);
            hasWhereClause = true;
            queryBuilder.append("prezzo <= ? ");
        }

        if (orderBy != null && !orderBy.isEmpty()) {
            queryBuilder.append("ORDER BY ").append(orderBy); // orderBy è già validato
        }
        return queryBuilder.toString();
    }

    private void appendWhereOrAnd(StringBuilder sb, boolean hasWhereAlready) {
        if (!hasWhereAlready) {
            sb.append(" WHERE ");
        } else {
            sb.append(" AND ");
        }
    }
}