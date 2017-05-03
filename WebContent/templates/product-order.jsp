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
        String product_id = request.getParameter("product_id");
    	System.out.println("product_id: "+product_id);
        String quantity = request.getParameter("quantity");  //TODO: need to parse to int later
        String price = request.getParameter("price");
        System.out.println("quantity: "+ quantity);
        String action = request.getParameter("action");
    	String alert = null;
    	
    	if(action != null && action.equals("submit-quantity")){
    		action = null;
    		
    		statement = conn.createStatement();
			rs = statement.executeQuery("SELECT * FROM Product WHERE delete= 'Y' and id ='" + product_id + "'");
				if(!rs.next()){
					alert = "Data modification failed. Reason: This product has already been deleted by an owner.";
					session.setAttribute("error-msg", alert);
					System.out.println("This product has already been deleted by other user.");
				}
				else {
	
		    		if(quantity == ""){
		    			alert = "Update quantity failed: Quantity is empty.";
		    			session.setAttribute("error-msg", alert);
		    			System.out.println(alert);
		    		}else{
		   			
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
     <% if(session.getAttribute("error-msg") != null) { %>
     <h3 style="color: red"><%=session.getAttribute("error-msg") %></h3>
     <% session.removeAttribute("error-msg");
     }%>
     <a href="product-browsing.jsp">Go back to PRODUCT BROWSING</a>
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
	        	<td><input value="<%= request.getParameter("id") %>" name="id" size=15 readonly/></td>
	        	<td><input value="<%= request.getParameter("name") %>" name="name" size=15 readonly/></td>
	        	<td><input value="<%= request.getParameter("price") %>" name="price" size=15 readonly/></td>
	        	<td><input value="" placeholder="Enter quantity" name="quantity" size=15 /></td>
	        	<td><input type="submit" value="Confirm Quantity"></td>
	        </form>
        </tr>

	<%-- -------- Iteration Code -------- --%>
	<tr>
	<% System.out.println("FIRST POINT"); %>
   <form action="product-order.jsp" method="POST">
   	   <input type="hidden" name="action" value="submit-quantity"/>
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

       <%-- Get the quantity --%>
       <td>
           <input value="<%=rs.getInt("quantity")%>" name="quantity" size="15" readonly/>
       </td>
        <%-- Get the price --%>
       <td>
           <input value="<%=rs.getInt("price_at_purchase")%>" name="price" size="15" readonly/>
       </td>     
    </tr>
    <tr><input type="submit" value="Confirm Shopping Cart"/></tr>
    </form>
    </tr>
    <%
        }
    %>
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

        // Wrap the SQL exception in a runtime exception to propagate
        // it upwards
        throw new RuntimeException(e);
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
   </table>
   </td>
   </tr>
  </table>
  </main>
  </body>
</html>