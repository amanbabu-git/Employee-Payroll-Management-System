<%@ page import="java.sql.*" %>
<%
    String username = request.getParameter("username");
    String password = request.getParameter("password");

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/EmployeeDB1", "root", "abhi@11");

        PreparedStatement pst = con.prepareStatement(
            "SELECT * FROM users u JOIN Employee e ON u.employee_id = e.id WHERE u.username=? AND u.password=?");
        pst.setString(1, username);
        pst.setString(2, password);
        ResultSet rs = pst.executeQuery();

        if (rs.next()) {
            String status = rs.getString("status");
            String role = rs.getString("role");

            if (!"Approved".equalsIgnoreCase(status)) {
                out.println("<script>alert('Your account is not approved yet.'); window.location='login.jsp';</script>");
            } else {
                // Set session attributes
                session.setAttribute("username", username);
                session.setAttribute("role", role);
                session.setAttribute("employee_id", rs.getInt("employee_id"));
                session.setAttribute("employee_name", rs.getString("name"));

                // Redirect based on role
                if ("admin".equalsIgnoreCase(role)) {
                    response.sendRedirect("admin-home.html");
                } else {
                    response.sendRedirect("employee-dashboard.html");
                }
            }
        } else {
            out.println("<script>alert('Invalid username or password.'); window.location='login.jsp';</script>");
        }

        con.close();
    } catch (Exception e) {
        out.println("<script>alert('Error: " + e.getMessage() + "');</script>");
    }
%>
