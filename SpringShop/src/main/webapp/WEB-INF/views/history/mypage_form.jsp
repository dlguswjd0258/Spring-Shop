<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/myhistory.css">
	
	<style type="text/css">
		.sub_title{
			position: relative;
			margin-top: 80px;
		}
		
		.sub_title a{
			position: absolute;
		    top: -5px;
		    right: 0;
		    color: #8c8b8b;
		}
		
		table:before{
			position: absolute;
			top: 0;
		    left: 0;
		    display: block;
		    content: "";
		    width: 100%;
		    height: 1px;
		    background: #d7d5d5;	
		}
		
	</style>
</head>
<body>
	<jsp:include page="../index/index_top.jsp"/>
	<jsp:include page="mypage_head.jsp"/>
	<div id="main">
		<div class="info">
			<div class="user">
				<div class="user_img">
					<img alt="프로필사진" src="${pageContext.request.contextPath}/resources/image/user_img.png">
				</div>
				
				<div class="user_info">
		            <p>${ sessionScope.user.name }[${ sessionScope.user.id }]님 </p>
		            <div class="box">
		                <dl>
		                    <dt>전 &nbsp;&nbsp;&nbsp; 화</dt>
		                    <dd>${ sessionScope.user.tel }</dd>
		                </dl>
		                <dl>
		                    <dt>이 메 일</dt>
		                    <dd>${ sessionScope.user.email }</dd>
		                </dl>
		                <dl>
		                    <dt>주 &nbsp;&nbsp;&nbsp; 소</dt>
		                    <dd>${ sessionScope.user.addr.split(",")[1] }&nbsp;</dd>
		                </dl>
		            </div>
	            </div>
            </div>
		
			<dl class="order">
	            <dt class="total">총 주문금액 :</dt>
	            <dd class="total">
	            	<strong><fmt:formatNumber>${ sessionScope.user.total_pay }</fmt:formatNumber></strong>원
	            </dd>
	            
                <dt>가 용 예 치 금</dt>
	            <dd>
	            	<a href="mycash_form.do?u_idx=${ sessionScope.user.idx }">
	            		<strong><fmt:formatNumber>${ sessionScope.user.cash }</fmt:formatNumber></strong>원
	            	</a>
	            </dd>

	            <dt>가 용 적 립 금</dt>
	            <dd>
	            	<a href="mypoint_form.do?u_idx=${ sessionScope.user.idx }">
	            		<strong><fmt:formatNumber>${ sessionScope.user.point }</fmt:formatNumber></strong>원
	            	</a>
	            </dd>
                
	        </dl>
		</div>
		
		<div class="sub_title">
            <h3>최근 주문 정보</h3>
            <a href="myhistory_form.do">+ MORE</a>
        </div>
        
        <div class="o_table">
		    <table>
		        <colgroup>
					<col style="width:135px;">
					<col style="width:93px;">
					<col style="width:auto;">
					<col style="width:61px;">
					<col style="width:111px;">
					<col style="width:111px;">
				</colgroup>
				<thead>
					<tr>
						<th>주문일자</th>
						<th>이미지</th>
						<th>상품정보</th>
						<th>수량</th>
						<th>상품구매금액</th>
						<th>주문처리상태</th>
					</tr>
				</thead>
				
		        <tbody class="center">
	                   <c:if test="${ empty h_list }">
	                        <tr>
				                <td colspan="6" align="center">주문 내역이 없습니다.</td>
				            </tr>
		               	</c:if>
		               	
	               		<c:forEach var="h_vo" items="${ h_list }">
	               			<tr>
		               			<td>
									${ h_vo.buydate.split(" ")[0] }
								</td>
								<td><img alt="주문한 상품 이미지" src="${pageContext.request.contextPath}/resources/upload/${h_vo.filename_s}"></td>
								<td class="p_info">
									<a href="product_one.do?idx=${ h_vo.p_idx }"><strong>${ h_vo.p_name }</strong><br></a>
									<div class="option">[사이즈: ${ h_vo.p_size }, 색상: <div class="color_box" style="background-color: ${h_vo.p_color}"></div>]</div>
								</td>
								<td>${ h_vo.p_cnt }</td>
								<td><strong><fmt:formatNumber value="${ h_vo.amount }"/>원</strong></td>
								<td>
									<c:choose>
										<c:when test="${ h_vo.delivery eq 0 }">
											주문 접수
										</c:when>
										<c:when test="${ h_vo.delivery eq 1 }">
											배송중
										</c:when>
										<c:when test="${ h_vo.delivery eq 2 }">
											배송 완료
										</c:when>
									</c:choose>
								</td>
							</tr>
	               		</c:forEach>
                   </tbody>
		    </table>
		</div>
	</div>
	<jsp:include page="../index/index_bottom.jsp"/>
</body>
</html>