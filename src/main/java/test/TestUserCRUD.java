package test;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.Select;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.testng.Assert;
import org.testng.annotations.*;

import java.time.Duration;
import java.util.List;

/**
 * Lớp kiểm thử CRUD (Create, Read, Update, Delete) cho chức năng Quản lý Người Dùng.
 * Sử dụng TestNG và Selenium WebDriver với các phương pháp chờ đợi tường minh (Explicit Waits)
 * để đảm bảo tính ổn định tối đa.
 */
public class TestUserCRUD {

    private WebDriver driver;
    private WebDriverWait wait;

    private final Duration TIMEOUT = Duration.ofSeconds(10);

    // Cấu hình URL cơ bản
    private final String BASE_URL = "http://localhost:8080/Assignment/";
    private final String LOGIN_PAGE_URL = BASE_URL + "Login.jsp";
    private final String ADMIN_CRUD_URL = BASE_URL + "nguoi-dung";
    
    // Tài khoản Admin giả định
    private final String ADMIN_EMAIL = "admin@news.com";
    private final String ADMIN_PASSWORD = "123"; 
    
    // Dữ liệu kiểm thử
    private String crudTestEmail = "crud" + System.currentTimeMillis() + "@test.com";
    private final String CRUD_FULLNAME = "CRUD User";
    private final String CRUD_PASSWORD = "CrudPass@123";
    private final String CRUD_MOBILE = "0987654321";

    // Định dạng Ngày sinh:
    // 1. Dùng cho input type="date" (bắt buộc phải là YYYY-MM-DD theo chuẩn HTML)
    private final String CRUD_BIRTHDAY_INPUT = "20-11-2001"; 
    // 2. Dùng để Assert (kiểm tra) trên bảng (phải là DD/MM/YYYY theo định dạng hiển thị tiếng Việt)
    private final String CRUD_BIRTHDAY_DISPLAY = "2001/11/20"; 

    // Dữ liệu Cập nhật
    private final String UPDATED_FULLNAME = "CRUD Updated Name";
    private final String UPDATED_MOBILE = "0123456789"; 


    /**
     * Khởi tạo WebDriver và đăng nhập Admin trước khi chạy các Test Case.
     */
    @BeforeClass
    public void setup() {
        // Cấu hình ChromeDriver (Giả định path đã được thiết lập)
        driver = new ChromeDriver();
        driver.manage().window().maximize();
        wait = new WebDriverWait(driver, TIMEOUT);
        performAdminLogin();
    }

    private void fillInput(By locator, String value) {
        // Chờ phần tử khả dụng để tương tác
        WebElement element = wait.until(ExpectedConditions.elementToBeClickable(locator));
        element.clear();
        element.sendKeys(value);
        // Lưu ý: Đã loại bỏ Thread.sleep() 200ms để tối ưu tốc độ, tin tưởng vào ExpectedConditions.
    }

    /** * Đăng nhập bằng tài khoản Admin và điều hướng đến trang CRUD.
     */
    private void performAdminLogin() {
        driver.get(LOGIN_PAGE_URL);

        // Nhập thông tin đăng nhập
        fillInput(By.id("email"), ADMIN_EMAIL);
        fillInput(By.id("password"), ADMIN_PASSWORD);

        WebElement loginBtn = wait.until(ExpectedConditions.elementToBeClickable(
                By.xpath("//button[text()='ĐĂNG NHẬP']")));
        loginBtn.click();
        
        // 1. Chờ URL thay đổi (thoát khỏi trang login)
        try {
            wait.until(ExpectedConditions.not(ExpectedConditions.urlToBe(LOGIN_PAGE_URL)));
        } catch (Exception e) {
             Assert.fail("Đăng nhập thất bại. Kiểm tra tài khoản Admin.");
        }
        
        // 2. Điều hướng đến trang CRUD (đã có session)
        driver.get(ADMIN_CRUD_URL);
        
        // 3. XÁC NHẬN TRUY CẬP ADMIN: Chờ tiêu đề trang CRUD hiển thị
        try {
            wait.until(ExpectedConditions.visibilityOfElementLocated(
                    By.xpath("//h2[contains(text(), 'Quản Lý Người Dùng')]")));
        } catch (Exception e) {
            Assert.fail("Không thể truy cập trang Quản Lý Người Dùng (" + ADMIN_CRUD_URL + 
                        "). Lỗi: " + e.getMessage());
        }
    }

