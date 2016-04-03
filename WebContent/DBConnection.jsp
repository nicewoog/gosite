<%@page import="java.sql.Statement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="javax.naming.InitialContext"%>
<%@page import="javax.sql.DataSource"%>
<%@page import="javax.naming.Context"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	Context initContext = new InitialContext();
	Context envContext  = (Context)initContext.lookup("java:/comp/env");
	DataSource ds = (DataSource)envContext.lookup("jdbc/gosite");
	Connection conn = ds.getConnection();
	System.out.println(conn);
	
	
	Connection con = null;
  	Statement stmt = null;
  	ResultSet rs = null;
  	
  	Class.forName("com.mysql.jdbc.Driver");
  	
	try{
		  
		  stmt = conn.createStatement();
		  rs = stmt.executeQuery("SELECT * FROM gosites");
		  while (rs.next()) {
		  	String result = rs.getString("WebName");
		  	System.out.println(result);
		  }
		  
	} catch (Exception e){
		e.printStackTrace();
	} finally {
		if(con != null) { con.close(); }
		if(conn != null) { conn.close(); }
		if(stmt != null) { stmt.close(); }
		if(rs != null) { rs.close(); }
	}
%>