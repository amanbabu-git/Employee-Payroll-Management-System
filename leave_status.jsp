<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    if (session.getAttribute("employee_id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int empId = (int) session.getAttribute("employee_id");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Leave Request Status</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: #f7f7f7;
            margin: 0;
            padding: 0;
        }

        .logo-container {
            text-align: center;
            padding-top: 30px;
        }

        .logo-container img {
            height: 80px;
        }

        h1 {
            text-align: center;
            font-size: 32px;
            margin-top: 10px;
            margin-bottom: 30px;
            color: #333;
        }

        table {
            width: 90%;
            margin: auto;
            border-collapse: collapse;
            background: white;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        }

        th, td {
            padding: 14px 20px;
            border: 1px solid #ccc;
            text-align: center;
        }

        th {
            background-color: #000;
            color: white;
        }

        td {
            color: #333;
        }
    </style>
</head>
<body>

<div class="logo-container">
    <img src="logo.png" alt="Company Logo">
</div>

<h1>Leave Request Status</h1>

<table>
    <tr>
        <th>Employee Id</th>
        <th>Employee Name</th>
        <th>From Date</th>
        <th>To Date</th>
        <th>Reason</th>
        <th>Leave Status</th>
    </tr>
<%
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/EmployeeDB1", "root", "abhi@11");

        PreparedStatement pst = con.prepareStatement("SELECT * FROM leave_requests WHERE employee_id = ?");
        pst.setInt(1, empId);
        ResultSet rs = pst.executeQuery();

        while (rs.next()) {
%>
    <tr>
        <td><%= rs.getInt("employee_id") %></td>
        <td><%= rs.getString("employee_name") %></td>
        <td><%= rs.getDate("from_date") %></td>
        <td><%= rs.getDate("to_date") %></td>
        <td><%= rs.getString("reason") %></td>
        <td><%= rs.getString("status") %></td>
    </tr>
<%
        }
        con.close();
    } catch (Exception e) {
        out.println("<tr><td colspan='6'>Error: " + e.getMessage() + "</td></tr>");
    }
%>
</table>

</body>
</html>
