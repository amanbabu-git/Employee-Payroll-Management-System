<%@ page import="java.sql.*" %>
<%
    String empid = request.getParameter("empid");
    String date = request.getParameter("date");
    String status = request.getParameter("status");

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/EmployeeDB1", "root", "abhi@11");

        PreparedStatement pst = con.prepareStatement("INSERT INTO attendance(employee_id, date, status) VALUES (?, ?, ?)");
        pst.setString(1, empid);
        pst.setString(2, date);
        pst.setString(3, status);

        int row = pst.executeUpdate();
        if (row > 0) {
            out.println("<script>alert('Attendance saved successfully'); window.location='attendance.jsp';</script>");
        } else {
            out.println("<script>alert('Failed to save attendance'); window.location='attendance.jsp';</script>");
        }

        con.close();
    } catch (Exception e) {
        out.println("<script>alert('Error: " + e.getMessage() + "');</script>");
    }
%>
