<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
 <head>
    <meta charset="utf-8">
    <title> My Online Shopping Site </title>
    <!-- css links -->
    <link href="../css/style.css" rel="stylesheet" type="text/css">
 </head>
 <body>
	<div class="wrapper">
		<h1>Your signup failed.</h1>
		<h3>-- Reason: <%= session.getAttribute("error-msg")%></h3>
		<a href="/CSE135Project1_eclipse/templates/signup.jsp">Go back to sign up</a>
	</div>
 </body>
</html>