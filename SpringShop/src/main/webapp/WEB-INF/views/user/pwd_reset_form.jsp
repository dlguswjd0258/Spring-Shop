<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

	<link rel="stylesheet" href="${ pageContext.request.contextPath }/resources/css/pwd_reset_form.css">
	
	<script type="text/javascript">
		function send( f ) {
			var pwd = f.pwd.value.trim();
			var pwd_check = document.getElementById("pwd_check").value.trim();
			
			pwd_pattern = /(?=.*[~`!@#$%\^&*()-+=]{1,50})(?=.*[a-zA-Z]{2,50}).{8,50}$/;
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
			
			f.submit();
		}
	</script>
</head>
<body>
	<jsp:include page="../index/index_top.jsp"/>
	<div id="main">
		<div class="title">
			<h2>비밀번호 찾기</h2>
		</div>
		<div id="form_div">
			<form action="pwd_reset.do" method="post">
				<input type="hidden" name="idx" value="${ param.idx }">
				<input type="hidden" name="id" value="${ param.id }">
				
				<table>
					<caption>비밀번호 재설정</caption>
					<tr>
						<th>아이디</th>
						<td>${ param.id }</td>
					</tr>
					
					<tr>
						<th id="new_pwd_th" >새 비밀번호</th>
						<td id="new_pwd_td">
							<input type="password" id="pwd" name="pwd"><br>
						</td>
						
					</tr>
					
					<tr>
						<th></th>
						<td id="condition">(특문을 포함하여 8자리 이상)</td>
					</tr>
					
					<tr>
						<th>새 비밀번호 확인</th>
						<td><input type="password" id="pwd_check"></td>
					</tr>
					
					<tr>
						<td colspan="2" align="center">
							<input type="button" value="비밀번호 변경"
									onclick="send(this.form)">
							<input type="button" value="취소"
									onclick="location.href='login_form.do?=${param.id}'">
						</td>
					</tr>			
				</table>
			</form>
		</div>
	</div>
	<jsp:include page="../index/index_bottom.jsp"/>
</body>
</html>