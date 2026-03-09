package com.traffic.controller;

import java.io.IOException;
import com.traffic.model.Owner;
import com.traffic.service.OwnerService;
import com.traffic.service.OwnerServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/OwnerController")
public class OwnerController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    OwnerService ownerService = new OwnerServiceImpl();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String base = request.getContextPath();

        if (action.equals("add")) {
            Owner owner = new Owner();
            owner.setName(request.getParameter("name"));
            owner.setMobile(request.getParameter("mobile"));
            owner.setAddress(request.getParameter("address"));
            owner.setUserId(Integer.parseInt(request.getParameter("userId")));
            boolean result = ownerService.addOwner(owner);
            response.sendRedirect(base + (result ? "/admin/owners.jsp?msg=Owner Added Successfully" : "/admin/owners.jsp?error=Failed to add owner"));
        }
        else if (action.equals("update")) {
            Owner owner = new Owner();
            owner.setOwnerId(Integer.parseInt(request.getParameter("ownerId")));
            owner.setName(request.getParameter("name"));
            owner.setMobile(request.getParameter("mobile"));
            owner.setAddress(request.getParameter("address"));
            boolean result = ownerService.updateOwner(owner);
            response.sendRedirect(base + (result ? "/admin/owners.jsp?msg=Owner Updated Successfully" : "/admin/owners.jsp?error=Update Failed"));
        }
        else if (action.equals("delete")) {
            int ownerId = Integer.parseInt(request.getParameter("ownerId"));
            boolean result = ownerService.deleteOwner(ownerId);
            response.sendRedirect(base + (result ? "/admin/owners.jsp?msg=Owner Deleted Successfully" : "/admin/owners.jsp?error=Delete Failed"));
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/admin/owners.jsp");
    }
}
