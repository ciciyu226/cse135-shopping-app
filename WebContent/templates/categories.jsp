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
      	//Check to see if logged in or not.
      	if(session.getAttribute("username")==null) {
      		session.setAttribute("error","PLEASE LOG IN BEFORE ENTERING OTHER PAGES");
      		response.sendRedirect("http://localhost:9999/CSE135Project1_eclipse");
      		return;
      	}
      %>
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
        <%@ page import="java.sql.*"%>
    	<%
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			Class.forName("org.postgresql.Driver");
			
			conn = DriverManager.getConnection(
			"jdbc:postgresql://localhost:5432/postgres?" +
        	"user=postgres&password=postgres");	
		%>
		<%
			String cat_id = request.getParameter("cat_id");
        	String cat_name = request.getParameter("cat_name");
			String cat_description = request.getParameter("cat_description");
		
			String action = request.getParameter("action");
			
			if(cat_name != null){
				if(cat_name == "" | cat_description == ""){
		/* 			alert = "Info cannot be empty. Please fill out the form again.";
					session.setAttribute("error-msg", alert);
					response.sendRedirect("http://localhost:9999/CSE135Project1_eclipse/templates/signup-failure.jsp"); */
					System.out.println("Category Info cannot be empty. Please fill up the form again.");
				}			
		    	else { 
		    	  System.out.println ("all category fields are filled out.");			
				  //Check if cat_name is valid by checking duplicate in database
				  //if it is valid, insert new category into database
				  Statement statement = conn.createStatement();
				  rs = statement.executeQuery("SELECT * FROM Category WHERE id ='" + cat_id + "'");
				  if(rs.next()){
					System.out.println("category name is already exist. Try a different name.");
				  }
				  else {
					System.out.println("This category name is unique.");
					//Do something: can be insert, update
					/* Handling INSERT*/
					if(action != null && action.equals("insert")){
						conn.setAutoCommit(false);
				
						pstmt = conn.prepareStatement("INSERT INTO Category (name, description, owner) VALUES (?,?,?,?)");
						pstmt.setString(1, cat_name);
						pstmt.setString(2, cat_description);
						pstmt.setInt(3, (Integer)session.getAttribute("uid"));
						int rowCount = pstmt.executeUpdate();

						//commit transaction
						conn.commit();
						conn.setAutoCommit(true);
					}        

				  }
				}
			}

		%>
        
        
        
        
        
        
        <div class="cat_list_wrapper">
          <ul class="categoryList">
          <%
			//TODO: loop through the returned list from query and display them in each list element
			while(rs.next()){
		   %>
			  <li> 
				<form action="categories.jsp" method="POST">
					<label>Category Name: </label><input type="text" name="cat_name">
                	<label>Description: </label><textarea placeholder="some words about your category... name="cat_description""></textarea>
                	<%/* TODO: check if current viewer is the owner of this category, if yes, then display the edit buttons 
						TODO: check if this category is empty, only show delete button if it is empty.
						TODO: concurency control: invalidate deleting when other user insert product into this category which was shown empty before.*/
					if(){}
					%>
                	<button class="btn cat_btn">
          				<input type="hidden" name="action" value="update">
                 		Update 
                 	</button>
                	<button class="btn cat_btn">
                		<input type="hidden" name="action" value="delete">
                	 	Delete 
                	</button>
                </form>
            </li>
			<%	}	

		  %>
            <li>
              <label>Category Name: </label><input type="text" name="category_name">
              <label>Description: </label><textarea placeholder="some words about your category..."></textarea>
              <button class="btn cat_btn"> Update </button>
              <button class="btn cat_btn"> Delete </button>
            </li>
          </ul>
          <div class="cat_insert_btn">
            <button class="btn"> 
            	<input type="hidden" name="action" value="insert">
            	<input type="hidden" name="cat_id" value="<%= rs.getInt("id")%>">
            	Insert 
            </button>
          </div>
        </div>

      </div>
    </main>
  </body>
</html>