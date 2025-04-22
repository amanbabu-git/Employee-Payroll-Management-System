<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>View Messages</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(to right, #83a4d4, #b6fbff);
            padding: 20px;
            margin: 0;
        }
        h2 {
            text-align: center;
            color: #333;
        }
        table {
            width: 100%;
            margin-top: 20px;
            border-collapse: collapse;
            background: #fff;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        th, td {
            padding: 12px 15px;
            border-bottom: 1px solid #ddd;
            text-align: center;
        }
        th {
            background-color: #1e88e5;
            color: white;
        }
        tr:hover {
            background-color: #f1f1f1;
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
    <h2>All Messages & Replies</h2>
    <%
        Connection con = null;
        Statement stmt = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/EmployeeDB1", "root", "abhi@11");
            stmt = con.createStatement();
            String sql = "SELECT * FROM messages ORDER BY sent_at DESC";
            rs = stmt.executeQuery(sql);

            boolean hasData = false;
    %>
    <table>
        <tr>
            <th>ID</th>
            <th>Sender</th>
            <th>Receiver</th>
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
            <td><%= rs.getString("sender") %></td>
            <td><%= rs.getString("receiver") %></td>
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
        <p class="no-data">No messages found.</p>
    <%
        }

        } catch (Exception e) {
            out.println("<p class='no-data'>Error: " + e.getMessage() + "</p>");
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (con != null) con.close();
        }
    %>
</body>
</html>
