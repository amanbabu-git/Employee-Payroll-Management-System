<%@ page import="java.sql.*, java.util.*" %>
<%
    if (session.getAttribute("employee_id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int empId = (int) session.getAttribute("employee_id");
    String empName = (String) session.getAttribute("employee_name");
    String fromDate = request.getParameter("fromDate");
    String toDate = request.getParameter("toDate");
    String reason = request.getParameter("reason");

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/EmployeeDB1", "root", "abhi@11");

        PreparedStatement pst = con.prepareStatement(
            "INSERT INTO leave_requests (employee_id, employee_name, from_date, to_date, reason) VALUES (?, ?, ?, ?, ?)"
        );
        pst.setInt(1, empId);
        pst.setString(2, empName);
        pst.setString(3, fromDate);
        pst.setString(4, toDate);
        pst.setString(5, reason);

        int rows = pst.executeUpdate();

        if (rows > 0) {
            response.sendRedirect("leave_status.jsp");
        } else {
            out.println("<script>alert('Leave request failed.'); history.back();</script>");
        }

        con.close();
    } catch (Exception e) {
        out.println("<script>alert('Error: " + e.getMessage() + "'); history.back();</script>");
    }
%>
