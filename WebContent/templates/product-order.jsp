  <head>
    <meta charset="utf-8">
    <title> My Online Shopping Site </title>
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
    if(request.getParameter("valid-request")==null || !request.getParameter("valid-request").equals("true")){
		session.setAttribute("error","LEL NOPE NICE TRY");
		response.sendRedirect("http://localhost:9999/CSE135Project1_eclipse");
		return;
    }
	%>
    
     <%-- Import the java.sql package --%>
    <%@ page import="java.sql.*"%>
    <%-- -------- Open Connection Code -------- --%>
    <%
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    Statement statement= null;
    ResultSet rs = null;
    ResultSet rs2 = null;
    ResultSet rs3 = null;
    String alert = null;
    
    try {
        // Registering Postgresql JDBC driver with the DriverManager
        Class.forName("org.postgresql.Driver");

        // Open a connection to the database using DriverManager
        conn = DriverManager.getConnection(
            "jdbc:postgresql://localhost:5432/postgres?" +
            "user=postgres&password=postgres");
    %>
    <%
    	System.out.println("=======================================");
        String product_id = request.getParameter("id");
    	System.out.println("product_id: "+product_id);
        String quantity = request.getParameter("quantity");  
        String price = request.getParameter("price");
        System.out.println("quantity: "+ quantity);
        String action = request.getParameter("action");
    	
    	String msgSuccess= null;
      if(quantity != null){
    	if(action != null && action.equals("submit-quantity")){
    		action = null;
    		
    		statement = conn.createStatement();
			rs = statement.executeQuery("SELECT * FROM Product WHERE delete= 'Y' and id ='" + product_id + "'");
				if(rs.next()){
					alert = "Update quantity failed: This product has already been deleted by an owner.";
					session.setAttribute("msg-pOrder", alert);
					System.out.println("This product has already been deleted by other user.");
				}
				else {
		    		if(quantity == ""){
		    			alert = "Update quantity failed: Quantity is empty.";
		    			session.setAttribute("msg-pOrder", alert);
		    			System.out.println(alert);
		    		}
		    		else{
		   					//check if product already exists in product_history table
		   					//if it is, just update instead of insert
		   					statement = conn.createStatement();
						    rs3= statement.executeQuery("SELECT * FROM Purchase_History WHERE bought is NULL AND product=" + product_id);
						    if(rs3.next()){
		   					  
		   						//Begin transaction
					    		conn.setAutoCommit(false);
					    		
					    		pstmt = conn.prepareStatement("UPDATE Purchase_History SET quantity= ? WHERE bought is NULL AND product="+ product_id);
					    		pstmt.setInt(1, Integer.parseInt(quantity));
					  
					    		int rowCount = pstmt.executeUpdate();
					    		
					    		conn.commit();
					    		conn.setAutoCommit(true);
					    		
		   						System.out.println("updating quantity of existing product.");	
		   						msgSuccess= "Your new product quantity has been updated.";
		   						session.setAttribute("msg", msgSuccess);
		   						response.sendRedirect("http://localhost:9999/CSE135Project1_eclipse/templates/products-browsing.jsp");
		   					}else {
				    		
			    				System.out.println("insert new tuple with submitted quantity");
					    	    //Begin transaction
					    		conn.setAutoCommit(false);
					    		
					    		pstmt = conn.prepareStatement("INSERT INTO Purchase_History (customer, product, quantity, price_at_purchase)"+
					    							"VALUES (?,?,?,?)");
					    		pstmt.setInt(1, (Integer)(session.getAttribute("uid")));
					    		pstmt.setInt(2, Integer.parseInt(product_id));
					    		pstmt.setInt(3, Integer.parseInt(quantity));
					    		pstmt.setDouble(4, Double.parseDouble(price));
					    		int rowCount = pstmt.executeUpdate();
					    		
					    		conn.commit();
					    		conn.setAutoCommit(true);
					    		msgSuccess= "Successfully added item to cart.";
					    		session.setAttribute("msg", msgSuccess);
					    		response.sendRedirect("http://localhost:9999/CSE135Project1_eclipse/templates/products-browsing.jsp");
		   					}
		   			  }	  
    		   }
    	}
      }
    	//Handling SELECT All
    	statement = conn.createStatement();
		rs = statement.executeQuery("SELECT * FROM purchase_history WHERE bought IS NULL AND customer='"+ session.getAttribute("uid") + "'");
			
    %>
    <%
    //TODO: display products using while loop
    //TODO: if quantity change, display message: quantity of product x you want to buy has changed to y.
    %>
    <main class="wrapper">
    <header>
  		<h2>Hello <%=session.getAttribute("username") %>!</h2>
  	</header>
     <% if(session.getAttribute("msg-pOrder") != null) { %>
     <h3 style="color: red"><%=session.getAttribute("msg-pOrder") %></h3>
     <% session.removeAttribute("msg-pOrder");
     }%>
     <a href="home.jsp">Home</a>
     <a href="products-browsing.jsp">Go back to PRODUCT BROWSING</a>
     <h1>Product Order Page (shopping cart)</h1>
   <table border="1">
     	<tr>
	     	<th>Product ID</th>
	        <th>Product Name</th>
	        <th>Price</th>
	        <th>Quantity</th>
        </tr>
        <tr>
	        <form action="product-order.jsp" method="POST">
	        	<input type="hidden" name="action" value="submit-quantity"/>
	        	<%
	        	String a,b,c;
	        	if(request.getParameter("id")==null){
	        		a = (String)session.getAttribute("prod_id");
	        		b = (String)session.getAttribute("prod_name");
	        		c = (String)session.getAttribute("prod_price");
	        		session.removeAttribute("prod_id");
	        		session.removeAttribute("prod_name");
	        		session.removeAttribute("prod_price");
	        	}
	        	else{
	        		a = request.getParameter("id");
	        		b = request.getParameter("name");
	        		c = request.getParameter("price");
	        	}
	        	%>
	        	
	        	<td><input value="<%= a %>" name="id" size=15 readonly/></td>
	        	<td><input value="<%= b %>" name="name" size=15 readonly/></td>
	        	<td><input value="<%= c %>" name="price" size=15 readonly/></td>
	        	<td><input value="" placeholder="Enter quantity" name="quantity" size=15 /></td>
	        	<td><input type="submit" value="Confirm Quantity"></td>
	        </form>
        </tr>

	<%-- -------- Iteration Code -------- --%>
	<tr>
	<% System.out.println("FIRST POINT"); %>
   <form action="buy-shopping-cart.jsp" method="POST"> 	   
  <%  while(rs.next()){
	  System.out.println("Second POINT");%>
    <tr> 
        <%-- Get the product id --%>
       <td>
           <input value="<%=rs.getInt("product")%>" name="product_id" size="15" readonly/>
           <%System.out.println(rs.getInt("product"));  %>
       </td>

       <%-- Get the name --%>
       <td>
       	<% 
       	statement = conn.createStatement();
		rs2 = statement.executeQuery("SELECT name FROM Product WHERE id="+ rs.getInt("product"));
  	    rs2.next();
  	    System.out.println(rs2.getString("name")); 
  	    %>
		<input value="<%=rs2.getString("name")%>" name="name" size="15" readonly/>
		
       </td>
        <%-- Get the price --%>
       <td>
           <input value="<%=rs.getInt("price_at_purchase")%>" name="price" size="15" readonly/>
       </td>   
       
       <%-- Get the quantity --%>
       <td>
           <input value="<%=rs.getInt("quantity")%>" name="quantity" size="15" readonly/>
       </td>  
    </tr>
    <%
        }
    %> 
    </table>
    <tr>
    	<td><input type="submit" value="Confirm Shopping Cart"></td>
    </tr>
    </form>    
   
   

    <%-- -------- Close Connection Code -------- --%>
    <%
        // Close the ResultSet
        rs.close();
		if(rs2 != null){
        rs2.close();
		}
        // Close the Statement
        statement.close();
        // Close the Connection
        conn.close();
    } catch (SQLException e) {
		if(e.getSQLState().equals("23514"))
		{
			alert = "Update quantity failed: Quantity cannot be zero or negative.";
			session.setAttribute("msg-pOrder", alert);
			session.setAttribute("prod_id",request.getParameter("id"));
			session.setAttribute("prod_name",request.getParameter("name"));
			session.setAttribute("prod_price",request.getParameter("price"));
			response.sendRedirect("http://localhost:9999/CSE135Project1_eclipse/templates/product-order.jsp");
			System.out.println(alert);
		}else{       
        throw new RuntimeException(e);
		}
    } catch (NumberFormatException e){
		  alert = "Update quantity failed: Quantity must be an integer";
		  session.setAttribute("msg-pOrder", alert);
		  session.setAttribute("prod_id",request.getParameter("id"));
		  session.setAttribute("prod_name",request.getParameter("name"));
		  session.setAttribute("prod_price",request.getParameter("price"));
		  response.sendRedirect("http://localhost:9999/CSE135Project1_eclipse/templates/product-order.jsp");
		  System.out.println("Quantity must be an integer");	
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
   </td>
   </tr>
  </table>
  </main>
  </body>
</html>