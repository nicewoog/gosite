<%@page import="java.util.List"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<% 
	String visit_date = (new SimpleDateFormat("yyyyMMdd")).format(new Date()); 
	System.out.println(visit_date);
%>
<!-- 접속자가 오늘 첫 접속이면 DB에 데이터를 입력 -->
<c:set var="visitor_ip" value="<%= request.getRemoteAddr() %>"/>
<c:set var="visit_date" value="<%= visit_date %>"/>

<script>
	alert("오늘 처음 접속하셨군요!");
</script>

<sql:update dataSource="jdbc/gosite" var="count">
	insert into gosite_visit_total (date, visitor_ip) values (?,?);
	<sql:param value="${visit_date}"/>
	<sql:param value="${visitor_ip}"/>
</sql:update>