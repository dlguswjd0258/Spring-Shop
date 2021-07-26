<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
	<link rel="stylesheet" href="${ pageContext.request.contextPath }/resources/css/basic.css">
	<link rel="stylesheet" href="${ pageContext.request.contextPath }/resources/css/id_find_form.css">

	<script type="text/javascript" src="${ pageContext.request.contextPath }/resources/js/httpRequest.js"></script>

	<script type="text/javascript">
		
		// 아이디 찾는 방법 고를 때 display 설정
		function find_method() {
			var f = document.getElementById("f");
			var method = f.method.value;
			var tel_label = document.getElementById("tel_label");
			var email_label = document.getElementById("email_label");
			var tel_view = document.getElementById("tel_view");
			var email_view = document.getElementById("email_view");
			
			if(method == '휴대폰'){
				tel_label.style.display = "block";
				tel_view.style.display = "block";
				
				email_label.style.display = "none";
				email_view.style.display = "none";
			} else {
				email_label.style.display = "block";
				email_view.style.display = "block";
				
				tel_label.style.display = "none";
				tel_view.style.display = "none";
			}
		}
		
		// 아이디 찾기
		function id_find( f ) {
			var method = f.method.value;
			var name = f.name.value.trim();
			var tel1 = document.getElementById("tel1").value.trim();
			var tel2 = document.getElementById("tel2").value.trim();
			var tel3 = document.getElementById("tel3").value.trim();
			var email = f.email.value.trim();
			
			// 유효성 체크
			if(name == ''){
				alert("이름을 입력해 주세요.");
				return;
			}
			
			if(method == '휴대폰'){
				if(tel2 == '' || tel3 == '' ){
					alert("전화번호를 입력해 주세요.");
					return;
				}
			}else{
				
				var email_pattern = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i;
				if(email == ''){
					alert("이메일을 입력해 주세요.");
					return;
				}
				
				if(!email_pattern.test(email)){
					alert("형식에 맞는 이메일을 작성해 주세요.");
					return;
				}
			}
			
			var url = "id_find.do";
			var param = "name=" + name 
						+ "&tel=" + tel1 + "-" + tel2 + "-" + tel3
						+ "&email=" + encodeURIComponent(email);
			sendRequest(url, param, resultFn, "POST");
			
		}
		
		function resultFn() {
			if(xhr.readyState == 4 && xhr.status == 200){
				
				var data = xhr.responseText;
				if(data == 'no'){
					alert("입력하신 정보로 가입된 회원 아이디는 존재하지 않습니다.");
					var f = document.getElementById("f");
					var method = f.method.value;
					
					f.reset();
					if(method != '휴대폰'){
						document.getElementsByName("method")[1].checked = true;
					}
					
					return;
				}
				
				location.href="id_inform.do?" + data;
			}
		}
	</script>
</head>
<body>
	<jsp:include page="../index/index_top.jsp"></jsp:include>
		<div id="main">
			<div class="title">
				<h2>아이디 찾기</h2>
				<p>회원가입 시, 입력하신 이름 + 휴대폰 번호 또는 이메일로 아이디를 확인하실 수 있습니다.</p>
			</div>
			<div id="form_div">
				<form id="f">
					<table>
						<caption>아이디 찾기</caption>
						<tr>
							<th>찾는 방법</th>
							<td>
								<input type="radio" id="method1" name="method" value="휴대폰" checked="checked"
								onclick="find_method();"> 
								<label for="method1">휴대폰</label> 
								
								<input type="radio" id="method2" name="method" value="이메일" 
										onclick="find_method();"> 
								<label for="method2">이메일</label>
							</td>
						</tr>
						
						<tr>
							<th class="lable">이름</th>
							<td><input class="input" name="name"></td>
							
						</tr>
						
						<tr>
							<th>
								<div id="tel_label">휴대폰</div>
								<div id="email_label" style="display: none;">email</div>
							</th>
							<td>
								<div id="tel_view">
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
									<input type="number" id="tel2" maxlength="4">	
									-
									<input type="number" id="tel3" maxlength="4">	
								</div>
								<input id="email_view" class="input" name="email"  style="display: none;" >	
							</td>
						</tr>
						
						
						<tr>
							<td colspan="2" align="center">
								<input id="findButton" type="button" value="아이디 찾기"
										onclick="id_find(this.form)">
								<input id="loginButton" type="button" value="로그인"
										onclick="location.href='login_form.do'">
							</td>
						</tr>			
					</table>
		
				</form>
			</div>
		</div>
	<jsp:include page="../index/index_bottom.jsp"></jsp:include>
</body>
</html>