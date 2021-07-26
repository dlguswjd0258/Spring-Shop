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
		#sliding_images{
			width: 1300px;
			height: 600px;
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
	</style>
	<!-- 2020.06.28 EDITED -->
	<script type="text/javascript">
		window.onload = function(){
			setTimeout(second_img, 3000);
		}
	
		var f_timer;
		function first_img(){
			document.getElementById("sliding_images").style.backgroundImage = "url(../team4/resources/image/back1.jpg)";
			document.getElementById("img_name").value = "back1";
			
			f_timer = setTimeout(second_img, 3000);
		}
		
		var s_timer;
		function second_img(){
			document.getElementById("sliding_images").style.backgroundImage = "url(../team4/resources/image/back2.jpg)";
			document.getElementById("img_name").value = "back2";
			
			s_timer = setTimeout(third_img, 3000);
		}
		
		var t_timer;
		function third_img(){
			document.getElementById("sliding_images").style.backgroundImage = "url(../team4/resources/image/back3.jpg)";
			document.getElementById("img_name").value = "back3";
			
			t_timer = setTimeout(first_img, 3000);
		}
		
		function next_img(){
			var img_name = document.getElementById("img_name").value;
			var sliding_images = document.getElementById("sliding_images"); 
			if(img_name == "back1"){
				clearTimeout(f_timer);
				second_img();
				return;
			}else if(img_name == "back2"){
				clearTimeout(s_timer);
				third_img();
				return;
			}else if(img_name == "back3"){
				clearTimeout(t_timer);
				first_img();
				return;
			}
		}
		
		function prev_img(){
			var img_name = document.getElementById("img_name").value;
			if(img_name == "back1"){
				clearTimeout(f_timer);
				setTimeout(third_img, 0);
				return;
			}else if(img_name == "back2"){
				clearTimeout(s_timer);
				setTimeout(first_img, 0);
				return;
			}else if(img_name == "back3"){
				clearTimeout(t_timer);
				setTimeout(second_img, 0);
				return;
			}
		}
	</script>
</head>
<body>
	<jsp:include page="../index/index_top.jsp"></jsp:include>
	<!-- 2020.06.26 EDITED -->
	<!-- 2020.06.27 EDITED --> 
	<div id="sliding_images"
		style="background-image: url(../team4/resources/image/back1.jpg); background-repeat: no-repeat; background-size: 100% 100%; margin-top: 30px;">
		<input type="hidden" value="back1" id="img_name">
		<table width="100%" height="100%">
			<tr>
				<td width="50%" align="left" ><a style="font-size: 70px;" href="javascript:void(0);" onclick="prev_img();">&lt;</a></td>
				<td width="50%" align="right"><a style="font-size: 70px;" href="javascript:void(0);" onclick="next_img();">&gt;</a></td>
			</tr>
		</table>
	</div>
	<div id="body">
		<c:if test="${empty list}">
			<p align="center">등록된 상품이 없습니다</p>
		</c:if>
		<c:if test="${!empty list}">
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
									<div class="HOT state_tag" style="background-color: red;" align="center">
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