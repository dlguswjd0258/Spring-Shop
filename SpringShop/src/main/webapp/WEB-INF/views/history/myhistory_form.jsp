<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/myhistory.css">
	<style type="text/css">
		table .no_order {
		    padding: 50px 0;
		    text-align: center;
		    color: #757575;
		    font-weight: normal;
		}
		
		
		table th:before{
			position: absolute;
			top: 0;
		    left: 0;
		    display: block;
		    content: "";
		    width: 100%;
		    height: 1px;
		    background: #d7d5d5;	
		}
		
	</style>
</head>
<body>
	<jsp:include page="../index/index_top.jsp" />
	<jsp:include page="mypage_head.jsp" />

	<div id="main">
		<div class="sub_title">
			<h3>주문내역</h3>
		</div>
		<table border="1" class="history_table">
			<colgroup>
				<col style="width:135px;">
				<col style="width:93px;">
				<col style="width:auto;">
				<col style="width:61px;">
				<col style="width:111px;">
				<col style="width:111px;">
			</colgroup>
			<thead>
				<tr>
					<th>주문일자<br>[주문번호]</th>
					<th>이미지</th>
					<th>상품정보</th>
					<th>수량</th>
					<th>상품구매금액</th>
					<th>주문처리상태</th>
				</tr>
			</thead>
			<tbody class="center">
				<c:if test="${ empty b_list }">
					<tr>
						<td colspan="6" class="no_order">주문 내역이 없습니다.</td>
					</tr>
				</c:if>
				
				<c:forEach var="b" items="${ b_list }">
					<c:forEach var="i" begin="0" end="${ b.size()-1 }">
						<tr>
							<c:if test="${ i eq 0 }">
								<td rowspan="${ b.size()}">
									${ b[i].buydate.split(" ")[0] }<br>
									[<a href="myhistory_detail_form.do?o_idx=${ b[i].o_idx }">${ b[i].o_idx }</a>]
								</td>
							</c:if>
							<td><img alt="주문한 상품 이미지" src="${pageContext.request.contextPath}/resources/upload/${b[i].filename_s}"></td>
							<td class="p_info">
								<a href="product_one.do?idx=${ b[i].p_idx }"><strong>${ b[i].p_name }</strong><br></a>
								<div class="option">[사이즈: ${ b[i].p_size }, 색상: <div class="color_box" style="background-color: ${b[i].p_color}"></div>]</div>
							</td>
							<td>${ b[i].p_cnt }</td>
							<td><strong><fmt:formatNumber value="${ b[i].amount }"/>원</strong></td>
							<td>
								<c:choose>
									<c:when test="${ b[i].delivery eq 0 }">
										주문 접수
									</c:when>
									<c:when test="${ b[i].delivery eq 1 }">
										배송중
									</c:when>
									<c:when test="${ b[i].delivery eq 2 }">
										배송 완료
									</c:when>
								</c:choose>
							</td>
						</tr>
					</c:forEach>
				</c:forEach>
			</tbody>
		</table>
		<c:if test="${!empty b_list }">
		<div style="width: 1300px;height: 50px;margin: 0 auto;" align="center">
			<p>${pageMenu}</p>
		</div>
		</c:if>
	</div>

	<jsp:include page="../index/index_bottom.jsp" />
</body>
</html>