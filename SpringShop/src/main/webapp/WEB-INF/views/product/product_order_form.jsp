<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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

	<link rel="stylesheet" href="${ pageContext.request.contextPath }/resources/css/basic.css">
	<link rel="stylesheet" href="${ pageContext.request.contextPath }/resources/css/product_order_form.css">
	<script type="text/javascript" src="${ pageContext.request.contextPath }/resources/js/httpRequest.js"></script>
	
	<!-- 주소 찾기 API -->
	<script type="text/javascript" src="${ pageContext.request.contextPath }/resources/js/postcode.js"></script>
	<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	
	<script type="text/javascript">
		var agreed = false;
		var total_status = false;
		var total_calc = 0;
		function check_agree(){
			var agreement = document.getElementById("agreement");
			if (agreement.checked == true) {
				agreed = true;
			}else {
				agreed = false;
			}
		}
		function use_point(max_point){
			var point = Number(document.getElementById("point").value.trim());
			var usePoint = document.getElementById("usePoint");
			var total = Number(document.getElementById("total").value);
			var o_fee = Number(document.getElementById("o_fee").value);
			var real_total = Number(document.getElementById("real_total").value);
			
			
			if (point > max_point) {
				alert("적립금이 부족합니다.");
				document.getElementById("point").value = '';
				return;
			}
			if (point < 0) {
				alert("잘못된 값입니다.");
				document.getElementById("point").value = '';
				return;
			}
			
			if (point % 10 != 0) {
				alert("10원단위 이상부터 사용가능합니다.");
				document.getElementById("point").value = '';
				return;
			}
			
			if ((real_total - point) < o_fee) {
				alert("배송비는 적립금으로 결제할 수 없습니다.");
				document.getElementById("point").value = '';
				return;
			}
			
			if (total_status == true) {
				total = total + total_calc;
				total_status = false;
			}
			
			
			usePoint.value = point;
			total = total-point;
			document.getElementById("point").value = '';
			document.getElementById("total").value = total;
			document.getElementById("real_total").value = total;
			total_status = true;
			total_calc = point;
		}
		
		function set_same(){
			var check = document.getElementById("check");
			var u_name = document.getElementById("u_name").value.trim();
			var u_tel1 = document.getElementById("u_tel1").value.trim();
			var u_tel2 = document.getElementById("u_tel2").value.trim();
			var u_tel3 = document.getElementById("u_tel3").value.trim();
			var u_postcode = document.getElementById("u_postcode").value.trim();
			var u_Address = document.getElementById("u_Address").value.trim();
			var u_detailAddress = document.getElementById("u_detailAddress").value.trim();
			var u_email = document.getElementById("u_email").value.trim();
			
			var name = document.getElementById("name");
			var tel1 = document.getElementById("tel1");
			var tel2 = document.getElementById("tel2");
			var tel3 = document.getElementById("tel3");
			var postcode = document.getElementById("postcode");
			var Address = document.getElementById("Address");
			var detailAddress = document.getElementById("detailAddress");
			var email = document.getElementById("email");
			
			if (check.checked == true) {
				name.value = u_name;
				tel1.value = u_tel1;
				tel2.value = u_tel2;
				tel3.value = u_tel3;
				postcode.value = u_postcode;
				Address.value = u_Address;
				detailAddress.value = u_detailAddress;
				email.value = u_email;
			}else {
				name.value = "";
				tel1.value = "";
				tel2.value = "";
				tel3.value = "";
				postcode.value = "";
				Address.value = "";
				detailAddress.value = "";
				email.value = "";
			}
		}
		
		function c_send(f){
			var u_idx = f.u_idx.value;
			var o_name = f.o_name.value.trim();
			var o_tel = f.o_tel;
				o_tel.value = document.getElementById("tel1").value.trim() + "-" + document.getElementById("tel2").value.trim()
						+ "-" + document.getElementById("tel3").value.trim();
			var o_addr = f.o_addr;
				o_addr.value = document.getElementById("postcode").value.trim() + "," + document.getElementById("Address").value.trim()
						+ "," + document.getElementById("detailAddress").value.trim();
			var o_email = f.o_email.value.trim();
			var o_content = f.o_content.value.trim();
			var o_fee = f.o_fee.value;
			var o_total = f.o_total.value;
			
			var usePoint = f.usePoint.value;
			var addPoint = f.addPoint.value;
			
			if (o_name == '') {
				alert("이름은 필수 입력 항목입니다.");
				return;
			}
			if (document.getElementById("tel1").value.trim() == '' ||
					document.getElementById("tel2").value.trim() == '' ||
					document.getElementById("tel3").value.trim() == '') {
				
				alert("전화번호는 필수 입력 항목입니다.");
				return;
			}
			
			if (document.getElementById("postcode").value.trim() == '' ||
					document.getElementById("Address").value.trim() == '' ||
					document.getElementById("detailAddress").value.trim() == '') {
				
				alert("주소는 필수 입력 항목입니다.");
				return;
			}
			
			if (o_email == '') {
				alert("이메일은 필수 입력 항목입니다.");
				return;
			}
			
			if (!agreed) {
				alert("주문자 동의에 체크해주세요");
				return;
			}
			
			if (o_total > Number(document.getElementById("cash").value)) {
				alert("예치금이 부족합니다. 충전을 먼저 진행해주세요");
				location.href="mypage_form.do?";
				return;
			}
			f.action = "order.do";
			f.method = "post";
			f.submit();
		}
		
		function one_send(f){
			var u_idx = f.u_idx.value;
			var o_name = f.o_name.value.trim();
			var o_tel = f.o_tel;
				o_tel.value = document.getElementById("tel1").value.trim() + "-" + document.getElementById("tel2").value.trim()
						+ "-" + document.getElementById("tel3").value.trim();
			var o_addr = f.o_addr;
				o_addr.value = document.getElementById("postcode").value.trim() + "," + document.getElementById("Address").value.trim()
						+ "," + document.getElementById("detailAddress").value.trim();
			var o_email = f.o_email.value.trim();
			var o_content = f.o_content.value.trim();
			var o_fee = f.o_fee.value;
			var o_total = f.o_total.value;
			
			var usePoint = f.usePoint.value;
			var addPoint = f.addPoint.value;
			
			if (o_name == '') {
				alert("이름은 필수 입력 항목입니다.");
				return;
			}
			if (document.getElementById("tel1").value.trim() == '' ||
					document.getElementById("tel2").value.trim() == '' ||
					document.getElementById("tel3").value.trim() == '') {
				
				alert("전화번호는 필수 입력 항목입니다.");
				return;
			}
			
			if (document.getElementById("postcode").value.trim() == '' ||
					document.getElementById("Address").value.trim() == '' ||
					document.getElementById("detailAddress").value.trim() == '') {
				
				alert("주소는 필수 입력 항목입니다.");
				return;
			}
			
			if (o_email == '') {
				alert("이메일은 필수 입력 항목입니다.");
				return;
			}
			
			if (!agreed) {
				alert("주문자 동의에 체크해주세요");
				return;
			}
			
			if (o_total > Number(document.getElementById("cash").value)) {
				alert("예치금이 부족합니다. 충전을 먼저 진행해주세요");
				location.href="mypage_form.do?";
				return;
			}
			f.action = "order_one.do";
			f.method = "post";
			f.submit();
		}
	</script>

