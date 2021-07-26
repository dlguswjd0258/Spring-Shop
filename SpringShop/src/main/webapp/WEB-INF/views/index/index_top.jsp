<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/basic.css">
<style type="text/css">
	body{width: 100%; display: block; padding:0; font-size:12px;}
	.top{width: 100%; position: relative; display: block;
		top: 0; left: 0; background-color: white; z-index: 9999;}
	#ani_top{display:none; position:fixed;}
	a{text-decoration: none; color: grey; margin: 0 10px;}
	.index_top{ border-bottom: 1px solid #E1E1E1; }
	.index_top_empty, .index_top_not_empty{
		text-align: right;
		padding-top: 15px; padding-bottom: 15px;
	}
	.index_top_admin{display:inline; left;
					padding-top: 15px; padding-bottom: 15px;}
	.index_top_empty a:hover, .index_top_not_empty a:hover, .index_top_admin a:hover{color: red;}
	
	.index_top_empty{display: block;}
	.index_top_not_empty, .index_top_admin{display: none;}
	.index_top .index_rl, .index_m, .ani_index_tm{ width: 1300px; margin: 0 auto;}
	
	.index_mid{text-align: center; padding-top: 10px; padding-bottom: 10px;}
	.ani_index_mid{text-align: center; padding-top: 20px; padding-bottom: 20px;}
	.index_mid a img, #ani_top img{width:180px; height: auto;}
	
	.ani_index_top{margin:0 auto; position: relative; float:right; top:25px;}
	ul, li{margin: 0 auto; padding: 0; list-style: none;}

	.index_bottom{text-align: center;}
	.index_bottom form ul{ margin: 0 auto; width:1300px;}
	.index_bottom form > ul > li{display: inline-block;}
	.index_bottom form > ul > li > a{color: black;}
	
	.index_bottom{border-top: 1px solid black; border-bottom: 1px solid #E1E1E1; padding-top: 15px; padding-bottom: 15px;}
	.index_bottom form > ul > li > ul{display: none; position: absolute; top: 100%; background-color: white; width: 150px;
									padding-top: 10px;}
	.index_bottom form > ul > li{position: relative; white-space: nowrap; width: 150px;}
	.index_bottom form > ul > li > ul > li, a{padding-bottom: 10px; padding-top: 10px;}
	.index_bottom form > ul > li:hover > ul{display: block;}
	.index_bottom form > ul > li > ul > li:hover{background-color: black;}	
	.index_bottom form > ul > li > ul > li:hover > a{color: white;}	
	
	input[type=text]{
	padding: 0 10px;
	height: 28px;
	line-height: 48px;
	vertical-align: middle;
    border: 1px solid #ddd;
	color: #353535;
	}

	input[type=text]:hover{
	border: 1px solid #aaa;
	}

	input[type=text]:focus{
	outline: none !important;
	border: 1px solid #aaa;
	}
	
	input[type=image] {
		width: 40px;
		height: 40px;
		vertical-align: middle;
		color: #353535;
	}
	
</style>


<c:if test="${ !empty sessionScope.user }">
	<style type="text/css">
		.index_top_empty, .ani_top_empty{display: none;}
		.index_top_not_empty, .ani_top_not_empty{display: block;}
	</style>
	<c:if test="${ sessionScope.user.admin ne 0 }">
		<style type="text/css">
			.index_top_admin{ display: block; }
			.index_top_not_empty{ display:inline; float:right; }
		</style>
	</c:if>
</c:if>

<c:if test="${ empty sessionScope.user }">
	<style type="text/css">
		.index_top_empty, .ani_top_empty{display: block; float: none;}
		.index_top_not_empty, .ani_top_not_empty{display: none;}
	</style>
</c:if>

<script type="text/javascript">
	window.onscroll = function() {
		var ani_top = document.getElementById("ani_top");
		if(window.scrollY > 180){
			ani_top.style.display = "block";
		}else{
			ani_top.style.display = "none";
		}
	}
	function login_first(){
		alert('로그인 후 이용가능합니다.');
		location.href="login_form.do";
	}
	
	function check_logout(){
		if(!confirm("정말로 로그아웃하시겠습니까?")){
			return;
		}
		
		location.href="logout.do";
	}
	
	function search(f){
		var search = f.search1.value.trim();
		if (search == '') {
			alert("검색어를 한자리 이상 입력해주세요.");
			return
		}
		f.action = "search_one.do";
		f.method = "post";
		f.submit();
	}


</script>

</head>
<body>
	<div class="top" id="top">
		<div class="index_top">
			<div class="index_rl">
				<div class="right">
				
					<div class="index_top_empty">
						<a href="login_form.do?idx=${vo.idx}">LOGIN</a> |
						<a href="user_insert_form.do">JOIN</a> |
						<a style="cursor: pointer" onclick="login_first();">MY PAGE</a> |
						<a style="cursor: pointer" onclick="login_first();">CART</a>
					</div>
					<div class="index_top_not_empty">
						<a href="#">${ sessionScope.user.id }님 환영합니다!</a> |
						<a href="#" onclick="check_logout();">LOGOUT</a> |
						<a href="mypage_form.do">MY PAGE</a> |
						<a href="cart_list.do?u_idx=${ sessionScope.user.idx }">CART</a>
					</div>
				</div>
				<div class="left">
					<div class="index_top_admin">
						<a href="product_list_form.do">사이트 관리</a> |
						<a href="usermanagement.do">회원 관리</a>
					</div>
				</div>
			</div>
		</div>
		<div class="index_mid">
			<div class="index_m">
				<a href="main.do"><img src="resources/image/logo.png"></a>
			</div>
		</div>
		<div class="index_bottom">
		<form>
			<ul>
				<li><a href="view_list.do?view_name=best">BEST</a></li>
				<li><a href="view_list.do?view_name=top">TOP</a>
					<ul>
						<li><a href="category_list.do?category=맨투맨,후드티">맨투맨&후드티</a></li>
						<li><a href="category_list.do?category=니트">니트</a></li>
						<li><a href="category_list.do?category=긴팔티">긴팔티</a></li>
						<li><a href="category_list.do?category=반팔티">반팔티</a></li>
						<li><a href="category_list.do?category=나시">나시</a></li>
						<li><a href="category_list.do?category=프린팅티">프린팅티</a></li>
					</ul>
				</li>
				<li><a href="view_list.do?view_name=pants">PANTS</a>
					<ul>
						<li><a href="category_list.do?category=슬랙스">슬랙스</a></li>
						<li><a href="category_list.do?category=면바지">면바지</a></li>
						<li><a href="category_list.do?category=청바지">청바지</a></li>
						<li><a href="category_list.do?category=밴딩팬츠">밴딩팬츠</a></li>
						<li><a href="category_list.do?category=반바지">반바지</a></li>
					</ul>
				</li>
				<li><a href="view_list.do?view_name=shirts">SHIRTS</a>
					<ul>
						<li><a href="category_list.do?category=베이직">베이직</a></li>
						<li><a href="category_list.do?category=청남방">청남방</a></li>
						<li><a href="category_list.do?category=체크,패턴">체크&패턴</a></li>
						<li><a href="category_list.do?category=스트라이프">스트라이프</a></li>
						<li><a href="category_list.do?category=핸리넥,차이나">핸리넥&차이나</a></li>
					</ul>
				</li>
				<li><a href="view_list.do?view_name=outer">OUTER</a>
					<ul>
						<li><a href="category_list.do?category=패딩">패딩</a></li>
						<li><a href="category_list.do?category=코트">코트</a></li>
						<li><a href="category_list.do?category=수트,블레이져">수트&블레이져</a></li>
						<li><a href="category_list.do?category=블루종/MA-1">블루종/MA-1</a></li>
						<li><a href="category_list.do?category=가디건,조끼">가디건&조끼</a></li>
						<li><a href="category_list.do?category=후드,집업">후드&집업</a></li>
					</ul>
				</li>
				<li><a href="review_list.do" style="color: RED;">REVIEWS</a></li>
				<li>
					<input type="text" name="search1" placeholder="검색할 내용을 입력">
				</li>
				<li>
					<input type="image" src="http://cdn2-aka.makeshop.co.kr/design/jogunshop/MakeshopRenewal/img/top_search_icon.png"
						onclick="search(this.form);">
				</li>
			</ul>
			</form>
		</div>
	</div>
	
	<div class="top" id="ani_top">
		<div class="ani_index_tm">		
			<div class="ani_index_top">
					<div class="ani_top_empty">
						<a href="login_form.do?idx=${vo.idx}">LOGIN</a> |
						<a href="user_insert_form.do">JOIN</a> |
						<a style="cursor: pointer" onclick="login_first();">MY PAGE</a> |
						<a style="cursor: pointer" onclick="login_first();">CART</a>
					</div>
					<div class="ani_top_not_empty">
						<a href="#" onclick="check_logout();">LOGOUT</a> |
						<a href="mypage_form.do">MY PAGE</a> |
						<a href="cart_list.do?u_idx=${ sessionScope.user.idx }">CART</a>
					</div>
			</div>
			
			<div class="ani_index_mid">
				<a href="main.do"><img src="resources/image/ani_logo.png"></a>
			</div>
		</div>
		<div class="index_bottom">
		<form>
			<ul>
				<li><a href="view_list.do?view_name=best">BEST</a></li>
				<li><a href="view_list.do?view_name=top">TOP</a>
					<ul>
						<li><a href="category_list.do?category=맨투맨,후드티">맨투맨&후드티</a></li>
						<li><a href="category_list.do?category=니트">니트</a></li>
						<li><a href="category_list.do?category=긴팔티">긴팔티</a></li>
						<li><a href="category_list.do?category=반팔티">반팔티</a></li>
						<li><a href="category_list.do?category=나시">나시</a></li>
						<li><a href="category_list.do?category=프린팅티">프린팅티</a></li>
					</ul>
				</li>
				<li><a href="view_list.do?view_name=pants">PANTS</a>
					<ul>
						<li><a href="category_list.do?category=슬랙스">슬랙스</a></li>
						<li><a href="category_list.do?category=면바지">면바지</a></li>
						<li><a href="category_list.do?category=청바지">청바지</a></li>
						<li><a href="category_list.do?category=밴딩팬츠">밴딩팬츠</a></li>
						<li><a href="category_list.do?category=반바지">반바지</a></li>
					</ul>
				</li>
				<li><a href="view_list.do?view_name=shirts">SHIRTS</a>
					<ul>
						<li><a href="category_list.do?category=베이직">베이직</a></li>
						<li><a href="category_list.do?category=청남방">청남방</a></li>
						<li><a href="category_list.do?category=체크,패턴">체크&패턴</a></li>
						<li><a href="category_list.do?category=스트라이프">스트라이프</a></li>
						<li><a href="category_list.do?category=핸리넥,차이나">핸리넥&차이나</a></li>
					</ul>
				</li>
				<li><a href="view_list.do?view_name=outer">OUTER</a>
					<ul>
						<li><a href="category_list.do?category=패딩">패딩</a></li>
						<li><a href="category_list.do?category=코트">코트</a></li>
						<li><a href="category_list.do?category=수트,블레이져">수트&블레이져</a></li>
						<li><a href="category_list.do?category=블루종/MA-1">블루종/MA-1</a></li>
						<li><a href="category_list.do?category=가디건,조끼">가디건&조끼</a></li>
						<li><a href="category_list.do?category=후드,집업">후드&집업</a></li>
					</ul>
				</li>
				<li><a href="review_list.do" style="color: RED;">REVIEWS</a></li>
				<li>
					<input type="text" name="search2" placeholder="검색할 내용을 입력">
				</li>
				<li>
					<input type="image" src="http://cdn2-aka.makeshop.co.kr/design/jogunshop/MakeshopRenewal/img/top_search_icon.png"
						onclick="search(this.form);">
				</li>
			</ul>
		</form>
		</div>
	</div>
</body>
</html>