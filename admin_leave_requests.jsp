<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Employee Leave Request</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(135deg, #fdfcfb, #e2d1c3);
            margin: 0;
            padding: 0;
        }

        header {
            background-color: #607975;
            color: white;
            padding: 20px 0;
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
            max-width: 1100px;
            margin: 40px auto;
            padding: 20px;
            background: rgba(255, 255, 255, 0.85);
            border-radius: 16px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.08);
        }

        .back-button {
            display: inline-block;
            background-color: #ff6a00;
            color: white;
            padding: 12px 26px;
            font-size: 1rem;
            font-weight: 500;
            text-decoration: none;
            border-radius: 10px;
            border: none;
            cursor: pointer;
            transition: background-color 0.3s ease;
            margin-bottom: 30px;
        }

        .back-button:hover {
            background-color: #e95c00;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background-color: white;
        }

        th, td {
            padding: 16px;
            border: 1px solid #ddd;
            text-align: center;
            font-size: 15px;
        }

        th {
            background-color: #2d3436;
            color: white;
        }

        tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        .btn-approve,
        .btn-reject {
            padding: 8px 16px;
            font-size: 0.95rem;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            color: white;
            transition: 0.3s ease;
        }

        .btn-approve {
            background-color: #28a745;
        }

        .btn-approve:hover {
            background-color: #218838;
        }

        .btn-reject {
            background-color: #dc3545;
        }

        .btn-reject:hover {
            background-color: #c82333;
        }

        footer {
            margin-top: 60px;
            text-align: center;
            padding: 20px;
            background-color: #ececec;
            font-size: 0.9rem;
            color: #666;
        }

        @media (max-width: 768px) {
            th, td {
                font-size: 13px;
                padding: 10px;
            }

            .btn-approve, .btn-reject {
                padding: 6px 12px;
                font-size: 0.85rem;
            }

            .back-button {
                padding: 10px 20px;
                font-size: 0.9rem;
            }
        }
    </style>
</head>
<body>
    <header>
        <h2>
            <img src="logo.png" alt="Company Logo">
            <span>Employee Leave Requests</span>
        </h2>
    </header>
    
    <div class="container">
        <a href="admin-home.html" class="back-button">← Back to Dashboard</a>

        <table>
            <tr>
                <th>Employee ID</th>
                <th>Employee Name</th>
                <th>From Date</th>
                <th>To Date</th>
                <th>Reason</th>
                <th>Status</th>
                <th>Action</th>
            </tr>

            <%
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/EmployeeDB1", "root", "abhi@11");
                    PreparedStatement pst = con.prepareStatement("SELECT * FROM leave_requests");
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
                    <td>
                        <form method="post" action="update_leave_status.jsp" style="display:inline;">
                            <input type="hidden" name="leave_id" value="<%= rs.getInt("leave_id") %>">
                            <input type="hidden" name="action" value="Approved">
                            <button type="submit" class="btn-approve">Approve</button>
                        </form>
                        <form method="post" action="update_leave_status.jsp" style="display:inline;">
                            <input type="hidden" name="leave_id" value="<%= rs.getInt("leave_id") %>">
                            <input type="hidden" name="action" value="Rejected">
                            <button type="submit" class="btn-reject">Reject</button>
                        </form>
                    </td>
                </tr>
            <%
                    }
                    con.close();
                } catch (Exception e) {
                    out.println("<tr><td colspan='7'>Error: " + e.getMessage() + "</td></tr>");
                }
            %>
        </table>
    </div>

    <footer>
        &copy; 2025 Employee Management System. All rights reserved.
    </footer>
</body>
</html>
