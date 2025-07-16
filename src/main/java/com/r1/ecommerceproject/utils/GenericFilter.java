package com.r1.ecommerceproject.utils;

import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

public class GenericFilter implements SqlFilter {
    private final List<String> filterNames;
    private final String columnName;

    public GenericFilter(List<String> filterNames, String columnName) {
        this.filterNames = filterNames != null ? filterNames : Collections.emptyList();
        this.columnName = columnName;
    }

    @Override
    public boolean apply(StringBuilder sb, boolean whereExists, List<Object> params) {
        if (filterNames.isEmpty()) {
            return whereExists;
        }

        // Apre la clausola WHERE/AND
        sb.append(whereExists ? " AND (" : " WHERE (");

        // Costruisce tutte le condizioni LIKE collegate da OR
        String likeClauses = filterNames.stream()
                .map(fn -> columnName + " LIKE ?")
                .collect(Collectors.joining(" OR "));
        sb.append(likeClauses)
                .append(")");

        // Aggiunge i parametri con i wildcard per il matching
        filterNames.stream()
                .map(fn -> "%" + fn + "%")
                .forEach(params::add);

        return true;
    }
}
