<%@ page import="java.sql.*" %>
<%
    int leaveId = Integer.parseInt(request.getParameter("leave_id"));
    String action = request.getParameter("action");

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/EmployeeDB1", "root", "abhi@11");

        PreparedStatement pst = con.prepareStatement("UPDATE leave_requests SET status = ? WHERE leave_id = ?");
        pst.setString(1, action);
        pst.setInt(2, leaveId);
        pst.executeUpdate();

        con.close();
        response.sendRedirect("admin_leave_requests.jsp");
    } catch (Exception e) {
        out.println("<script>alert('Error: " + e.getMessage() + "');</script>");
    }
%>
