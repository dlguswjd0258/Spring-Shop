<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<<c:if test="${ vo.p_del eq 1 }">
	<script>
		alert("판매가 중단된 상품입니다.");
		location.href="main.do";
	</script>
</c:if>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/resources/css/basic.css">

<style type="text/css">
span {
	color: pink;
}

#body {
	width: 1300px;
	margin: 0 auto;
}

#body #outline_table {
	margin-top: 30px;
	width: 100%;
}

/* 2020.06.29 EDITED */
#outline_table tr:nth-child(1) td {
	width: 50%;
}

/* 2020.06.28 EDITED */
#p_info {
	width: 100%;
}

#p_info td{
	font-size: 15px;
}

#review_show_box {
	width: 1000px;
	border-spacing: 0 10px;
}

tr.reviews {
	height: 30px;
}

/* 2020.06.27. EDITED */
.black_button1 {
	background: black;
	color: white;
	padding: 30px 197px;
	border: none;
	border-radius: 0;
}

#to_dadat {
	color: pink;
	font-size: 3px;
	font-weight: bold;
}

#to_dadat:hover {
	color: orange;
	cursor: pointer;
}

.padding30 {
	padding-top: 30px;
}

#to_reviews {
	padding: 2px 500px;
	border-radius: 0;
	border-color: black;
	background-color: white;
	font-size: 25px;
	color: gray;
}

#to_reviews:hover {
	color: red;
	cursor: pointer;
}

#review_category td {
	border-bottom: 1px solid gray;
	height: 30px;
}

/* 2020.06.28 EDITED */
#to_cart {
	width: 100%;
}

.bt_for_review {
	border-radius: 0;
	border: none;
	background-color: black;
	color: white;
	font-size: 3px;
	padding: 2px 3px;
	margin-bottom: 5px;
}

.bt_for_review:hover {
	cursor: pointer;
	color: orange;
}

.bt_cartinfo:hover {
	cursor: pointer;
}

#selected_items tr:nth-child(1) td {
	padding: 10px 0px;
	color: gray;
}

#cart_p_color {
	width: 30px;
	height: 30px;
	border: 1px solid gray;
}

.black_button2 {
	background: black;
	color: white;
	padding: 30px 20px;
	border: none;
	border-radius: 0;
	display: inline-block;
}

.state_tag {
	width: 70px;
	height: 17px;
	border-radius: 3px;
	display: inline-block;
}
</style>

<script type="text/javascript"
	src="${ pageContext.request.contextPath }/resources/js/httpRequest.js"></script>
