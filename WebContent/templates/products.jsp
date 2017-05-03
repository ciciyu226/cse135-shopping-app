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
%>
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
  	<li><a href="signup.jsp">Go to sign up</a></li>
  	<li><a href="/CSE135Project1_eclipse/index.jsp">Go to log in</a></li>
  	<li><a href="home.jsp">Home Page</a></li>
  	<li><a href="categories.jsp">Categories Page</a></li>
  	<li><a href="products.jsp"></a>Products Page</li>
  </ul>
  	 </td>
   </tr>
   </tr>
     <td>
     <ul>
       <label>Sort by:</label>
       <li><input type="text" placeholder="Item Name"></input></li>
       <li><form name="Category" action="product.jsp" value="categorySort">Category:</form>
       <%
     	  Statement categoryStatement = conn.createStatement();
     	  rs = categoryStatement.executeQuery("SELECT * FROM category");
     	  while( rs.next() ){
     		  %>
     		  <ul>
     		  	<li><input type="submit" value="<%=rs.getString("name")%>"></li>
     		  </ul>
     		  <%
     		
     	  }
     	  rs = null;
       %>
       </form></li>
     </ul>
     <ul>
       
     </ul>
     </td>
  	 <td>

    <%-- -------- INSERT Code -------- --%>
    <%
        String action = request.getParameter("action");
        // Check if an insertion is requested
        if (action != null && action.equals("insert")) { 

            // Begin transaction
            conn.setAutoCommit(false);

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
    %>
    <%-- -------- UPDATE Code -------- --%>
    <%
        // Check if an update is requested
        if (action != null && action.equals("update")) {

            // Begin transaction
            conn.setAutoCommit(false);

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
                .prepareStatement("DELETE FROM Product WHERE id = ?");

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
        // the student attributes FROM the product table.
        rs = statement.executeQuery("SELECT * FROM product");
        //rs2 = statement.executeQuery("SELECT id,name FROM category");
    %>
    
    <!-- Add an HTML table header row to format the results -->
    
    <!-- Print out the message -->
    <%if( session.getAttribute("message")!=null )
   	  {
    	%>
    	  <h3 style="color:red"><%=session.getAttribute("message")%></h3>
   <%     session.removeAttribute("message");
      } %>
      
    <table border="1" style="color:blue">
    <tr>
     	<!-- Removed id here -->
        <th>Name</th>
        <th>SKU</th>
        <th>Price</th>
        <th>Category</th>
    </tr>

    <tr>
        <form action="products.jsp" method="POST">
            <input type="hidden" name="action" value="insert"/>
            <!-- Removed id here -->
            <th><input name="name" placeholder="Enter Name" size="10"/></th>
            <th><input name="SKU" placeholder="Enter SKU" size="15"/></th>
            <th><input name="price" placeholder="Sell Price(Ex:3.99)" size="15"/></th>
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
        	statement3 = conn.createStatement();
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
            <input value="<%=rs.getString("price")%>" name="price" size="15"/>
        </td>

        <%-- Get the category --%>
        <td>
            <select name="category">
            <%
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
            <%}
            }
            %>
            </select>
        </td>

        <%-- Button --%>
        <td><input type="submit" value="Update"></td>
        </form>
        <form action="products.jsp" method="POST">
            <input type="hidden" name="action" value="delete"/>
            <input type="hidden" name="id" value="<%=rs.getInt("id")%>" />
            <%-- Button --%>
        <td><input type="submit" value="Delete"/></td>
        </form>
    </tr>

    <%
        }
    %>
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
  </table>
  </td>
  </tr>
  </table>
  </main>
  </body>
</html>