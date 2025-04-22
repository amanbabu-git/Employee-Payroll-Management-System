<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("employee_id") == null) {
        response.sendRedirect("employee-dashboard.html");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
  <title>Leave Request</title>
  <style>
    body {
      font-family: 'Segoe UI', sans-serif;
      background: linear-gradient(to right, #f8f9fa, #e0eafc);
      margin: 0;
      padding: 0;
    }

    .logo-container {
      text-align: center;
      padding: 40px 0 10px 0;
    }

    .logo-container img {
      height: 80px;
    }

    .form-container {
      max-width: 520px;
      margin: 30px auto 70px auto;
      padding: 30px 50px;
      background: #ffffff;
      border-radius: 16px;
      box-shadow: 0 8px 20px rgba(0, 0, 0, 0.08);
    }

    h2 {
      text-align: center;
      color: #222;
      margin-bottom: 35px;
      font-size: 36px;
      letter-spacing: 1.5px;
    }

    label {
      display: block;
      margin-bottom: 10px;
      font-weight: 600;
      color: #333;
    }

    input[type="date"],
    textarea {
      width: 90%;
      padding: 12px 15px;
      border: 2px solid #ff6a00;
      border-radius: 8px;
      margin-bottom: 25px;
      font-size: 16px;
      outline: none;
      transition: 0.3s ease;
    }

    input[type="date"]:focus,
    textarea:focus {
      border-color: #e55c00;
      box-shadow: 0 0 5px rgba(255, 106, 0, 0.3);
    }

    textarea {
      resize: vertical;
      min-height: 100px;
    }

    button {
      width: 100%;
      padding: 14px;
      background: linear-gradient(to right, #ff6a00, #ff9900);
      color: #fff;
      font-size: 16px;
      font-weight: bold;
      border: none;
      border-radius: 8px;
      cursor: pointer;
      transition: 0.3s ease;
    }

    button:hover {
      background: linear-gradient(to right, #e65c00, #ff7f00);
    }

    @media (max-width: 600px) {
      .form-container {
        margin: 20px;
        padding: 30px 20px;
      }
    }
  </style>
</head>
<body>

<div class="logo-container">
  <img src="logo.png" alt="Company Logo">
</div>

<div class="form-container">
  <h2>Submit Leave Request</h2>
  <form action="submit_leave.jsp" method="post">
    <label for="fromDate">From Date</label>
    <input type="date" name="fromDate" required>

    <label for="toDate">To Date</label>
    <input type="date" name="toDate" required>

    <label for="reason">Reason</label>
    <textarea name="reason" required placeholder="Write your reason..."></textarea>

    <button type="submit">Submit</button>
  </form>
</div>

</body>
</html>
