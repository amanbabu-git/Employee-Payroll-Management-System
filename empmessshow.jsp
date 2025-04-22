<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>All Messages - Admin View</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(to right, #bdc3c7, #2c3e50);
            margin: 0;
            padding: 20px;
            color: #333;
        }
        h2 {
            text-align: center;
            color: #fff;
        }
        table {
            width: 100%;
            margin-top: 20px;
            border-collapse: collapse;
            background: #fff;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        th, td {
            padding: 12px 15px;
            text-align: center;
            border-bottom: 1px solid #ddd;
        }
        th {
            background-color: #34495e;
            color: white;
        }
        tr:hover {
            background-color: #f2f2f2;
        }
        .no-data {
            text-align: center;
            padding: 20px;
            color: red;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <h2>All Messages</h2>
    <%
        Connection con = null;
        Statement stmt = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/EmployeeDB1", "root", "abhi@11");
            stmt = con.createStatement();

            String query = "SELECT * FROM messages ORDER BY sent_at DESC";
            rs = stmt.executeQuery(query);

            boolean hasData = false;
    %>
    <table>
        <tr>
            <th>ID</th>
            <th>Sender Email</th>
            <th>Receiver Email</th>
            <th>Message</th>
            <th>Reply</th>
            <th>Sent At</th>
        </tr>
        <%
            while (rs.next()) {
                hasData = true;
        %>
        <tr>
            <td><%= rs.getInt("id") %></td>
            <td><%= rs.getString("sender_email") %></td>
            <td><%= rs.getString("receiver_email") %></td>
            <td><%= rs.getString("message") %></td>
            <td><%= rs.getString("reply") %></td>
            <td><%= rs.getTimestamp("sent_at") %></td>
        </tr>
        <%
            }
        %>
    </table>
    <%
        if (!hasData) {
    %>
        <p class="no-data">No messages found in the system.</p>
    <%
        }

        } catch (Exception e) {
            out.println("<p class='no-data'>Error: " + e.getMessage() + "</p>");
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                out.println("<p class='no-data'>Error closing resources: " + e.getMessage() + "</p>");
            }
        }
    %>
</body>
</html>
