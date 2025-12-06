package DAO; 

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import Entity.News; 
import Util.DBConnection; 
import java.sql.Date; 

public class NewsDAO {

    // Phương thức ánh xạ ResultSet thành đối tượng News (Giữ nguyên)
    private News mapResultSetToNews(ResultSet rs) throws SQLException {
        News news = new News();
        news.setId(rs.getInt("Id"));
        news.setTitle(rs.getString("Title"));
        news.setContent(rs.getString("Content"));
        news.setImage(rs.getString("Image"));
        // Lấy ngày dưới dạng java.sql.Date sau đó chuyển sang java.util.Date
        news.setPostedDate(new java.util.Date(rs.getDate("PostedDate").getTime()));
        news.setAuthor(rs.getString("Author"));
        news.setViewCount(rs.getInt("ViewCount"));
        news.setCategoryId(rs.getInt("CategoryId"));
        // TINYINT(1) trong MySQL thường được ánh xạ thành boolean trong Java
        news.setHome(rs.getBoolean("Home"));
        return news;
    }
    /**
     * Lấy tất cả tin tức
     */
    public List<News> getAllNews() {
        List<News> list = new ArrayList<>();
        // Truy vấn SQL lấy TẤT CẢ bản ghi, sắp xếp theo PostedDate để tin mới nhất lên đầu
        String query = "SELECT * FROM News ORDER BY PostedDate DESC"; 
        
        // Thực hiện kết nối DB và ánh xạ (mapping) kết quả từ ResultSet sang đối tượng News
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                News news = new News(); 
                news.setId(rs.getInt("Id"));
                news.setTitle(rs.getString("Title"));
                news.setContent(rs.getString("content"));
                
                // >>> THÊM DÒNG NÀY ĐỂ GÁN CATEGORYID <<<
                news.setCategoryId(rs.getInt("CategoryId")); // <-- Lỗi đã được khắc phục ở đây!
                
                news.setImage(rs.getString("Image"));
                news.setPostedDate(new java.util.Date(rs.getDate("PostedDate").getTime())); // SỬA: Dùng java.util.Date
                news.setAuthor(rs.getString("Author"));
                news.setViewCount(rs.getInt("viewCount"));
                news.setHome(rs.getBoolean("Home"));
                list.add(news);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            // Xử lý lỗi
        }
        return list;
    }
    /**
     * Lấy tin tức theo ID
     */
    public News getNewsById(int newsId) { 
        String sql = "SELECT * FROM news WHERE Id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, newsId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToNews(rs);
                }
            }
        } catch (Exception e) { 
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Thêm tin tức mới
     */
    public boolean addNews(News news) {
        String sql = "INSERT INTO news (Title, Content, Image, PostedDate, Author, ViewCount, CategoryId, Home) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, news.getTitle());
            ps.setString(2, news.getContent());
            ps.setString(3, news.getImage());
            ps.setDate(4, new java.sql.Date(news.getPostedDate().getTime()));
            ps.setString(5, news.getAuthor());
            ps.setInt(6, news.getViewCount());
            ps.setInt(7, news.getCategoryId());
            ps.setBoolean(8, news.isHome());
            
            return ps.executeUpdate() > 0;
            
        } catch (Exception e) { 
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Cập nhật tin tức
     */
    public boolean updateNews(News news) {
        String sql = "UPDATE news SET Title=?, Content=?, Image=?, PostedDate=?, Author=?, ViewCount=?, CategoryId=?, Home=? WHERE Id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, news.getTitle());
            ps.setString(2, news.getContent());
            ps.setString(3, news.getImage());
            ps.setDate(4, new java.sql.Date(news.getPostedDate().getTime())); 
            ps.setString(5, news.getAuthor());
            ps.setInt(6, news.getViewCount());
            ps.setInt(7, news.getCategoryId());
            ps.setBoolean(8, news.isHome());
            ps.setInt(9, news.getId()); 
            
            return ps.executeUpdate() > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Xóa tin tức theo ID
     */
    public boolean deleteNews(int newsId) {
        String sql = "DELETE FROM news WHERE Id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, newsId);
            
            return ps.executeUpdate() > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

	/**
     * Lấy danh sách các tin tức được đánh dấu hiển thị trên trang chủ (Home = 1).
     */
	public List<News> getFeaturedNews() {
		List<News> list = new ArrayList<>();
		// Truy vấn: Lấy tất cả tin tức có Home = 1 và sắp xếp theo ngày đăng mới nhất
	    String sql = "SELECT * FROM news WHERE Home = 1 ORDER BY PostedDate DESC"; 
	    
	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql);
	         ResultSet rs = ps.executeQuery()) {

	        while (rs.next()) {
	            list.add(mapResultSetToNews(rs));
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return list;

	}

	/**
     * Lấy danh sách N tin tức mới nhất (N = limit).
     */
	public List<News> getLatestNews(int limit) { // Đã sửa tên tham số
		List<News> list = new ArrayList<>();
	    // Truy vấn: Lấy tất cả tin tức, sắp xếp theo ngày đăng mới nhất, và giới hạn số lượng
	    String sql = "SELECT * FROM news ORDER BY PostedDate DESC LIMIT ?"; // Sử dụng LIMIT cho MySQL
	    
	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, limit); // SỬA: Dùng đúng giá trị LIMIT truyền vào
	        
	        try (ResultSet rs = ps.executeQuery()) {
	            while (rs.next()) {
	                list.add(mapResultSetToNews(rs));
	            }
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return list;
	}
	
	// Lấy danh sách tin theo CategoryId
	public List<News> getNewsByCategory(int categoryId) {
	    List<News> list = new ArrayList<>();
	    String sql = "SELECT * FROM News WHERE CategoryId = ? ORDER BY PostedDate DESC";

	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {

	        ps.setInt(1, categoryId);

	        try (ResultSet rs = ps.executeQuery()) {
	            while (rs.next()) {
	                list.add(mapResultSetToNews(rs));
	            }
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return list;
	}
	
	
	public List<News> getAllNewsMoiNhat() {
	    List<News> list = new ArrayList<>();
	    String sql = "SELECT * FROM News ORDER BY PostedDate DESC";

	    try (Connection con = DBConnection.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql);
	         ResultSet rs = ps.executeQuery()) {

	        while (rs.next()) {
	            list.add(mapResultSetToNews(rs));  // Dùng lại hàm map chung
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return list;
	}



}