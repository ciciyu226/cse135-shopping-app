<html>
  <head>
    <meta charset="utf-8">
    <title> My Online Shopping Site </title>
    <!-- css links -->
    <link href="../css/style.css" rel="stylesheet" type="text/css">
  </head>
  <body>
    <main>
      <%
		System.out.println(session.getAttribute("role"));
		if(session.getAttribute("role").equals("customer") && 1==2){
			System.out.println("dfafdsafa");
			response.sendRedirect("http://localhost:9999/CSE135Project1_eclipse/templates/error-ownerOnly.jsp");
		}
		%>
      
      <div class="wrapper">
        <h2> Hello <%=session.getAttribute("username")%> </h2>
        <h1> Categories Page </h1>
        <div class="pagelinks">
          some jsp methods that display all links.
          <ul>
            <li><a href="home.jsp">Home Page</a></li>
            <li><a href="product.jsp">Product Page</a></li>
            <li><a href="product-browsing.jsp">Product Browsing Page</a></li>
            <li><a href="product-order.jsp">Product Order Page</a></li>
          </ul>
        </div>
        <%%>
        
        
        <div class="cat_list_wrapper">
          <ul class="categoryList">
            <%
				//TODO: loop through the returned list from query and display them in each list element
				


			%>
            <li>
              <label>Category Name: </label><input type="text" name="category_name">
              <label>Description: </label><textarea placeholder="some words about your category..."></textarea>
              <button class="btn cat_btn"> Update </button>
              <button class="btn cat_btn"> Delete </button>
            </li>
            <li>
              <label>Category Name: </label><input type="text" name="category_name">
              <label>Description: </label><textarea placeholder="some words about your category..."></textarea>
              <button class="btn cat_btn"> Update </button>
              <button class="btn cat_btn"> Delete </button>
            </li>
            <li>
              <label>Category Name: </label><input type="text" name="category_name">
              <label>Description: </label><textarea placeholder="some words about your category..."></textarea>
              <button class="btn cat_btn"> Update </button>
              <button class="btn cat_btn"> Delete </button>
            </li>
            <li>
              <label>Category Name: </label><input type="text" name="category_name">
              <label>Description: </label><textarea placeholder="some words about your category..."></textarea>
              <button class="btn cat_btn"> Update </button>
              <button class="btn cat_btn"> Delete </button>
            </li>
            <li>
              <label>Category Name: </label><input type="text" name="category_name">
              <label>Description: </label><textarea placeholder="some words about your category..."></textarea>
              <button class="btn cat_btn"> Update </button>
              <button class="btn cat_btn"> Delete </button>
            </li>
            <li>
              <label>Category Name: </label><input type="text" name="category_name">
              <label>Description: </label><textarea placeholder="some words about your category..."></textarea>
              <button class="btn cat_btn"> Update </button>
              <button class="btn cat_btn"> Delete </button>
            </li>
            <li>
              <label>Category Name: </label><input type="text" name="category_name">
              <label>Description: </label><textarea placeholder="some words about your category..."></textarea>
              <button class="btn cat_btn"> Update </button>
              <button class="btn cat_btn"> Delete </button>
            </li>
          </ul>
          <div class="cat_insert_btn">
            <button class="btn"> Insert </button>
          </div>
        </div>

      </div>
    </main>
  </body>
</html>