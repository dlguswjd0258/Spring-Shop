<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
	<link rel="stylesheet" href="${ pageContext.request.contextPath }/resources/css/basic.css">
	<link rel="stylesheet" href="${ pageContext.request.contextPath }/resources/css/product_list_form.css">
	
	<script type="text/javascript" src="${ pageContext.request.contextPath }/resources/js/httpRequest.js"></script>
	<script type="text/javascript">
		window.onload = function() {
			if( <c:out value="${ empty sessionScope.user}"/>){
				alert("로그인 먼저 하세요.");
				location.href="login_form.do";
			}
			
			if(<c:out value="${ category eq ''}"/>)
				return;
			
			var category = document.getElementById("category").options;
		
			for(var i=0; i<category.length; i++){
				if(category[i].value == '${ category }'){
					category[i].selected = true;
					break;
				}
			}
		}
		
		function product_delete( idx ) {
			if( !confirm("정말로 삭제하시겠습니까?")){
				return;
			}
			
			var url = "product_delet.do";
			var param = "idx=" + idx;
			sendRequest( url, param, resultFn, "GET");
		}
		
		function resultFn() {
			if( xhr.readyState == 4 && xhr.status == 200){
				var data = xhr.responseText;
				
				if(data == 'no'){
					alert("삭제하지 못했습니다. 다시 시도해 주세요.");
					return;
				}
				
				alert("삭제 완료하였습니다.");
				location.href="product_list_form.do";
			}
		}
		
		function categoryList() {
			var category = document.getElementById("category").value;
			if(category.includes('&')){
				category = category.replace('&', ',');
			}
			location.href="product_list_form.do?category=" + category;
		}
	</script>

</head>
<body>
	<jsp:include page="../index/index_top.jsp"/>
	<div id="main">
		<div class="title"><h2>사이트 관리</h2></div>
		<div class="sub_title"><h3>상품관리</h3></div>
		
		<select id="category"  name="category" onchange="categoryList();">
			<option>카테고리 선택</option>
			<option>---TOP---</option>
			<option>맨투맨&후드티</option>
			<option>니트</option>
			<option>긴팔티</option>
			<option>반팔티</option>
			<option>나시</option>
			<option>프린팅티</option>
			<option>---PANTS---</option>
			<option>슬랙스</option>
			<option>면바지</option>
			<option>청바지</option>
			<option>밴딩팬츠</option>
			<option>반바지</option>
			<option>---SHIRTS---</option>
			<option>베이직</option>
			<option>청남방</option>
			<option>체크&패턴</option>
			<option>스트라이프</option>
			<option>핸리넷&차이나</option>
			<option>---OUTER---</option>
			<option>패딩</option>
			<option>코트</option>
			<option>수트&블레이져</option>
			<option>블루종/MA-1</option>
			<option>가디건&조끼</option>
			<option>후드&집업</option>
		
		</select>
		<input id="insertButton" type="button" value="상품 등록하기" onclick="location.href='product_insert_form.do'">
		<table border="1">
			<tr>
				<th class="num">번호</th>
				<th class="cate">카테고리</th>
				<th class="name">상품명</th>
				<th class="date">작성일</th>
				<th>비고</th>
			</tr>
			
			<c:if test="${empty list}">
				<td colspan="5"><p align="center">등록된 상품이 없습니다</p></td>
			</c:if>
			
			<c:forEach var="vo" items="${ list }">
				<tr>
					<td>${ vo.idx }</td>
					<td>${ vo.category }</td>
					<td class="p_name">
						<a href="product_one.do?idx=${ vo.idx }">${ vo.p_name }</a>					
					</td>
					<td>${ vo.p_date.split(" ")[0] }</td>
					<td>
						<c:if test="${ vo.p_del eq 1 }">
							삭제된<br>
							상품입니다.
						</c:if>
		
						<c:if test="${ vo.p_del ne 1 }">
							<input type="button" value="수정" onclick="location.href='product_update_form.do?idx=${ vo.idx }'">
							<input type="button" value="삭제" onclick="product_delete(${ vo.idx });">
						</c:if>
						
					</td>
				</tr>
			</c:forEach>
			
		</table>
		<br><br>
		<c:if test="${!empty list}">
		<div id="pageMenu" align="center">${pageMenu}</div>
		</c:if>
	</div>
	<jsp:include page="../index/index_bottom.jsp"/>
</body>
</html>