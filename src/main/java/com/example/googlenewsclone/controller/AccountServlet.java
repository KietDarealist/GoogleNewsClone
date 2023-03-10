package com.example.googlenewsclone.controller;

import com.example.googlenewsclone.beans.User;
import com.example.googlenewsclone.services.EmailService;
import com.example.googlenewsclone.services.UserService;
import com.example.googlenewsclone.utils.ServletUtils;
import com.example.googlenewsclone.utils.VerifyRecaptcha;
import org.mindrot.jbcrypt.BCrypt;

import javax.mail.MessagingException;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;


@WebServlet(name = "AccountServlet", value = "/Account/*")
public class AccountServlet extends HttpServlet {
    private String host;
    private String port;
    private String user;
    private String pass;

    public void init() {
        ServletContext context = getServletContext();
        host = context.getInitParameter("host");
        port = context.getInitParameter("port");
        user = context.getInitParameter("user");
        pass = System.getenv("SMTP_PASSWORD");
    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getPathInfo();
        if(path == null || path.equals("/")){
            path = "/Index";
        }
        HttpSession session;
        switch (path){
            case "/Login":
                session = request.getSession();
                if((boolean) session.getAttribute("auth")){
                    ServletUtils.redirect("/Home", request, response);
                } else ServletUtils.forward("/views/vwAccount/login.jsp", request, response);
                break;
            case "/Register":
                ServletUtils.forward("/views/vwAccount/register.jsp", request, response);
                break;
            case "/ForgetPassword":
                ServletUtils.forward("/views/vwAccount/recovery.jsp", request, response);
                break;
            case "/Verify":
                String otp = request.getParameter("otp");
                User u = UserService.findUserByOTP(otp);
                if(u != null){
                    //Sau khi ???? verify r???i th?? s??? x??a OTP c???a user ????
                    UserService.deleteOTP(u.getUserID());

                    request.setAttribute("verifiedUser", u);
                    ServletUtils.forward("/views/vwAccount/newpwd.jsp", request, response);
                }
                else {
                    request.setAttribute("errVerify","M?? OTP kh??ng ????ng!");
                    ServletUtils.forward("/views/vwAccount/recovery.jsp", request, response);
                }
                    break;
            case "/Profile":
                //Check xem user da login chua
                session = request.getSession();
                if(!((boolean) session.getAttribute("auth"))){
                    ServletUtils.redirect("/Account/Login", request, response);
                } else {
                    ServletUtils.forward("/views/vwAccount/profile.jsp", request, response);
                }
                break;
            default:
                ServletUtils.forward("/views/404.jsp", request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getPathInfo();
        switch (path) {
            case "/Login":
                loginUser(request, response);
                break;
            case "/Logout":
                logoutUser(request, response);
                break;
            case "/Register":
                registerUser(request, response);
                break;
            case "/Update":
                updateUser(request, response);
                break;
            case "/ForgetPassword":
                forgetPassword(request, response);
                break;
            case "/UpdatePassword":
                updatePassword(request, response);
                break;
            default:
                ServletUtils.forward("/views/404.jsp", request, response);
                break;
        }
    }
    private static void registerUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String name = request.getParameter("name");
        String password = BCrypt.hashpw(request.getParameter("password"), BCrypt.gensalt());
        String username = request.getParameter("username");
        int role = Integer.parseInt(request.getParameter("roles"));

        Date issue_at = Date.valueOf(LocalDate.now());
        int expiration = 10080; // 7 days

        User u = new User(username, password, name, issue_at, expiration, role, email);
        if(UserService.findByUsername(username) != null){
                request.setAttribute("existedUser", "T??n ng?????i d??ng ???? t???n t???i, vui l??ng ch???n t??n kh??c");
            } else {
                String gRecaptchaResponse = request.getParameter("g-recaptcha-response");
                boolean verify = VerifyRecaptcha.verify(gRecaptchaResponse);
                if(verify){
                    UserService.add(u);
                    request.setAttribute("successfulRegistration", "????ng k?? th??nh c??ng!");
                } else request.setAttribute("errRegistration", "B???n ch??a x??c th???c Captcha!");
            }
        ServletUtils.forward("/views/vwAccount/register.jsp", request, response);
    }

    private static void loginUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String url = "/Home";

        User u = UserService.findByUsername(username);
        if(u != null){
            boolean isAuthenticated = BCrypt.checkpw(password, u.getPassword());
            int perm = u.getRoleID();
            if(!isAuthenticated){
                request.setAttribute("hasError", true);
                request.setAttribute("message", "M???t kh???u kh??ng ch??nh x??c. Vui l??ng th??? l???i");
                ServletUtils.forward("/views/vwAccount/login.jsp", request, response);
            } else {
                HttpSession session = request.getSession();
                session.setAttribute("auth", true);
                session.setAttribute("authUser", u);
                if(perm == 1){
                    ServletUtils.redirect(url, request, response);
                } else if(perm == 2){
                    url = "/Staff/Writer/Index?statusid=0&page=1";
                    ServletUtils.redirect(url, request, response);
                } else if (perm == 3){
                    url = "/Staff/Editor/Index?statusid=0&page=1";
                    ServletUtils.redirect(url, request, response);
                } else if(perm == 4){
                    url = "/Staff/Admin/User?page=1";
                    ServletUtils.redirect(url, request, response);
                }
            }
        } else{
            request.setAttribute("hasError", true);
            request.setAttribute("message", "Kh??ng t??m th???y t??i kho???n. Vui l??ng th??? l???i");
            ServletUtils.forward("/views/vwAccount/login.jsp", request, response);
        }
    }
    private static void logoutUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        session.setAttribute("auth", false);
        session.setAttribute("authUser", new User());
        String url ="/Home";
        ServletUtils.redirect(url, request, response);
    }
    private static void updateUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        int userid = Integer.parseInt(request.getParameter("userid"));
        String username = ((User) session.getAttribute("authUser")).getUsername();

        String firstname = request.getParameter("firstname");
        String lastname = request.getParameter("lastname");
        Date dob = Date.valueOf(request.getParameter("dob"));
        String email = request.getParameter("email");

        User u = new User(userid, username, firstname, lastname, dob, email);
        UserService.update(u);

        //C???p nh???t l???i session v???i th??ng tin user v???a update
        session.setAttribute("authUser", u);
        request.setAttribute("successfulUpdate", "C???p nh???t th??ng tin th??nh c??ng!");
        ServletUtils.forward("/views/vwAccount/profile.jsp", request, response);
    }
    private void forgetPassword(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String email = request.getParameter("email");
            EmailService.sendEmail(host, port, user, pass, email, "m?? OTP x??c th???c ????? kh??i ph???c m???t kh???u",
                    EmailService.recoveryEmail, new User());
            request.setAttribute("message", "Vui l??ng ki???m tra Email c???a b???n!");
            ServletUtils.forward("/views/vwAccount/recovery.jsp", request, response);
        } catch (MessagingException e) {
            throw new RuntimeException(e);
        }
    }
    private static void updatePassword(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int userid = Integer.parseInt(request.getParameter("userid"));
        String password = BCrypt.hashpw(request.getParameter("password"), BCrypt.gensalt());
        UserService.updatePassword(userid, password);

        request.setAttribute("completeRecovery", "Kh??i ph???c m???t kh???u th??nh c??ng! H??y quay v??? trang ????ng nh???p");
        ServletUtils.forward("/views/vwAccount/recovery.jsp", request, response);
    }
}
