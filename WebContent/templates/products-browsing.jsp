<html>
<head>
  <meta charset="utf-8">
  <title> Products Browsing </title>
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
   <tr>
  	 <td>
  	 	 <a href="home.jsp">Home</a>
  	 	 <a href="buy-shopping-cart.jsp">Buy Shopping Cart</a>

  	 </td>
  	 <td><h1 style="color:blue">Welcome to the Products Browsing Page!</h1></td>
   </tr>
    <tr>
      <td></td>
      <%if(session.getAttribute("msg") != null){ %>
      <td><h3 style="color:green"><%=session.getAttribute("msg") %></h3></td>
      <% session.removeAttribute("msg");
        }%>
    </tr>
    <tr>
     <td>
     <!-- SORTING SECTION -->
     <ul>
       <label>Sort by:</label>
       <li><form action="products-browsing.jsp" method="POST">
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
     	  <form action="products-browsing.jsp" method="POST">
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
     		  	<form action="products-browsing.jsp" method="POST">
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
  	     <%-- -------- SELECT Statement Code -------- --%>
    <%
        // Create the statement
        Statement statement = conn.createStatement();
    	Statement statement2 = conn.createStatement();

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
        <!-- Print out the message -->
		<%if( session.getAttribute("sortMessage")!=null )
   	  {
    	%>
    	  <h3 style="color:red"><%=session.getAttribute("sortMessage")%></h3>
   <% 	  session.removeAttribute("sortMessage");
      } %>
        <%if( session.getAttribute("message")!=null )
   	  {
    	%>
    	  <h3 style="color:red"><%=session.getAttribute("message")%></h3>
   <% 	  session.removeAttribute("message");
      } %>

    <table border="1" style="color:blue">
    <tr>
        <th>Name</th>
        <th>SKU</th>
        <th>Price</th>
        <th>Category</th>
        <th>Buy</th>
    </tr>
    <%-- -------- Iteration Code -------- --%>
    <%
        // Iterate over the ResultSet
        while (rs.next()) {
        	rs2 = statement2.executeQuery("SELECT name FROM category WHERE delete IS NULL AND id='" + rs.getInt("category") + "'");
        	rs2.next();
    %>

    <tr>
        <form action="product-order.jsp" method="POST">
            <input type="hidden" name="id" value="<%=rs.getInt("id")%>"/>

        <%-- Get the id --%>
		<!-- Removed id here -->

        <%-- Get the name --%>
        <td>
            <input value="<%=rs.getString("name")%>" name="name" size="15" readonly/>
        </td>

        <%-- Get the SKU --%>
        <td>
            <input value="<%=rs.getString("SKU")%>" name="SKU" size="15" readonly/>
        </td>

        <%-- Get the price --%>
        <td>
            <input value="<%=rs.getString("price")%>" name="price" size="15" readonly/>
        </td>

        <%-- Get the category --%>
        <td>
          <input value="<%=rs2.getString("name")%>" name="category" size="15"  readonly/>
        </td>
        <td>
       	  <input type="submit" value="Details>>" size="15"/>
        </td>
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
</main>
</body>
</html>