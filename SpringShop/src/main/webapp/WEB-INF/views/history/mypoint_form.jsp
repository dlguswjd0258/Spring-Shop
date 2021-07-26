<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/myhistory.css">
	<style type="text/css">
		.own th, .own td{
			font-weight: bold;
		}	
		.own td{
			padding-right: 10px;
		}
	</style>
</head>
<body>
	<jsp:include page="../index/index_top.jsp" />
	<jsp:include page="mypage_head.jsp" />
	<div id="main">
		<div class="sub_title">
			<h3>적립금 현상황</h3>
		</div>
		
		<table border="1">
			<colgroup>
	           <col style="width:15%">
	           <col style="width:33%">
	           <col style="width:15%">
	           <col style="width:auto">
	       </colgroup>
	       
	       <tbody class="own">
	            <tr>
	                <th scope="row">
	                	<div class="tb-center">보유 적립금</div>
	                </th>
	                <td align="right">
	                	<fmt:formatNumber value="${ sessionScope.user.point }"/>원
	                </td>
	                <th scope="row"><div class="tb-center">누적 사용 적립금</div></th>
	                <td align="right">
	                	<fmt:formatNumber value="${ use_point }"/>원
	                 </td>
	            </tr>
	        </tbody>
	       
		</table>
		
		<div class="sub_title">
			<h3>적립 내역</h3>
		</div>
		
		<table border="1">
			<colgroup>
				<col style="width:15%">
				<col style="width:15%">
				<col style="width:25%"> 
				<col style="width:auto">
			</colgroup>
			
			<thead>
				<tr>
					<th scope="col">적립날짜</th>
                    <th scope="col">적립금</th>
                    <th scope="col">관련 주문</th>
                    <th scope="col">내용</th>
                </tr>
                
                
            </thead>
			
			<tbody>
				<c:if test="${ empty save_list }">
					<tr>
						<td colspan="4" align="center">적립금 내역이 없습니다.</td>
					</tr>
				</c:if>
				
				<c:forEach var="vo" items="${ save_list }">
					<tr>
						<td align="center">${ vo.p_date.split(" ")[0] }</td>
						<td align="right">
							<c:if test="${ vo.p_type eq 1}">-</c:if>
							<fmt:formatNumber value="${ vo.amount }"/>원
						</td>
						<td align="center"><a href="myhistory_detail_form.do?o_idx=${ vo.o_idx }">${ vo.o_idx }</a></td>
						<td>
							<c:choose>
								<c:when test="${ vo.p_type eq 0 }">
									구매에 대한 적립금
								</c:when>
								<c:when test="${ vo.p_type ne 0 }">
									적립금 사용
								</c:when>
							</c:choose>
						</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
		
		<c:if test="${ !empty save_list }">
		<div style="width: 1300px;height: 50px;margin: 0 auto;" align="center">
			<p>${pageMenu.get(0)}</p>
		</div>
		</c:if>
		
		<div class="sub_title">
			<h3>사용 내역</h3>
		</div>
		
		<table border="1">
			<colgroup>
				<col style="width:15%">
				<col style="width:15%">
				<col style="width:25%"> 
				<col style="width:auto">
			</colgroup>
			
			<thead>
				<tr>
					<th scope="col">사용날짜</th>
                    <th scope="col">적립금</th>
                    <th scope="col">관련 주문</th>
                    <th scope="col">내용</th>
                </tr>
                
                
            </thead>
			
			<tbody>
				<c:if test="${ empty use_list }">
					<tr>
						<td colspan="4" align="center">적립 사용 내역이 없습니다.</td>
					</tr>
				</c:if>
				
				<c:forEach var="vo" items="${ use_list }">
					<tr>
						<td align="center">${ vo.p_date.split(" ")[0] }</td>
						<td align="right">
							<c:if test="${ vo.p_type eq 1}">-</c:if>
							<fmt:formatNumber value="${ vo.amount }"/>원
						</td>
						<td align="center"><a href="myhistory_detail_form.do?o_idx=${ vo.o_idx }">${ vo.o_idx }</a></td>
						<td>
							<c:choose>
								<c:when test="${ vo.p_type eq 0 }">
									구매에 대한 적립금
								</c:when>
								<c:when test="${ vo.p_type ne 0 }">
									적립금 사용
								</c:when>
							</c:choose>
						</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
		<c:if test="${ !empty use_list }">
		<div style="width: 1300px;height: 50px;margin: 0 auto;" align="center">
			<p>${pageMenu.get(1)}</p>
		</div>
		</c:if>
	</div>
	<jsp:include page="../index/index_bottom.jsp" />
</body>
</html>