<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
	<link rel="stylesheet" href="${ pageContext.request.contextPath }/resources/css/login_form.css">
	
	<script type="text/javascript" src="${ pageContext.request.contextPath }/resources/js/httpRequest.js"></script>
	<script type="text/javascript">
		//엔터키 눌렀을 대
		function enterkey(){
			if( event.keyCode == 13){
				login();
			}
		}
	
		//로그인
		function login() {
			var f = document.getElementById("f");
			var id = f.id.value.trim();
			var pwd = f.pwd.value.trim();
			var idx = document.getElementById("idx").value;
			
			if(id == ''){
				alert("아이디를 입력하세요.");
				return;
			}
			
			if(pwd == ''){
				alert("비밀번호를 입력하세요.");
				return;
			}
			
			var url = "login.do";
			var param = "id=" + id + "&pwd=" + pwd + "&idx=" + idx;
			sendRequest( url, param, resultFn, "POST");
			
		}
		
		function resultFn() {
			if(xhr.readyState == 4 && xhr.status == 200){
				var data = xhr.responseText;
				if(data == 'no_id'){
					alert("해당 아이디는 존재하지 않습니다.");
					return;
				}
				
				if(data == "no_pwd"){
					alert("비밀번호가 일치하지 않습니다.");
					return;
				}
				
				// 2020.06.26 EDITED
				if(data == "home"){
					location.href="main.do";
				}else{
					location.href="product_one.do?idx="+data;	
				}
			}
		}
	</script>
</head>
<body>
	<jsp:include page="../index/index_top.jsp"></jsp:include>
	<div id="main">
		<div class="submain">
			<div class="title"><h2>로그인</h2></div>
			<div class="login">
				<form id="f" class="inputarea">
					<ul>
						<li>
							<div class="dist">아이디</div>
							<label class="id_label">
								<input id="id" name="id" value="${ param.id }">
							</label>
							
						</li>			
			
						<li>
							<div class="dist">비밀번호</div>
							<label class="id_label">
								<input type="password" id="pwd" name="pwd" onkeydown="enterkey();">
							</label>
						</li>			
					</ul>
					
				</form>
			</div>
			
			<input type="hidden" value="${param.idx}" id="idx">
			<input id="loginButton" type="button" value="로그인"
					onclick="login();" >
					
			<div class="userlink">
				<ul>
					<li><a href="id_find_form.do">아이디 찾기</a></li>
					<li><a href="pwd_find_form.do">비밀번호 찾기</a></li>
					<li><a href="user_insert_form.do">회원가입</a></li>
				</ul>
			</div>
		</div>
	</div>
	<jsp:include page="../index/index_bottom.jsp"></jsp:include>	
</body>
</html>