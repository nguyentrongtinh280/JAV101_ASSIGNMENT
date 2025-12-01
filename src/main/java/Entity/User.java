package Entity;

import java.sql.Date; // Hoặc java.util.Date nếu cần

public class User {
	private int id;
	private String fullname;
	private String email;
	private String password;
	private int role; // Đã sửa: Role nên là int (TINYINT(1))
	private Date birthday; // Đã thêm: Cột Birthday
	private int gender;    // Đã thêm: Cột Gender (TINYINT(1))

	// Đã loại bỏ: Thuộc tính Status

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getFullname() {
		return fullname;
	}

	public void setFullname(String fullname) {
		this.fullname = fullname;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	// Đã sửa: Getter/Setter cho Role là int
	public int getRole() {
		return role;
	}

	public void setRole(int role) {
		this.role = role;
	}
    
    // Đã thêm: Getter/Setter cho Birthday
    public Date getBirthday() {
        return birthday;
    }

    public void setBirthday(Date birthday) {
        this.birthday = birthday;
    }

    // Đã thêm: Getter/Setter cho Gender
    public int getGender() {
        return gender;
    }

    public void setGender(int gender) {
        this.gender = gender;
    }
}