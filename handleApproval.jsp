<%@ page import="java.sql.*" %>
<%
    String employeeId = request.getParameter("employeeId");
    String action = request.getParameter("action"); // "approve" or "reject"

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/EmployeeDB1", "root", "abhi@11");

        PreparedStatement ps = con.prepareStatement("UPDATE Employee SET status = ? WHERE id = ?");
        ps.setString(1, action); // assuming you have a 'status' column in your table
        ps.setInt(2, Integer.parseInt(employeeId));
        ps.executeUpdate();
        con.close();
        response.sendRedirect("employee_details.jsp");
    } catch(Exception e){
        out.println("Error: " + e.getMessage());
    }
%>