</head>
<body>
	<jsp:include page="../index/index_top.jsp"></jsp:include>
	<form>
		<section class="main1">
			<div id="order_list">
				<div class="title">
					<h2>상품 주문</h2>
				</div>
				<table>
					<tr>
						<th>번호</th>
						<th>사진</th>
						<th>상품명</th>
						<th>수량</th>
						<th>금액</th>
						<th>적립금</th>
					</tr>
					<c:set var="sale_total" value="0"/>
					<c:set var="price_total" value="0"/>
						<c:forEach var="vo" items="${ list }" varStatus="c">
							<tr>
								<td>
									${ c.count }
								</td>
								<td>
									<img style="width: 50px; height: 50px;" src="${ pageContext.request.contextPath }/resources/upload/${ vo.filename_s }">
								</td>
								<td>
									<a href="product_one.do?idx=${ vo.p_idx }">${ vo.p_name }</a><br>
									<div class="option">[사이즈: ${ vo.p_size }, 색상: <div class="color_box" style="background-color: ${ vo.p_color };"></div>]</div></td>
								<td><input type="number" readonly="readonly" name="c_cnt" value="${ vo.c_cnt }"></td>
								
								<td><fmt:formatNumber>${ vo.total_price }</fmt:formatNumber>원</td>
								<td><fmt:formatNumber>${ vo.total_price * point_rate }</fmt:formatNumber>원</td>
							</tr>
							<c:set var="sale_total" value="${ sale_total + (vo.c_cnt * vo.p_saleprice) }" />
							<c:set var="price_total" value="${ price_total + (vo.c_cnt * vo.p_price) }" />
						</c:forEach>
					
					<c:if test="${ sale_total lt 50000 }">
						<c:set var="del_fee" value="2500" />
					</c:if>
					<c:if test="${ sale_total ge 50000 }">
						<c:set var="del_fee" value="0" />
					</c:if>
					<c:set var="addPoint" value="${ sale_total * point_rate }" />
					
					<tr>
						<td colspan="6" align="center">
							<img alt="" src="">
							회원님의 현재 멤버십 등급은 <span style="color: ${mem_color};">${ sessionScope.user.membership }</span>입니다.<br>
							상품 구매시 <fmt:formatNumber>${ point_rate * 100 }</fmt:formatNumber>%적립됩니다.
						</td>
					</tr>
				</table>
	
			</div>
		</section>
		
		<section class="main2">
			<div id="user_info">
					<h3>회원정보</h3>
					<p class="required"><img src="//img.echosting.cafe24.com/skin/base/common/ico_required.gif" alt="필수"> 필수입력사항</p>
					<table border="1" class="basic_info">
						
						<tr>
						<tr>
							<th>
								<img src="//img.echosting.cafe24.com/skin/base/common/ico_required.gif" alt="필수">
								이름
							</th>
							
							<td><input id="u_name" readonly="readonly" value="${ sessionScope.user.name }"></td>
							
						</tr>
						
						<tr>
							<th>
								<img src="//img.echosting.cafe24.com/skin/base/common/ico_required.gif" alt="필수">
								휴대전화
							</th>
							
							<td>
								<input type="number" id="u_tel1" value="${ sessionScope.user.tel.split('-')[0] }" readonly="readonly">	
								-
								<input type="number" id="u_tel2" value="${ sessionScope.user.tel.split('-')[1] }" readonly="readonly">	
								-
								<input type="number" id="u_tel3" value="${ sessionScope.user.tel.split('-')[2] }" readonly="readonly">
							</td>
						</tr>
						
						<tr>
							<th>
								<img src="//img.echosting.cafe24.com/skin/base/common/ico_required.gif" alt="필수">
								주소
							</th>
							<td>
								<input type="text" id="u_postcode" value="${ sessionScope.user.addr.split(',')[0] }" readonly="readonly"><br>
								<input type="text" id="u_Address" value="${ sessionScope.user.addr.split(',')[1] }" readonly="readonly"></br>
								<span id="guide" style="color:#999;display:none"></span>
								<input type="text" id="u_detailAddress" value="${ sessionScope.user.addr.split(',')[2] }" readonly="readonly">
							</td>
						</tr>
						
						<tr>
							<th>
								<img src="//img.echosting.cafe24.com/skin/base/common/ico_required.gif" alt="필수">
								이메일
							</th>
							
							<td><input id="u_email" value="${ sessionScope.user.email }" readonly="readonly"></td>
						</tr>
						
					</table>
			</div>
		</section>
		
		<section class="main3">
			<div id="addr_info">
					<h3>배송지정보 입력</h3>
					<p class="required">
						<img src="//img.echosting.cafe24.com/skin/base/common/ico_required.gif" alt="필수"> 필수입력사항
						<input  id="check" type="checkbox" onclick="set_same();">위의 정보와 같음
					</p>
					<table border="1">
						<tr>
							<th>
								<img src="//img.echosting.cafe24.com/skin/base/common/ico_required.gif" alt="필수">
								이름
							</th>
							
							<td><input id="name" name="o_name" placeholder="이름"></td>
							
						</tr>
						
						<tr>
							<th>
								<img src="//img.echosting.cafe24.com/skin/base/common/ico_required.gif" alt="필수">
								휴대전화
							</th>
							
							<td>
								<input type="hidden" name="o_tel">
								<input type="number" id="tel1">	
								-
								<input type="number" id="tel2">	
								-
								<input type="number" id="tel3">	
							</td>
						</tr>
						<tr>
							<th>
								<img src="//img.echosting.cafe24.com/skin/base/common/ico_required.gif" alt="필수">
								주소
							</th>
							
							<td>
								<input type="hidden" name="o_addr">
								<input type="text" id="postcode" placeholder="우편번호">
								<input  id="postButton" type="button" onclick="execDaumPostcode()" value="우편번호 찾기"><br>
								<input type="text" id="Address" placeholder="주소"></br>
								<span id="guide" style="color:#999;display:none"></span>
								<input type="text" id="detailAddress" placeholder="상세주소">
							</td>
						</tr>
						
						
						<tr>
							<th>
								<img src="//img.echosting.cafe24.com/skin/base/common/ico_required.gif" alt="필수">
								이메일
							</th>
							
							<td><input id="email" name="o_email" placeholder="이메일"></td>
						</tr>
						<tr>
							<th>
								배송메시지
							</th>
							
							<td>
								<input style="width: 200px;" name="o_content" placeholder="배송메시지 ex)부재시 경비실에 맡겨주세요.">
							</td>
						</tr>
					</table>
			
			</div>
		</section>
		
		<section class="main4">
			<div id="price_info">
				<h3>주문상품 할인적용</h3>
				<table>
					<tr>
						<th>상품금액</th>
						<td class="empty"></td>
						<th >배송비</th>
						<td class="empty"></td>
						<th>할인금액</th>
						<td class="empty"></td>
						<th>적립금사용</th>
						<td class="empty"></td>
						<th>결제 예정금액</th>
					</tr>
					<tr>
						<td><fmt:formatNumber>${ price_total }</fmt:formatNumber>(원)</td>
						
						<td class="empty"><img src="https://www.jogunshop.com/images/common/bul_h23_plus.png"></td>
						
						<td><fmt:formatNumber>${ del_fee }</fmt:formatNumber>(원)</td>
						
						<td class="empty"><img src="https://www.jogunshop.com/images/common/bul_h23_minus.png"></td>
						
						<td>
							<fmt:formatNumber>${ price_total - sale_total }</fmt:formatNumber>(원)
						</td>
						
						<td class="empty"><img src="https://www.jogunshop.com/images/common/bul_h23_minus.png"></td>
						
						<td>
							<input type="number" id="usePoint" name="usePoint" value='0' readonly="readonly">(원)
						</td>
						
						<td class="empty"><img src="https://www.jogunshop.com/images/common/bul_h23_equal.png"></td>
						
						<c:set var="total" value="${ sale_total + del_fee }"/>
						<td>
							<input type="number" id="total" value='${ total }' readonly="readonly">(원)
						</td>
					</tr>
					<tr>
						<th>적립금 사용</th>
						<td colspan="8" align="left">
							<input id="point" type="number" placeholder="0" maxlength="${ sessionScope.user.point }">
							<input type="button" value="사용" onclick="use_point('${ sessionScope.user.point }');">
							<span style="font-size: 13px; color: #353535;">
								(사용가능 적립금 : <fmt:formatNumber>${ sessionScope.user.point }</fmt:formatNumber>원)
							</span>
						</td>
					</tr>
				</table>
			</div>
		</section>
		
		<section class="main5">
			<div id="agree">
				<h3>주문자 동의</h3>
				<table>
					<tr>
						<th>주문자 동의</th>
						<td>
							<input type="checkbox" id="agreement" onclick="check_agree();"> 상기 결제내역을 확인하였으며 이에 동의합니다.
						</td>
					</tr>
				</table>
			</div>
		</section>
		
		<section class="main6">
			<div id="last_price">
				<table>
					<tr>
						<th>최종 결제금액</th>
						<td>
							<input type="number" id="real_total" name="o_total" value="${ total }" readonly="readonly">(원)
							<span>(적립예정 : <fmt:formatNumber>${ addPoint }</fmt:formatNumber>원)</span>
						</td>
					</tr>
				</table>
			</div>
		</section>
		
		<section class="main7">
			<div id="btn_menu" align="center">
				<input type="hidden" value="${ sessionScope.user.cash }" id="cash">	
				<input type="hidden" value="${ del_fee }" name="o_fee" id="o_fee">
				<input type="hidden" value="${ sessionScope.user.idx }" name="u_idx">
				<input type="hidden" value="${ addPoint }" name="addPoint">
				<c:if test="${ !empty check }">
					<input type="button" value="주문하기" onclick="one_send(this.form);">
				</c:if>
				<c:if test="${ empty check }">
					<input type="button" value="주문하기" onclick="c_send(this.form);">
				</c:if>
				<input type="button" value="주문취소">
			</div>
		</section>
	</form>
	<jsp:include page="../index/index_bottom.jsp"/>
</body>
</html>