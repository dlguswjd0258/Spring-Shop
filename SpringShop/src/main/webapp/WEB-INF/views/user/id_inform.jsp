<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
	<link rel="stylesheet" href="${ pageContext.request.contextPath }/resources/css/id_inform.css">
</head>
<body>
	<jsp:include page="../index/index_top.jsp"/>
	<div id="main">
		<div class="title">
			<h2>아이디 찾기</h2>
		</div>
		<div id="form_div">
			<h3>아이디 찾기</h3>
			<h4>고객님 아이디 찾기가 완료 되었습니다.</h4>
			<table>
				<tr>
					<th>이름:</th>
					<td>${ vo.name }</td>
				</tr>

				<tr>
					<th>아이디:</th>
					<td>${ vo.id }</td>
				</tr>

				<tr>
					<td colspan="2">
						<input id="loginButton" type="button" value="로그인"
							onclick="location.href='login_form.do?id=${ param.id }'">
						<input id="findpwdButton" type="button" value="비밀번호 찾기"
							onclick="location.href='pwd_find_form.do?id=${ param.id }'">
					</td>
				</tr>
			</table>
		</div>
	</div>
	<jsp:include page="../index/index_bottom.jsp"/>
</body>
</html>