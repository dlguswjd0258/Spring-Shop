<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
   
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Insert title here</title>
		<link rel="stylesheet" href="${ pageContext.request.contextPath }/resources/css/basic.css">
		<link rel="stylesheet" href="${ pageContext.request.contextPath }/resources/css/product_insert_form.css">
		
		<!-- 200629 -->
		<style type="text/css">
			#inform td{
				width: 50px;
			}
			
			#inform input[type=text]{
				width:150px;
			}
			
			table input[type=color]{
				background-color: white; border: 0px;
			}
		</style>
		
		<script type="text/javascript" src="${ pageContext.request.contextPath }/resources/js/httpRequest.js"></script>
		<script type="text/javascript">
			window.onload = function() {
				var category = document.getElementById("f").category.options;

				for(var i=0; i<category.length; i++){
					if(category[i].value == '${ vo.category }'){
						category[i].selected = true;
						break;
					}
				}
			}
		
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
				
				var img_s_button = document.getElementById("img_s_button").value;
				var img_l_button = document.getElementById("img_l_button").value;
				
				
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
					alert("상품명을 입력해주세요.");
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
				
				if (img_s_button == '취소' && p_image_s == '') {
					alert("사진을 선택해주세요");
					return
				} else if (img_s_button == '변경'){
					f.p_image_s.value = '';
				}
				
				if (img_l_button == '취소' && p_image_l == '') {
					alert("사진을 선택해주세요");
					return
				} else if (img_l_button == '변경'){
					f.p_image_l.value = '';
				}
				
				if (p_content == '') {
					alert("상세설명을 입력해주세요");
					return
				}
				
				if ( p_name != '${ vo.p_name }' &&!p_nameCheck) {
					alert("상품명 중복체크를 먼저 진행해주세요");
					return;
				}
				
				f.action = "product_update.do";
				f.submit();
			}
			
			/* 이미지 변경할 건지 아닌지에 대한 버튼 */
			function img_change(size) {
				var img_s_button = document.getElementById("img_s_button");
				var img_l_button = document.getElementById("img_l_button");

				var img_s = document.getElementById("img_s");
				var img_l = document.getElementById("img_l");
		
				var img_s_input = document.getElementById("img_s_input");
				var img_l_input = document.getElementById("img_l_input");
				
				if(size == 's'){
					if(img_s_button.value == "변경"){
						img_s.style.display = "none";
						img_s_input.style.display = "block"; 
						img_s_button.value = "취소";
					} else{
						img_s.style.display = "block";
						img_s_input.style.display = "none"; 
						img_s_button.value = "변경";
					}
				}else{
					if(img_l_button.value == "변경"){
						img_l.style.display = "none";
						img_l_input.style.display = "block"; 
						img_l_button.value = "취소";
					} else{
						img_l.style.display = "block";
						img_l_input.style.display = "none"; 
						img_l_button.value = "변경";
					}
				}
			}
			
			//200629
			function add(){
				var inform_table = document.getElementById("inform_table");
				var ref = document.getElementById("f").idx.value;
				var i_size = document.getElementById("i_size").value;
				var color = document.getElementById("color").value;
				var i_stock = document.getElementById("i_stock").value;
				
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
				
				inform_table.innerHTML += '<input type="hidden" name="i_idx_s" value="추가">' + 
				'<tr>' +
				'<th>사이즈</th>' +
				'<td><input type="hidden" name="i_size" value="' + i_size + '">' + i_size + '</td>'+
				'<th>색상</th>' +
				'<td><input class="color_box"  type="color" name="color" value="'+ color +'"></td>' +
				'<th>수량</th>' +
				'<td><input name="i_stock_s" type="text" value="' + i_stock + '"></td>' +
				'</tr>';				
			}
			
		</script>
	</head>
	<body>
		
		<jsp:include page="../index/index_top.jsp"/>
			<div id="main">
				<div class="title">
					<h2>상품 수정</h2>
				</div>
				<form id="f" method="post" enctype="multipart/form-data">
					<input type="hidden" name="idx" value="${ vo.idx }">
					<input type="hidden" name="filename_s" value=${ vo.filename_s }>
					<input type="hidden" name="filename_l" value=${ vo.filename_l }>
					<h3>상품정보 입력</h3>
					<p class="required"><img src="//img.echosting.cafe24.com/skin/base/common/ico_required.gif" alt="필수"> 필수입력사항</p>
					<table border="1">
						<tr>
							<th>
							<img src="//img.echosting.cafe24.com/skin/base/common/ico_required.gif" alt="필수">
								카테고리 선택
							</th>
							<td colspan="5">
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
							<td colspan="5">
								<input name="p_name" id="p_name" value="${ vo.p_name }">
								<input type="button" id="p_name_check" value="중복 확인"
									onclick="check();">
							</td>
						</tr>
						<tr>
							<th>
								<img src="//img.echosting.cafe24.com/skin/base/common/ico_required.gif" alt="필수">
								상품 가격(원)
							</th>
							<td colspan="5">
								<input name="p_price" placeholder="정수만 입력하세요" value="${ vo.p_price }">
							</td>
						</tr>
						<tr>
							<th>
								<img src="//img.echosting.cafe24.com/skin/base/common/ico_required.gif" alt="필수">
								할인 가격(원)
							</th>
							<td colspan="5">
								<input name="p_saleprice" placeholder="정수만 입력하세요" value="${ vo.p_saleprice}">
							</td>
						</tr>
						<tr>
							<th>
								<img src="//img.echosting.cafe24.com/skin/base/common/ico_required.gif" alt="필수">
								상품 이미지(소)<br>
								<input id="img_s_button" type="button" value="변경" onclick="img_change('s');">
							</th>
							
							<td colspan="5">
								<img class="p_img" id="img_s" alt="상품 이미지(소)" src="${ pageContext.request.contextPath }/resources/upload/${ vo.filename_s }">
								<input id="img_s_input" type="file" name="p_image_s" style="display:none;">
							</td>
						</tr>
						<tr>
							<th>
								<img src="//img.echosting.cafe24.com/skin/base/common/ico_required.gif" alt="필수">
								상품이미지(대)<br>
								<input id="img_l_button" type="button" value="변경" onclick="img_change('l');">
							</th>
							<td colspan="5">
								<img class="p_img" id="img_l" alt="상품 이미지(대)" src="${ pageContext.request.contextPath }/resources/upload/${ vo.filename_l }">
								<input id="img_l_input" type="file" name="p_image_l" style="display:none;">
							</td>
						</tr>
						<tr>
							<th>
								<img src="//img.echosting.cafe24.com/skin/base/common/ico_required.gif" alt="필수">
								상품 설명
							</th>
							<td colspan="5">
								<textarea rows="20" cols="100" name="p_content">${ vo.p_content }</textarea>
							</td>
						</tr>
						
					</table>
					
				<h3>세부정보 입력</h3>
				<table border="1">
					<tr>
						<th>사이즈 선택</th>
						<td>
							<select id="i_size">
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
							</select>
						</td>
						<th>색상선택</th>
						<td>
							<input type="color" id="color">
						</td>
						<th>수량 입력</th>
						<td>
							<input type="number" id="i_stock">
							<input type="button" value="등록" onclick="add();">
						</td>
					</tr>
				</table>
				
				<div id="inform">
					<h3>등록 내역</h3>
					<table id="inform_table" border="1">
					
						<c:forEach var="vo" items="${ list }">
							<input type="hidden" name="i_idx_s" value="${ vo.i_idx }">
							<input type="hidden" name="ref" value="${ vo.ref }">
							<tr>
								<th>사이즈</th>
								<td>
									<input type="hidden" name="i_size" value="${ vo.i_size }">
									${ vo.i_size }
								</td>
								
								<th>색상</th>
								<td>
									<input class="color_box"  type="color" name="color" value="${ vo.color }">
								</td>
								
								<th>수량</th>
								<td>
									<input name="i_stock_s" type="text" value="${ vo.i_stock }">
								</td>
							</tr>
						</c:forEach>
					</table>
				</div>
					
					<div id="nextButton" align="center">
						<input type="button" value="수정"
								onclick="send(this.form);">
						<input type="button" value="취소"
								onclick="location.href='product_list_form.do'">
					</div>
				</form>
			</div>
			
		<jsp:include page="../index/index_bottom.jsp"/>
	</body>
</html>