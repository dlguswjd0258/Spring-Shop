<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:if test="${ empty sessionScope.user }">
	<script>
		alert("잘못된 접근입니다.");
		location.href="login_form.do";
	</script>
</c:if>

<c:if test="${ sessionScope.user.membership == 'bronze' }">
	<c:set var="point_rate" value="0.01"/>
	<c:set var="mem_color" value="#a0534b"/>
</c:if>
<c:if test="${ sessionScope.user.membership == 'gold' }">
	<c:set var="point_rate" value="0.05"/>
	<c:set var="mem_color" value="#a48252"/>
</c:if>
<c:if test="${ sessionScope.user.membership == 'vip' }">
	<c:set var="point_rate" value="0.1"/>
	<c:set var="mem_color" value="#5586EB"/>
</c:if>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Insert title here</title>
		<link rel="stylesheet" href="${ pageContext.request.contextPath }/resources/css/cart_list.css">
		<script type="text/javascript" src="${ pageContext.request.contextPath }/resources/js/httpRequest.js"></script>
		<script type="text/javascript">
			function del(c_idx){
				if (!confirm("해당 상품을 장바구니에서 제거하시겠습니까?")) {
					return;
				}
				
				var url = "cart_delete.do";
				var param = "c_idx="+c_idx;
				
				sendRequest(url,param,resultFn,"post");
			}
			
			function resultFn(){
				if (xhr.readyState == 4 && xhr.status == 200) {
					var data = xhr.responseText;
					if (data == "no") {
						alert("삭제실패");
					}
					alert("삭제완료");
					
					location.reload();
				}
			}
			
			function modify(c_cnt, c_idx, u_idx){
				//alert(c_cnt);
				var c_cnt2 = document.getElementsByName("c_cnt")[c_cnt].value;
				
				//var c_cnt = document.getElementById("c_cnt").value.trim();
				var url = "cart_modify.do";
				var param = "c_idx="+c_idx+"&c_cnt="+c_cnt2+"&u_idx="+u_idx;
				sendRequest(url,param,resultFn2,"post");
			}
			
			function resultFn2(){
				if (xhr.readyState == 4 && xhr.status == 200) {
					var data = xhr.responseText;
					if (data == "noStock") {
						alert("재고가 부족합니다.");
						location.reload();
						return;
					}
					if (data == "tooLow") {
						alert("수량은 1개이상 입력해주세요");
						location.reload();
						return;
					}
					alert("수정완료");
					
					location.reload();
				}
			}
			
			function cart_clear(f){
				var u_idx = f.u_idx.value; 
				if (!confirm("장바구니를 비우시겠습니까?")) {
					return;
				}
				
				f.action = "cart_clear.do";
				f.method = "post";
				f.submit();
			}
			
			function order(f){
				var u_idx = f.u_idx.value;
				
				f.action = "cart_order_form.do";
				f.method = "post";
				f.submit();
			}
		</script>
	</head>
	<body>
		<jsp:include page="../index/index_top.jsp"></jsp:include>
		
		
		
		<div id="main">
			<div class="title">
				<h2>장바구니</h2>
			</div>
			<table class="table1">
				<tr>
					<th>번호</th>
					<th>사진</th>
					<th>상품명</th>
					<th>수량</th>
					<th>금액</th>
					<th>비고</th>
				</tr>
				<c:if test="${ empty list }">
					<tr class="empty">
						<td colspan="6" align="center">
							장바구니가 비어있습니다.
						</td>
					</tr>
				</c:if>
				<c:if test="${ !empty list }">
					<c:set var="total" value="0"/>
					<c:forEach var="vo" items="${ list }" varStatus="c">
						<tr>
							<td>${ c.count }</td>
							<td>
								<img src="${ pageContext.request.contextPath }/resources/upload/${ vo.filename_s }">
							</td>
							<td>
								<a href="product_one.do?idx=${ vo.p_idx }">${ vo.p_name }</a><br>
								<div class="option">[사이즈: ${ vo.p_size }, 색상: <div class="color_box" style="background-color: ${ vo.p_color };"></div>]</div></td>
							<td><input type="number" name="c_cnt" value="${ vo.c_cnt }"></td>
							
							<td><fmt:formatNumber>${ vo.total_price }</fmt:formatNumber></td>
							<td>
								<input type="button" value="수정" onclick="modify('${c.index}', '${ vo.c_idx }','${ sessionScope.user.idx }')">
								<input type="button" value="삭제" onclick="del('${ vo.c_idx }');">
							</td>
						</tr>
						<c:set var="total" value="${ total + vo.total_price }" />
					</c:forEach>
				</c:if>
				<tr>
					<td colspan="6" align="center">
						<img alt="" src="">
						회원님의 현재 멤버십 등급은 <span style="color: ${mem_color};">${ sessionScope.user.membership }</span>입니다.<br>
						상품 구매시 <fmt:formatNumber>${ point_rate * 100 }</fmt:formatNumber>%적립됩니다.
					</td>
				</tr>
			</table>
			<form>
			<table class="table2">
			
				<tr>
					<c:if test="${ !empty total and total ne 0 }">
						<td> 총액 : <fmt:formatNumber><c:out value="${ total }"/></fmt:formatNumber>(원)</td>
					</c:if>
					<c:if test="${ empty total }">
						<td> 총액 : <fmt:formatNumber>0</fmt:formatNumber>(원)</td>
					</c:if>
				</tr>
				<tr>
					<td>
						적립금 : <fmt:formatNumber><c:out value="${ total * point_rate }"/></fmt:formatNumber>(원)
					</td>
				</tr>
			</table>
			<div class="btn_box">
				<input type="hidden" name="u_idx" value="${ sessionScope.user.idx }">
				<c:if test="${ !empty list }">
					<input type="button" value="상품구매" onclick="order(this.form);">
				</c:if>
				<c:if test="${ empty list }">
					<input type="button" value="상품구매" onclick="order(this.form);" disabled="disabled">
				</c:if>
				<c:if test="${ !empty list }">
					<input type="button" value="장바구니 비우기" onclick="cart_clear(this.form);">
				</c:if>
				<c:if test="${ empty list }">
					<input type="button" value="장바구니 비우기" onclick="cart_clear(this.form);" disabled="disabled">
				</c:if>
				<input type="button" value="계속 쇼핑하기" onclick="location.href='main.do'">
			</div>
			</form>
		</div>
		
		<jsp:include page="../index/index_bottom.jsp"></jsp:include>
	</body>
</html>