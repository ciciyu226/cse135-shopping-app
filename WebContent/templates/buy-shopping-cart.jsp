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
<main class="wrapper">
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
  <header>
  	<h2>Hello <%=session.getAttribute("username") %>!</h2>
  </header>
  <table>
  <h1 style="color:blue">Welcome to Cart Checkout!</h1>
  <p><a href="home.jsp"/>Go Back to Home Page</a></p>
  <table border="1" style="color:blue">
    <tr>
      <th>Item</th>
      <th>Unit Price</th>
      <th>Quantity</th>
      <th>Price</th>
    </tr>
  <!-- SELECT FROM PURCHASE HISTORY -->
  <%
  Statement statement = conn.createStatement();
  rs = statement.executeQuery("SELECT * FROM Purchase_History ph, Product p WHERE ph.bought IS NULL AND ph.customer="
		  + session.getAttribute("uid") + " AND ph.product=p.id");
  double runningSum = 0;
  double itemSum = 0;
  int quantitySum = 0;
  
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
  <br>
 <% if(session.getAttribute("cardMessage")!=null){ %>
  	<h3 style="color:red"><%=session.getAttribute("cardMessage") %></h3>
 <% 
 	session.removeAttribute("cardMessage");
    } %>
  <form action="confirmation.jsp" method="POST">
    <input type="text" name="card_number" placeholder="Enter Card Number"/>
  	<input type="submit" value="Buy Cart" style="width:100"/>
  	<input type="hidden" name="p_total" value="<%=(double)itemSum%>"/>
  </form>
  
      
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