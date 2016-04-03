<%@page import="java.util.List"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
  <head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

    <!-- 제이쿼리 -->
    <script src="https://code.jquery.com/jquery.min.js"></script>

    <!-- 부트스트랩 3.3.2 -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap-theme.min.css">
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>

    <title>오늘은 어딜 가지?</title>
  </head>
  <body>
  	<div id="hide"></div>
	  <%/* 
		out.print("<p>Remote Addr: " + request.getRemoteAddr() + "</p>");
		out.print("<p>Remote Host: " + request.getRemoteHost() + "</p>");
		out.print("<p>X-Forwarded-For: " + request.getHeader("X-Forwarded-For") + "</p>");
		out.print("<p>WL-Proxy-Client-IP: " + request.getHeader("WL-Proxy-Client-IP") + "</p>");
		
		String visit_date = (new SimpleDateFormat("yyyyMMdd")).format(new Date());
		out.print((new SimpleDateFormat("yyyyMMdd")).format(new Date())); */
		
		String visit_date = (new SimpleDateFormat("yyyyMMdd")).format(new Date());
	  %>
	
	<c:set var="visitor_ip" value="<%= request.getRemoteAddr() %>"/>
	<c:set var="visit_date" value="<%= visit_date %>"/>

	<!-- 
		방문자수 및 클릭수 카운팅하기 위하여 DB를 조회하여 IP정보를 받아오는 기능
		
		자바스크립트 변수 ipList에 접속한 날짜에 대한 접속자의 모든 IP를 저장한다.
		물론,이 IP주소들은 페이지에 접속과 동시에 DB에 insert되는 정보이다.
	 -->
	<script>
		var ipList = [];
		var visitor_ip = "${visitor_ip}";
		var fistVisitToday = "true"; // true이면 오늘은 처음 접속
	</script>
	<sql:query var="visit_check" dataSource="jdbc/gosite">
		select 'Y' as 'checker' from gosite_visit_total where date=? and visitor_ip=?
		<sql:param value="${visit_date}"></sql:param>
		<sql:param value="${visitor_ip}"></sql:param>
	</sql:query>
	<!-- 오늘 첫 방문인지 확인 <script>
		var aa = "${fn:length(visit_check.rows)}"
		alert(aa);
	</script> -->
	<c:if test="${fn:length(visit_check.rows) == 0}">	
		<script>
			$.ajax({
				url:'./visitInsert.jsp',
				dataType:'html',
				success: function(data){
					$('#hide').html(data)
				}
			});
		</script>
	</c:if>
	
  	
	
	<!-- static 변수를 set으로 설정 -->
	<c:set var="tooltib_desc" value="더 자세한 설명을 원한다면 Click!!"></c:set>
	
	
	<!--추천할 사이트의 정보를 받아와 데이터를 할당. -->
	<sql:query var="rs" dataSource="jdbc/gosite">
		select * from gosites where ID=1
	</sql:query>
	<c:forEach var="row" items="${rs.rows}">
		<c:if test="${row.id == 1}">
			<c:set var="site" value="${row}"></c:set>
		</c:if>
	</c:forEach>
		
    <div class="container">
      <div class="row">
        <div class="col-md-12">
          <h1 style="text-align:center">오늘은 어딜 가지? <c:out value="${fistVisitToday}"></c:out></h1>
        </div>
      </div>
      <div class="row">
      <div class="col-md-2" style="padding-left: 40px;padding-right: 40px;">
          <ul class="nav nav-pills nav-stacked" style="text-align:center">
            <li role="presentation" class="active"><a href="#">ALL</a></li>
            <li role="presentation"><a href="#">뉴스</a></li>
            <li role="presentation"><a href="#">건강</a></li>
            <li role="presentation"><a href="#">IT</a></li>
            <li role="presentation"><a href="#">동물</a></li>
            <li role="presentation"><a href="#">게임</a></li>
          </ul>
        </div>
        <div class="col-md-8" style="text-align:center">
          <br>
          <div class="row"><div class="col-md-12">
            <img src="${site.Logo}" class="img-thumbnail" style="cursor:pointer" onclick="fnGosite()"/>
            <h2>${site.WebName}</h2><br><br>
          </div></div>
          <div class="row">
            <div class="col-md-12" id="moveToWiki">
              <div style="background-color:black">
	              <div id="siteInfo" data-toggle="tooltip" data-placement="bottom" title="${tooltib_desc}" style="background-color:white;cursor:pointer" onclick="fnSiteInfo()">
	                ${site.SiteInfo}
	              </div>
            	</div>
            	<br><br>
            	<button class="btn btn-primary">다른 추천 사이트 보기</button>
            </div>
          </div>
        </div>
        <div class="col-md-2">
        	<div class="col-md-12" style="text-align:center">
        		<h4><span id="visitCnt" class="label label-primary" data-toggle="tooltip" data-placement="top" title="클릭 수 / 총 방문자 수">5 / 10</span></h4>
        	</div>
      	</div>
      </div>
      <div class="row">
        <div class="col-md-12">
          <h2 style="text-align:center">Footer here</h2>
        </div>
      </div>
    </div>
  </body>


  <script>
    $(function () {
      $('[data-toggle="tooltip"]').tooltip('hide');
    });

    // Div-Tag Fade option
    $(function (){
      $('#siteInfo').mouseover(function(){
        $('#siteInfo').fadeTo("fast", 0.4);
      });
      $('#siteInfo').mouseout(function(){
        $('#siteInfo').fadeTo("fast", 1.0);
      });
    });
    
    // 방문자-tag Fade option
    
    // 위키 설명 보러가기
    function fnSiteInfo(){
    	var siteInfoUrl = "${site.SiteInfoUrl}"; // JSTL로 입력된 주소값 가져오기
    	window.open(siteInfoUrl);
    }
    
    // 사이트로 이동
    function fnGosite(){
    	var logoUrl = "${site.LogoUrl}";
    	window.open(logoUrl);
    }
    
  </script>
</html>
