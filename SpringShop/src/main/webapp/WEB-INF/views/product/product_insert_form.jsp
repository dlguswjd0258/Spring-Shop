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
		<title>상품 등록</title>
		<link rel="stylesheet" href="${ pageContext.request.contextPath }/resources/css/basic.css">
		<link rel="stylesheet" href="${ pageContext.request.contextPath }/resources/css/product_insert_form.css">
		<script type="text/javascript" src="${ pageContext.request.contextPath }/resources/js/httpRequest.js"></script>
		<script type="text/javascript">
			var p_nameCheck = false;
			//상품명 중복체크
			function check(){
				var p_name = document.getElementById("p_name").value.trim();
				
				if (p_name == '') {
					alert("상품명을 먼저 입력하세요");
					return;
				}
				
				var url = "p_name_check.do";
				param = "p_name="+p_name;
				
				sendRequest(url,param,resultFn,"post");
			}
			function resultFn(){
				if (xhr.readyState == 4 && xhr.status == 200) {
					var data = xhr.responseText;
					var json = eval(data);
					if (json[0].result == 'no') {
						alert("이미 등록된 상품명입니다.");
						return;
					}
					alert("등록 가능한 상품명입니다.");
					p_nameCheck = true;
					document.getElementById("p_name").readOnly = true;
				}
			}
			function send(f){
				var category = f.category.value;
				var p_name = f.p_name.value.trim();
				var p_price = f.p_price.value.trim();
				var p_saleprice = f.p_saleprice.value.trim();
				var p_image_s = f.p_image_s.value;
				var p_image_l = f.p_image_l.value;
				var p_content = f.p_content.value.trim();
				
				if (category == '카테고리 선택') {
					alert("카테고리를 선택해주세요");
					return;
				}
				if (category == '---TOP---' || category == '---PANTS---' || category == '---SHIRTS---'
						|| category == '---OUTTER---') {
					alert("올바르지 않은 카테고리입니다. 카테고리를 다시 선택해주세요");
					return;
				}
				if (p_name == '') {
					alert("");
					return
				}
				pattern = /^[0-9]+$/;
				if (!pattern.test(p_price)) {
					alert("가격은 정수로 입력하세요");
					return
				}
				if (!pattern.test(p_saleprice)) {
					alert("가격은 정수로 입력하세요");
					return
				}
				if (p_image_s == '') {
					alert("사진을 선택해주세요");
					return
				}
				if (p_image_l == '') {
					alert("사진을 선택해주세요");
					return
				}
				if (p_content == '') {
					alert("상세설명을 입력해주세요");
					return
				}
				if (!p_nameCheck) {
					alert("상품명 중복체크를 먼저 진행해주세요");
					return;
				}
				
				f.action = "product_insert.do";
				f.submit();
			}
		</script>
	</head>
	<body>
		
		<jsp:include page="../index/index_top.jsp"/>
			<div id="main">
				<div class="title">
					<h2>상품 등록</h2>
				</div>
				<form method="post" enctype="multipart/form-data">
					<h3>상품정보 입력</h3>
					<p class="required"><img src="//img.echosting.cafe24.com/skin/base/common/ico_required.gif" alt="필수"> 필수입력사항</p>
					<table border="1">
						<tr>
							<th>
							<img src="//img.echosting.cafe24.com/skin/base/common/ico_required.gif" alt="필수">
								카테고리 선택
							</th>
							<td>
								<select name="category">
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
							</td>
						</tr>
						<tr>
							<th>
								<img src="//img.echosting.cafe24.com/skin/base/common/ico_required.gif" alt="필수">
								상품명
							</th>
							<td>
								<input name="p_name" id="p_name">
								<input type="button" id="p_name_check" value="중복 확인"
									onclick="check();">
							</td>
						</tr>
						<tr>
							<th>
								<img src="//img.echosting.cafe24.com/skin/base/common/ico_required.gif" alt="필수">
								상품 가격(원)
							</th>
							<td>
								<input name="p_price" placeholder="정수만 입력하세요">
							</td>
						</tr>
						<tr>
							<th>
								<img src="//img.echosting.cafe24.com/skin/base/common/ico_required.gif" alt="필수">
								할인 가격(원)
							</th>
							<td>
								<input name="p_saleprice" placeholder="정수만 입력하세요">
							</td>
						</tr>
						<tr>
							<th>
								<img src="//img.echosting.cafe24.com/skin/base/common/ico_required.gif" alt="필수">
								상품 이미지(소)
							</th>
							<td>
								<input type="file" name="p_image_s">
							</td>
						</tr>
						<tr>
							<th>
								<img src="//img.echosting.cafe24.com/skin/base/common/ico_required.gif" alt="필수">
								상품이미지(대)
							</th>
							<td>
								<input type="file" name="p_image_l">
							</td>
						</tr>
						<tr>
							<th>
								<img src="//img.echosting.cafe24.com/skin/base/common/ico_required.gif" alt="필수">
								상품 설명
							</th>
							<td>
								<textarea rows="20" cols="100" name="p_content"></textarea>
							</td>
						</tr>
					</table>
					
					<div id="nextButton" align="center">
						<input type="button" value="다음단계"
								onclick="send(this.form);">
						<input type="button" value="취소"
								onclick="location.href='main.do'">
					</div>
				</form>
			</div>
		<jsp:include page="../index/index_bottom.jsp"/>
	</body>
</html>