package DAO;

import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import Entity.Categories;
import Util.DBConnection;

public class CategoriesDAO {

    // INSERT CATEGORIES (LOẠI TIN)
    public void insert(Categories ct) {
        String sql = "INSERT INTO categories(name) VALUES (?)";
        DBConnection.update(sql, ct.getName());
    }

    // UPDATE CATEGORIES (LOẠI TIN)
    public void update(Categories ct) {
        String sql = "UPDATE categories SET name = ? WHERE id = ?";
        DBConnection.update(sql, ct.getName(), ct.getId());
    }

    // DELETE CATEGORIES (LOẠI TIN)
    public void delete(int id) {
        String sql = "DELETE FROM categories WHERE id = ?";
        DBConnection.update(sql, id);
    }

    // LẤY TẤT CẢ
    public List<Categories> selectAll() {
        List<Categories> list = new ArrayList<>();
        String sql = "SELECT * FROM categories";
        try (ResultSet rs = DBConnection.query(sql)) {
            while (rs.next()) {
                Categories ct = new Categories();
                ct.setId(rs.getInt("id"));
                ct.setName(rs.getString("name"));
                list.add(ct);
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return list;
    }

    // LẤY THEO ID
    public Categories selectByID(int id) {
        String sql = "SELECT * FROM categories WHERE id = ?";
        try (ResultSet rs = DBConnection.query(sql, id)) {
            if (rs.next()) {
                Categories ct = new Categories();
                ct.setId(rs.getInt("id"));
                ct.setName(rs.getString("name"));
                return ct;
            }
            return null;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}