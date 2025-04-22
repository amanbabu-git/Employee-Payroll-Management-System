<%@ page import="java.sql.*" %>
<%
    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String message = request.getParameter("message");

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/EmployeeDB1", "root", "abhi@11");

        String sql = "INSERT INTO contact_messages (name, email, message) VALUES (?, ?, ?)";
        PreparedStatement pst = con.prepareStatement(sql);
        pst.setString(1, name);
        pst.setString(2, email);
        pst.setString(3, message);

        int rows = pst.executeUpdate();

        if (rows > 0) {
            out.println("<script>alert('Message sent successfully!'); window.location='employee-dashboard.html';</script>");
        } else {
            out.println("<script>alert('Message sending failed.'); window.location='employee-dashboard.html';</script>");
        }

        con.close();
    } catch (Exception e) {
        out.println("<script>alert('Error: " + e.getMessage() + "');</script>");
    }
%>
