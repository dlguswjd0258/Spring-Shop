<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

	<link rel="stylesheet" href="${ pageContext.request.contextPath }/resources/css/basic.css">
	<link rel="stylesheet" href="${ pageContext.request.contextPath }/resources/css/user_insert_form.css">
	<script type="text/javascript" src="${ pageContext.request.contextPath }/resources/js/httpRequest.js"></script>
	
	<!-- 주소 찾기 API -->
	<script type="text/javascript" src="${ pageContext.request.contextPath }/resources/js/postcode.js"></script>
	<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	
	<script type="text/javascript">
		window.onload = function() {
			if( <c:out value="${ empty sessionScope.user}"/>){
				alert("로그인 먼저 하세요.");
				location.href="login_form.do";
			}


			if( <c:out value="${ vo.gender ne '남' }"/>){
				document.getElementsByName("gender")[1].checked = true;
			}
		}
		
		var b_telCheck = false;
		var b_emailCheck = false;
		
		// 전화번호 중복 체크
		function check_tel() {
			var now_tel = document.getElementById("now_tel").value;
			var tel1 = document.getElementById("tel1").value.trim();
			var tel2 = document.getElementById("tel2").value.trim();
			var tel3 = document.getElementById("tel3").value.trim();
		
			if(tel2 == '' || tel3 == '' ){
				alert("전화번호를 입력해 주세요.");
				return;
			}
			var tel = tel1 + "-" + tel2 + "-" + tel3;
			if(now_tel == tel){
				alert("현재 전화번호입니다.");
				return;
			}
			
			//id를 Ajax를 통해서 서버로 전송
			var url = "check_tel.do";
			var param = "tel="+tel;
			sendRequest(url, param, resultFnTEL, "GET");
		}
		
		function resultFnTEL() {
			if(xhr.readyState == 4 && xhr.status == 200){
				var data = xhr.responseText;
				if(data == 'no'){
					alert("중복된 전화번호입니다.");
					return;
				}
				
				alert("사용가능한 전화번호입니다.");
				b_telCheck = true;
				document.getElementById("tel2").readOnly = true;
				document.getElementById("tel3").readOnly = true;
			}
			
		}
		
		// 이메일 중복 체크
		function check_email() {
			var now_email = document.getElementById('now_email').value;
			var email = document.getElementById('email').value.trim();
		
			var email_pattern = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i;
			if(email == ''){
				alert("이메일을 입력해 주세요.");
				return;
			}
			
			if(!email_pattern.test(email)){
				alert("형식에 맞는 이메일을 작성해 주세요.");
				return;
			}
		
			if(now_email == email){
				alert("현재 이메일입니다.");
				return;
			}
			
			//id를 Ajax를 통해서 서버로 전송
			var url = "check_email.do";
			var param = "email="+email;
			sendRequest(url, param, resultFnEMAIL, "GET");
		}
		
		function resultFnEMAIL() {
			if(xhr.readyState == 4 && xhr.status == 200){
				var data = xhr.responseText;
				if(data == 'no'){
					alert("중복된 이메일 주소입니다.");
					return;
				}
				
				alert("사용가능한 이메일 주소입니다.");
				b_emailCheck = true;
				document.getElementById("email").readOnly = true;
			}
			
		}
		
		function send( f ) {
			var pwd = f.pwd.value.trim();
			var pwd_check = document.getElementById("pwd_check").value.trim();
			var name = f.name.value.trim();
			var gender = f.gender.value.trim();
			var postcode = document.getElementById("postcode").value.trim();
			var addr = f.addr.value.trim();
			var exaddr = document.getElementById("detailAddress").value.trim();
			var tel1 = document.getElementById("tel1").value.trim();
			var tel2 = document.getElementById("tel2").value.trim();
			var tel3 = document.getElementById("tel3").value.trim();
			var email = f.email.value.trim();
			
			
			var now_tel = document.getElementById("now_tel").value;
			var now_email = document.getElementById("now_email").value;
			
			//유효성 검사
			var pwd_pattern = /(?=.*[~`!@#$%\^&*()-+=]{1,50})(?=.*[a-zA-Z]{2,50}).{8,50}$/;
			if(pwd == ''){
				alert("비밀번호를 입력해주세요.");
				f.pwd.focus();
				return;
			}
			
			if(!pwd_pattern.test(pwd)){
				alert("비밀번호 입력 조건을 다시 한번 확인해 주세요.");
				return;
			}
			
			if(pwd != pwd_check){
				alert("비밀번호가 일치하지 않습니다.");
				document.getElementById("pwd_check").focus();
				return;
			}
			
			if(name == ''){
				alert("이름을 입력해 주세요.");
				return;
			}
			
			if(gender == ''){
				alert("성별을 입력해 주세요.");
				return;
			}
			
			if(gender != '남' && gender != '여'){
				alert("성별은 '남' 또는 '여'로 작성해 주세요.");
				return;
			}
			
			if(addr == ''){
				alert("주소를 입력해 주세요.");
				return;
			}
			
			addr = postcode + "," + addr;
			
			if(exaddr != ''){
				addr +=  "," + exaddr;
			}
			
			
			if(tel2 == '' || tel3 == '' ){
				alert("전화번호를 입력해 주세요.");
				return;
			}
			f.tel.value = tel1 + "-" + tel2 + "-" + tel3;
			
			var email_pattern = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i;
			if(email == ''){
				alert("이메일을 입력해 주세요.");
				return;
			}
			
			if(!email_pattern.test(email)){
				alert("형식에 맞는 이메일을 작성해 주세요.");
				return;
			}
			
			if(f.tel.value!= now_tel && !b_telCheck){
				alert("전화번호 중복 확인을 하세요.");
				return;
			}
			
			if(email != now_email && !b_emailCheck){
				alert("이메일 중복 확인을 하세요.");
				return;
			}
			
			f.addr.value = addr;
			f.submit();
		}
	</script>

</head>
<body>
	<jsp:include page="../index/index_top.jsp"></jsp:include>
	<div id="main">
		<div class="title">
			<h2>회원정보 수정</h2>
		</div>
		<form action="myinfo_update.do" method="post">
			<input type="hidden" name="idx" value="${ vo.idx }">
			<h3>회원 정보 입력</h3>
			<p class="required"><img src="//img.echosting.cafe24.com/skin/base/common/ico_required.gif" alt="필수"> 필수입력사항</p>
			<table border="1">
				
				<tr>
					<th>
						<img src="//img.echosting.cafe24.com/skin/base/common/ico_required.gif" alt="필수">
						아이디
					</th>
					
					<td>
						<input value="${ vo.id }" readonly="readonly"> (영문소문자/숫자)
					</td>
				</tr>
				
				<tr>
					<th>
						<img src="//img.echosting.cafe24.com/skin/base/common/ico_required.gif" alt="필수">
						비밀번호
					</th>
					
					<td><input type="password" name="pwd"> (특문을 포함하여 8자리 이상)</td>
				</tr>
				
				<tr>
					<th>
						<img src="//img.echosting.cafe24.com/skin/base/common/ico_required.gif" alt="필수">
						비밀번호 확인
					</th>
					
					<td><input type="password" id="pwd_check"></td>
				</tr>
				
				<tr>
					<th>
						<img src="//img.echosting.cafe24.com/skin/base/common/ico_required.gif" alt="필수">
						이름
					</th>
					
					<td><input name="name" value="${ vo.name }"></td>
					
				</tr>
				
				<tr>
					<th>
						<img src="//img.echosting.cafe24.com/skin/base/common/ico_required.gif" alt="필수">
						성별
					</th>
					
					<td>
						<input type="radio" id="man" name="gender" value="남" checked="checked">
						<label for="man">남</label>
						<input type="radio" id="woman" name="gender" value="여">
						<label for="woman">여</label> 
					</td>
				</tr>
				
				<tr>
					<th>
						<img src="//img.echosting.cafe24.com/skin/base/common/ico_required.gif" alt="필수">
						주소
					</th>
					
					<td>
						<input type="text" id="postcode" placeholder="우편번호" value="${ vo.addr.split(',')[0] }">
						<input id="postButton" type="button" onclick="execDaumPostcode()" value="우편번호 찾기"><br>
						<input type="text" name="addr" id="Address" placeholder="주소" value="${ vo.addr.split(',')[1] }"><br>
						<span id="guide" style="color:#999;display:none"></span>
						<input type="text" id="detailAddress" placeholder="상세주소" value="${ vo.addr.split(',')[2] }">
					</td>
				</tr>
				
				<tr>
					<th>
						<img src="//img.echosting.cafe24.com/skin/base/common/ico_required.gif" alt="필수">
						휴대전화
					</th>
					
					<td>
						<input type="hidden" id="now_tel" value="${ vo.tel }">
						<input type="hidden" name="tel">
						<select id="tel1">
							<option>010</option>
							<option>011</option>
							<option>016</option>
							<option>017</option>
							<option>018</option>
							<option>019</option>
						</select>
						-
						<input type="number" id="tel2" value="${ vo.tel.split('-')[1] }">	
						-
						<input type="number" id="tel3" value="${ vo.tel.split('-')[2] }">	
						<input type="button" id="id_check" value="중복 확인"
								onclick="check_tel( this.form );">
					</td>
				</tr>
				
				<tr>
					<th>
						<img src="//img.echosting.cafe24.com/skin/base/common/ico_required.gif" alt="필수">
						이메일
					</th>
					
					<td>
						<input type="hidden" id="now_email" value="${ vo.email }">
						<input name="email" id="email" value="${ vo.email }">
						<input type="button" id="id_check" value="중복 확인"
								onclick="check_email( this.form );">
					</td>
				</tr>
				
			</table>
				    
			<div id="joinButton" align="center">
				<input type="button" value="수정"
						onclick="send(this.form);">
				<input type="button" value="취소"
						onclick="location.href='mypage_form.do'">
			</div>
		</form>
		
	</div>
	<jsp:include page="../index/index_bottom.jsp"/>
</body>
</html>