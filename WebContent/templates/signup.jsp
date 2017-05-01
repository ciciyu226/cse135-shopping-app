<html>
<head>
  <title>Signup Page</title>
  <meta charset="UTF-8">
  <link href="../css/style.css" rel="stylesheet" type="text/css">
</head>
<body style="background-color:cyan">
  <div class="text-center">
    <h1 style="color:blue">
      Signup
    </h1>
    <hr>
    <div>
    	<%@ page import="java.sql.*"%>
    	<%
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			Class.forName("org.postgresql.Driver");
			
			conn = DriverManager.getConnection(
			"jdbc:postgresql://localhost:5432/postgres?" +
        	"user=postgres&password=postgres");	
		%>
		<%
			conn.setAutoCommit(false);
			String username = request.getParameter("username");
			String role = request.getParameter("role");
			String age = request.getParameter("age");
			String state = request.getParameter("state");

			String alert = null;
			if(username != null) {
				if(username == "" | role == "" | age == "" | state == ""){
					alert = "Info cannot be empty. Please fill out the form again.";
					session.setAttribute("error-msg", alert);
					response.sendRedirect("http://localhost:9999/CSE135Project1_eclipse/templates/signup-failure.jsp");
					System.out.println("Info cannot be empty. Please fill up the form again.");
				}			
		    	else { 
		    	  System.out.println ("all fields are filled out.");			
				  //Check if username is valid by checking duplicate in database
				  //if it is valid, redirect to login page.(requirement: redirect to page says login successful)
				  Statement statement = conn.createStatement();
				  rs = statement.executeQuery("SELECT username FROM Client WHERE username ='" + username + "'");
				  if(rs.next()){
				    alert = "username is already exist. Try a different name.";
					session.setAttribute("error-msg", alert);
					response.sendRedirect("http://localhost:9999/CSE135Project1_eclipse/templates/signup-failure.jsp");
				  	System.out.println("username is already exist. Try a different name.");
				  }else {
					try {
						Integer.parseInt(age);
				
						//Create the prepared statement and use it to insert signup 
						//user information
						pstmt = conn.prepareStatement("INSERT INTO Client(username, role, age, loc_state) VALUES (?,?,?,?)");
						pstmt.setString(1, username);
						pstmt.setString(2, role);
						pstmt.setInt(3, Integer.parseInt(age));
						pstmt.setString(4, state);
			
						int rowCount = pstmt.executeUpdate();
				
            			// Commit transaction
            			conn.commit();
            			conn.setAutoCommit(true);
		
						rs.close();
	        			statement.close();
	        		    conn.close();
	        		    
						response.sendRedirect("http://localhost:9999/CSE135Project1_eclipse/templates/signup-success.jsp");
					}catch (NumberFormatException e) {
						alert = "Age must be an integer";
						session.setAttribute("error-msg", alert);
						response.sendRedirect("http://localhost:9999/CSE135Project1_eclipse/templates/signup-failure.jsp");
						System.out.println("Age must be an integer");	
					}
				 }
	     	  }
			}
		}catch (SQLException e) {	
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

    
      <form action="signup.jsp" method="">
        Please enter a username:<br>
        <input type="text" name="username" placeholder="Example123"><br>
    	  Please enter your age:<br>
        <input type="text" name="age" placeholder="Age in Years"><br>
    	  Please enter your desired account type:
    		  
    	  <select name="role">
          <!-- <option>--</option> -->
          <option value="customer">Customer</option>
          <option value="owner">Owner</option>
          
        </select><br>
        Please select the state which you reside in:
        
        <select name="state">
          <!-- <option>--</option> -->
          <option value="AL">Alabama</option>
          <option value="AK">Alaska</option>
          <option value="AZ">Arizona</option>
          <option value="AR">Arkansas</option>
          <option value="CA">California</option>
          <option value="CO">Colorado</option>
          <option value="CT">Connecticut</option>
          <option value="DE">Delaware</option>
          <option value="DC">District Of Columbia</option>
          <option value="FL">Florida</option>
          <option value="GA">Georgia</option>
          <option value="HI">Hawaii</option>
          <option value="ID">Idaho</option>
          <option value="IL">Illinois</option>
          <option value="IN">Indiana</option>
          <option value="IA">Iowa</option>
          <option value="KS">Kansas</option>
          <option value="KY">Kentucky</option>
          <option value="LA">Louisiana</option>
          <option value="ME">Maine</option>
          <option value="MD">Maryland</option>
          <option value="MA">Massachusetts</option>
          <option value="MI">Michigan</option>
          <option value="MN">Minnesota</option>
          <option value="MS">Mississippi</option>
          <option value="MO">Missouri</option>
          <option value="MT">Montana</option>
          <option value="NE">Nebraska</option>
          <option value="NV">Nevada</option>
          <option value="NH">New Hampshire</option>
          <option value="NJ">New Jersey</option>
          <option value="NM">New Mexico</option>
          <option value="NY">New York</option>
          <option value="NC">North Carolina</option>
          <option value="ND">North Dakota</option>
          <option value="OH">Ohio</option>
          <option value="OK">Oklahoma</option>
          <option value="OR">Oregon</option>
          <option value="PA">Pennsylvania</option>
          <option value="RI">Rhode Island</option>
          <option value="SC">South Carolina</option>
          <option value="SD">South Dakota</option>
          <option value="TN">Tennessee</option>
          <option value="TX">Texas</option>
          <option value="UT">Utah</option>
          <option value="VT">Vermont</option>
          <option value="VA">Virginia</option>
          <option value="WA">Washington</option>
          <option value="WV">West Virginia</option>
          <option value="WI">Wisconsin</option>
          <option value="WY">Wyoming</option>
          
        </select><br>
        <input class="btn" type="submit" onclick="alert('Form Submitted!')" value="Create Account">
      </form>
    </div>
  </div>
</body>
</html>