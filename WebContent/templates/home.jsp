<html>
  <head>
    <meta charset="utf-8">
    <title> My Online Shopping Site </title>
    <!-- css links -->
    <link href="../css/style.css" rel="stylesheet" type="text/css">
  </head>
  <body>
    <main>
      <div class="wrapper">
      	<h2> Hello <%=session.getAttribute("username")%> </h2>
        <h1> Home Page </h1>
        <div class="pagelinks">
          some jsp methods that display links to other pages based on user role
          <ul>
         	<li><a href="signup.jsp">Go to sign up</a></li>
          	<li><a href="/CSE135Project1_eclipse/index.jsp">Go to log in</a></li>
          	<li><a href="categories.jsp">Categories Page</a></li>
          	<li><a href="products.jsp"</a>Products Page</li>
          </ul>           
        </div>
      </div>
    </main>
  </body>
</html>