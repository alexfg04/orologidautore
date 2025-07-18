package com.r1.ecommerceproject.dao;

import com.r1.ecommerceproject.model.ReviewBean;
import java.sql.SQLException;
import java.util.List;

public interface ReviewDao {
    boolean insertReview(ReviewBean review, long idUtente) throws SQLException;
    List<ReviewBean> getReviewsByProductId(long codiceProdotto) throws SQLException;
}