    /** * Hàm tìm kiếm dòng (tr) của người dùng trong bảng dựa trên Email.
     * @param email Email của người dùng cần tìm
     * @return WebElement là dòng (row) chứa thông tin người dùng, hoặc null nếu không tìm thấy.
     */
    private WebElement findUserRowByEmail(String email) {
        // Chờ bảng dữ liệu (tbody) hiển thị hoàn toàn
        WebElement tableBody = wait.until(ExpectedConditions.visibilityOfElementLocated(
            By.xpath("//div[@class='crud-table user-table']//tbody")));
            
        List<WebElement> rows = tableBody.findElements(By.xpath("./tr"));
        
        for (WebElement row : rows) {
            try {
                // Giả định cột Email là td[5] theo cấu trúc JSP
                if (row.findElements(By.xpath("./td")).size() >= 5) {
                    String rowEmail = row.findElement(By.xpath("./td[5]")).getText().trim(); 
                    if (rowEmail.equals(email)) {
                        return row;
                    }
                }
            } catch (Exception e) {
                // Bỏ qua các dòng không hợp lệ
            }
        }
        return null;
    }

    /** =======================================================================
     * TEST CASES
     * ======================================================================= */
    
    @Test(priority = 1, description = "1. Kiểm tra Tạo mới Người dùng (Insert)")
    public void testCreateNewUser() {
        
        driver.get(ADMIN_CRUD_URL);
        wait.until(ExpectedConditions.urlToBe(ADMIN_CRUD_URL));
        
        // 1. Nhập dữ liệu vào Form
        fillInput(By.id("fullname"), CRUD_FULLNAME);
        fillInput(By.id("email"), crudTestEmail);
        fillInput(By.id("password"), CRUD_PASSWORD);
        fillInput(By.id("confirm_password"), CRUD_PASSWORD);
        fillInput(By.id("mobile"), CRUD_MOBILE);
        fillInput(By.id("birthday"), CRUD_BIRTHDAY_INPUT); // YYYY-MM-DD
        
        // Chọn Vai trò (Phóng viên/Role 0)
        WebElement roleElement = wait.until(ExpectedConditions.visibilityOfElementLocated(By.id("role")));
        new Select(roleElement).selectByValue("0"); 
        
        // Chọn Giới tính Nam (0)
        wait.until(ExpectedConditions.elementToBeClickable(By.id("gender_male"))).click();
        
        // 2. Click nút Lưu (action=insert)
        WebElement saveBtn = wait.until(ExpectedConditions.elementToBeClickable(
                By.xpath("//button[text()='Lưu']")));
        saveBtn.click();
        
        // Chờ server xử lý và reload trang về URL gốc
        wait.until(ExpectedConditions.urlToBe(ADMIN_CRUD_URL)); 
        
        // 3. Kiểm tra thông báo thành công
        WebElement successAlert = wait.until(ExpectedConditions.visibilityOfElementLocated(
                By.xpath("//div[contains(@class, 'alert') and contains(@class, 'success')]")));
        Assert.assertTrue(successAlert.getText().contains("Thêm người dùng thành công!"), 
                          "Thông báo thành công không hiển thị hoặc sai nội dung.");
        
        // 4. Kiểm tra dữ liệu trong bảng
        WebElement userRow = findUserRowByEmail(crudTestEmail);
        Assert.assertNotNull(userRow, "Người dùng mới không xuất hiện trong danh sách.");
        Assert.assertTrue(userRow.getText().contains(CRUD_FULLNAME));
        
        // Kiểm tra Ngày sinh phải khớp với định dạng hiển thị DD/MM/YYYY (td[3])
        Assert.assertEquals(userRow.findElement(By.xpath("./td[3]")).getText().trim(), CRUD_BIRTHDAY_DISPLAY, 
                            "Ngày sinh hiển thị sai định dạng. Cần là DD/MM/YYYY.");
    }

