<%@ page import="java.sql.*" %>
<%
    String email = request.getParameter("email");
    String name = request.getParameter("name");
    String message = request.getParameter("message");
    String reply = request.getParameter("reply");

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/EmployeeDB1", "root", "abhi@11");

        // Insert into messages table
        PreparedStatement ps = con.prepareStatement(
            "INSERT INTO messages (sender_email, receiver_email, message, reply) VALUES (?, ?, ?, ?)"
        );
        ps.setString(1, "admin@gmail.com"); // admin email (hardcoded or use session)
        ps.setString(2, email); // receiver = employee email
        ps.setString(3, message);
        ps.setString(4, reply);

        int i = ps.executeUpdate();
        if(i > 0) {
            out.println("<script>alert('Reply sent successfully!'); window.location='view-messages.jsp';</script>");
        } else {
            out.println("<script>alert('Failed to send reply'); history.back();</script>");
        }
        con.close();
    } catch(Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>
