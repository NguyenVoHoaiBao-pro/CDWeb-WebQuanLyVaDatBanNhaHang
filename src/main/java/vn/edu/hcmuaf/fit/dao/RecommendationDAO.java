package vn.edu.hcmuaf.fit.dao;

import vn.edu.hcmuaf.fit.model.Product;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RecommendationDAO {

    public List<Product> findAllProducts(){

        List<Product> list = new ArrayList<>();

        String sql = "SELECT * FROM products";

        try(
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()
        ){

            while(rs.next()){

                Product p = new Product();

                p.setId(rs.getInt("id"));
                p.setName(rs.getString("name"));

                p.setPrice(rs.getDouble("price"));

                p.setImage(rs.getString("image"));

                p.setAiKeywords(
                        rs.getString("ai_keywords")
                );

                p.setAiDescription(
                        rs.getString("ai_description")
                );

                list.add(p);
            }

        }catch(Exception e){
            e.printStackTrace();
        }

        return list;
    }
}