<script type="text/javascript">
	
		/* 2020.06.26 EDITED */
		window.onload=function(){
			var page = document.getElementById("page").value;
			
			if(page != ""){
				window.scrollTo(0, 4000);
			}
		}
		
		/* 2020.06.26 EDITED */
		function scrolldown(){
			window.scrollTo(0, 4000);
		}
		
		function send(f){
			var p_idx = f.p_idx.value;
			var name = f.name.value.trim();
			var subject = f.subject.value.trim();
			var pwd = f.pwd.value.trim();
			var grade = f.grade.value;
			var content = f.content.value.trim(); 
			
			if (name==""){
				alert("이름은 필수입력 사항입니다");
				return;
			}
 			if(subject==""){
				alert("제목을 작성하세요");
				return;
			}
 			if(pwd==""){
				alert("비밀번호를 설정하세요");
				return;
			}
 			if(grade=="0"){
				alert("별점을 선택하세요 (1~5)");
				return;
			}
 			if (content==""){
				alert("내용은 1자 이상 입력해야합니다");
				return;
			}
 			
 			if(!confirm("등록하시겠습니까?")){
 				return;
 			}
 			
 			f.action="review_insert.do";
 			f.submit();
		}
		
		/* 2020.06.29 EDITED */
		var prev_selection = "";
		function size_box_on(color){
			document.getElementById("temp_size").style.display = "none";
			
			if(color != ""){
				if(prev_selection != ""){
					var y = document.getElementsByClassName(prev_selection);
					var j;
					for( j=0;j<y.length;j++){
						y[j].style.display = "none";	
					}	
				}
				var x = document.getElementsByClassName(color);
				var i;
				for (i=0;i<x.length;i++){
					x[i].style.display = "block";
				}
				
				document.getElementById("cart_p_color").style.backgroundColor = color;
				document.getElementById("cart_p_color_input").value = color;
				
				prev_selection = color;
			}
			
		}
		
		var r_idx_prev = "";
		var on = 0;
		function to_dadat(r_idx){
			if(r_idx != r_idx_prev){
				if(r_idx_prev != ""){
					document.getElementById(r_idx_prev).style.display = "none";	
				}
				document.getElementById(r_idx).style.display = "";	
				on = 1;
			}
			
			if(r_idx_prev == r_idx && on == 1){
				document.getElementById(r_idx_prev).style.display = "none";	
				on = 0;
			}else if(r_idx_prev == r_idx && on == 0){
				document.getElementById(r_idx_prev).style.display = "";	
				on = 1;
			}		
			
			r_idx_prev = r_idx;
		}
		
		function dadat_do(f){
			var content = f.content.value.trim();
			var pwd = f.pwd.value.trim();
			var p_idx = f.p_idx.value;
			var ref = f.ref.value;
			var page = f.page.value;
			
			if(content == ""){
				alert("내용은 1자 이상 입력하세요");
				return;
			}
			
			if(pwd == ""){
				alert("비밀번호를 입력하세요");
				return;
			}
			
			f.action = "review_dat_insert.do";
 			f.submit();
		}
		
		function review_edit(f){
			var r_idx = f.r_idx.value;
			var pwd = f.pwd.value;
			
			if(pwd.trim()==""){
				alert("비밀번호를 입력하세요");
				return;
			}
			
			var url = "review_edit_form.do";
			var param = "r_idx=" + r_idx + "&pwd=" + pwd;
			sendRequest(url, param, resultFn_2, "post");
		}
		
		function resultFn_2(){
			if(xhr.readyState == 4 && xhr.status == 200){
				var data = xhr.responseText;

				if(data == "wrong_pwd"){
					alert("비밀번호가 틀렸습니다");
					return;
				}
					
				document.getElementById("show_").style.display = "none";
				document.getElementById("sh_1").style.display = "none";
				document.getElementById("sh_2").style.display = "none";
				document.getElementById("sh_3").style.display = "none";
				 
				document.getElementById("edit_").style.display = "block";
				document.getElementById("ed_1").style.display = "";
				document.getElementById("ed_2").style.display = "";
				document.getElementById("ed_3").style.display = "";
			}
		}
		
		function edit_cancel(){
			if(!confirm("수정한 내용이 저장되지 않습니다.\n계속하시겠습니까?")){
				return;
			}
			
			document.getElementById("show_").style.display = "block";
			document.getElementById("sh_1").style.display = "";
			document.getElementById("sh_1").value = "";
			document.getElementById("sh_2").style.display = "";
			document.getElementById("sh_3").style.display = "";
			
			document.getElementById("edit_").style.display = "none";
			document.getElementById("ed_1").style.display = "none";
			document.getElementById("ed_2").style.display = "none";
			document.getElementById("ed_3").style.display = "none";
		}
		
		function review_edit2(f){
			var r_idx = f.r_idx.value;
			var pwd = f.pwd.value;
			
			if(pwd.trim()==""){
				alert("비밀번호를 입력하세요");
				return;
			}
			
			var url = "review_edit_form.do";
			var param = "r_idx=" + r_idx + "&pwd=" + pwd;
			sendRequest(url, param, resultFn_3, "post");
		}
		
		function resultFn_3(){
			if(xhr.readyState == 4 && xhr.status == 200){
				var data = xhr.responseText;
				var json = eval(data);
				
				if(json[0].res == "wrong_pwd"){
					alert("비밀번호가 틀렸습니다");
					return;
				}
					
				document.getElementById(json[0].r_idx+".1").style.display = "none";
				document.getElementById(json[0].r_idx+".4").style.display = "none";
				document.getElementById(json[0].r_idx+".5").style.display = "none";
				document.getElementById(json[0].r_idx+".6").style.display = "none";
				 
				document.getElementById(json[0].r_idx+".2").style.display = "block";
				document.getElementById(json[0].r_idx+".04").style.display = "";
				document.getElementById(json[0].r_idx+".05").style.display = "";
			}
		}
		
		function edit_cancel2(r_idx){
			if(!confirm("수정한 내용이 저장되지 않습니다.\n계속하시겠습니까?")){
				return;
			}
			
			document.getElementById(r_idx+".1").style.display = "block";
			document.getElementById(r_idx+".4").style.display = "";
			document.getElementById(r_idx+".4").value = "";
			document.getElementById(r_idx+".5").style.display = "";
			document.getElementById(r_idx+".6").style.display = "";
			
			document.getElementById(r_idx+".2").style.display = "none";
			document.getElementById(r_idx+".04").style.display = "none";
			document.getElementById(r_idx+".05").style.display = "none";
		}
		
		function send_edit(f){
			var content = f.content.value;
			
			if(content.trim() == ""){
				alert("내용은 1자 이상 입력하세요");
				return;
			}
			
			if(!confirm("수정하시겠습니까?")){
				return;
			}
			
			f.action = "review_edit.do";
			f.submit();
		}
		
		function send_edit2(f){
			var content = f.content.value;
			
			if(content.trim() == ""){
				alert("내용은 1자 이상 입력하세요");
				return;
			}
			
			if(!confirm("수정하시겠습니까?")){
				return;
			}
			
			f.action = "review_edit2.do";
			f.submit();
		}
		
		function review_delete(f){
			var pwd = f.pwd.value;
			var r_idx = f.r_idx.value;
			var p_idx = f.p_idx.value;
			var page = f.page.value;
			
			if(pwd.trim() == ""){
				alert("비밀번호를 입력하세요");
				return;
			}
			
			if(!confirm("삭제하시겠습니까?")){
				return;
			}
			
 			var url = "review_delete.do";
			var param = "r_idx=" + r_idx + "&idx=" + p_idx + "&page=" + page + "&pwd=" + pwd;
			sendRequest(url, param, resultFn, "POST");
		}
		
		function resultFn(){
			if(xhr.readyState == 4 && xhr.status == 200){
				var data = xhr.responseText;
				var json = eval(data);
				if(json[0].res == "wrong_pwd"){
					alert("비밀번호가 틀렸습니다");
					return;
				}else if(json[0].res == "no"){
					alert("삭제에 실패했습니다");
					return;
				}else if(json[0].res == "yes"){
					alert("성공적으로 삭제되었습니다");
				}
				location.href="product_one.do?idx=" + json[0].idx + "&page=" + json[0].page;
			}
		}
		
		function set_cart_p_size(size, max){
			document.getElementById("cart_p_size").innerHTML = size; 
			document.getElementById("cart_p_size_input").value = size;
			
			document.getElementById("cart_c_cnt_input").max = max;
			document.getElementById("max_stock").innerHTML = "(재고수: " + max + "개)";
			
			document.getElementById("selected_items").style.display= "";
		}
		
		function send_to_cart(f){
			var c_cnt = document.getElementById("cart_c_cnt_input").value;
			var p_size = document.getElementById("cart_p_size_input").value;
			var c_cnt_max = document.getElementById("cart_c_cnt_input").max;
			
			if(p_size == ""){
				alert("사이즈를 선택하세요");
				return;
			}
			
			if(c_cnt == 0){
				alert("수량을 입력하세요");
				return;
			}else if(parseInt(c_cnt) > parseInt(c_cnt_max)){
				alert("재고가 부족합니다");
				return;
			}else if(parseInt(c_cnt) < 0){
				alert("수량은 정수로 입력하세요");
				return;
			}
			
			
			// 상품 장바구니에 추가하기
			var p_idx = document.getElementById("p_idx").value;
			var u_idx = document.getElementById("u_idx").value;
			var p_size = f.p_size.value;
			var p_color = f.p_color.value;
			var c_cnt = f.c_cnt.value;
			
			var url = "cart_insert.do";
			var param = "p_idx="+p_idx+"&u_idx="+u_idx+"&p_size="+p_size+"&p_color="+p_color+"&c_cnt="+c_cnt;
			
			sendRequest(url,param,resultFn2,"post");
		}
		
		function buy_now(f){
			var c_cnt = document.getElementById("cart_c_cnt_input").value;
			var p_size = document.getElementById("cart_p_size_input").value;
			var c_cnt_max = document.getElementById("cart_c_cnt_input").max;
			
			if(p_size == ""){
				alert("사이즈를 선택하세요");
				return;
			}
			
			if(c_cnt == 0){
				alert("수량을 입력하세요");
				document.getElementById("cart_p_totalprice").innerHTML = "(총 금액)";
				return;
			}else if(parseInt(c_cnt) > parseInt(c_cnt_max)){
				alert("재고가 부족합니다");
				document.getElementById("cart_p_totalprice").innerHTML = "(총 금액)";
				return;
			}else if(parseInt(c_cnt) < 0){
				alert("수량은 정수로 입력하세요");
				document.getElementById("cart_p_totalprice").innerHTML = "(총 금액)";
				return;
			}
			
			
			f.action = "product_order_form.do";
			f.method = "post";
			f.submit();
		}
		
		function resultFn2(){
			if (xhr.readyState == 4 && xhr.status == 200) {
				var data = xhr.responseText;
				var u_idx = document.getElementById("u_idx").value;
				if (data == "already") {
					alert("이미 장바구니에 해당 상품이 존재합니다.");
					location.reload();
					return;
				}
				if (data == "tooLow") {
					alert("수량은 1개이상 입력해주세요");
					location.reload();
					return;
				}
				if (!confirm("장바구니 리스트로 가시겠습니까?")) {
					location.reload();
					return;
				}
				
				location.href="cart_list.do?u_idx="+u_idx;
				
			}
		}
		
		function login_first(){
			alert("로그인 후 이용가능합니다.");
			location.href="login_form.do";
		}
	</script>
