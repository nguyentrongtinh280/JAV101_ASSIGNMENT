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
  
    public List<News> getAllNews() {
        List<News> list = new ArrayList<>();
        String query = "SELECT * FROM News ORDER BY PostedDate DESC, Id DESC";
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
        }
        return list;
    }
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

	public List<News> getFeaturedNews() {
		List<News> list = new ArrayList<>();
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


	public List<News> getLatestNews(int limit) {
		List<News> list = new ArrayList<>();
	    String sql = "SELECT * FROM news ORDER BY PostedDate DESC LIMIT ?"; 
	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, limit); 
	        
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
	            list.add(mapResultSetToNews(rs)); 
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return list;
	}
	
	public List<News> getTopViewedNews(int limit) {
	    List<News> list = new ArrayList<>();
	    String sql = "SELECT * FROM news ORDER BY ViewCount DESC LIMIT ?";
	    
	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {

	        ps.setInt(1, limit);
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
	
	public void increaseViewCount(int id) {
	    String sql = "UPDATE News SET ViewCount = ViewCount + 1 WHERE Id = ?";
	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {

	        ps.setInt(1, id);
	        ps.executeUpdate();

	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	}


	public void UpdateViewCount(int newsId) {
	    String sql = "UPDATE news SET ViewCount = ViewCount + 1 WHERE Id = ?"; 
	    
	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {

	        ps.setInt(1, newsId);
	        ps.executeUpdate();
	        
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	}

	// Tìm kiếm thông tin tức
	public static class Category {
	    private int id;
	    private String name;

	    public Category() {}
	    public Category(int id, String name) {
	        this.id = id;
	        this.name = name;
	    }

	    public int getId() { return id; }
	    public void setId(int id) { this.id = id; }
	    public String getName() { return name; }
	    public void setName(String name) { this.name = name; }
	}

	public List<Category> getAllCategories() {
	    List<Category> list = new ArrayList<>();
	    // Đảm bảo tên bảng là 'categories' hoặc tên bảng Loại tin của bạn
	    String query = "SELECT Id, Name FROM categories"; 
	    
	    try (Connection conn = Util.DBConnection.getConnection(); // Sử dụng DBConnection
	         PreparedStatement ps = conn.prepareStatement(query);
	         ResultSet rs = ps.executeQuery()) {
	        
	        while (rs.next()) {
	            Category cat = new Category();
	            cat.setId(rs.getInt("Id"));
	            cat.setName(rs.getString("Name"));
	            list.add(cat);
	        }
	        
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return list;
	}
	// Đặt phương thức này vào trong class NewsDAO
	public List<News> searchNews(String keyword, int categoryId) {
	    List<News> list = new ArrayList<>();
	    
	    // Khởi tạo phần cơ sở của câu truy vấn
	    String query = "SELECT * FROM News WHERE 1=1"; 

	    List<String> parameters = new ArrayList<>();

	    if (categoryId > 0) {
	        query += " AND CategoryId = ?";
	    }
	    
	    if (keyword != null && !keyword.trim().isEmpty()) {
	        query += " AND (Title LIKE ? OR Content LIKE ?)";
	    }
	    // Sắp xếp theo ngày đăng mới nhất
	    query += " ORDER BY PostedDate DESC, Id DESC";

	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement ps = conn.prepareStatement(query)) {

	        int paramIndex = 1;

	        if (categoryId > 0) {
	            ps.setInt(paramIndex++, categoryId);
	        }

	        if (keyword != null && !keyword.trim().isEmpty()) {
	            String searchPattern = "%" + keyword.trim() + "%";
	            ps.setString(paramIndex++, searchPattern); 
	            ps.setString(paramIndex++, searchPattern); 
	        }
	        
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
}