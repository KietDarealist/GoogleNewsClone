package com.example.googlenewsclone.controller;

import com.example.googlenewsclone.beans.User;
import com.example.googlenewsclone.services.UserService;
import com.example.googlenewsclone.utils.ServletUtils;
import org.mindrot.jbcrypt.BCrypt;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Date;
import java.time.LocalDate;

@WebServlet(name = "AccountServlet", value = "/Account/*")
public class AccountServlet extends HttpServlet {
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
            case "/Profile":
                //Check xem user da login chua
                session = request.getSession();
                if(!((boolean) session.getAttribute("auth"))){
                    ServletUtils.redirect("/Account/Login", request, response);
                } else {
                    int id = 0;
                    try{
                        id = Integer.parseInt(request.getParameter("id"));
                    }catch (NumberFormatException e){

                    }
                    User user = UserService.findByID(id);
                    request.setAttribute("profileUser", user);
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
            case "/Update":
                updateUser(request, response);
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
        if (UserService.findByUsername(username).getUsername().equals(username)){
            request.setAttribute("message", "Tên người dùng đã tồn tại, vui lòng chọn tên khác");
        } else {
            UserService.add(u);
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
                request.setAttribute("message", "Mật khẩu không chính xác. Vui lòng thử lại");
                ServletUtils.forward("/views/vwAccount/login.jsp", request, response);
            } else {
                HttpSession session = request.getSession();
                session.setAttribute("auth", true);
                session.setAttribute("authUser", u);
                if(perm == 1){
                    ServletUtils.redirect(url, request, response);
                } else if(perm == 2){
                    url = "/Staff/Writer";
                    ServletUtils.redirect(url, request, response);
                } else if (perm == 3){
                    url = "/Staff/Editor";
                    ServletUtils.redirect(url, request, response);
                } else if(perm == 4){
                    url = "/Staff/Admin";
                    ServletUtils.redirect(url, request, response);
                }
            }
        } else{
            request.setAttribute("hasError", true);
            request.setAttribute("message", "Không tìm thấy tài khoản. Vui lòng thử lại");
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
        int userid = Integer.parseInt(request.getParameter("userid"));
        String firstname = request.getParameter("firstname");
        String lastname = request.getParameter("lastname");
        Date dob = Date.valueOf(request.getParameter("dob"));
        String email = request.getParameter("email");

        User u = new User(userid, firstname, lastname, dob, email);
        UserService.update(u);
        ServletUtils.redirect("/Account/Profile?id=" + request.getParameter("userid"), request, response);
    }
}