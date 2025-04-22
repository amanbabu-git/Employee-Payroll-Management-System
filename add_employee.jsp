<%@ page import="java.sql.*, java.util.UUID, java.io.*" %>
<%@ page errorPage="error.jsp" %>

<html>
<head>
    <title>Add Employee</title>
    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(135deg, #fdfcfb, #e2d1c3);
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        .form-container {
            max-width: 650px;
            margin: 30px auto;
            background: rgba(255, 255, 255, 0.7);
            backdrop-filter: blur(12px);
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.1);
            animation: fadeIn 0.8s ease;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .back-button {
            display: inline-block;
            margin-bottom: 20px;
            color: #ff6a00;
            font-weight: bold;
            text-decoration: none;
            font-size: 1rem;
            transition: color 0.3s ease;
        }

        .back-button:hover {
            color: #e95c00;
            text-decoration: underline;
        }

        h2 {
            text-align: center;
            margin-bottom: 30px;
            color: #2d3436;
        }

        input[type="text"],
        input[type="email"],
        input[type="date"],
        input[type="number"],
        textarea {
            width: 100%;
            padding: 14px;
            margin-bottom: 20px;
            border: 1px solid #ddd;
            border-radius: 12px;
            font-size: 1rem;
            background-color: #fff;
            transition: 0.3s ease;
        }

        input:focus, textarea:focus {
            border-color: #ff6a00;
            outline: none;
            box-shadow: 0 0 5px rgba(255,106,0,0.3);
        }

        textarea {
            resize: vertical;
            min-height: 100px;
        }

        input[type="submit"] {
            background-color: #ff6a00;
            color: white;
            padding: 14px;
            font-size: 1.1rem;
            border: none;
            border-radius: 12px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        input[type="submit"]:hover {
            background-color: #e95c00;
        }

        .message {
            text-align: center;
            margin-top: 20px;
            font-weight: bold;
        }

        footer {
            margin-top: auto;
            text-align: center;
            padding: 20px;
            background-color: #ececec;
            font-size: 0.9rem;
        }

        @media (max-width: 768px) {
            .form-container {
                margin: 40px 20px;
                padding: 30px 20px;
            }
        }
        .back-button {
    display: inline-block;
    background-color: #ff6a00;
    color: white;
    padding: 14px 24px;
    font-size: 1.1rem;
    text-decoration: none;
    border: none;
    border-radius: 12px;
    cursor: pointer;
    transition: background-color 0.3s ease;
}

.back-button:hover {
    background-color: #e95c00;
}

    </style>
</head>
<body>
    <div style="text-align:center; padding-top: 20px;">
        <img src="logo.png" alt="Company Logo" style="height:100px;">
    </div>
    
    <div class="form-container">
        <h2> Add New Employee </h2>
        <form method="post" action="add_employee.jsp">
            <input type="text" name="name" placeholder="Employee Name" required>
            <input type="text" name="father_name" placeholder="Father's Name" required>
            <input type="date" name="dob" required>
            <input type="email" name="email" placeholder="Email" required>
            <input type="text" name="phone" placeholder="Phone" required>
            <textarea name="address" placeholder="Address" required></textarea>
            <input type="text" name="designation" placeholder="Designation" required>
            <input type="date" name="date_of_joining" required>
            <input type="number" step="0.01" name="basic_salary" placeholder="Basic Salary" required>
            <input type="number" step="0.01" name="allowance" placeholder="Allowance" required>
            <center>   <input type="submit" name="submit" value="Add Employee"></center>
        </form>
        <center>   <a href="admin-home.html" class="back-button">Back to Dashboard</a></center>


        <%
        if(request.getMethod().equalsIgnoreCase("post")) {
            String name = request.getParameter("name");
            String father = request.getParameter("father_name");
            String dob = request.getParameter("dob");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String designation = request.getParameter("designation");
            String doj = request.getParameter("date_of_joining");
            double salary = Double.parseDouble(request.getParameter("basic_salary"));
            double allowance = Double.parseDouble(request.getParameter("allowance"));
            
            String password = UUID.randomUUID().toString().substring(0, 8);
        
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/EmployeeDB1", "root", "abhi@11");

                PreparedStatement pst = con.prepareStatement(
                    "INSERT INTO Employee (name, father_name, dob, email, phone, address, designation, date_of_joining, basic_salary, allowance) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
                    Statement.RETURN_GENERATED_KEYS);

                pst.setString(1, name);
                pst.setString(2, father);
                pst.setDate(3, Date.valueOf(dob));
                pst.setString(4, email);
                pst.setString(5, phone);
                pst.setString(6, address);
                pst.setString(7, designation);
                pst.setDate(8, Date.valueOf(doj));
                pst.setDouble(9, salary);
                pst.setDouble(10, allowance);

                int i = pst.executeUpdate();

                if(i > 0) {
                    ResultSet rs = pst.getGeneratedKeys();
                    int employeeId = 0;
                    if(rs.next()) {
                        employeeId = rs.getInt(1);
                    }

                    PreparedStatement userPst = con.prepareStatement(
                        "INSERT INTO users (employee_id, username, password, role) VALUES (?, ?, ?, ?)");
                    userPst.setInt(1, employeeId);
                    userPst.setString(2, email);
                    userPst.setString(3, password);
                    userPst.setString(4, "employee");
                    userPst.executeUpdate();

                    String filePath = application.getRealPath("/") + "employee/credentials.txt";
                    File file = new File(filePath);
                    file.getParentFile().mkdirs();

                    FileWriter fw = new FileWriter(file, true);
                    fw.write("Email: " + email + ", Password: " + password + "\n");
                    fw.close();

                    out.println("<p class='message' style='color:green;'>Employee Added Successfully!</p>");
                }
                con.close();
            } catch(Exception e){
                out.println("<p class='message' style='color:red;'>Error: " + e.getMessage() + "</p>");
            }
        }
        %>
    </div>

    <footer>
        &copy; 2025 Employee Management System. All rights reserved.
    </footer>
</body>
</html>
