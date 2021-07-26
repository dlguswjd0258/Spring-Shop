<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:if test="${empty sessionScope.user || sessionScope.user.admin eq 0}">
	<script>
		alert("경고! 이 페이지에 접근할 권한이 없습니다!");
		location.href = "main.do";
	</script>
</c:if>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원명단</title>
<link rel="stylesheet"
	href="${ pageContext.request.contextPath }/resources/css/basic.css">
<link rel="stylesheet"
	href="${ pageContext.request.contextPath }/resources/css/user_management.css">
<script type="text/javascript"
	src="${pageContext.request.contextPath}/resources/js/httpRequest.js"></script>

<script type="text/javascript">

	function modify(f) {
		var selectoption = document.getElementById("userclass"+f);
		/* alert(selectoption.options[selectoption.selectedIndex].text); */
		var currentclass = document.getElementById("currentclass"+f).innerText;
		/* alert(currentclass); */
		if(selectoption.options[selectoption.selectedIndex].text == currentclass){
			return;
		}
		var url = "usermodify.do";
		var param = "idx=" + f +
		"&selectoption=" + encodeURIComponent(selectoption.options[selectoption.selectedIndex].value);

		sendRequest(url, param, resultFnM, "POST");
	}
	
	function resultFnM() {
		if(xhr.readyState == 4 && xhr.status == 200){
			var data = xhr.responseText;
			
			if(data == 'no'){
				alert("변경실패");
				return;
			}
			
			alert("변경완료!");
			location.href="usermanagement.do";
		}
		
	}
	
	function kick(f) {
		if (!confirm("정말로 탈퇴시키시겠습니까?")) {
			return;
		}
		var url = "user_delete.do";
		var param = "idx=" + f;

		sendRequest(url, param, resultFnD, "POST");
	}
	
	function resultFnD() {
		if(xhr.readyState == 4 && xhr.status == 200){
			var data = xhr.responseText;
			
			if(data == 'no'){
				alert("삭제에 실패했습니다. 다시 시도해 주세요.");
				return;
			}
			
			alert("삭제 완료하였습니다.");
			location.href="usermanagement.do";
		}
		
	}
	
	function seeDeleted(){

	var con= document.getElementById("deleted_member");
		if (con.style.display=='none'){
		con.style.display='block';
		}else{
		con.style.display='none';
		}
	}
</script>
<style type="text/css">

#id_kick:hover {
	background: #EB0000;
	color: white;
}

#id_modify:hover {
	background: #D2FFD2;
}

#id_return:hover {
	background: #FAFAA0;
}

#id_blocked:hover {
	background: #9400D3;
	color: white;
}

#id_blocked{
	width: 115px;
}
select {
	width: 100px; /* 원하는 너비설정 */
	font-family: inherit; /* 폰트 상속 */
	border: 4px solid #999;
	border-radius: 0px; /* iOS 둥근모서리 제거 */
	text-align: center;
}

