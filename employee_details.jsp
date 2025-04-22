<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Employee Details</title>
    <style>
        * {
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', sans-serif;
            margin: 0;
            padding: 0;
            background: linear-gradient(to right, #f5f7fa, #c3cfe2);
        }

        header {
            background-color: #5a7f9b;
            color: white;
            padding: 25px 0;
            text-align: center;
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
        }

        header h2 {
            margin: 0;
            font-size: 30px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 15px;
        }

        header img {
            height: 50px;
        }

        .container {
            max-width: 95%;
            margin: 40px auto;
            padding: 30px;
            background: #ffffff;
            border-radius: 20px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.1);
        }

        .back-button {
            display: inline-block;
            background-color: #ff6a00;
            color: white;
            padding: 12px 28px;
            font-size: 16px;
            font-weight: bold;
            border-radius: 10px;
            text-decoration: none;
            margin-bottom: 25px;
            transition: all 0.3s ease;
        }

        .back-button:hover {
            background-color: #e95c00;
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
            background-color: #fff;
        }

        th, td {
            padding: 14px;
            border: 1px solid #ccc;
            text-align: center;
            font-size: 15px;
        }

        th {
            background-color: #2f3542;
            color: white;
            letter-spacing: 0.5px;
        }

        tr:nth-child(even) {
            background-color: #f1f2f6;
        }

        tr:hover {
            background-color: #dfe4ea;
            transition: 0.2s;
        }

        .btn-approve,
        .btn-reject {
            padding: 8px 16px;
            font-size: 14px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            color: white;
            transition: background-color 0.3s ease, transform 0.2s;
        }

        .btn-approve {
            background-color: #27ae60;
        }

        .btn-approve:hover {
            background-color: #219150;
            transform: scale(1.05);
        }

        .btn-reject {
            background-color: #e74c3c;
        }

        .btn-reject:hover {
            background-color: #c0392b;
            transform: scale(1.05);
        }

        footer {
            text-align: center;
            padding: 20px;
            background-color: #1e272e;
            color: #ccc;
            margin-top: 50px;
        }

        @media screen and (max-width: 768px) {
            table, thead, tbody, th, td, tr {
                display: block;
            }

            tr {
                margin-bottom: 15px;
                border: 1px solid #ccc;
                border-radius: 10px;
                padding: 10px;
                background: #fff;
            }

            th {
                display: none;
            }

            td {
                text-align: right;
                position: relative;
                padding-left: 50%;
            }

            td::before {
                content: attr(data-label);
                position: absolute;
                left: 15px;
                width: 45%;
                font-weight: bold;
                text-align: left;
                color: #2f3542;
            }
        }
    </style>
</head>
<body>

<header>
    <h2>
        <img src="logo.png" alt="Company Logo">
        <span>All Employee Details</span>
    </h2>
</header>

<div class="container">
    <a href="admin-home.html" class="back-button">Back to Dashboard</a>

    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Father's Name</th>
                <th>DOB</th>
                <th>Email</th>
                <th>Phone</th>
                <th>Address</th>
                <th>Designation</th>
                <th>Joining Date</th>
                <th>Basic Salary</th>
                <th>Allowance</th>
                <th>Status</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
        <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/EmployeeDB1", "root", "abhi@11");

                // Handle Approve/Reject form submission
                String empId = request.getParameter("empId");
                String action = request.getParameter("action");
                if (empId != null && action != null) {
                    PreparedStatement updateStatus = con.prepareStatement("UPDATE Employee SET status = ? WHERE id = ?");
                    updateStatus.setString(1, action);
                    updateStatus.setInt(2, Integer.parseInt(empId));
                    updateStatus.executeUpdate();
                }

                Statement st = con.createStatement();
                ResultSet rs = st.executeQuery("SELECT * FROM Employee");

                while (rs.next()) {
        %>
            <tr>
                <td data-label="ID"><%= rs.getInt("id") %></td>
                <td data-label="Name"><%= rs.getString("name") %></td>
                <td data-label="Father's Name"><%= rs.getString("father_name") %></td>
                <td data-label="DOB"><%= rs.getDate("dob") %></td>
                <td data-label="Email"><%= rs.getString("email") %></td>
                <td data-label="Phone"><%= rs.getString("phone") %></td>
                <td data-label="Address"><%= rs.getString("address") %></td>
                <td data-label="Designation"><%= rs.getString("designation") %></td>
                <td data-label="Joining Date"><%= rs.getDate("date_of_joining") %></td>
                <td data-label="Basic Salary"><%= rs.getDouble("basic_salary") %></td>
                <td data-label="Allowance"><%= rs.getDouble("allowance") %></td>
                <td data-label="Status"><%= rs.getString("status") %></td>
                <td data-label="Action">
                    <form method="post">
                        <input type="hidden" name="empId" value="<%= rs.getInt("id") %>">
                        <button class="btn-approve" name="action" value="Approved">Approve</button>
                        <button class="btn-reject" name="action" value="Rejected">Reject</button>
                    </form>
                </td>
            </tr>
        <%
                }
                con.close();
            } catch(Exception e){
                out.println("<tr><td colspan='13'>Error: " + e.getMessage() + "</td></tr>");
            }
        %>
        </tbody>
    </table>
</div>

<footer>
    &copy; 2025 Employee Management System. All rights reserved.
</footer>

</body>
</html>
