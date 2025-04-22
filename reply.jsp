<%
    String id = request.getParameter("id");
    String email = request.getParameter("email");
    String name = request.getParameter("name");
    String message = request.getParameter("message");
%>

<html>
<head>
  <title>Reply to Message</title>
</head>
<body>
  <h2>Reply to <%= name %> (<%= email %>)</h2>
  <p><strong>Original Message:</strong> <%= message %></p>
  
  <form action="sendReply.jsp" method="post">
    <input type="hidden" name="id" value="<%= id %>">
    <input type="hidden" name="email" value="<%= email %>">
    <input type="hidden" name="message" value="<%= message %>">

    <textarea name="reply" rows="5" cols="60" placeholder="Write your reply here..." required></textarea><br><br>
    <input type="submit" value="Send Reply">
  </form>
</body>
</html>
