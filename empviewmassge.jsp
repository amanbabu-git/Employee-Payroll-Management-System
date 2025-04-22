<%@ page import="java.sql.*" %>
<html>
<head>
  <title>Your Messages</title>
  <style>
    table {
      width: 90%;
      margin: 20px auto;
      border-collapse: collapse;
    }
    th, td {
      padding: 12px;
      border: 1px solid #ccc;
    }
    th {
      background: #eee;
    }
  </style>
</head>
<body>
  <h2 align="center">Your Messages</h2>
  <table>
    <tr>
      <th>ID</th>
      <th>Sender</th>
      <th>Message</th>
      <th>Reply</th>
      <th>Sent At</th>
    </tr>

<%
    String employeeEmail = "employee@example.com"; // Replace this with dynamic employee email if needed
    try {
        // Database connection
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/EmployeeDB1", "root", "abhi@11");

        // Query to fetch messages for the employee
        String query = "SELECT * FROM messages WHERE receiver = ?";
        PreparedStatement pstmt = con.prepareStatement(query);
        pstmt.setString(1, employeeEmail);
        
        ResultSet rs = pstmt.executeQuery();

        while(rs.next()) {
            int id = rs.getInt("id");
            String sender = rs.getString("sender");
            String message = rs.getString("message");
            String reply = rs.getString("reply");
            Timestamp sentAt = rs.getTimestamp("sent_at");
%>
    <tr>
        <td><%= id %></td>
        <td><%= sender %></td>
        <td><%= message %></td>
        <td><%= reply != null ? reply : "No reply yet" %></td>
        <td><%= sentAt %></td>
    </tr>
<%
        }
        con.close();
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>
  </table>
</body>
</html>