#nothing{
height: 220px;
}
</style>
</head>
<body>
	<jsp:include page="../index/index_top.jsp" />
	<h1>회원관리</h1>
	<div class="main_table">
	<form name="f">
		<table align="center">
			<tr>
				<th>회원번호</th>
				<th>아이디</th>
				<th>비밀번호</th>
				<th>이름</th>
				<th>주소</th>
				<th>성별</th>
				<th>전화번호</th>
				<th>이메일</th>
				<th>적립금</th>
				<th>회원등급</th>
				<th>회원종류</th>
				<th colspan="2">관리</th>
			</tr>


			<c:forEach var="vo" items="${list}">
				<c:if test="${vo.del_info eq '0'}">
					<tr class="rank_2">
						<c:if test="${vo.admin eq 2}">
							<td>${vo.idx}</td>
							<input type="hidden" id="c_idx" value="${vo.idx}">
							<td>${vo.id}</td>
							<td>${vo.pwd}</td>
							<td>${vo.name}</td>
							<td>${vo.addr}</td>
							<td>${vo.gender}</td>
							<td>${vo.tel}</td>
							<td>${vo.email}</td>
							<td>${vo.point}</td>
							<td><c:if test="${vo.membership eq 'bronze'}">
									<p id="bronze">브론즈</p>
								</c:if> <c:if test="${vo.membership eq 'silver'}">
									<p id="silver">실버</p>
								</c:if> <c:if test="${vo.membership eq 'gold'}">
									<p id="gold">골드</p>
								</c:if><c:if test="${vo.membership eq 'vip'}">
									<p id="vip">VIP</p>
								</c:if></td>
							<td id="currentclass${vo.idx}">
								<p class="class_2">사장</p>
							</td>
							<td><input type="button" value="탈퇴한 회원 보기"
								onclick='seeDeleted()' ;
								id="id_blocked"></td>

							<td><input type="button" value="돌아가기"
								onclick="location.href='main.do'" ;
								id="id_return">
							</td>
						</c:if>
					</tr>
					<tr class="rank_1">
						<c:if test="${vo.admin eq 1}">
							<td>${vo.idx}</td>
							<input type="hidden" id="c_idx" value="${vo.idx}">
							<td>${vo.id}</td>
							<td>${vo.pwd}</td>
							<td>${vo.name}</td>
							<td>${vo.addr}</td>
							<td>${vo.gender}</td>
							<td>${vo.tel}</td>
							<td>${vo.email}</td>
							<td>${vo.point}</td>
							<td><c:if test="${vo.membership eq 'bronze'}">
									<p id="bronze">브론즈</p>
								</c:if> <c:if test="${vo.membership eq 'silver'}">
									<p id="silver">실버</p>
								</c:if> <c:if test="${vo.membership eq 'gold'}">
									<p id="gold">골드</p>
								</c:if><c:if test="${vo.membership eq 'vip'}">
									<p id="vip">VIP</p>
								</c:if></td>
							<td id="currentclass${vo.idx}">
								<p class="class_1">관리자</p>
							</td>
							<td><select id="userclass${vo.idx}">

									<option value="0"
										<c:if test="${vo.admin eq 0}"> selected </c:if>>일반회원</option>

									<option value="1"
										<c:if test="${vo.admin eq 1}"> selected </c:if>>관리자</option>
							</select> <input type="button" value="변경" onclick="modify(${vo.idx});"
								id="id_modify"></td>

							<td><input type="button" value="강제추방"
								onclick="kick(${vo.idx});" id="id_kick"></td>
						</c:if>
					</tr>
					<tr class="rank_0">
						<c:if test="${vo.admin eq 0}">
							<td>${vo.idx}</td>
							<input type="hidden" id="c_idx" value="${vo.idx}">
							<td>${vo.id}</td>
							<td>${vo.pwd}</td>
							<td>${vo.name}</td>
							<td>${vo.addr}</td>
							<td>${vo.gender}</td>
							<td>${vo.tel}</td>
							<td>${vo.email}</td>
							<td>${vo.point}</td>
							<td><c:if test="${vo.membership eq 'bronze'}">
									<p id="bronze">브론즈</p>
								</c:if> <c:if test="${vo.membership eq 'silver'}">
									<p id="silver">실버</p>
								</c:if> <c:if test="${vo.membership eq 'gold'}">
									<p id="gold">골드</p>
								</c:if><c:if test="${vo.membership eq 'vip'}">
									<p id="vip">VIP</p>
								</c:if></td>
							<td id="currentclass${vo.idx}">
								<p class="class_0">일반회원</p>
							</td>
							<td><select id="userclass${vo.idx}">

									<option value="0"
										<c:if test="${vo.admin eq 0}"> selected </c:if>>일반회원</option>

									<option value="1"
										<c:if test="${vo.admin eq 1}"> selected </c:if>>관리자</option>
							</select> <input type="button" value="변경" onclick="modify(${vo.idx});"
								id="id_modify"></td>

							<td><input type="button" value="강제추방"
								onclick="kick(${vo.idx});" id="id_kick"></td>
						</c:if>
					</tr>
				</c:if>
			</c:forEach>


		</table>
	</form>
	<div id="deleted_member" style="display: none";>

		<h2>삭제된 회원명단</h2>
		<form name="f">
			<table align="center">
				<tr>
					<th>회원번호</th>
					<th>아이디</th>
					<th>비밀번호</th>
					<th>이름</th>
					<th>주소</th>
					<th>성별</th>
					<th>전화번호</th>
					<th>이메일</th>
					<th>적립금</th>
					<th>회원등급</th>
					<th>회원종류</th>
				</tr>


				<c:forEach var="vo" items="${list}">
					<c:if test="${vo.del_info eq '1'}">
						<tr class="rank_2">
							<c:if test="${vo.admin eq 2}">
								<td>${vo.idx}</td>
								<input type="hidden" id="c_idx" value="${vo.idx}">
								<td>${vo.id}</td>
								<td>${vo.pwd}</td>
								<td>${vo.name}</td>
								<td>${vo.addr}</td>
								<td>${vo.gender}</td>
								<td>${vo.tel}</td>
								<td>${vo.email}</td>
								<td>${vo.point}</td>
								<td><c:if test="${vo.membership eq 'bronze'}">
										<p id="bronze">브론즈</p>
									</c:if> <c:if test="${vo.membership eq 'silver'}">
										<p id="silver">실버</p>
									</c:if> <c:if test="${vo.membership eq 'gold'}">
										<p id="gold">골드</p>
									</c:if><c:if test="${vo.membership eq 'vip'}">
									<p id="vip">VIP</p>
								</c:if></td>
								<td id="currentclass${vo.idx}">
									<p class="class_2">사장</p>
								</td>
							</c:if>
						</tr>
						<tr class="rank_1">
							<c:if test="${vo.admin eq 1}">
								<td>${vo.idx}</td>
								<input type="hidden" id="c_idx" value="${vo.idx}">
								<td>${vo.id}</td>
								<td>${vo.pwd}</td>
								<td>${vo.name}</td>
								<td>${vo.addr}</td>
								<td>${vo.gender}</td>
								<td>${vo.tel}</td>
								<td>${vo.email}</td>
								<td>${vo.point}</td>
								<td><c:if test="${vo.membership eq 'bronze'}">
										<p id="bronze">브론즈</p>
									</c:if> <c:if test="${vo.membership eq 'silver'}">
										<p id="silver">실버</p>
									</c:if> <c:if test="${vo.membership eq 'gold'}">
										<p id="gold">골드</p>
									</c:if><c:if test="${vo.membership eq 'vip'}">
									<p id="vip">VIP</p>
								</c:if></td>
								<td id="currentclass${vo.idx}">
									<p class="class_1">관리자</p>
								</td>
							</c:if>
						</tr>
						<tr class="rank_0">
							<c:if test="${vo.admin eq 0}">
								<td>${vo.idx}</td>
								<input type="hidden" id="c_idx" value="${vo.idx}">
								<td>${vo.id}</td>
								<td>${vo.pwd}</td>
								<td>${vo.name}</td>
								<td>${vo.addr}</td>
								<td>${vo.gender}</td>
								<td>${vo.tel}</td>
								<td>${vo.email}</td>
								<td>${vo.point}</td>
								<td><c:if test="${vo.membership eq 'bronze'}">
										<p id="bronze">브론즈</p>
									</c:if> <c:if test="${vo.membership eq 'silver'}">
										<p id="silver">실버</p>
									</c:if> <c:if test="${vo.membership eq 'gold'}">
										<p id="gold">골드</p>
									</c:if><c:if test="${vo.membership eq 'vip'}">
									<p id="vip">VIP</p>
								</c:if></td>
								<td id="currentclass${vo.idx}">
									<p class="class_0">일반회원</p>
								</td>
							</c:if>
						</tr>
					</c:if>
				</c:forEach>
			</table>

		</form>
	</div>
	<div id="nothing"></div>
	<c:if test="${!empty list}">
		<div id="pageMenu" align="center">${pageMenu}</div>
	</c:if>
	</div>
	<jsp:include page="../index/index_bottom.jsp"/>
</body>
</html>