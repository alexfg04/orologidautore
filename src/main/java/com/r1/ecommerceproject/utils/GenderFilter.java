package com.r1.ecommerceproject.utils;

import java.util.List;

public class GenderFilter implements SqlFilter {
    private final String gender;

    public GenderFilter(String gender) {
        if (gender != null && (gender.equalsIgnoreCase("uomo") || gender.equalsIgnoreCase("donna"))) {
            this.gender = gender.substring(0, 1).toUpperCase() + gender.substring(1).toLowerCase();
        } else {
            this.gender = null;
        }
    }

    @Override
    public boolean apply(StringBuilder sb, boolean whereExists, List<Object> params) {
        if (gender == null) {
            return whereExists;
        }
        sb.append(whereExists ? " AND " : " WHERE ")
                .append("gender = ?");
        params.add(gender);
        return true;
    }
}
