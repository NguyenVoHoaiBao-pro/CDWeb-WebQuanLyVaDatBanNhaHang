package vn.edu.hcmuaf.fit.dao;

import vn.edu.hcmuaf.fit.model.RestaurantTable;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class RestaurantTableDAO {

    public RestaurantTable findById(int id){

        String sql =
                "SELECT * FROM restaurant_tables WHERE id=?";

        try(
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps =
                        conn.prepareStatement(sql)
        ){

            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();

            if(rs.next()){

                RestaurantTable t =
                        new RestaurantTable();

                t.setId(rs.getInt("id"));
                t.setName(rs.getString("name"));
                t.setCapacity(rs.getInt("capacity"));
                t.setStatus(rs.getString("status"));

                return t;
            }

        }catch(Exception e){
            e.printStackTrace();
        }

        return null;
    }
}