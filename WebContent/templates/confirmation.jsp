<html>
<head>
  <meta charset="utf-8">
  <title> Confirmation </title>
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
//Check if card number was input properly
if( request.getParameter("card_number")==null || request.getParameter("card_number")=="" 
		|| request.getParameter("card_number").matches(".*[a-z].*")){
	session.setAttribute("cardMessage","Please enter your payment information again.");
	response.sendRedirect("http://localhost:9999/CSE135Project1_eclipse/templates/buy-shopping-cart.jsp");
	return;
}
//Check if cart was empty
if( request.getParameter("p_total")==null || request.getParameter("p_total")=="" ){
	session.setAttribute("sortMessage","Cart was empty. Please add something to cart first.");
	response.sendRedirect("http://localhost:9999/CSE135Project1_eclipse/templates/products-browsing.jsp");
	return;
}
%>
<header>
  <h2 style="color:blue">Successfully Purchased the Following Items</h2>
</header>
<main>
  <%-- Import the java.sql package --%>
  <%@ page import="java.sql.*"%>
  <%-- Import the java utils that has date and calendar --%>
  <%-- -------- Open Connection Code -------- --%>
  <%
  
  Connection conn = null;
  PreparedStatement pstmt = null;
  PreparedStatement pstmt2 = null;
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
	  
	  <!-- DB WORK HERE -->
	  <%
	  //BUY THE ITEMS(MARK ITEMS AS BOUGHT IN PURCHASE_HISTORY TABLE)
	  conn.setAutoCommit(false);
	  
	  pstmt = conn.prepareStatement("INSERT INTO Transactions(customer,time,card_number,total) VALUES(?,?,?,?)",
			  Statement.RETURN_GENERATED_KEYS);
	  pstmt.setInt(1, (Integer)session.getAttribute("uid"));
	  
	  System.out.println("UID IS " + session.getAttribute("uid"));
	  
	  Timestamp time = new Timestamp(System.currentTimeMillis());
	  pstmt.setTimestamp(2, time);
	  //System.out.println("TIME IS " + time);
	  pstmt.setString(3, request.getParameter("card_number"));
	  //System.out.println("CARD NUM IS " + request.getParameter("card_number"));
	  pstmt.setDouble(4, Double.parseDouble( request.getParameter("p_total")) );
	  //System.out.println("P_TOTAL IS " + request.getParameter("p_total"));
	  
	  pstmt.execute();
	  conn.commit();
	  
	  int trans_id;
      try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
          if (generatedKeys.next()) {
              trans_id = generatedKeys.getInt(1);
          }
          else {
              throw new SQLException("Creating transaction failed, no ID obtained.");
          }
      }
      
      pstmt2 = conn.prepareStatement("UPDATE Purchase_History SET bought='Y', trans_id=? WHERE bought IS NULL AND customer=?");
      pstmt2.setInt(1, trans_id);
      pstmt2.setInt(2, (Integer)session.getAttribute("uid"));
      
      pstmt2.execute();
      conn.commit();
      conn.setAutoCommit(true);
      
	  //SELECT FROM PURCHASE HISTORY
	  Statement statement = conn.createStatement();
	  rs = statement.executeQuery("SELECT * FROM Purchase_History ph, Product p WHERE trans_id="
			  + trans_id +" AND ph.customer=" + session.getAttribute("uid") + " AND ph.product=p.id");
	  	  
	  double runningSum = 0;
	  double itemSum;
	  int quantitySum = 0;
	  %>
	  <table border="1">
	  <tr>
	  <td>Item</td>
	  <td>Unit Price</td>
	  <td>Quantity</td>
	  <td>Price</td>
	  </tr>
	  <%
	  while(rs.next()){
	  %>
	  <tr>
	  	<td>
	  	  <input value="<%=rs.getString("name")%>" readonly/>
	  	</td>
	  	<td>  
	  	  <input value="$<%=rs.getDouble("price_at_purchase")%>" readonly/>
	  	</td>
	  	<td>
	  	  <input value="<%=rs.getInt("quantity")%>" readonly/>
	  	</td>
		<td>
		  <% itemSum = rs.getDouble("price_at_purchase") * rs.getInt("quantity");
		     runningSum += itemSum;
		     quantitySum += rs.getInt("quantity");
		  %>
		  <input value="$<%=itemSum%>" readonly/>
		</td>
	  </tr>
	  <%
	  }
	  %>
	  <tr>
	    <td>Total:</td>
	    <td>--</td>
	    <td><%=quantitySum%></td>
	    <td>$<%=runningSum%></td>
	  </tr>
	  </table>
	  <p>Transaction Number: <%=trans_id %></p>
	  <p>Transaction Amount: <%=request.getParameter("p_total")%></p>
	  
	  <p>
	  <form action="products-browsing.jsp">
	  	<input type=submit value="Back to Browsing"/>
	  </form>
	  </p>
        
    <%-- -------- Close Connection Code -------- --%>
    <%
        // Close the ResultSet
        rs.close();

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
</main>
</body>
</html>