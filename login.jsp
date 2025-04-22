<!DOCTYPE html>
<html>
<head>
  <title>Login</title>
  <style>
    * {
      box-sizing: border-box;
    }
    body {
      font-family: 'Segoe UI', sans-serif;
      background: linear-gradient(135deg, #ff6a00, #ffb347);
      height: 100vh;
      margin: 0;
      display: flex;
      justify-content: center;
      align-items: center;
    }
    .login-container {
      background: #fff;
      padding: 40px 30px;
      border-radius: 15px;
      box-shadow: 0 10px 30px rgba(0,0,0,0.2);
      width: 100%;
      max-width: 350px;
      animation: fadeIn 0.5s ease-in;
      text-align: center;
    }
    .logo {
      width: 80px;
      height: 80px;
      margin: 0 auto 20px;
    }
    h2 {
      margin-bottom: 30px;
      color: #333;
    }
    input[type="text"],
    input[type="password"],
    select {
      width: 100%;
      padding: 12px;
      margin: 10px 0 20px;
      border: 1px solid #ccc;
      border-radius: 8px;
      font-size: 1rem;
      transition: border 0.3s ease;
    }
    input:focus {
      border-color: #ff6a00;
      outline: none;
    }
    button {
      width: 100%;
      background: #ff6a00;
      color: white;
      padding: 12px;
      border: none;
      border-radius: 8px;
      font-size: 1rem;
      font-weight: bold;
      cursor: pointer;
      transition: background 0.3s;
    }
    button:hover {
      background: #e65c00;
    }
    @keyframes fadeIn {
      from { opacity: 0; transform: translateY(-20px); }
      to { opacity: 1; transform: translateY(0); }
    }
    .footer-text {
      margin-top: 20px;
      font-size: 0.85rem;
      color: #777;
    }
  </style>
</head>
<body>

<div class="login-container">
  <img src="logo.png" alt="Logo" class="logo"> <!-- 👈 Add your logo here -->
  <form action="login_action.jsp" method="post">
    <input type="text" name="username" placeholder="Username or Email" required>
    <input type="password" name="password" placeholder="Password" required>
    <button type="submit">Login</button>
  </form>
  <div class="footer-text">
    &copy; 2025 Employee Management System
  </div>
</div>

</body>
</html>
