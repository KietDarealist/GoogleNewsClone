package com.example.googlenewsclone.controller;

import com.example.googlenewsclone.beans.Category;
import com.example.googlenewsclone.beans.ParentCategory;
import com.example.googlenewsclone.services.CategoryService;
import com.example.googlenewsclone.services.ParentCategoryService;
import com.example.googlenewsclone.utils.ServletUtils;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "StaffServlet", value = "/Staff/*")
public class StaffServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getPathInfo();
        if(path == null || path.equals("/")){
            path = "/Index";
        }
        switch (path){
            case "/Index":
                List<ParentCategory> parentList = ParentCategoryService.findAll();
                List<Category> catList = CategoryService.findAll();
                request.setAttribute("parentCategories", parentList);
                request.setAttribute("categories", catList);
                ServletUtils.forward("/views/vwHome/index.jsp", request, response);
                break;
            case "/AddArticle":
                ServletUtils.forward("/views/vwWriter/addArticle.jsp", request, response);
                break;
            default:
                ServletUtils.forward("../../404.jsp", request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getPathInfo();
        switch (path) {
            case "/AddArticle":
                addArticle(request, response);
                break;
            default:
                ServletUtils.forward("../../views/404.jsp", request, response);
                break;
    }
}
    private static void addArticle(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        String content = request.getParameter("content");
        request.setAttribute("id", id);
        request.setAttribute("content", content);
        ServletUtils.forward("/views/vwWriter/addArticle.jsp", request, response);
    }
}
