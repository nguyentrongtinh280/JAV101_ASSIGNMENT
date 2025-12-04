package test;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.testng.Assert;
import org.testng.annotations.*;

import java.time.Duration;

public class TestLogin1 {

    private WebDriver driver;
    private WebDriverWait wait;

    private final Duration TIMEOUT = Duration.ofSeconds(10);

    private final String BASE_URL = "http://localhost:8080/Assignment/";
    private final String LOGIN_PAGE_URL = BASE_URL + "Login.jsp";
    private final String HOME_PAGE_URL = BASE_URL + "index.jsp";
    private final String REGISTER_PAGE_URL = BASE_URL + "Register.jsp";

    private final String VALID_EMAIL = "quocanhbuinhat@gmail.com";
    private final String VALID_PASSWORD = "123456";
    private final String INVALID_PASSWORD = "wrongpassword123";

    private String uniqueEmail = "test" + System.currentTimeMillis() + "@assignment.com";
    private final String REG_FULLNAME = "Tester A";
    private final String REG_PASSWORD = "Password@123";
    private final String REG_MISMATCH_PASSWORD = "Password@456";

    @BeforeClass
    public void setup() {
        driver = new ChromeDriver();
        driver.manage().window().maximize();
        wait = new WebDriverWait(driver, TIMEOUT);
    }

    /** ----------------------------------------------------
     * HÀM NGỦ NHẸ SAU MỖI HÀNH ĐỘNG
     * ---------------------------------------------------- */
    private void sleep() {
        try {
            Thread.sleep(2000); // chỉnh tại đây nếu muốn nhanh/chậm hơn
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
    }

    /** ----- HÀM DÙNG CHUNG NHẬP DỮ LIỆU INPUT ----- */
    private void fillInput(By locator, String value) {
        WebElement element = wait.until(ExpectedConditions.visibilityOfElementLocated(locator));
        element.clear();
        sleep();
        element.sendKeys(value);
        sleep();
    }

    /** ----- LOGIN ACTION ----- */
    private void performLogin(String email, String password) {
        driver.get(LOGIN_PAGE_URL);
        sleep();

        fillInput(By.id("email"), email);
        fillInput(By.id("password"), password);

        WebElement loginBtn = wait.until(ExpectedConditions.elementToBeClickable(
                By.xpath("//button[text()='ĐĂNG NHẬP']")));
        sleep();
        loginBtn.click();
        sleep();
    }

    /** ----- REGISTER ACTION ----- */
    private void performRegistration(String fullname, String email, String password, String confirmPassword) {
        driver.get(REGISTER_PAGE_URL);
        sleep();

        fillInput(By.id("fullname"), fullname);
        fillInput(By.id("email"), email);
        fillInput(By.id("password"), password);
        fillInput(By.id("confirmPassword"), confirmPassword);

        WebElement btn = wait.until(ExpectedConditions.elementToBeClickable(
                By.xpath("//button[text()='ĐĂNG KÝ']")));
        sleep();
        btn.click();
        sleep();
    }

    /** =======================================================================
     *  TEST CASES
     *  ======================================================================= */

    @Test(priority = 1, description = "Kiểm tra Đăng ký thành công")
    public void testSuccessfulRegistration() {

        performRegistration(REG_FULLNAME, uniqueEmail, REG_PASSWORD, REG_PASSWORD);

        wait.until(ExpectedConditions.urlToBe(LOGIN_PAGE_URL));

        Assert.assertEquals(driver.getCurrentUrl(), LOGIN_PAGE_URL);

        WebElement successAlert = wait.until(ExpectedConditions.visibilityOfElementLocated(
                By.cssSelector(".alert-success-custom")));
        Assert.assertTrue(successAlert.isDisplayed());
    }

    @Test(priority = 2, description = "Kiểm tra Đăng ký thất bại (Mật khẩu không khớp)")
    public void testFailedRegistration_MismatchedPasswords() {

        String mismatchEmail = "mis" + System.currentTimeMillis() + "@assignment.com";

        performRegistration(REG_FULLNAME, mismatchEmail, REG_PASSWORD, REG_MISMATCH_PASSWORD);

        Assert.assertEquals(driver.getCurrentUrl(), REGISTER_PAGE_URL);

        WebElement errorAlert = wait.until(ExpectedConditions.visibilityOfElementLocated(
                By.cssSelector(".alert-error")));
        Assert.assertTrue(errorAlert.isDisplayed());
    }

    @Test(priority = 3, description = "Kiểm tra Đăng nhập thành công")
    public void testSuccessfulLogin() {

        performLogin(uniqueEmail, REG_PASSWORD);

        wait.until(ExpectedConditions.urlToBe(HOME_PAGE_URL));

        Assert.assertEquals(driver.getCurrentUrl(), HOME_PAGE_URL);
    }

    @Test(priority = 4, description = "Kiểm tra Đăng nhập thất bại (Mật khẩu sai)")
    public void testFailedLogin() {

        performLogin(VALID_EMAIL, INVALID_PASSWORD);

        Assert.assertEquals(driver.getCurrentUrl(), LOGIN_PAGE_URL);

        WebElement errorAlert = wait.until(ExpectedConditions.visibilityOfElementLocated(
                By.cssSelector(".alert-error-custom")));
        Assert.assertTrue(errorAlert.isDisplayed());
    }

    @AfterClass
    public void tearDown() {
        if (driver != null) driver.quit();
    }
}
