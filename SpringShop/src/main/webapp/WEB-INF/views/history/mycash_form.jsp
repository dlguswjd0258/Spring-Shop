<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/myhistory.css">
	<style type="text/css">
		.sub_title h3{
			display: inline;
		}
		
		#main input{
			width: 50px;
			height: 25px;
		    border: 1px solid #ddd;
		    color: #555;
			float: right;
			cursor: pointer;
		}
		
		#main input:hover{
		    border: 1px solid #aaa;
		}
		
		#main input:focus{
			outline: none !important;
			border: 1px solid #aaa;
		}
	</style>
	
	<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/httpRequest.js"></script>
	<script type="text/javascript">
		function charge_cash() {
			var cash = prompt("충전할 금액을 작성해 주세요.");
			var pattern = /^[0-9]+$/;
			
			if(!pattern.test(cash)){
				alert("충전할 금액은 정수로 입력해주세요.");
				return;
			}
			
			var url = "cash_update.do";
			var param = "u_idx=" + ${ sessionScope.user.idx } + "&cash=" + cash;
			sendRequest( url, param, resultFnCash, "post");
		}
		
		function resultFnCash() {
			if(xhr.readyState == 4 && xhr.status == 200){
				var data = xhr.responseText;
				
				if(data == 'no'){
					alert("충전에 실패했습니다. 다시 시도해주세요.");
					return;
				}
				
				alert("충전 완료되었습니다.");
				location.href="mycash_form.do?u_idx=" + ${ sessionScope.user.idx }; 
			}
		}
	</script>
</head>
<body>
	<jsp:include page="../index/index_top.jsp" />
	<jsp:include page="mypage_head.jsp" />
	<div id="main">
		<div class="sub_title">
			<h3>예치금 현상황</h3>
			<input type="button" value="충전" onclick="charge_cash();">
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
	                	<div class="tb-center">보유 예치금</div>
	                </th>
	                <td align="right">
	                	<fmt:formatNumber value="${ sessionScope.user.cash }"/>원
	                </td>
	                <th scope="row"><div class="tb-center">누적 사용 예치금</div></th>
	                <td align="right">
	                	<fmt:formatNumber value="${ use_cash }"/>원
	                </td>
	            </tr>
	        </tbody>
	       
		</table>
		
		<div class="sub_title">
			<h3>충전 내역</h3>
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
					<th scope="col">주문날짜</th>
                    <th scope="col">예치금</th>
                    <th scope="col">내용</th>
                </tr>
            </thead>
			
			<tbody>
				<c:if test="${ empty save_list }">
					<tr>
						<td colspan="4" align="center">예치금 내역이 없습니다.</td>
					</tr>
				</c:if>
				
				<c:forEach var="vo" items="${ save_list }">
					<tr>
						<td align="center">${ vo.c_date.split(" ")[0] }</td>
						<td align="right">
							<c:if test="${ vo.c_type eq 1}">-</c:if>
							<fmt:formatNumber value="${ vo.amount }"/>원
						</td>
						<td>
							<c:choose>
								<c:when test="${ vo.c_type eq 0 }">
									예치금 충전
								</c:when>
								<c:when test="${ vo.c_type ne 0 }">
									구매에 대한 예치금 사용
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
			<h3>충전 내역</h3>
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
					<th scope="col">주문날짜</th>
                    <th scope="col">예치금</th>
                    <th scope="col">내용</th>
                </tr>
            </thead>
			
			<tbody>
				<c:if test="${ empty use_list }">
					<tr>
						<td colspan="4" align="center">예치금 내역이 없습니다.</td>
					</tr>
				</c:if>
				
				<c:forEach var="vo" items="${ use_list }">
					<tr>
						<td align="center">${ vo.c_date.split(" ")[0] }</td>
						<td align="right">
							<c:if test="${ vo.c_type eq 1}">-</c:if>
							<fmt:formatNumber value="${ vo.amount }"/>원
						</td>
						<td>
							<c:choose>
								<c:when test="${ vo.c_type eq 0 }">
									예치금 충전
								</c:when>
								<c:when test="${ vo.c_type ne 0 }">
									구매에 대한 예치금 사용
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