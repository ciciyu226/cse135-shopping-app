<html>
<head>
  <meta charset="utf-8">
  <title> Products </title>
  <!-- css links -->
  <link href="../css/style.css" rel="stylesheet" type="text/css">
</head>
<body>
<%
//Check to see if logged in or not.
if(session.getAttribute("username")==null) {
	session.setAttribute("error","PLEASE LOG IN BEFORE ENTERING OTHER PAGES");
	response.sendRedirect("http://localhost:9999/CSE135Project1_eclipse");
	return;
}
//Check to see role
if(session.getAttribute("role").equals("owner")!=true) {
	response.sendRedirect("http://localhost:9999/CSE135Project1_eclipse/templates/error-ownerOnly.jsp");
	return;
}
%>
<div class="wrapper">
  <header>
  	<h2>Hello <%=session.getAttribute("username") %>!</h2>
  </header>
  <main>
  
    <%-- Import the java.sql package --%>
    <%@ page import="java.sql.*"%>
    <%-- -------- Open Connection Code -------- --%>
    <%
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    PreparedStatement pstmt2 = null;
    PreparedStatement pstmt3 = null;
    ResultSet rs = null;
    ResultSet rs2 = null;
    ResultSet rs3 = null;
    boolean showDeleted = false;
    
    try {
        // Registering Postgresql JDBC driver with the DriverManager
        Class.forName("org.postgresql.Driver");

        // Open a connection to the database using DriverManager
        conn = DriverManager.getConnection(
            "jdbc:postgresql://localhost:5432/postgres?" +
            "user=postgres&password=postgres");
    %>
  <table>
   <tr>
  	 <td>
  <ul>
  	<li><a href="home.jsp">Home</a></li>
  	<li><a href="categories.jsp">Categories</a></li>
  	<li>Products</li>
  	<li><a href="products-browsing.jsp">Products Browsing</a></li>
  	<p><a href="buy-shopping-cart.jsp">Buy Items in Cart</a></p>
  </ul>
  	 </td>
  	 <td><h1 style="color:blue">Welcome to the Products Page!</h1>
  	 
  	 </td>
   </tr>
   </tr>
     <td>
     <!-- SORTING SECTION -->
     <ul>
       <label>Sort by:</label>
       <li><form action="products.jsp" method="POST">
       <% if( request.getParameter("nameSort")!= null && request.getParameter("nameSort")!="" ){
    	   %>
            <input placeholder="Item Name" name="nameSort" value="<%=request.getParameter("nameSort")%>"></input>
       <% }
       	  else{
       	  %> 
       		<input placeholder="Item Name" name="nameSort"></input>
      <%  }%>
         <input type="submit" value="Search"></input>
         <%if(request.getParameter("categoryId")!=null && request.getParameter("categoryId")!=""){
       	 %>
         	<input type="hidden" name="categoryId" value="<%=request.getParameter("categoryId")%>"></input>
         	<input type="hidden" name="categorySort" value="<%=request.getParameter("categorySort")%>"></input>
       <%}%>	
       </form></li>
       <br>
       <li>Category:</li>
       <li>
       <%
     	  Statement categoryStatement = conn.createStatement();
     	  rs = categoryStatement.executeQuery("SELECT * FROM category");
     	  %>
     	  <form action="products.jsp" method="POST">
     	  	<input type="submit" value="Show All"></input>
     	  	<input type="hidden" name="categoryId" value="">
     	 <% if( request.getParameter("nameSort")!= null && request.getParameter("nameSort")!="" ){
    	   %>
     	 	 	<input type="hidden" name="nameSort" value="<%=request.getParameter("nameSort")%>"></input>
     	 <% } %>
     	  </form>
     	  <% 
     	  while( rs.next() ){
     		  %>
     		  	<form action="products.jsp" method="POST">
     		  	  <input type="hidden" name="categoryId" value="<%=rs.getInt("id")%>"/>
     		  	  <input type="submit" name="categorySort" value="<%=rs.getString("name")%>"/>
     		   <% if( request.getParameter("nameSort")!= null && request.getParameter("nameSort")!="" ){
    	   %>
     		  	  	<input type="hidden" name="nameSort" value="<%=request.getParameter("nameSort")%>"></input>
     		   <% } %>
     		  	</form>
     		  <%
     	  }
     	  rs = null;
       %>
       </li>
     </ul>
     <ul>
       
     </ul>
     </td>
  	 <td>

    <%-- -------- INSERT Code -------- --%>
    <%
        String action = request.getParameter("action");
    	String alert = null;
        // Check if an insertion is requested
        if (action != null && action.equals("insert")) { 

			//Check for all fields 
            if(request.getParameter("name")==null||request.getParameter("SKU")==null
            		||request.getParameter("price")==null||request.getParameter("category")==null
            		||request.getParameter("name")==""||request.getParameter("SKU")==""
            		||request.getParameter("price")==""||request.getParameter("category")=="") {
            	session.setAttribute("message", "One or more field was empty. Please try again.");
            }
            else { 
            	
            	// Begin transaction
	            conn.setAutoCommit(false);
            	
	            Statement cat_check = conn.createStatement();
	            ResultSet rs4 = cat_check.executeQuery("SELECT * FROM category WHERE id=" + request.getParameter("category"));
	            
	            if(!rs4.next()){
	        		session.setAttribute("message","Category no longer available.");
	        		response.sendRedirect("http://localhost:9999/CSE135Project1_eclipse/templates/products.jsp");
	        		return;
	            }
	
	            // Create the prepared statement and use it to
	            // INSERT student values INTO the students table.
	            pstmt = conn
	            .prepareStatement("INSERT INTO Product (name, SKU, price, category) VALUES (?, ?, ?, ?)");
	
	            pstmt.setString(1, request.getParameter("name"));
	            pstmt.setString(2, request.getParameter("SKU"));
	            pstmt.setDouble(3, Double.parseDouble(request.getParameter("price")));
	            pstmt.setInt(4, Integer.parseInt(request.getParameter("category")));
	            int rowCount = pstmt.executeUpdate();
	
	            // Commit transaction
	            conn.commit();
	            conn.setAutoCommit(true);
	            
	            action = null;
	            session.setAttribute("message", request.getParameter("name")+" was added to the list.");
          }
        }
    %>
    <%-- -------- UPDATE Code -------- --%>
    <%
        // Check if an update is requested
        if (action != null && action.equals("update")) {

        	//Check for all fields
            if(request.getParameter("name")==null||request.getParameter("SKU")==null
            		||request.getParameter("price")==null||request.getParameter("category")==null
            		||request.getParameter("name")==""||request.getParameter("SKU")==""
            		||request.getParameter("price")==""||request.getParameter("category")==""){
            	session.setAttribute("message", "One or more field was empty. Please try again.");
            }
            else {            	
	            // Begin transaction
	            conn.setAutoCommit(false);
	
	            //CHECK CATEGORY STILL EXISTS
	            Statement cat_check = conn.createStatement();
	            ResultSet rs4 = cat_check.executeQuery("SELECT * FROM category WHERE id=" + request.getParameter("category"));
	            
	            if(!rs4.next()){
	        		session.setAttribute("message","Category no longer available.");
	        		response.sendRedirect("http://localhost:9999/CSE135Project1_eclipse/templates/products.jsp");
	        		return;
	            }
	            Statement prod_check = conn.createStatement();
	            ResultSet rs5 = prod_check.executeQuery("SELECT * FROM product WHERE delete is NULL AND id=" + request.getParameter("id"));
	            if(!rs5.next()){
	        		session.setAttribute("message","Product no longer available.");
	        		response.sendRedirect("http://localhost:9999/CSE135Project1_eclipse/templates/products.jsp");
	        		return;
	            }
	            // Create the prepared statement and use it to
	            // UPDATE student values in the Students table.
	            pstmt = conn
	                .prepareStatement("UPDATE Product SET name = ?, SKU = ?, "
	                    + "price = ?, category = ? WHERE id = ?");
	
	            pstmt.setString(1, request.getParameter("name"));
	            pstmt.setString(2, request.getParameter("SKU"));
	            pstmt.setDouble(3, Double.parseDouble(request.getParameter("price")));
	            pstmt.setInt(4, Integer.parseInt(request.getParameter("category")));
	            pstmt.setInt(5, Integer.parseInt(request.getParameter("id")));
	            int rowCount = pstmt.executeUpdate();
	
	            // Commit transaction
	            conn.commit();
	            conn.setAutoCommit(true);
	            
	            action = null;
	            session.setAttribute("message", request.getParameter("name")+" was updated.");
            
          }
        }
        	
    %>
    <%-- -------- DELETE Code -------- --%>
    <%
        // Check if a delete is requested
        if (action != null && action.equals("delete")) {

            // Begin transaction
            conn.setAutoCommit(false);

            // Create the prepared statement and use it to
            // DELETE students FROM the Students table.
            pstmt = conn
                .prepareStatement("UPDATE Product SET delete='Y' WHERE id = ?");

            pstmt.setInt(1, Integer.parseInt(request.getParameter("id")));
            int rowCount = pstmt.executeUpdate();

            // Commit transaction
            conn.commit();
            conn.setAutoCommit(true);
            
            action = null;
            session.setAttribute("message", "Deleted item from the list.");
        }
    %>
    <%-- -------- SELECT Statement Code -------- --%>
    <%
        // Create the statement
        Statement statement = conn.createStatement();
    	Statement statement2 = conn.createStatement();
    	Statement statement3 = conn.createStatement();
    	statement2 = conn.createStatement();
    	rs2 = statement2.executeQuery("SELECT id,name FROM category");  

        // Use the created statement to SELECT
        // the student attributes FROM the Student table.
        
        /*
         * THIS PART IS TO HANDLE THE SORTING
        */
        //Both category and search
        if( request.getParameter("categoryId")!=null && request.getParameter("categoryId")!="" 
        		&& request.getParameter("nameSort")!=null && request.getParameter("nameSort")!=""){
			rs = statement.executeQuery("SELECT * FROM product WHERE delete IS NULL AND category=" 
					+ request.getParameter("categoryId") + " AND name LIKE '%" 
					+ request.getParameter("nameSort") + "%'");
			session.setAttribute("sortMessage","Sorting by category and search: " 
					+ request.getParameter("categorySort") + ", " + request.getParameter("nameSort"));
        }//Just category
        else if( request.getParameter("categoryId")!=null && request.getParameter("categoryId")!="" ){
			rs = statement.executeQuery("SELECT * FROM product WHERE delete IS NULL AND category=" 
				+ request.getParameter("categoryId"));
			//System.out.println(request.getParameter("categoryId"));
			session.setAttribute("sortMessage","Sorting by category: " + request.getParameter("categorySort"));
		}//Just search
        else if( request.getParameter("nameSort")!=null && request.getParameter("nameSort")!="" ){
        	rs = statement.executeQuery("SELECT * FROM product WHERE delete IS NULL AND name LIKE '%" 
					+ request.getParameter("nameSort") + "%'");
        	session.setAttribute("sortMessage","Searching for: " + request.getParameter("nameSort"));
        }//show all
		else{
			session.removeAttribute("sortMessage");
        	rs = statement.executeQuery("SELECT * FROM product WHERE delete IS NULL");
		}
    %>
    
    <!-- Add an HTML table header row to format the results -->
    
    <!-- Print out the message -->
    <%
    if( session.getAttribute("message")!=null && session.getAttribute("sortMessage")!=null )
   	  {
    	String att = (String)session.getAttribute("message");
    	if(att.equals("SKU is not unique. Please try a different one."))
    		showDeleted = true;
    	%>
    	  <h3 style="color:red"><%=session.getAttribute("message")%> <%=session.getAttribute("sortMessage")%></h3>
   <%     session.removeAttribute("message");
   		  session.removeAttribute("sortMessage");
      }
      else if( session.getAttribute("message")!=null )
   	  {
      	String att = (String)session.getAttribute("message");
      	if(att.equals("SKU is not unique. Please try a different one."))
      		showDeleted = true;
    	%>
    	  <h3 style="color:red"><%=session.getAttribute("message")%></h3>
   <%     session.removeAttribute("message");
      }
      else if( session.getAttribute("sortMessage")!=null )
   	  {
    	%>
    	  <h3 style="color:red"><%=session.getAttribute("sortMessage")%></h3>
   <% 	  session.removeAttribute("sortMessage");
      } %>
      
    <table border="1" style="color:blue">
    <tr>
     	<!-- Removed id here -->
        <th>Name</th>
        <th>SKU</th>
        <th>Price($.$$)</th>
        <th>Category</th>
    </tr>
    
	<!-- HTML FOR INSERT -->
    <tr>
        <form action="products.jsp" method="POST">
            <input type="hidden" name="action" value="insert"/>
           <% if( request.getParameter("categoryId")!= null && request.getParameter("categoryId")!="" ){
    	   %>
            	<input type="hidden" name="categoryId" value="<%=request.getParameter("categoryId")%>"></input>
            	<input type="hidden" name="categorySort" value="<%=request.getParameter("categorySort")%>"></input>
           <% } %>
           <% if( request.getParameter("nameSort")!= null && request.getParameter("nameSort")!="" ){
    	   %> 
            	<input type="hidden" name="nameSort" value="<%=request.getParameter("nameSort")%>"></input>
           <% } %>
            
            <!-- Removed id here -->
            <th><input name="name" placeholder="Enter Name" size="10"/></th>
            <th><input name="SKU" placeholder="Enter SKU" size="15"/></th>
            <th>$<input name="price" placeholder="Sell Price(Ex:3.99)" size="15"/></th>
            <th><select name="category">
              <% while(rs2.next()){
              %>
                <option value="<%=rs2.getInt("id")%>"><%=rs2.getString("name")%></option>
              <% 
              } 
              %>
            </select></th>
            <th><input type="submit" value="Insert"/></th>
        </form>
    </tr>
    <%-- -------- Iteration Code -------- --%>
    <%
        // Iterate over the ResultSet
        while (rs.next()) {
        	statement2 = conn.createStatement();
        	statement3 = conn.createStatement(); //ADDED
        	rs2 = statement2.executeQuery("SELECT id,name FROM category");        
    %>

    <tr>
        <form action="products.jsp" method="POST">
            <input type="hidden" name="action" value="update"/>
            <input type="hidden" name="id" value="<%=rs.getInt("id")%>"/>

        <%-- Get the id --%>
		<!-- Removed id here -->

        <%-- Get the name --%>
        <td>
            <input value="<%=rs.getString("name")%>" name="name" size="15"/>
        </td>

        <%-- Get the SKU --%>
        <td>
            <input value="<%=rs.getString("SKU")%>" name="SKU" size="15"/>
        </td>

        <%-- Get the price --%>
        <td>
            $<input value="<%=rs.getString("price")%>" name="price" size="15"/>
        </td>

        <%-- Get the category --%>
        <th>
            <select name="category">
            <%
            statement3 = conn.createStatement();
        	rs3 = statement3.executeQuery("SELECT name FROM category WHERE id=" + rs.getInt("category"));
        	rs3.next();
        	String cat_name = rs3.getString("name");
            %>
              <option value="<%=rs.getInt("category")%>"><%=cat_name%></option>
            <%
            while(rs2.next()){
            	if(rs2.getInt("id") != rs.getInt("category")){
            %>  
                  <option value="<%=rs2.getInt("id")%>"><%=rs2.getString("name")%></option>
            <%
            	}
            }
            %>
            </select>
        </th>

        <%-- Button --%>
        <!-- HTML FOR UPDATE AND DELETE IS ABOVE AND BELOW THIS -->
        <td><input type="submit" value="Update"></td>
      <%if(request.getParameter("categoryId")!=null && request.getParameter("categoryId")!=""){
      %>
        	<input type="hidden" name="categoryId" value="<%=request.getParameter("categoryId")%>"></input>
        	<input type="hidden" name="categorySort" value="<%=request.getParameter("categorySort")%>"></input>
     <% } %>
      <%if(request.getParameter("nameSort")!=null && request.getParameter("nameSort")!=""){
      %>
        	<input type="hidden" name="nameSort" value="<%=request.getParameter("nameSort")%>"></input>
     <% } %>
        </form>
        <form action="products.jsp" method="POST">
            <input type="hidden" name="action" value="delete"/>
            <input type="hidden" name="id" value="<%=rs.getInt("id")%>" />
		    <%if(request.getParameter("categoryId")!=null && request.getParameter("categoryId")!=""){
		    %>
		      	<input type="hidden" name="categoryId" value="<%=request.getParameter("categoryId")%>"></input>
		      	<input type="hidden" name="categorySort" value="<%=request.getParameter("categorySort")%>"></input>
		   <% } %>
		    <%if(request.getParameter("nameSort")!=null && request.getParameter("nameSort")!=""){
		    %>
		      	<input type="hidden" name="nameSort" value="<%=request.getParameter("nameSort")%>"></input>
		   <% } %>
            <%-- Button --%>
        <td><input type="submit" value="Delete"/></td>
        </form>
    </tr>

    <%
        } //end while
        	
    %>
    
      </table>
  </td>
  <td>
  
    	     <!-- SHOW DELETED PRODUCTS -->
    <%
    
    if(showDeleted){
    	
        // Iterate over the ResultSet
		Statement deleted = conn.createStatement();
		System.out.println("BEFORE EXECUTE");
        ResultSet rsDeleted = deleted.executeQuery("SELECT * FROM product WHERE delete='Y'");
        
        %>
        
        <table border="1" style="color:red">
		  <tr><td>Past Items' SKUs</td></tr>
		  <tr>
		    <td>Name</td>
		    <td>SKU</td>
		  </tr>
        
        <% 
        
        while (rsDeleted.next()) {
        	System.out.println("ENTERING");
    %>
    	<tr>
	<!--    <form action="products.jsp" method="POST"> 
            <input type="hidden" name="action" value="update"/>
            <input type="hidden" name="id" value=""/>
	-->
        <%-- Get the id --%>
		<!-- Removed id here -->

        <%-- Get the name --%>
        <td>
            <input value="<%=rsDeleted.getString("name")%>" name="name" size="15" readonly/>
        </td>

        <%-- Get the SKU --%>
        <td>
            <input value="<%=rsDeleted.getString("SKU")%>" name="SKU" size="15" readonly/>
        </td>

       <!-- </form>-->
      </tr>
      
      <% 
        } System.out.println("DONE");
      %>
      </table>
      <% 
    } 
    %>
  
  </td>
  </tr>
  </table>
    
    <%-- -------- Close Connection Code -------- --%>
    <%
        // Close the ResultSet
        rs.close();

        // Close the Statement
        statement.close();

        // Close the Connection
        conn.close();
    } catch (SQLException e) {
    	if(e.getSQLState().equals("23505")){ //Unique Violation
    		session.setAttribute("message", "SKU is not unique. Please try a different one.");
    		response.sendRedirect("http://localhost:9999/CSE135Project1_eclipse/templates/products.jsp");
    	}
    	else if(e.getSQLState().equals("23514")){ //Check Violation
    		session.setAttribute("message","Price cannot be negative.");
    		response.sendRedirect("http://localhost:9999/CSE135Project1_eclipse/templates/products.jsp");
    	}
    	else if(e.getSQLState().equals("23503")){ //Check if Category still exists
    		session.setAttribute("message","Category no longer available. Please choose a different one.");
    		response.sendRedirect("http://localhost:9999/CSE135Project1_eclipse/templates/products.jsp");
    	}
    	else{
        // Wrap the SQL exception in a runtime exception to propagate
        // it upwards
        System.out.println("SQL EXCEPTION IS: " + e.getSQLState());
        throw new RuntimeException(e);
        
    	}
    }
    catch(NumberFormatException e){
		session.setAttribute("message","Price must be a number.");
		response.sendRedirect("http://localhost:9999/CSE135Project1_eclipse/templates/products.jsp");
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
  </main>
  </div>
  </body>
</html>