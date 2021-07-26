<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>  
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/mypage_head.css">

<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/httpRequest.js"></script>

<script type="text/javascript">
	window.onload = function() {
		if( <c:out value="${ empty sessionScope.user}"/>){
			alert("로그인 먼저 하세요.");
			location.href="login_form.do";
		}
	}
	
	function user_delete( idx ) {
		if(!confirm("정말로 탈퇴하시겠습니까?")){
			return;
		}
		
		if(<c:out value="${sessionScope.user.admin eq 2}"/>){
			alert("사장님은 탈퇴하실 수 없습니다.");
			return;
		}
		var url = "user_delete.do";
		var param = "idx=" + idx;
		sendRequest( url, param, resultFnDel, "GET");
		
	}
	
	function resultFnDel() {
		if(xhr.readyState == 4 && xhr.status == 200){
			var data = xhr.responseText;
			
			if(data == 'no'){
				alert("삭제에 실패했습니다. 다시 시도해 주세요.");
				return;
			}
			
			alert("삭제 완료하였습니다.");
			location.href="logout.do";
		}
		
	}
</script>

</head>
<body>
	<div id="mypage_head">
		<div class="title">
			<h2>마이 페이지</h2>
		</div>
		
		<div class="lnb-wrap">
	        <div class="lnb-bx">
	            <h2 class="txt txt1">SHOPPING INFO</h2>
	            <div class="lnb">
	                <ul>
                         <li class="first"><a href="myhistory_form.do">주문내역</a></li>
                         <li><a href="mypoint_form.do?u_idx=${ sessionScope.user.idx }">적립금내역</a></li>
                         <li><a href="mycash_form.do?u_idx=${ sessionScope.user.idx }">예치금내역</a></li>
                         <li><a href="#">오늘본상품</a></li>
                     </ul>
	            </div>
	        </div>
	        
	        <div class="lnb-bx">
	            <h2 class="txt txt2">SHOPPING QUESTION</h2>
	            <div class="lnb">
	                <ul>
		                <li class="first"><a href="myarticle_form.do?u_idx=${ sessionScope.user.idx }">내 게시글 보기</a></li>
                        <li><a href="#">E-mail 문의</a></li>
                    </ul>
	            </div>
	        </div>
	       
	        <div class="lnb-bx">
	            <h2 class="txt txt3">CUSTOMER INFO</h2>
	            <div class="lnb">
	                <ul>
                        <li class="first"><a href="myinfo_update_form.do?u_id=${ sessionScope.user.id }">회원정보변경</a></li>
                        <li><a href="#" onclick="user_delete(${sessionScope.user.idx});">회원정보탈퇴신청</a></li>
                    </ul>
	            </div>
	        </div>
	    </div>
	</div>
</body>
</html>