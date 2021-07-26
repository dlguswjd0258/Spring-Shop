<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:if test="${ empty sessionScope.user}">
	<script>
		alert("잘못된 접근입니다.");
		location.href="main.do";
	</script>
</c:if>


<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>상품 세부 정보</title>
		<link rel="stylesheet" href="${ pageContext.request.contextPath }/resources/css/basic.css">
		<link rel="stylesheet" href="${ pageContext.request.contextPath }/resources/css/p_inform_insert_form.css">
		<script type="text/javascript" src="${ pageContext.request.contextPath }/resources/js/httpRequest.js"></script>
		<script type="text/javascript">
			function add_first(f){
				var i_size = f.i_size.value;
				var color = f.color.value;
				var i_stock = f.i_stock.value;
				
				if (i_size == '사이즈선택') {
					alert("사이즈를 선택해주세요");
					return;
				}
				var c_pattern = /^#[0-9a-f]{3,6}$/i;
				if (!c_pattern.test(color)) {
					alert("올바른 색상 값이 아닙니다.");
					return;
				}
				var pattern = /^[0-9]+$/;
				if (!pattern.test(i_stock)) {
					alert("수량은 정수로 입력해주세요.");
					return;
				}
				
				f.action = "p_inform_insert_first.do";
				f.submit();
			}
			function add(f){
				var ref = f.ref.value;
				var i_size = f.i_size.value;
				var color = f.color.value;
				var i_stock = f.i_stock.value;
				
				if (i_size == '사이즈선택') {
					alert("사이즈를 선택해주세요");
					return;
				}
				var c_pattern = /^#[0-9a-f]{3,6}$/i;
				if (!c_pattern.test(color)) {
					alert("올바른 색상 값이 아닙니다.");
					return;
				}
				var pattern = /^[0-9]+$/;
				if (!pattern.test(i_stock)) {
					alert("수량은 정수로 입력해주세요.");
					return;
				}
				
				f.action = "p_inform_insert.do";
				f.submit();
			}
			function p_delete(idx){
				if (!confirm("지금 취소하시면 현재까지 등록된 정보가 모두 삭제됩니다. 정말 취소하시겠습니까?")) {
					return;
				}
				var url = "product_delete_all.do";
				var param = "idx="+idx;7
				sendRequest(url,param,resultFn,"post");
			}
			function resultFn(){
				if (xhr.readyState == 4 && xhr.status == 200) {
					var data = xhr.responseText;
					var json = eval(data);
					if (json[0].result == 'no') {
						alert("요청 실패");
						return;
					}
					location.href="main.do";
				}
			}
			
			function call_main(){
				if (!confirm("지금 취소하시면 현재까지 등록된 정보가 모두 삭제됩니다. 정말 취소하시겠습니까?")) {
					return;
				}
					location.href="main.do";
			}
		</script>
	</head>
	<body>
		<jsp:include page="../index/index_top.jsp"/>
			
		<div id="main">
			<div class="title">
				<h2>상품 세부정보 등록</h2>
			</div>
			<form method="post">
				<c:if test="${ !empty check }">
					<input type="hidden" name="ref" value="${ idx }">
				</c:if>
				<h3>세부정보 입력</h3>
				<table border="1">
					<tr>
						<th>사이즈 선택</th>
						<td>
							<c:if test="${ empty check }">
								<input type="hidden" name="category" value="${ product_vo.category }">
								<input type="hidden" name="p_name" value="${ product_vo.p_name }">
								<input type="hidden" name="p_price" value="${ product_vo.p_price }">
								<input type="hidden" name="p_saleprice" value="${ product_vo.p_saleprice }">
								<input type="hidden" name="filename_s" value="${ product_vo.filename_s }">
								<input type="hidden" name="filename_l" value="${ product_vo.filename_l }">
								<input type="hidden" name="p_content" value="${ product_vo.p_content }">
							</c:if>
							
							<select name="i_size">
								<option>사이즈선택</option>
								<option>XXS</option>
								<option>XS</option>
								<option>S</option>
								<option>M</option>
								<option>L</option>
								<option>XL</option>
								<option>2XL</option>
								<option>3XL</option>
								<option>4XL</option>
								<option>FREE</option>
							</select>
						</td>
						<th>색상선택</th>
						<td>
							<input type="color" name="color">
						</td>
						<th>수량 입력</th>
						<td>
							<input type="number" name="i_stock">
							<c:if test="${ !empty check }">
								<input type="button" value="등록" onclick="add(this.form);">
							</c:if>
							<c:if test="${ empty check }">
								<input type="button" value="등록" onclick="add_first(this.form);">
							</c:if>
						</td>
					</tr>
					
				</table>
				
				<div id="inform">
					<h3>등록 내역</h3>
					<table border="1">
						<c:if test="${ empty list }">
							<tr>
								<td colspan="6" align="center">등록된 정보가 없습니다</td>
							</tr>
						</c:if>
						
						<c:if test="${ !empty list }">
								<c:forEach var="vo" items="${ list }">
									<tr>
										<th>사이즈</th>
										<td>${ vo.i_size }</td>
										
										<th>색상</th>
										<td>
											<div class="color_box" style="background-color: ${vo.color};"></div>
										</td>
										
										<th>수량</th>
										<td>${ vo.i_stock }</td>
									</tr>
								</c:forEach>
						</c:if>
					</table>
				</div>
				
				<div id="finishButton" align="center">
					<c:if test="${ empty list }">
						<input type="button" value="등록완료" disabled="disabled" style="cursor: default; background: grey;">
					</c:if>
					<c:if test="${ !empty list }">
						<input type="button" value="등록완료"
								onclick="location.href='main.do'">
					</c:if>
					<c:if test="${ empty list }">
						<input type="button" value="취소" onclick="call_main();">
					</c:if>
					<c:if test="${ !empty list }">
						<input type="button" value="취소" onclick="p_delete('${idx}');">
					</c:if>
				</div>
			</form>
		</div>
		<jsp:include page="../index/index_bottom.jsp"/>
	</body>
</html>