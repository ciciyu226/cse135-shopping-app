<html>
  <head>
    <meta charset="utf-8">
    <title> My Online Shopping Site </title>
    <!-- css links -->
    <link href="css/style.css" rel="stylesheet" type="text/css">
  </head>
  <body>
    <main>
      <div class="wrapper text-center">
        <h2> Log In </h2>
        <%@ page import="java.sql.*" %>
        <%
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
        	//Registering Postgresql JDBC driver with teh DriverManager
        	Class.forName("org.postgresql.Driver");
        	//Open a connection to the database using DriverManager
        	conn = DriverManager.getConnection(
        			"jdbc:postgresql://localhost:5432/postgres?" +
        			"user=postgres&password=postgres");
        %>

        <%
	        /* String action = request.getParameter("action"); */
	    String username = request.getParameter("username");
	    String alert = "";
	    Statement statement = conn.createStatement();

	    /* System.out.print(input_name) */
	    if(username != "") {
	       	// Create the statement
	        if (username != null) {
		        rs = statement.executeQuery("SELECT username, role FROM Client WHERE username ='" + username + "'");
		       	if(!rs.next()) {
		       		alert = "The Provided name " + username + " does not exist. Enter username again.";
		       	}
		       	else{
<<<<<<< HEAD
		       		String role = rs.getString("role");
		       		session.setAttribute("username", username);
		       		session.setAttribute("role", role);
		       		response.sendRedirect("http://localhost:9999/CSE135Project1_eclipse/templates/home.jsp?");
		       	}
=======
		       		session.setAttribute("username",input_name);
		       		response.sendRedirect("http://localhost:9999/CSE135Project1_eclipse/templates/home.jsp");
		       	}
>>>>>>> 1ec991b5360c3bf29a8ab808faa31b8ea9044a45

	        rs.close();
	        statement.close();
	        conn.close();
	        }
	    }else {
	    	alert = "username cannot be empty.";
	    }

	    %>
	    <form action="index.jsp" method="POST">
        <label>Username: </label><input type="text" name="username"><br>
        <span><%=alert%></span><br>
        <input class=" btn btn-login" type="submit" value="Log In">

      	</form>
      <a href="templates/signup.jsp" style="color:blue;">Don't have an account? Sign up here!</a>
	<%  }catch (SQLException e) {
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
      </div>
    </main>
  </body>
</html>