</head>
<body>
	<jsp:include page="../index/index_top.jsp"></jsp:include>
	<div id="body">
		<table id="outline_table">
			<tr>
				<!-- 상품 이미지 -->
				<td align="center" style="vertical-align: top;">
					<img src="${pageContext.request.contextPath}/resources/upload/${vo.filename_s}"
						style="display: block; width: 90%; height: 650px;">
				</td>
				<!-- 상품 구매 선택 -->
				<td>
					<!-- 2020.07.08 EDITED 533-1016-->
					<form>
					<table id="p_info">
						<tr style="border-bottom: 1px solid gray;" height="50">
							<!-- 2020.07.07 EDITED -->
							<td align="left" style="vertical-align: top;">
								<font size="5"><b>${vo.p_name}</b></font> &nbsp;&nbsp;&nbsp;
								
								<c:if
									test="${NEW eq 'NEW'}">
									<div class="NEW state_tag" style="background-color: orange;"
										align="center"><font size="2">NEW</font></div>
								</c:if>
								<c:if test="${HOT eq 'HOT'}">
									<div class="HOT state_tag"
										style="background-image: 'http://www.jogunshop.com/shopimages/jogunshop/prod_icons/40?1536891462';"
										align="center">HOT</div>
								</c:if>
								<c:if test="${SOLD_OUT eq 'SOLD_OUT'}">
									<div class="SOLD_OUT state_tag"
										style="background-color: purple; color: white;" align="center">
										SOLD_OUT</div>
								</c:if>
							</td>
							<td align="right" style="vertical-align: top; padding-top: 10px;">
								<b>(리뷰: ${review_num} 개)</b>
							</td>
						</tr>

						<tr height="50" style="vertical-align: top;">
							<td colspan="2"><font color="gray">${vo.p_content}</font></td>
						</tr>
						
						<tr height="50">
							<td>
								<font color="gray">
									별점:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								</font>
								<b><fmt:formatNumber
									value="${vo.p_grade}" pattern=".0" />점</b>
							</td>
						</tr>

						<tr height="50">
							<td>
								<font color="gray">
									판매가:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								</font>
								<b>
								<del>
									<fmt:formatNumber>${vo.p_price}</fmt:formatNumber>
								</del>&nbsp;&nbsp;&nbsp;
									<fmt:formatNumber>${vo.p_saleprice}</fmt:formatNumber>
								</b>
							</td>
						</tr>
						
						<tr>
							<td colspan="2">
								<c:if test="${SOLD_OUT eq 'SOLD_OUT'}">
									<div style="height: 370px;"><font color="gray">품절된 상품입니다</font></div>
								</c:if>
								<c:if test="${SOLD_OUT ne 'SOLD_OUT'}">
									<!-- 장바구니 form -->
									<input type="hidden" value="${sessionScope.user.idx}"
										name="u_idx">
									<input type="hidden" value="${vo.idx}" name="p_idx">
									<table id="to_cart">
										<tr style="height: 50px;">
											<td style="width: 7%"><font color="gray">색상:</font><br></td>
											<td>
												<c:forEach var="color" items="${color_list}">
													<input type="button"
														style="width: 30px; height: 30px; border: 1px solid gray;
															background: ${color}; float: left; margin: 5px 5px;"
														onclick="size_box_on('${color}');" class="bt_cartinfo">
												</c:forEach>
											</td>
										</tr>
										<tr style="height: 50px;">
											<td style="width: 7%"><font color="gray">사이즈:</font></td>
											<td>
												<p style="color: gray;" id="temp_size">(색상을 먼저 선택하세요)</p> <c:forEach
													var="color2" items="${color_list}">
													<c:forEach var="size" items="${size_map.get(color2)}">
														<input type="button" value="${size}"
															style="width: 50px; height: 30px; border: 1px solid gray; background: white; color: gray; float: left; margin: 5px 5px; border-radius: 3px; display: none;"
															class="${color2}"
															onclick="set_cart_p_size('${size}', '${stock_map.get(color2).get(size)}');">
													</c:forEach>
												</c:forEach>
											</td>
										</tr>
										<tr>
											<td colspan="2">
											<div style="min-height: 240px; padding-top: 30px;">
												<!-- 선택된 상품 list -->
													<table style="width: 100%; display: none;"
														id="selected_items">
														<tr style="border-bottom: 1px solid gray;">
															<!-- 색상 -->
															<td style="width: 20%;">
																<input type="hidden" name="p_name" value="${vo.p_name}">
																<input type="hidden" value="${ vo.idx }" id="p_idx">
																<input type="hidden" value="${ vo.filename_s }" name="filename_s">
																<input type="hidden" value="${ sessionScope.user.idx }"
																id="u_idx"> <!-- 상품 가격 --> <input type="hidden"
																value="${vo.p_price}" name="p_price"> <input type="hidden"
																value="${vo.p_saleprice}" name="p_saleprice" id="cart_p_saleprice_input">
																
																
																<div id="cart_p_color" style="margin-left: 20px;"></div>
																<input type="hidden" name="p_color" id="cart_p_color_input">
															</td>


															<!-- 상품사이즈 -->
															<td style="width: 20%;">
																<div id="cart_p_size" style="font-size: 25px;"></div>
																<input type="hidden" name="p_size" id="cart_p_size_input">
															</td>


															<!-- 상품갯수 -->
															<td style="width: 15%;">
																<input type="number" placeholder="수량" name="c_cnt"
																style="width: 80px; height: 40px; border-radius: 0; border: 1px solid gray; font-size: 25px;"
																id="cart_c_cnt_input" min="0" value="1">
															</td>


															<!-- 재고량 -->
															<td style="width: 15%">
																<div id="max_stock">(재고량)</div>
															</td>


															<!-- 삭제버튼 -->
															<td align="right">
																<a style="color: black; font-size: 25px;" href="javascript:void(0)" onclick="document.getElementById('selected_items').style.display='none';">X</a>
															</td>
														</tr>
													</table>
											</div>
											</td>
										</tr>
									</table>
								</c:if></td>
						</tr>
						
						<tr height="80">
							<td align="center">
								<c:if test="${ !empty sessionScope.user }">
									<input type="button" value="바로구매" class="black_button1" onclick="buy_now(this.form);">
								</c:if>
								<c:if test="${ empty sessionScope.user }">
									<input type="button" value="바로구매" class="black_button1" onclick="login_first();">
								</c:if>
							</td>
							<!-- 2020.07.07 EDITED -->
							<td align="right">
								<c:if test="${empty sessionScope.user}">
									<input type="button" value="장바구니" class="black_button2" onclick="login_first();">
								</c:if>
								<c:if test="${!empty sessionScope.user}">
									<input type="button" value="장바구니" class="black_button2" onclick="send_to_cart(this.form);">
								</c:if>
									<input type="button" value="목록으로" class="black_button2" onclick="location.href='main.do'">
							</td>
						</tr>
						
					</table>
					</form>
				</td>
			</tr>
			<tr height="30">
				<td colspan="2" style="vertical-align: bottom;">
					<hr>
				</td>
			</tr>
			<tr>
				<td align="center" colspan="2" class="padding30"><input
					type="button" value="구매후기(${review_num})" id="to_reviews"
					onclick="scrolldown();"></td>
			</tr>
			<tr>
				<td align="center" colspan="2" class="padding30"><img
					src="${pageContext.request.contextPath}/resources/upload/${vo.filename_l}"
					width="100%"></td>
			</tr>

			<!-- 2020.07.08 EDITED -->
			<tr>
				<td align="center" colspan="2" class="padding30">
					<font style="font-weight: bold; font-size: 25px;">상품 후기</font><br><br>
					<input type="hidden" value="${param.page}" id="page">
					<c:if test="${empty reviews}">
						작성된 후기가 없습니다.
					</c:if>
					<table id="review_show_box">
						<c:if test="${!empty reviews}">
							<tr id="review_category" style="border-top: 2px solid #dfdfdf;">
								<td align="center" style="width: 10%; vertical-align: middle;"><b>번호</b></td>
								<td align="center" style="width: 27%; vertical-align: middle;"><b>제목</b></td>
								<td align="center" style="width: 13%; vertical-align: middle;"><b>별점</b></td>
								<td align="center" style="width: 10%; vertical-align: middle;"><b>작성자</b></td>
								<td align="center" style="width: 30%; vertical-align: middle;"><b>작성일</b></td>
								<td align="center" style="width: 10%; vertical-align: middle;"><b>조회수</b></td>
							</tr>

							<c:forEach var="vo" items="${reviews}">
								<tr class="reviews" style="border-bottom: 1px solid #dfdfdf;">
									<td align="center" style="width: 10%;">${vo.idx}</td>

									<!-- 댓글 -->
									<td style="width: 27%;">
										<!-- 댓글 들여쓰기 -->
										<c:forEach begin="1" end="${ vo.depth }">
											&nbsp;
										</c:forEach>
										<!-- 댓글기호 -->
										<c:if test="${ vo.depth ne 0 }">
											ㄴ
										</c:if>
										<!-- del_info가 -1인 경우 클릭 가능 -->
										<c:if test="${ vo.del_info ne 1}">
											<c:if test="${vo.idx eq param.r_idx}">
												<a href="product_one.do?idx=${vo.p_idx}&page=${ empty param.page ? 1 : param.page }"
												class="num">&nbsp;${vo.subject} </a>
											</c:if>
											<c:if test="${vo.idx ne param.r_idx}">
											<a href="product_one.do?idx=${vo.p_idx}&page=${ empty param.page ? 1 : param.page }&r_idx=${vo.idx}"
												class="num">&nbsp;${vo.subject} </a>
											</c:if>
										</c:if>
										
										<c:if test="${ vo.del_info eq 1 }">
											<span class="num" style="color: pink;"> 삭제된 후기입니다 </span>
										</c:if>
									</td>

									<!-- 별점 -->
									<td style="width: 13%; padding-left: 10px;"><c:if
											test="${ vo.del_info ne 1}">
											<c:forEach var="i" begin="1" end="${vo.grade}">
												<img
													src="${pageContext.request.contextPath}/resources/image/star.png"
													width="10" height="10">
											</c:forEach>
										</c:if></td>

									<!-- 작성자 -->
									<td align="center" style="width: 10%;"><c:if
											test="${ vo.del_info ne 1}">
											${vo.name}
										</c:if></td>

									<!-- 작성일 -->
									<td align="center" style="width: 30%;"><c:if
											test="${ vo.del_info ne 1}">
											${vo.regidate.split(' ')[0]}
										</c:if></td>

									<!-- 조회수 -->
									<td align="center" style="width: 10%;"><c:if
											test="${ vo.del_info ne 1}">
											${vo.readhit}
										</c:if></td>

								</tr>
								<c:if test="${param.r_idx eq vo.idx}">
									<input type="hidden" value="${param.r_idx}" id="r_idx">

									<!-- 후기 -->
									<tr style="border-bottom: 1px solid #dfdfdf;">
										<td colspan="1" width="10%" align="center">
											<c:if test="${!empty sessionScope.user}">
													ㄴ<br>
													<a id="to_dadat" href="javascript:void(0);" onclick="to_dadat(${param.r_idx});">
														댓글달기
													</a>
											</c:if>
											<c:if test="${empty sessionScope.user}">
												ㄴ
											</c:if>
										</td>
										<td colspan="5" height="50" style="padding: 3px 12px;">
											<!-- 2020.06.29 EDITED -->
											<form method="post" enctype="multipart/form-data">
												<p align="right">
													<input type="button" value="수정완료" class="bt_for_review"
														onclick="send_edit(this.form);" id="ed_1"
														style="display: none;"> <input type="button"
														value="취소" class="bt_for_review" onclick="edit_cancel();"
														id="ed_2" style="display: none;">
												</p>
												<div style="margin: 3px 0; padding: 3px 3px; float: left;">
													<c:if test="${vo.filename_r != 'no_file'}">
														<img
															src="${pageContext.request.contextPath}/resources/r_upload/${vo.filename_r}"
															width="150" height="150">
														<br>
													</c:if>
													<p id="ed_3"
														style="display: none; padding: 3px 0; color: gray;">
														(사진을 올리거나 바꾸시려면 파일을 선택하세요)<br>
														<br>ㄴ <input type="file" name="file_r">
													</p>
													<p style="display: block;" id="show_">${r_content}</p>
													<textarea rows="10" cols="80" name="content"
														style="display: none;" id="edit_">${r_content_fortxt}</textarea>
												</div>
												<div style="margin: 3px 0; padding: 3px 3px; float: right;">
													<input type="hidden" value="${param.r_idx}" name="r_idx">
													<input type="hidden" value="${param.idx}" name="p_idx">
													<input type="hidden" value="${param.page}" name="page">
													<input type="password" name="pwd"
														style="width: 80px; height: 15px; font-size: 10px; border: 1px solid gray;"
														placeholder="비밀번호" id="sh_1">
														
														
													<input type="button"
														value="수정" class="bt_for_review"
														onclick="review_edit(this.form);" id="sh_2">
														
														
													<input type="button" value="삭제" class="bt_for_review"
														onclick="review_delete(this.form);" id="sh_3">
												</div>
											</form>
										</td>
									</tr>

									<!-- 대댓글 -->
									<c:forEach var="dadat" items="${dadat_list}">
										<tr style="border-bottom: 1px solid #dfdfdf;">
											<td colspan="1" width="10%" align="center">ㄴ</td>
											<td colspan="5" height="50" style="padding: 3px 12px;">
												<form>
													<div>
														<p align="right">
															<input type="button" value="수정완료" class="bt_for_review"
																onclick="send_edit2(this.form);"
																id="${dadat.idx + 0.04}" style="display: none;">
															<input type="button" value="취소" class="bt_for_review"
																onclick="edit_cancel2('${dadat.idx}');"
																id="${dadat.idx + 0.05}" style="display: none;">
														</p>
														<div style="margin: 3px 0; padding: 3px 3px; float: left;">

															<p
																style="border: 3px solid black; width: 100px; margin: 3px 3px;"
																align="center">
																<b>${dadat.name}</b>
															</p>
															<br>
															<c:if test="${ dadat.del_info ne 1}">
																<p style="display: block;" id="${dadat.idx + 0.1}">${dadat.content}</p>
																<textarea rows="10" cols="80" name="content"
																	style="display: none;" id="${dadat.idx + 0.2}">${dadat_ORcontent.get(dadat.idx)}</textarea>
															</c:if>
															<c:if test="${ dadat.del_info eq 1 }">
																<span class="num" style="color: pink;">삭제된 댓글입니다</span>
															</c:if>
														</div>
														<div
															style="margin: 3px 0; padding: 3px 3px; float: right;">
															<input type="hidden" value="${dadat.idx}" name="r_idx">
															<input type="hidden" value="${param.r_idx}" name="ref">
															<input type="hidden" value="${param.idx}" name="p_idx">
															<input type="hidden" value="${param.page}" name="page">
															<c:if test="${ dadat.del_info ne 1}">
																<input type="password" name="pwd"
																	style="width: 80px; font-size: 10px; height: 15px; border: 1px solid gray;"
																	placeholder="비밀번호" id="${dadat.idx + 0.4}">
																	
																<input type="button" value="수정" class="bt_for_review"
																	onclick="review_edit2(this.form);"
																	id="${dadat.idx + 0.5}">
																<!-- 글 수정 -->
																<input type="button" value="삭제" class="bt_for_review"
																	onclick="review_delete(this.form);"
																	id="${dadat.idx + 0.6}">
																<!-- 글 삭제 -->
															</c:if>
														</div>
													</div>
												</form>
											</td>
										</tr>
									</c:forEach>
									<c:if test="${!empty sessionScope.user}">
										<tr style="border: 1px solid black; display: none;"
											id="${param.r_idx}">
											<form>
												<input type="hidden" value="${param.page}" name="page">
												<input type="hidden" value="${param.r_idx}" name="ref">
												<input type="hidden" value="${param.idx}" name="p_idx">
												<input type="hidden" value="${sessionScope.user.idx}" name="u_idx">
												<td colspan="1" width="10%" align="center">ㄴ</td>
												<td colspan="5" height="50" style="padding: 3px 12px;">
													작성자: <input value="${sessionScope.user.name}" name="name"
													type="hidden"> <input style="width: 100px;"
													value="${sessionScope.user.name}" disabled>
													&nbsp;&nbsp;&nbsp; 비밀번호: <input type="password"
													style="width: 70px;" name="pwd"> &nbsp;&nbsp;&nbsp;
													<input type="button" value="등록하기"
													onclick="dadat_do(this.form);"> <br> <br>
													<textarea rows="10" cols="80"
														placeholder="후기에 대한 답변을 작성해주세요" name="content"></textarea>
												</td>
											</form>
										</tr>
									</c:if>
								</c:if>
							</c:forEach>
							<tr style="border-top: 2px solid gray;">
								<td align="center" colspan="6" style="padding-top: 10px;">${ pageMenu }</td>
							</tr>
						</c:if>
					</table></td>
			</tr>
			
			<tr>
				<td align="center" colspan="2" class="padding30" style="padding-top: 100px;">
					<!-- 2020.07.07 EDITED -->
					<font style="font-weight: bold; font-size: 25px;">후기 작성하기</font><br><br>
					<c:if test="${review_writable eq 'no'}">
						후기작성은 해당상품 구매 후 1회 가능합니다
					</c:if>
					<c:if test="${review_writable eq 'yes'}">
						<form method="post" enctype="multipart/form-data">
							<input type="hidden" value="${vo.idx}" name="p_idx">
							<input type="hidden" value="${sessionScope.user.idx}" name="u_idx">
							<table id="review_insert_box" style="width: 800px;">								
								<tr>
									<!-- 2020.06.29 EDITED -->
									<td width="27%">
												<br>
												<input type="hidden" value="${sessionScope.user.idx}" name="u_idx">
										 		<input value="${sessionScope.user.name}" name="name" type="hidden">
										작성자:	<input style="width: 100px; background-color: white; border: 1px solid #dfdfdf;
													height: 20px;" value="${sessionScope.user.name}" disabled>
									</td>
									
									<td width="33%">
												<br>
										제목: 	<input placeholder="제목" style="width: 150px; border: 1px solid #dfdfdf;
													height: 20px;" name="subject">
									</td>
									
									<td width="25%">
												<br>
										비밀번호: <input type="password" style="width: 70px; border: 1px solid #dfdfdf;
													height: 20px;" name="pwd">
									</td>
									
									<td width="15%">
										<br>
										별점:	
										<select name="grade" style="width: 80px; border: 1px solid #dfdfdf; height: 20px;">
											<option value="0">:::</option>
											<option value="1">1</option>
											<option value="2">2</option>
											<option value="3">3</option>
											<option value="4">4</option>
											<option value="5">5</option>
										</select>
									</td>
								</tr>
								<tr>
									<td colspan="4">
										<br>
										<textarea rows="10" cols="115" placeholder="후기를 남겨주세요" name="content"></textarea>
									</td>
								</tr>
								<!-- 2020.06.29 EDITED -->
								<tr style="border-bottom: 1px solid #dfdfdf;">
									<td colspan="3">
										<br>
										<input type="file" name="file_r">
									</td>
									<td align="right">
										<br>
										<input type="button" value="등록" onclick="send(this.form);" id="dat_block"
											style="background-color: black; color: white; border: none;">
									</td>
								</tr>
							</table>
						</form>
					</c:if>
				</td>
			</tr>
		</table>
		<br><br><br>
	</div>
	<jsp:include page="../index/index_bottom.jsp"></jsp:include>
</body>
</html>









