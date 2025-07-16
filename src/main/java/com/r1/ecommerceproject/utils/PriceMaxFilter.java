package com.r1.ecommerceproject.utils;

import java.math.BigDecimal;
import java.util.List;

public class PriceMaxFilter implements SqlFilter {
    private final BigDecimal priceMax;

    public PriceMaxFilter(BigDecimal priceMax) {
        this.priceMax = priceMax != null && priceMax.signum() > 0 ? priceMax : null;
    }

    @Override
    public boolean apply(StringBuilder sb, boolean whereExists, List<Object> params) {
        if (priceMax == null) {
            return whereExists;
        }
        sb.append(whereExists ? " AND " : " WHERE ")
                .append("prezzo <= ?");
        params.add(priceMax);
        return true;
    }
}
