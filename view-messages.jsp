<%@ page import="java.sql.*" %>
<html>
<head>
  <title>View Messages</title>
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
    .reply-btn {
      background-color: #4CAF50;
      color: white;
      padding: 6px 12px;
      border: none;
      border-radius: 4px;
      cursor: pointer;
    }
    .reply-btn:hover {
      background-color: #45a049;
    }
  </style>
</head>
<body>
  <h2 align="center">Contact Form Messages</h2>
  <table>
    <tr>
      <th>ID</th>
      <th>Name</th>
      <th>Email</th>
      <th>Message</th>
      <th>Submitted At</th>
      <th>Action</th>
    </tr>
<%
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/EmployeeDB1", "root", "abhi@11");
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT * FROM contact_messages");

        while(rs.next()) {
            int id = rs.getInt("id");
            String name = rs.getString("name");
            String email = rs.getString("email");
            String message = rs.getString("message");
            Timestamp submittedAt = rs.getTimestamp("submitted_at");
%>
    <tr>
        <td><%= id %></td>
        <td><%= name %></td>
        <td><%= email %></td>
        <td><%= message %></td>
        <td><%= submittedAt %></td>
        <td>
          <form action="reply.jsp" method="post">
            <input type="hidden" name="email" value="<%= email %>">
            <input type="hidden" name="name" value="<%= name %>">
            <input type="hidden" name="message" value="<%= message %>">
            <button class="reply-btn" type="submit">Reply</button>
          </form>
        </td>
    </tr>
<%
        }
        con.close();
    } catch(Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>
  </table>
</body>
</html>
