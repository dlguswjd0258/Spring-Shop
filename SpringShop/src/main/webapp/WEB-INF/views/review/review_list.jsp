<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style type="text/css">
#main {
	width: 1260px;
	margin: 0 auto;
}

th{
	height: 18px;
}
.sub_title {
	padding: 50px 0 10px;
	font-size: 16px;
	color: #2e2e2e;
}

table {
	width: 100%;
	border-top-color: #fff;
	color: #353535;
	text-align: center;
}

table input[type=button] {
	width: 85px;
}

table:before {
	position: absolute;
	left: 0;
	display: block;
	content: "";
	width: 100%;
	background: #d7d5d5;
}

table th {
	background-color: #fbfafa;
}

table .p_name {
	text-align: left;
}

table a {
	color: #353535;
}

.product_box {
	width: 100%;
	height: 100px;
}

.pageMenu {
	width: 100%;
	height: 50px;
	margin-top: 30px;
}

.r_name:hover {
	color: red;
}

</style>

<script type="text/javascript">
	var prev_selection = "";
	var off = 0;
	function show_reviews(p_idx) {
		if (prev_selection != p_idx) {
			var x = document.getElementsByClassName(p_idx);
			var i;
			for (i = 0; i < x.length; i++) {
				x[i].style.display = "block";
			}

			prev_selection = p_idx;
		} else if (prev_selection == p_idx) {
			var x = document.getElementsByClassName(p_idx);
			var i;
			for (i = 0; i < x.length; i++) {
				x[i].style.display = "none";
			}

			var name = parseInt(p_idx) + 0.2;
			var y = document.getElementsByClassName(name);
			var j;
			for (j = 0; j < y.length; j++) {
				y[j].style.display = "none";
			}

			prev_selection = "";
		}
	}

	var prev_selection2 = "";
	var off2 = 0;
	function show_dadats(dadat_class) {
		var content = document.getElementById((Number(dadat_class)+0.2).toFixed(1)).style;
		if (prev_selection2 != dadat_class) {
			var x = document.getElementsByClassName(dadat_class);
			var i;
			for (i = 0; i < x.length; i++) {
				x[i].style.display = "block";
			}
			content.overflow = 'auto'; 
			content.textOverflow = 'clip'; 
			content.whiteSpace = 'normal';
			content.height = '140px';

			prev_selection2 = dadat_class;
		} else if (prev_selection2 == dadat_class) {
			var x = document.getElementsByClassName(dadat_class);
			var i;
			for (i = 0; i < x.length; i++) {
				x[i].style.display = "none";
			}
			content.overflow = 'hidden'; 
			content.textOverflow = 'ellipsis'; 
			content.whiteSpace = 'nowrap';
			content.height = '20px';
			
			prev_selection2 = "";
		}

	}
	
	function to_review_page(p_idx){
		if(!confirm("후기(또는 댓글)이 달린 상품 페이지로 이동합니다.\n이동하시겠습니까?")){
			return;
		}
		location.href="product_one.do?idx="+p_idx+"&page=1"
	}