    @Test(priority = 2, description = "2. Kiểm tra Cập nhật Người dùng (Update)")
    public void testUpdateExistingUser() {
        
        driver.get(ADMIN_CRUD_URL); 
        wait.until(ExpectedConditions.urlToBe(ADMIN_CRUD_URL));
        
        // 1. Tìm và click nút Sửa
        WebElement userRow = findUserRowByEmail(crudTestEmail);
        Assert.assertNotNull(userRow, "Không tìm thấy người dùng để Cập nhật.");
        
        // Dùng ExpectedConditions để đảm bảo link 'Sửa' có thể click được
        WebElement editLink = wait.until(ExpectedConditions.elementToBeClickable(
                userRow.findElement(By.xpath(".//td/a[text()='Sửa']"))
        ));
        editLink.click();
        
        // Chờ form chuyển sang chế độ Update (URL có action=edit)
        wait.until(ExpectedConditions.urlContains("action=edit")); 
        
        // 2. Kiểm tra Form đã load dữ liệu cũ và chế độ Update
        Assert.assertEquals(driver.findElement(By.name("action")).getAttribute("value"), "update");
        
        // 3. Thay đổi Họ và tên và Điện thoại
        fillInput(By.id("fullname"), UPDATED_FULLNAME);
        fillInput(By.id("mobile"), UPDATED_MOBILE); 
        
        // 4. Click nút Cập nhật
        WebElement updateBtn = wait.until(ExpectedConditions.elementToBeClickable(
                By.xpath("//button[text()='Cập nhật']")));
        updateBtn.click();
        
        // Chờ reload về trang danh sách
        wait.until(ExpectedConditions.urlToBe(ADMIN_CRUD_URL)); 
        
        // 5. Kiểm tra thông báo thành công
        WebElement successAlert = wait.until(ExpectedConditions.visibilityOfElementLocated(
                By.xpath("//div[contains(@class, 'alert') and contains(@class, 'success')]")));
        Assert.assertTrue(successAlert.getText().contains("Cập nhật thông tin thành công!"), 
                          "Thông báo cập nhật không hiển thị.");
        
        // 6. Kiểm tra dữ liệu mới trong bảng
        WebElement updatedRow = findUserRowByEmail(crudTestEmail);
        Assert.assertNotNull(updatedRow);
        Assert.assertTrue(updatedRow.getText().contains(UPDATED_FULLNAME), "Tên người dùng không được cập nhật.");
        
        // Kiểm tra Ngày sinh (không đổi)
        Assert.assertEquals(updatedRow.findElement(By.xpath("./td[3]")).getText().trim(), CRUD_BIRTHDAY_DISPLAY, 
                            "Ngày sinh bị thay đổi hoặc sai định dạng sau khi cập nhật.");
    }

    @Test(priority = 3, description = "3. Kiểm tra Xóa Người dùng (Delete)")
    public void testDeleteUser() {
        
        driver.get(ADMIN_CRUD_URL);
        wait.until(ExpectedConditions.urlToBe(ADMIN_CRUD_URL));
        
        // 1. Tìm dòng và link Xóa
        WebElement userRow = findUserRowByEmail(crudTestEmail);
        Assert.assertNotNull(userRow, "Không tìm thấy người dùng để Xóa.");
        
        // Dùng ExpectedConditions để đảm bảo link 'Xóa' có thể click được
        WebElement deleteLink = wait.until(ExpectedConditions.elementToBeClickable(
                userRow.findElement(By.xpath(".//td/a[text()='Xóa']"))
        ));
        
        // 2. Click nút Xóa
        deleteLink.click();
        
        // 3. Chấp nhận cửa sổ xác nhận (confirm())
        wait.until(ExpectedConditions.alertIsPresent());
        driver.switchTo().alert().accept(); 
        
        // Chờ trang tải lại sau khi xóa
        wait.until(ExpectedConditions.urlToBe(ADMIN_CRUD_URL)); 
        
        // 4. Kiểm tra thông báo thành công 
        WebElement successAlert = wait.until(ExpectedConditions.visibilityOfElementLocated(
                By.xpath("//div[contains(@class, 'alert')]"))); 
        Assert.assertTrue(successAlert.getText().contains("Xóa người dùng thành công"), 
                          "Thông báo xóa không hiển thị.");
        
        // 5. Kiểm tra người dùng đã bị xóa khỏi bảng chưa
        WebElement deletedRow = findUserRowByEmail(crudTestEmail);
        Assert.assertNull(deletedRow, "Người dùng vẫn còn tồn tại trong danh sách sau khi xóa.");
    }

    /**
     * Dọn dẹp: Đóng trình duyệt sau khi tất cả các Test Case hoàn thành.
     */
    @AfterClass
    public void tearDown() {
        if (driver != null) driver.quit();
    }
}