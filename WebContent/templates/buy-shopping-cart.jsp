<html>
<head>
  <meta charset="utf-8">
  <title> Buy Shopping Cart </title>
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
<main>
  <%-- Import the java.sql package --%>
  <%@ page import="java.sql.*"%>
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
  <table>
  <h1 style="color:blue">Welcome to Cart Checkout!</h1>
  <table border="1" style="color:blue">
    <tr>
      <th>Item</th>
      <th>Quantity</th>
      <th>Price</th>
    </tr>
  <!-- SELECT FROM PURCHASE HISTORY -->
  <%
  Statement statement = conn.createStatement();
  rs = statement.executeQuery("SELECT * FROM Purchase_History ph, Product p WHERE ph.bought IS NULL AND ph.customer="
		  + session.getAttribute("uid") + " AND ph.product=p.id");
  while(rs.next()){
  %>
  <tr>
  	<td>
  	  <input value="<%=rs.getString("name")%>" readonly/>
  	</td>
  	<td>
  	  <input value="<%=rs.getInt("quantity")%>" readonly/>
  	</td>
  	<td>  
  	  <input value="$<%=rs.getDouble("price_at_purchase")%>" readonly/>
  	</td>
  </tr>
  <%
  }
  %>
  <tr>
  <td>Total:</td>
  <td></td>
  <td>
  <%
  statement = conn.createStatement();
  rs = statement.executeQuery("SELECT SUM(price_at_purchase) as sum FROM Purchase_History " 
  	+ "WHERE bought IS NULL AND customer=" + session.getAttribute("uid"));
  rs.next();
  %>
  $<%=rs.getInt("sum") %>
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