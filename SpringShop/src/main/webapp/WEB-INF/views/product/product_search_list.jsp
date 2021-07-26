<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix ="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix ="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>    
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/basic.css">
	<style type="text/css">
	 
		#header{
			width: 100%;
			height: 200px;
			position: fixed;
			top: 0;
			left: 0;
			background-color: #fff;
			margin: 0 auto;
		}
		
		/* 2020.06.26 EDITED */
		#body{
			width:1300px;
			margin: 0 auto;
		}
		
		.product_block{
			width: 305px;
			height: 540px;
	 		margin-top: 50px;
			margin-left: 13px;  
			float: left;
		}
			
		.block_a{
			margin: 0;
		}
		
		/* 2020.06.26 EDITED */
		.color_box{
			border: none;
			width:10px;
			height:10px;
			display: inline-block;
		}
		
		.state_tag{
			width: 70px;
			height:17px;
			border-radius: 3px;
			display: inline-block;
		}
		
		p{
			margin-top: 30px;
		}
	</style>
	<!-- 2020.06.28 EDITED -->
</head>
<body>
	<jsp:include page="../index/index_top.jsp"></jsp:include>
	<!-- 2020.06.26 EDITED -->
	<!-- 2020.06.27 EDITED --> 
	<div id="body">
		<c:if test="${empty list}">
			<p align="center">'${ search }'로 검색한 결과가 존재하지 않습니다.</p>
		</c:if>
		<c:if test="${!empty list}">
			<p align="center">'${ search }'에 대한 검색 결과입니다.</p>
			<c:forEach var="vo" items="${list}">
			<a href="product_one.do?idx=${vo.idx}" style="color: black;" class="block_a">
				<div class="product_block">
					<table style="height: 100%;">
						<!-- 2020.07.02 EDITED -->
						<tr height="80%">
							<td colspan="2">
									<img src="${pageContext.request.contextPath}/resources/upload/${vo.filename_s}"
									 width="100%" height="72%">
							 </td>
						</tr>
						<tr>
							<td width="300" colspan="2">
									
								<c:forEach var="color" items="${color_map.get(vo.idx)}">
								<c:if test="${color ne '#ffffff'}">
									<div class="color_box" style="background-color: ${color};">
									</div>
								</c:if>
								<c:if test="${color eq '#ffffff'}">
									<div class="color_box" style="background-color: ${color}; border: 1px solid gray; width: 9px; height: 9px;">
									</div>
								</c:if>
								
									
								</c:forEach>
							</td>
						</tr>
						<tr>
							<td width="300" colspan="2">${vo.p_name}</td>
						</tr>
						<tr>
							<!-- 2020.06.29 EDITED -->
							<td width="300" colspan="2">${size_str_map.get(vo.idx)}</td>
						</tr>
						<tr>
							<td width="150" align="left"><b><del><fmt:formatNumber>${vo.p_price}</fmt:formatNumber></del>&nbsp;&nbsp;&nbsp;
												<fmt:formatNumber>${vo.p_saleprice}</fmt:formatNumber></b></td>
							<td width="150" align="right">누적 판매량: ${vo.p_sold}</td>
						</tr>
						<tr>
							<td colspan="2">
								<c:if test="${NEW.get(vo.idx) eq 'NEW'}">
									<div class="NEW state_tag" style="background-color: orange;" align="center">
									NEW
									</div>
								</c:if>
								
								<c:if test="${HOT.get(vo.idx) eq 'HOT'}">
									<div class="HOT state_tag" style="background-image: 'http://www.jogunshop.com/shopimages/jogunshop/prod_icons/40?1536891462';" align="center">
									HOT
									</div>
								</c:if>
								
								<c:if test="${SOLD_OUT.get(vo.idx) eq 'SOLD_OUT'}">
									<div class="SOLD_OUT state_tag" style="background-color: purple; color: white;" align="center">
									SOLD_OUT
									</div>
								</c:if>
							</td>
						</tr>
					</table>
				</div>
			</a>
			</c:forEach>
		<!-- 2020.06.26 EDITED -->
		<div style="width: 1300px; height: 50px; margin: 0 auto; float: left;" align="center">
				<p>${pageMenu}</p>
		</div>
		</c:if>
	</div>
	
	<jsp:include page="../index/index_bottom.jsp"></jsp:include>
</body>
</html>