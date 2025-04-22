<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Attendance Entry</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        * {
            box-sizing: border-box;
            font-family: 'Segoe UI', sans-serif;
        }

        body {
            margin: 0;
            padding: 0;
            background: linear-gradient(to right, #fceabb, #f8b500);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .container {
            background-color: #fff;
            padding: 40px 30px;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            max-width: 500px;
            width: 90%;
            text-align: center;
        }

        .logo {
            margin-bottom: 20px;
        }

        .logo img {
            height: 60px;
        }

        h1 {
            margin-bottom: 30px;
            color: #333;
            font-size: 26px;
        }

        label {
            font-weight: 600;
            color: #444;
            margin-bottom: 8px;
            display: block;
            text-align: left;
        }

        select, input[type="date"], input[type="text"] {
            width: 100%;
            padding: 12px;
            border-radius: 12px;
            border: 2px solid #f8b500;
            margin-bottom: 25px;
            font-size: 16px;
            transition: 0.3s ease;
        }

        input:focus, select:focus {
            border-color: #ff6a00;
            box-shadow: 0 0 8px rgba(255, 106, 0, 0.3);
            outline: none;
        }

        .radio-group {
            display: flex;
            justify-content: space-between;
            margin-bottom: 30px;
        }

        .radio-group label {
            font-weight: normal;
            color: #333;
            display: flex;
            align-items: center;
        }

        .radio-group input {
            margin-right: 8px;
        }

        .btn-submit {
            width: 100%;
            padding: 14px;
            background-color: #ff6a00;
            border: none;
            border-radius: 30px;
            color: white;
            font-size: 17px;
            font-weight: bold;
            cursor: pointer;
            transition: background 0.3s ease;
        }

        .btn-submit:hover {
            background-color: #e65c00;
        }

        .back-button {
            display: block;
            margin: 20px auto 0;
            text-align: center;
            text-decoration: none;
            padding: 12px 24px;
            background-color: #ff6a00;
            color: white;
            border-radius: 30px;
            font-size: 16px;
            transition: background-color 0.3s ease;
        }

        .back-button:hover {
            background-color: #e95c00;
        }

        @media (max-width: 600px) {
            .radio-group {
                flex-direction: column;
                gap: 12px;
            }
        }
    </style>
</head>
<body>

<div class="container">
    <div class="logo">
        <img src="logo.png" alt="Company Logo">
    </div>

    <h1>Employee Attendance</h1>

    <form action="save_attendance.jsp" method="post">

        <label for="empid">Employee ID</label>
        <select name="empid" id="empid" required>
            <option value="">Select Employee</option>
            <% 
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/EmployeeDB1", "root", "abhi@11");
                    Statement stmt = con.createStatement();
                    ResultSet rs = stmt.executeQuery("SELECT id, name FROM Employee");

                    while (rs.next()) {
                        int empId = rs.getInt("id");
                        String empName = rs.getString("name");
            %>
                <option value="<%= empId %>"><%= empId %> - <%= empName %></option>
            <%
                    }
                    rs.close();
                    stmt.close();
                    con.close();
                } catch (Exception e) {
            %>
                <option disabled>Error loading employees</option>
            <%
                }
            %>
        </select>

        <label for="date">Date</label>
        <input type="date" name="date" id="date" required>

        <label>Attendance</label>
        <div class="radio-group">
            <label><input type="radio" name="status" value="Present" required> Present</label>
            <label><input type="radio" name="status" value="Absent"> Absent</label>
        </div>

        <button type="submit" class="btn-submit">Submit</button>
    </form>

    <a href="admin-home.html" class="back-button">⬅ Back to Dashboard</a>
</div>

</body>
</html>
