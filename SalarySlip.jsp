<%@ page import="java.sql.*, java.text.DecimalFormat, java.time.*, java.time.format.*" %>
<%! 
    public static String convertToWords(int n) {
        String[] units = {
            "", "One", "Two", "Three", "Four", "Five", "Six",
            "Seven", "Eight", "Nine", "Ten", "Eleven", "Twelve",
            "Thirteen", "Fourteen", "Fifteen", "Sixteen", "Seventeen",
            "Eighteen", "Nineteen"
        };

        String[] tens = {
            "", "", "Twenty", "Thirty", "Forty", "Fifty",
            "Sixty", "Seventy", "Eighty", "Ninety"
        };

        if (n == 0) return "Zero";

        String words = "";

        if ((n / 100000) > 0) {
            words += convertToWords(n / 100000) + " Lakh ";
            n %= 100000;
        }
        if ((n / 1000) > 0) {
            words += convertToWords(n / 1000) + " Thousand ";
            n %= 1000;
        }
        if ((n / 100) > 0) {
            words += convertToWords(n / 100) + " Hundred ";
            n %= 100;
        }
        if (n > 0) {
            if (!words.equals("")) words += "and ";
            if (n < 20) {
                words += units[n];
            } else {
                words += tens[n / 10];
                if ((n % 10) > 0) {
                    words += " " + units[n % 10];
                }
            }
        }
        return words.trim();
    }
%>

<%
    request.setCharacterEncoding("UTF-8");

    String empIdStr = request.getParameter("empId");
    String monthYear = request.getParameter("monthYear");

    int empId = empIdStr != null ? Integer.parseInt(empIdStr) : 0;
    int month = Integer.parseInt(monthYear.split("-")[1]);
    int year = Integer.parseInt(monthYear.split("-")[0]);

    int totalDays = YearMonth.of(year, month).lengthOfMonth();
    int presentDays = 0;
    int clDays = 0; // Number of CL (Casual Leave) days
    double basic = 0.0, perDay = 0.0, netPay = 0.0, deduction = 0.0;
    double da = 0.0, hra = 0.0, totalEarning = 0.0;
    double deductionForCL = 0.0;

    String empName = "", designation = "";
    DecimalFormat df = new DecimalFormat("0.00");

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/EmployeeDB1", "root", "abhi@11");

        // Fetch employee details
        PreparedStatement pst1 = con.prepareStatement("SELECT name, designation, basic_salary FROM employee WHERE id = ?");
        pst1.setInt(1, empId);
        ResultSet rs1 = pst1.executeQuery();
        if (rs1.next()) {
            empName = rs1.getString("name");
            designation = rs1.getString("designation");
            basic = rs1.getDouble("basic_salary");
        }
        rs1.close();
        pst1.close();

        // Fetch Present days
        PreparedStatement pst2 = con.prepareStatement(
            "SELECT COUNT(*) FROM attendance WHERE employee_id = ? AND status = 'Present' AND MONTH(date) = ? AND YEAR(date) = ?"
        );
        pst2.setInt(1, empId);
        pst2.setInt(2, month);
        pst2.setInt(3, year);
        ResultSet rs2 = pst2.executeQuery();
        if (rs2.next()) {
            presentDays = rs2.getInt(1);
        }
        rs2.close();
        pst2.close();

        // Fetch CL days if stored in a separate table (optional - you can skip this if not required)
        PreparedStatement pst3 = con.prepareStatement(
            "SELECT COUNT(*) FROM attendance WHERE employee_id = ? AND status = 'CL' AND MONTH(date) = ? AND YEAR(date) = ?"
        );
        pst3.setInt(1, empId);
        pst3.setInt(2, month);
        pst3.setInt(3, year);
        ResultSet rs3 = pst3.executeQuery();
        if (rs3.next()) {
            clDays = rs3.getInt(1);
        }
        rs3.close();
        pst3.close();

        con.close();

        perDay = basic / totalDays;
        da = basic * 0.20;
        hra = basic * 0.10;
        totalEarning = basic + da + hra;

        deductionForCL = clDays * perDay;
        netPay = (perDay * presentDays) + da + hra;
        deduction = totalEarning - netPay;

    } catch (Exception e) {
        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
    }

    String inWords = "";
    try {
        int rupeePart = (int) Math.round(netPay);
        inWords = convertToWords(rupeePart);
    } catch (Exception ex) {
        inWords = netPay + "";
    }
%>

<html>
<head>
    <title>Salary Slip</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f9f9f9; }
        .container {
            width: 800px;
            margin: 30px auto;
            padding: 30px;
            background: #fff;
            border: 2px solid orange;
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
        }
        h2, h3 { text-align: center; margin-bottom: 10px; }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 25px;
        }
        th, td {
            border: 1px solid #ccc;
            padding: 12px;
            text-align: left;
        }
        th { background-color: #f2f2f2; }
        .print-btn {
            text-align: center;
            margin-top: 30px;
        }
        .label { font-weight: bold; }
        .back-button {
            display: inline-block;
            background-color: #ff6a00;
            color: white;
            padding: 14px 28px;
            font-size: 1.1rem;
            font-weight: 500;
            text-decoration: none;
            border-radius: 12px;
            border: none;
            cursor: pointer;
            transition: background-color 0.3s ease;
            margin-top: 25px;
        }
        .back-button:hover {
            background-color: #e95c00;
        }
        .logo {
            display: block;
            margin: 0 auto 15px auto;
            height: 80px;
        }
    </style>
</head>
<body>
<div class="container">
    <img src="logo.png" alt="Company Logo" class="logo">

    <h2>Salary Slip</h2>
    <h3>Payment for: <%= monthYear %></h3>

    <p>
        <span class="label">EMP Code:</span> <%= empId %><br/>
        <span class="label">EMP Name:</span> <%= empName %><br/>
        <span class="label">Designation:</span> <%= designation %><br/>
        <span class="label">Present Days:</span> <%= presentDays %> / <%= totalDays %><br/>
        <span class="label">CL Days:</span> <%= clDays %>
    </p>

    <table>
        <tr>
            <th colspan="2">Earnings</th>
            <th colspan="2">Deductions</th>
        </tr>
        <tr>
            <td>Basic</td><td><%= df.format(basic) %></td>
            <td>Deduction (For CL Days)</td><td><%= df.format(deductionForCL) %></td>
        </tr>
        <tr>
            <td>DA (20%)</td><td><%= df.format(da) %></td>
            <td colspan="2"></td>
        </tr>
        <tr>
            <td>HRA (10%)</td><td><%= df.format(hra) %></td>
            <td colspan="2"></td>
        </tr>
        <tr>
            <td><strong>Total Earnings</strong></td><td><%= df.format(totalEarning) %></td>
            <td><strong>Total Deductions</strong></td><td><%= df.format(deduction) %></td>
        </tr>
    </table>

    <p><strong>Net Pay:</strong> <%= df.format(netPay) %></p>
    <p><strong>In Words:</strong> <%= inWords %> Rupees only</p>

    <div class="print-btn">
        <button onclick="window.print()">Print</button> 
    </div>

    <center>
        <a href="admin-home.html" class="back-button">Back to Dashboard</a>
    </center>
</div>
</body>
</html>