</script>
</head>
<body>
	<jsp:include page="../index/index_top.jsp" />
	<div id="main">
		<div class="title">
			<h2>후기 모아보기</h2>
		</div>

		<table style="width: 100%;">
			<tr style="border-top: 2px solid #dfdfdf; border-bottom: 1px solid #dfdfdf;">
				<th style="width: 10%;">상품번호</th>
				<th style="width: 10%;">상품이미지</th>
				<th style="width: 30%;">상품명</th>
				<th style="width: 20%;">총 판매량</th>
				<th style="width: 10%;">별점</th>
				<th style="width: 20%;">후기 수</th>
			</tr>

			<c:if test="${empty product_list}">
				<tr>
					<td colspan="6"><p align="center">등록된 상품이 없습니다</p></td>
				</tr>
			</c:if>

			<c:forEach var="product" items="${product_list}">
				<tr style="border-bottom: 1px solid #dfdfdf;">
					<td>${ product.idx }</td>
					<td><a href="product_one.do?idx=${product.idx}" class="p_name"><img
						src="${pageContext.request.contextPath}/resources/upload/${product.filename_s}"
						width="70" height="70"></a></td>
					<td>${product.p_name}</td>
					<td>${product.p_sold}</td>
					<td>${product.p_grade}</td>
					<td>${reviews_map.get(product.idx).size()}</td>

				</tr>
			</c:forEach>
		</table>
		<div class="pageMenu" align="center">${pageMenu[0]}</div>
		<br><br><br>
		<table>
			<tr>
				<td> 
					<table style="width: 100%; ">
						<tr style="border-top: 2px solid #dfdfdf; border-bottom: 1px solid #dfdfdf;">
							<th>후기 번호</th>
							<th>상품 이미지</th>
							<th>작성자</th>
							<th>제목</th>
							<th>내용</th>
							<th>첨부 이미지</th>
							<th>평점</th>
							<th>작성일</th>
							<th>조회수</th>
							<th>수정/삭제</th>
							
						</tr>
						<c:if test="${empty review_list}">
							<tr>
								<td colspan="10"><p align="center">등록된 후기가 없습니다</p></td>
							</tr>
						</c:if>
						
						<c:forEach var="review" items="${review_list}">
						<tr style="height: 70px; border-bottom: 1px solid #dfdfdf;">
							<td style="width: 8%;">${review.idx}</td>
							<td style="width: 10%;"><img
								src="${pageContext.request.contextPath}/resources/upload/${product_map.get(review.idx).filename_s}"
								width="70" height="70"></td>
							<td style="width: 10%;">${review.name}</td>
							<td style="width: 15%;"><a href="javascript:void(0)"
								onclick="show_dadats('${review.idx + 0.1}');" class="r_name"><b>${review.subject}</b></a></td>
							<td style="width: 10%;">
								<div style="width:330px; height:20px; white-space:nowrap; 
											text-overflow:ellipsis; overflow: hidden;" 
									 id="${review.idx + 0.3}">
									${review.content}
								</div>
							</td>
							<td style="width: 10%;">
								<c:choose>
									<c:when test="${ review.filename_r eq 'no_file' }">
										 이미지<br>없음
									</c:when>
									
									<c:when test="${ review.filename_r ne 'no_file' }">
										<img src="${pageContext.request.contextPath}/resources/upload/${review.filename_r}"
											width="70" height="70">
									</c:when>
								</c:choose>
							</td>
								
							<td style="width: 7%;">${review.grade}</td>
							<td style="width: 8%;">${review.regidate.split(' ')[0]}</td>
							<td style="width: 8%;">${review.readhit}</td>
							<td style="width: 7%;"><a
								style="color: white; border: none; padding: 1px 2px; background-color: black;"
								href="javascript:void(0)" onclick="to_review_page('${product_map.get(review.idx).idx}')">수정/삭제</a></td>
						</tr>
						
						<tr>
						<td colspan="10">
							<table style="width: 100%; display: none;" class="${review.idx + 0.1} ${product_map.get(review.idx).idx + 0.2}">
								<c:if test="${empty dadat_map.get(review.idx)}">
									<tr style="border-bottom: 1px solid #dfdfdf;">
										<td colspan="6" style="height: 50px; width: 1460px;">작성된 댓글이 없습니다</td>
									</tr>
								</c:if>
								<c:forEach var="dadat" items="${dadat_map.get(review.idx)}">
									<tr style="border-bottom: 1px solid #dfdfdf; height: 70px;">
										<td style="width: 50px;">ㄴ</td>
										<td style="width: 6%;">${dadat.idx}</td>
										<td style="width: 10%;">${dadat.name}</td>
										<td style="width: 55%;">${dadat.content}</td>
										<td style="width: 18%;">${dadat.regidate.split(' ')[0]}</td>
										<td style="width: 7%;"><a
											style="color: white; border: none; padding: 1px 2px; background-color: black;"
											href="javascript:void(0)" onclick="to_review_page('${product_map.get(review.idx).idx}')">수정/삭제</a></td>
									</tr>
								</c:forEach>
							</table>
						</td>
						</tr>
						</c:forEach>
					</table>
				</td>
				</tr>
		</table>
	</div>
	<c:if test="${review_empty ne 1}">
		<div class="pageMenu" align="center">${pageMenu[1]}</div>
	</c:if>
	<jsp:include page="../index/index_bottom.jsp" />
</body>
</html>