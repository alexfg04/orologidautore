package com.r1.ecommerceproject.utils;

import com.r1.ecommerceproject.utils.SqlFilter;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class ProductFilter {
    private final List<SqlFilter> filters;
    List<Object> params = new ArrayList<>();
    private final String orderByClause;
    private final Integer limit;
    private final Integer offset;

    private ProductFilter(Builder b) {
        this.filters       = List.copyOf(b.filters);
        this.orderByClause = b.orderByKey != null
                ? Builder.ALLOWED_ORDER_BY.get(b.orderByKey)
                : null;
        this.limit  = b.limit;
        this.offset = b.offset;
    }

    public String toSql() {
        StringBuilder sb = new StringBuilder();
        boolean whereExists = false;

        params.clear();

        for (SqlFilter f : filters) {
            whereExists = f.apply(sb, whereExists, params);
        }
        if (orderByClause != null) {
            sb.append(" ORDER BY ").append(orderByClause);
        }
        if (limit != null) {
            sb.append(" LIMIT ").append(limit);
            if (offset != null) {
                sb.append(" OFFSET ").append(offset);
            }
        }
        return sb.toString();
    }

    public List<Object> getParameters() {
        return params;
    }

    @Override
    public String toString() {
        return "SQL: " + toSql() + "\nParams: " + getParameters();
    }

    public static class Builder {
        private final List<SqlFilter> filters = new ArrayList<>();
        private String orderByKey;
        private Integer limit;
        private Integer offset;

        static final Map<String, String> ALLOWED_ORDER_BY = new LinkedHashMap<>();
        static {
            ALLOWED_ORDER_BY.put("prezzo_asc",  "prezzo ASC");
            ALLOWED_ORDER_BY.put("prezzo_desc", "prezzo DESC");
            ALLOWED_ORDER_BY.put("nome_asc",    "nome ASC");
            ALLOWED_ORDER_BY.put("nome_desc",   "nome DESC");
        }

        public Builder addFilter(SqlFilter filter) {
            if (filter != null) filters.add(filter);
            return this;
        }
        public Builder orderBy(String key) {
            this.orderByKey = key!=null && ALLOWED_ORDER_BY.containsKey(key.toLowerCase())
                    ? key.toLowerCase() : null;
            return this;
        }
        public Builder limit(int l) {
            this.limit = l > 0 ? l : null;
            return this;
        }
        public Builder offset(int o) {
            this.offset = o >= 0 ? o : null;
            return this;
        }
        public ProductFilter build() {
            return new ProductFilter(this);
        }
    }
}