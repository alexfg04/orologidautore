package com.r1.ecommerceproject.dao.impl;

import com.r1.ecommerceproject.dao.ReviewDao;
import com.r1.ecommerceproject.model.ReviewBean;
import com.r1.ecommerceproject.utils.DataSourceConnectionPool;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReviewDaoImpl implements ReviewDao {

    private static final String TABLE_NAME = "Recensione";

    @Override
    public boolean insertReview(ReviewBean review) throws SQLException {
        String sql = "INSERT INTO " + TABLE_NAME + " (commento, autore, valutazione, codice_prodotto, created_at) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DataSourceConnectionPool.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, review.getCommento());
            ps.setString(2, review.getAutore());
            ps.setInt(3, review.getValutazione());
            ps.setLong(4, review.getCodiceProdotto());
            ps.setTimestamp(5, Timestamp.valueOf(review.getCreatedAt()));

            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public List<ReviewBean> getReviewsByProductId(long codiceProdotto) throws SQLException {
        List<ReviewBean> reviews = new ArrayList<>();
        String sql = "SELECT * FROM " + TABLE_NAME + " WHERE codice_prodotto = ? ORDER BY created_at DESC";

        try (Connection conn = DataSourceConnectionPool.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, codiceProdotto);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ReviewBean r = new ReviewBean();
                    r.setIdRecensione(rs.getLong("id_recensione"));
                    r.setCommento(rs.getString("commento"));
                    r.setAutore(rs.getString("autore"));
                    r.setValutazione(rs.getInt("valutazione"));
                    r.setCodiceProdotto(rs.getLong("codice_prodotto"));
                    r.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());

                    reviews.add(r);
                }
            }
        }
        return reviews;
    }
}
