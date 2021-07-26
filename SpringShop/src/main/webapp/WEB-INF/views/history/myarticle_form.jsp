<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/myhistory.css">
<style type="text/css">
	#main #main_table{
		margin-bottom: 10px;
		text-align: center;
	}
	#main #pageMenu{
		margin-bottom: 50px;
	}
	
	
</style>
<script type="text/javascript">
	var prev_selection2 = "";
	function show_dadats(dadat_class) {
		var x = document.getElementsByClassName(dadat_class);
		var content = document.getElementById((Number(dadat_class)+0.2).toFixed(1)).style;
		var i;
		if (prev_selection2 != dadat_class) {
			for (i = 0; i < x.length; i++) {
				x[i].style.display = "";
			}
			content.overflow = 'auto'; 
			content.textOverflow = 'clip'; 
			content.whiteSpace = 'normal';
			content.height = 'auto';
			
			prev_selection2 = dadat_class;
		} else if (prev_selection2 == dadat_class) {
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
</script>
</head>
<body>
	<jsp:include page="../index/index_top.jsp" />
	<jsp:include page="mypage_head.jsp" />
	<div id="main">
		<div class="sub_title">
			<h3>내가 작성한 리뷰</h3>
		</div>
			<table id="main_table">
				<colgroup>
					<col style="width:8%;">
					<col style="width:10%;">
					<col style="width:10%;">
					<col style="width:15%;">
					<col style="width:350px;">
					<col style="width:10%;">
					<col style="width:7%;">
					<col style="width:8%;">
					<col style="width:8%;">
					<col style="width:7%;">
				</colgroup>
			
				<tr style="background-color: #fbfafa; border-top: 2px solid #dfdfdf; border-bottom: 1px solid #dfdfdf;">
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
				
				<c:choose>
					<c:when test="${ empty r_list }">
					 <tr>
					 	<td colspan="10" align="center">작성한 후기가 없습니다.</td>
					 </tr>
					</c:when>
					
					<c:when test="${ !empty r_list }">
						<c:forEach var="i" begin="0" end="${ r_list.size()-1 }" >
							<tr style="height: 70px; border-bottom: 1px solid #dfdfdf;">
								<td>${r_list[i].idx}</td>
								<td><a href="product_one.do?idx=${ p_list[i].idx }"><img
									src="${pageContext.request.contextPath}/resources/upload/${p_list[i].filename_s}"
									width="70" height="70"></a></td>
								<td>${r_list[i].name}</td>
								<td><a href="javascript:void(0)"
									onclick="show_dadats('${r_list[i].idx + 0.1}');" class="r_name"><b>${r_list[i].subject}</b></a></td>
								<td>
									<div style="width:330px; height:20px; white-space:nowrap; 
											text-overflow:ellipsis; overflow: hidden;" 
									 	 id="${r_list[i].idx + 0.3}">
										${r_list[i].content}</div>
									</td>
								<td>
									<c:choose>
										<c:when test="${ r_list[i].filename_r eq 'no_file' }">
											 이미지<br>없음
										</c:when>
										
										<c:when test="${ r_list[i].filename_r ne 'no_file' }">
											<img src="${pageContext.request.contextPath}/resources/upload/${r_list[i].filename_r}"
												width="70" height="70">
										</c:when>
									</c:choose>
								</td>
								<td>${r_list[i].grade}</td>
								<td>${r_list[i].regidate.split(' ')[0]}</td>
								<td>${r_list[i].readhit}</td>
								<td><a
									style="color: white; border: none; padding: 1px 2px; background-color: black;"
									href="product_one.do?idx=${p_list[i].idx}&page=1">수정/삭제</a></td>
							</tr>
							
							<c:choose>
								<c:when test="${empty dat_list[i]}">
									<tr style="display:none; text-align:center; border-bottom: 1px solid #dfdfdf;"  class="${r_list[i].ref + 0.1} ${p_list[i].idx + 0.2}">
										<td colspan="10" style="height: 70px; width: 1460px;">작성된 댓글이 없습니다</td>
									</tr>
								</c:when>
								
								<c:when test="${ !empty dat_list[i] }">
									<c:forEach var="dat" items="${ dat_list[i] }">
										<tr style="display:none; border-bottom: 1px solid #dfdfdf; height: 70px;" class="${r_list[i].ref + 0.1} ${p_list[i].idx + 0.2}">
											<td>ㄴ</td>
											<td>${dat.idx}</td>
											<td>${dat.name}</td>
											<td></td>
											<td>${dat.content}</td>
											<td></td>
											<td></td>
											<td>${dat.regidate.split(' ')[0]}</td>
											<td></td>
											<td>
												<a style="color: white; border: none; padding: 1px 2px; background-color: black;"
												href="product_one.do?idx=${p_list[i].idx}&page=1">수정/삭제</a></td>
										</tr>
									</c:forEach>
								</c:when>
							</c:choose>
						</c:forEach>
					</c:when>
				</c:choose>
				
				
			</table>
			<c:if test="${!empty r_list}">
			<div id="pageMenu" align="center">${pageMenu}</div>
			</c:if>
		</div>
	<jsp:include page="../index/index_bottom.jsp" />
</body>
</html>