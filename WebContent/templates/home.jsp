<html>
  <head>
    <meta charset="utf-8">
    <title> My Online Shopping Site </title>
    <!-- css links -->
    <link href="../css/style.css" rel="stylesheet" type="text/css">
  </head>
  <body>
    <header>
      <h2> Hello <%=session.getAttribute("username")%> </h2>
    </header>
    <main>
      <div class="home">
        <h1> Home Page </h1>
        <div class="pagelinks">
          some jsp methods that display links to other pages based on user role
          <a href="signup.jsp">Go to sign up</a>
        </div>
      </div>
    </main>
  </body>
</html>