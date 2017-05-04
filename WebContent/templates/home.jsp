<html>
  <head>
    <meta charset="utf-8">
    <title> My Online Shopping Site </title>
    <!-- css links -->
    <link href="../css/style.css" rel="stylesheet" type="text/css">
  </head>
  <body>
    <main class="wrapper">
      <%
      	//Check to see if logged in or not.
      	if(session.getAttribute("username")==null) {
      		session.setAttribute("error","PLEASE LOG IN BEFORE ENTERING OTHER PAGES");
      		response.sendRedirect("http://localhost:9999/CSE135Project1_eclipse");
      		return;
      	}
      %>
  	  <h2> Hello <%=session.getAttribute("username")%>! </h2>
      <label>You are a <%=session.getAttribute("role")%>.</label>
      <br>
      <a href="../index.jsp">Not you? Click here to sign in to a different account.<a>
      <p><a href="buy-shopping-cart.jsp">Go to Buy Shopping Cart Here</a></p>
      <div class="wrapper">
  	    <h1> Home Page </h1>
  	    <div class="pagelinks">
          <%
          	String categoryLink = "";
          	String productLink = "";
    	    if(session.getAttribute("role").equals("customer")){
	    	  	//Only customers can see this
	    	  	categoryLink = "error-ownerOnly.jsp";
	    	  	productLink = "error-ownerOnly.jsp";
				
    	    }
    	    else if(session.getAttribute("role").equals("owner")){
    	  	  	//Only owners can see this
    	  		categoryLink = "categories.jsp";
	    	  	productLink = "products.jsp";
    	    }
    	  %>
          <ul>
            <li>Home</li>
            <li><a href="<%=categoryLink%>">Categories</a></li>
            <li><a href="<%=productLink%>">Products</a></li>
            <li><a href="products-browsing.jsp">Products Browsing</a></li>
          </ul>
	    </div>
	  </div>
    </main>
  </body>
</html>