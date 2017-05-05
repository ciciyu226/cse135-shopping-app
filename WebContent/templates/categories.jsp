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
			
			response.sendRedirect("http://localhost:9999/CSE135Project1_eclipse/templates/error-ownerOnly.jsp");
			return;
		}
		%>
      
   
        <%@ page import="java.sql.*"%>
    	<%
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ResultSet rs2 = null;
		Statement statement= null;
		String alert = "";
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
			
		    	  //System.out.println ("all category fields are filled out.");			
				  //Check if cat_name is valid by checking duplicate in database
				  //if it is valid, insert new category into database
					
				  //Do something: can be insert, update
					/* Handling INSERT*/
					if(action != null && action.equals("insert")){
						action = null;
						if(cat_name == "" | cat_description == ""){
				/* 			alert = "Info cannot be empty. Please fill out the form again.";
							session.setAttribute("error-msg", alert);
							response.sendRedirect("http://localhost:9999/CSE135Project1_eclipse/templates/signup-failure.jsp"); */
							alert = "Data modification failed. Reason: Insert is empty. Please fill out the information again.";
							session.setAttribute("error-msg", alert);
							System.out.println("Category Info cannot be empty. Please fill up the form again.");
					    }
						else{
							conn.setAutoCommit(false);
					
							pstmt = conn.prepareStatement("INSERT INTO Category (name, description, owner) VALUES (?,?,?)");
							pstmt.setString(1, cat_name);
							pstmt.setString(2, cat_description);
							pstmt.setInt(3, (Integer)session.getAttribute("uid"));
							int rowCount = pstmt.executeUpdate();
							//commit transaction
							conn.commit();
							conn.setAutoCommit(true);
						}
					  }
					/* Handling UPDATE */
					if(action != null && action.equals("update")){
						action = null;
						if(cat_name == "" | cat_description == ""){
						alert = "Data modification failed. Reason: Update is empty. Please fill out the information again.";
						session.setAttribute("error-msg", alert);
						System.out.println("Category Info cannot be empty. Please fill up the form again.");
					    }else{
							conn.setAutoCommit(false);
							
							pstmt = conn.prepareStatement("UPDATE Category SET name= ?, description= ? WHERE id = ?");
							pstmt.setString(1, cat_name);
							pstmt.setString(2, cat_description);
							pstmt.setInt(3, Integer.parseInt(cat_id));
							int rowCount = pstmt.executeUpdate();
							
							conn.commit();
							conn.setAutoCommit(true);
						    }
	  				  
					}
					System.out.println(action);
					/* Handling DELETE */
					if(action != null && action.equals("delete")){
						action = null;
						System.out.println("delete");
						//category is empty, delete it from database
							conn.setAutoCommit(false);
							pstmt = conn.prepareStatement("DELETE FROM Category WHERE id= ?");
							pstmt.setInt(1, Integer.parseInt(cat_id));
							int rowCount = pstmt.executeUpdate();
							System.out.println("category is deleted");
							conn.commit();
							conn.setAutoCommit(true);							
					}
				 
			   
			/* Handling SELECT */
			statement = conn.createStatement();
			rs = statement.executeQuery("SELECT * FROM category");
			
		%>
       <div class="wrapper">
        <% 
        if(session.getAttribute("error-msg") != null){
        System.out.println("error message: " + session.getAttribute("error-msg") );
        %>
        <h3 style="color: red"><%=session.getAttribute("error-msg") %></h3> 
        <%
          session.removeAttribute("error-msg");
        }%>
        <h2> Hello <%=session.getAttribute("username")%>! </h2>
        <h1 class="text-center"> Categories </h1>
        <table>
          <tr>
        	<td>
	          <ul class="pagelinks">
	            <li><a href="home.jsp">Home</a></li>
	            <li>Categories</li>
	            <li><a href="products.jsp">Products</a></li>
	            <li><a href="products-browsing.jsp">Products Browsing</a></li>
	          </ul>
           </td>
            <td>
		        <div class="cat_list_wrapper">
		          <ul class="categoryList">
		          	<li>
			          <form action="categories.jsp" method="POST">
				          <label>Category ID: </label><input style="background-color: #dee1e5" type="text"  disabled>
				          <label>Category Name: </label><input type="text" name="cat_name">
				          <label>Description: </label><input type="text" name="cat_description">
				          <div style="display: inline-block" class="cat_insert_btn text-center"> 
				            <button class="btn"> 
				            	<input type="hidden" name="action" value="insert">
				            	Insert 
				            </button>
		                  </div> 
				      </form>
			       </li>
		          <%
					//TODO: loop through the returned list from query and display them in each list element
					
					while(rs.next()){
						System.out.println("FIRST POINT");
				   %>
					  <li> 
						<form style="display: inline-block" action="categories.jsp" method="POST">
							<label>Category ID: </label><input style="background-color: #dee1e5" type="text" value="<%=rs.getInt("id")%>" disabled>
							<label>Category Name: </label><input type="text" value="<%=rs.getString("name")%>" name="cat_name"/>
		                	<label>Description: </label><input type="text" placeholder="some words about your category..." value="<%=rs.getString("description") %>" name="cat_description">
		                	<%/* TODO: check if current viewer is the owner of this category, if yes, then display the edit buttons 
								TODO: check if this category is empty, only show delete button if it is empty.
								TODO: concurency control: invalidate deleting when other user insert product into this category which was shown empty before.*/
							%>
		                	<button class="btn cat_btn">
		          				<input type="hidden" name="action" value="update">
		          				<input type="hidden" name="cat_id" value="<%= rs.getInt("id")%>">
		                 		Update 
		                 	</button>
		                 </form>
		             <%  
		             	statement = conn.createStatement();
						rs2 = statement.executeQuery("SELECT * FROM Product, Category WHERE Product.category = Category.id AND Category.id="+ rs.getInt("id"));
		             	if(!rs2.next()) {   %>
		                 <form style="display: inline-block" action="categories.jsp" method="POST">
		                	<button class="btn cat_btn">
		                		<input type="hidden" name="action" value="delete">
		                		<input type="hidden" name="cat_id" value="<%= rs.getInt("id") %>">
		                	 	Delete 
		                	</button>
		                </form>
		             <%  }  %>
		            </li>
					<%	}	
						System.out.println("SECOND POINT");
				  %>				    
		        </ul>   
		      </div>
      		</td>
     	 </tr>
      </table>
    </div>
  </main>

            <%-- -------- Close Connection Code -------- --%>
            <% System.out.println("THIRD POINT");
            
                // Close the ResultSet
                rs.close();
                // Close the Statement
                statement.close();
                // Close the Connection
                conn.close();
                
            } catch (SQLException e) {
                // Wrap the SQL exception in a runtime exception to propagate
                // it upwards
                if(e.getSQLState().equals("23505")){
                	alert = "Data modification failed: Category name already exists. Please use a different name.";
					session.setAttribute("error-msg", alert);
					response.sendRedirect("http://localhost:9999/CSE135Project1_eclipse/templates/categories.jsp");
					System.out.println("category name already exists. Try a different name.");		
                }else if (e.getSQLState().equals("23503")) {
                	alert = "Data modification failed: This category is not empty.";
					session.setAttribute("error-msg", alert);
					response.sendRedirect("http://localhost:9999/CSE135Project1_eclipse/templates/categories.jsp");
                }else{
                    throw new RuntimeException(e);
                }
            }
            finally {
                // Release resources in a finally block in reverse-order of
                // their creation
                if (rs != null) {
                    try {
                        rs.close();
                    } catch (SQLException e) { } // Ignore
                    rs = null;
                }
                if (pstmt != null) {
                    try {
                        pstmt.close();
                    } catch (SQLException e) { } // Ignore
                    pstmt = null;
                }
                if (conn != null) {
                    try {
                        conn.close();
                    } catch (SQLException e) { } // Ignore
                    conn = null;
                }
            }
            %>
  </body>
</html>