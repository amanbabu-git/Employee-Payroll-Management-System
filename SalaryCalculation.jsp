<%@ page import="java.sql.*, java.time.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
<head>
    <title>Salary Calculation</title>
    <style>
        body {
            font-family: Arial;
            background-color: #f2f2f2;
        }

        .box {
            width: 450px;
            margin: 50px auto;
            background: #fff;
            padding: 25px;
            border: 2px solid orange;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }

        .logo {
            text-align: center;
            margin-bottom: 20px;
        }

        .logo img {
            height: 60px;
        }

        input, select, button {
            width: 100%;
            padding: 10px;
            margin-top: 12px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }

        label {
            font-weight: bold;
            margin-top: 10px;
            display: block;
        }

        button {
            background-color: orange;
            color: white;
            border: none;
            cursor: pointer;
            font-size: 16px;
        }

        button:hover {
            background-color: darkorange;
        }
    </style>
</head>
<body>
<div class="box">
    <div class="logo">
        <img src="logo.png" alt="Company Logo">
    </div>

    <form method="post">
        <label>Employee:</label>
        <select name="empId" required>
            <option value="">Select Employee</option>

            <%
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/EmployeeDB1", "root", "abhi@11");
                    Statement st = con.createStatement();
                    ResultSet empRs = st.executeQuery("SELECT id, name FROM employee");

                    String selectedEmp = request.getParameter("empId");

                    while (empRs.next()) {
                        int id = empRs.getInt("id");
                        String name = empRs.getString("name");
                        String selected = (selectedEmp != null && selectedEmp.equals(String.valueOf(id))) ? "selected" : "";
            %>
                <option value="<%= id %>" <%= selected %>><%= id %> - <%= name %></option>
            <%
                    }
                    empRs.close();
                    st.close();
                    con.close();
                } catch (Exception e) {
            %>
                <option disabled>Error loading employees</option>
            <%
                }
            %>
        </select>

        <label>Select Month:</label>
        <input type="month" name="monthYear" value="<%= request.getParameter("monthYear") != null ? request.getParameter("monthYear") : "" %>" required />

        <button type="submit">Submit</button>
    </form>

<%
    String empIdStr = request.getParameter("empId");
    String monthYear = request.getParameter("monthYear");

    if (empIdStr != null && monthYear != null) {
        int empId = Integer.parseInt(empIdStr);
        int year = Integer.parseInt(monthYear.split("-")[0]);
        int month = Integer.parseInt(monthYear.split("-")[1]);

        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/EmployeeDB1", "root", "abhi@11");

            String query = "SELECT COUNT(*) AS present_days FROM attendance WHERE employee_id = ? AND status = 'Present' AND MONTH(date) = ? AND YEAR(date) = ?";
            pst = conn.prepareStatement(query);
            pst.setInt(1, empId);
            pst.setInt(2, month);
            pst.setInt(3, year);
            rs = pst.executeQuery();

            if (rs.next() && rs.getInt("present_days") > 0) {
                int presentDays = rs.getInt("present_days");
                int totalDays = YearMonth.of(year, month).lengthOfMonth();
                int absentDays = totalDays - presentDays;

                pst = conn.prepareStatement("SELECT basic_salary FROM employee WHERE id = ?");
                pst.setInt(1, empId);
                rs = pst.executeQuery();

                if (rs.next()) {
                    double basicSalary = rs.getDouble("basic_salary");
                    double perDay = basicSalary / totalDays;
                    double deduction = perDay * absentDays;
                    double netSalary = basicSalary - deduction;

%>
    <hr/>
    <form method="post" action="SalarySlip.jsp">
        <input type="hidden" name="empId" value="<%= empId %>" />
        <input type="hidden" name="monthYear" value="<%= monthYear %>" />

        <label>Present Days:</label>
        <input type="text" name="presentDays" value="<%= presentDays %>" readonly />

        <label>Basic Salary:</label>
        <input type="text" name="basicSalary" value="<%= basicSalary %>" readonly />

        <label>Deductions:</label>
        <input type="text" name="deductions" value="<%= String.format("%.2f", deduction) %>" readonly />

        <label>Net Salary:</label>
        <input type="text" name="netSalary" value="<%= String.format("%.2f", netSalary) %>" readonly />

        <button type="submit">Generate Payslip</button>
    </form>
<%
                } else {
%>
    <p style="color: red;">Employee not found in database.</p>
<%
                }
            } else {
%>
    <p style="color: red;">No attendance record found for this employee in the selected month.</p>
<%
            }
        } catch (Exception e) {
%>
    <p style="color: red;">Error: <%= e.getMessage() %></p>
<%
        } finally {
            if (rs != null) rs.close();
            if (pst != null) pst.close();
            if (conn != null) conn.close();
        }
    }
%>
</div>
</body>
</html>
