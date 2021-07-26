<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/basic.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/myhistory.css">
	
	<style type="text/css">
		tfoot td{
			text-align: right;
		    padding: 15px 10px 17px;
		    background: #fbfafa;
		}
		
		.orderArea tbody th{
			padding: 11px 0 10px 18px;
			border: 1px solid #dfdfdf;
			border-bottom-width: 0;
			color: #353535;
			font-weight: normal;
			background-color: #fbfafa;
		}
		
		.sum{
			font-weight:bold;
			background-color: #fbfafa;
		}
		
		#total_table td{
			font-size: 18px;
		}
		
		.amount{
		    font-size: 18px;
		    letter-spacing: -1px;
		}
		
		.history_button{
			width: 100%;
			height: 60px;
		}
		
		input[type=button]{
			margin: 10px 0 0;
		  	display: block;
			width: 15%;
			border: 1px solid #555;
			background: #353535;
			color: #fff;
			padding: 10px 14px;
			cursor: pointer;
			float: right;
		}
		
	</style>

	<script type="text/javascript" src="${ pageContext.request.contextPath }/resources/js/httpRequest.js"></script>
	<script type="text/javascript">
		window.onload = function() {
			if( <c:out value="${ empty sessionScope.user}"/>){
				alert("로그인 먼저 하세요.");
				location.href="login_form.do";
			}
		}
	</script>
</head>
<body>
	<jsp:include page="../index/index_top.jsp" />

	<div id="main">
		<div class="title">
			<h2>주문 상세 조회</h2>
		</div>

		<div class="orderArea">
			<div class="sub_title">
				<h3>주문정보</h3>
			</div>
			<table border="1">
				<colgroup>
					<col style="width: 160px">
					<col style="width: auto">
				</colgroup>

				<tbody>
					<tr>
						<th scope="row">주문번호</th>
						<td>${ o_vo.o_idx }</td>
					</tr>

					<tr>
						<th scope="row">주문일자</th>
						<td>${ o_vo.buydate }</td>
					</tr>
					<tr>

						<th scope="row">주문자</th>
						<td><span>${ o_vo.o_name }</span></td>
					</tr>

					<tr>
						<th scope="row">주문처리상태</th>
						<td>
							<c:choose>
								<c:when test="${ o_vo.delivery eq 0 }">
									주문 접수
								</c:when>
								<c:when test="${ o_vo.delivery eq 1 }">
									배송중
								</c:when>
								<c:when test="${ o_vo.delivery eq 2 }">
									배송 완료
								</c:when>
							</c:choose>
						</td>
					</tr>
				</tbody>
			</table>
		</div>

		<div class="orderArea" id="">
			<div class="sub_title">
				<h3>결제정보</h3>
			</div>
			<table border="1">
	            <colgroup>
						<col style="width:160px">
						<col style="width:auto">
				</colgroup>
				
				<tbody>
					<tr class="sum">
						<th scope="row">총 주문금액</th>
	                    <td><fmt:formatNumber value="${ p_total + o_vo.o_fee }"/>원</td>
	                </tr>
                </tbody>
				<tbody class="sum">
					<tr class="sum">
						<th scope="row">총 할인금액</th>
						<td><fmt:formatNumber value="${ s_price }"/>원</td>
	                </tr>
					</tbody>
	
					<tbody class="displaynone">
					<tr class="displaynone">
						<th scope="row">적립금</th>
	                    <td><fmt:formatNumber value="${ p_vo.amount }"/>원</td>
	                </tr>
				</tbody>
			</table>
			
			<div id="total">
				<table border="1" id="total_table">
					<colgroup>
						<col style="width:160px">
						<col style="width:auto">
					</colgroup>
					
					<tbody>
						<tr class="sum">
							<th scope="row">총 결제금액</th>
		                    <td><strong><fmt:formatNumber value="${ o_vo.o_total }"/>원</strong></td>
		                </tr>
					</tbody>
				</table>
			</div>
		</div>

		<div class="orderArea">
			<div class="sub_title">
				<h3>주문 상품 정보</h3>
			</div>
			<table border="1">
				<colgroup>
					<col style="width: 92px">
					<col style="width: auto">
					<col style="width: 60px">
					<col style="width: 100px">
					<col style="width: 95px">
					<col style="width: 110px">
					<col style="width: 110px">
				</colgroup>
				
				<thead>
					<tr>
						<th scope="col">이미지</th>
						<th scope="col">상품정보</th>
						<th scope="col">수량</th>
						<th scope="col">판매가</th>
						<th scope="col">할인가</th>
						<th scope="col">주문처리상태</th>
					</tr>
				</thead>
				
				<tfoot>
					<tr>
						<td colspan="6">
							 상품구매금액 <strong><fmt:formatNumber value="${ p_total }"/></strong> 
							 + 배송비 <fmt:formatNumber value="${ o_vo.o_fee }"/> 
							 - 상품할인금액 <fmt:formatNumber value="${ s_price }"/> 
							 = 합계 : <strong class="amount" id="test"><fmt:formatNumber value="${ p_total + o_vo.o_fee - s_price }"/>원</strong>
						</td>
					</tr>
				</tfoot>
				<tbody class="center">
					<c:forEach var="h_vo" items="${ h_list }">
						<tr>
							<td>
								<img alt="주문한 상품 이미지" src="${pageContext.request.contextPath}/resources/upload/${h_vo.filename_s}">
							</td>
							<td class="p_info">
								<a href="product_one.do?idx=${ h_vo.p_idx }"><strong>${ h_vo.p_name }</strong><br></a>
								<div class="option">[사이즈: ${ h_vo.p_size }, 색상: <div class="color_box" style="background-color: ${h_vo.p_color}"></div>]</div>
							</td>
							<td>${ h_vo.p_cnt }</td>
							<td><fmt:formatNumber value="${ h_vo.p_price * h_vo.p_cnt }"></fmt:formatNumber>원</td>
							
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

		<div class="orderArea">
			<div class="sub_title">
				<h3>배송지정보</h3>
			</div>
			<table border="1">
				<colgroup>
					<col style="width: 160px">
					<col style="width: auto">
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">받으시는분</th>
						<td><span>${ o_vo.o_name }</span></td>
					</tr>

					<tr>
						<th scope="row">우편번호</th>
						<td><span>${ o_vo.o_addr.split(",")[0] }</span></td>
					</tr>
					<tr>
						<th scope="row">주소</th>
						<td><span>${ o_vo.o_addr.split(",")[1] } ${ o_vo.o_addr.split(",")[2] }</span></td>
					</tr>
					<tr>
						<th scope="row">휴대전화</th>
						<td><span>${o_vo.o_tel }</span></td>
					</tr>

					<tr>
						<th scope="row">배송메시지</th>
						<td><span>${ o_vo.o_content }</span></td>
					</tr>
				</tbody>
			</table>
		</div>
	
		<div class="history_button">
			<input type="button" class="history_list"  value="주문목록 보기"
					onclick="location.href='myhistory_form.do'">
		</div>
		
		<div class="help">
			<div>
				<h3>이용안내</h3>
			</div>
			<div class="inner">
				<h4>신용카드매출전표 발행 안내</h4>
				<p>신용카드 결제는 사용하는 PG사 명의로 발행됩니다.</p>

				<h4>세금계산서 발행 안내</h4>
				<ol>
					<li class="item1">1. 부가가치세법 제 54조에 의거하여 세금계산서는 배송완료일로부터 다음달
						10일까지만 요청하실 수 있습니다.</li>
					<li class="item2">2. 세금계산서는 사업자만 신청하실 수 있습니다.</li>
					<li class="item3">3. 배송이 완료된 주문에 한하여 세금계산서 발행신청이 가능합니다.</li>
					<li class="item4">4. [세금계산서 신청]버튼을 눌러 세금계산서 신청양식을 작성한 후 팩스로
						사업자등록증사본을 보내셔야 세금계산서 발생이 가능합니다.</li>
					<li class="item5">5. [세금계산서 인쇄]버튼을 누르면 발행된 세금계산서를 인쇄하실 수 있습니다.</li>
					<li class="item6">6. 세금계산서는 실결제금액에 대해서만 발행됩니다.(적립금과 할인금액은 세금계산서
						금액에서 제외됨)</li>
				</ol>

				<h4>부가가치세법 변경에 따른 신용카드매출전표 및 세금계산서 변경 안내</h4>
				<ol>
					<li class="item1">1. 변경된 부가가치세법에 의거, 2004.7.1 이후 신용카드로 결제하신 주문에
						대해서는 세금계산서 발행이 불가하며<br>신용카드매출전표로 부가가치세 신고를 하셔야 합니다.(부가가치세법
						시행령 57조)
					</li>
					<li class="item2">2. 상기 부가가치세법 변경내용에 따라 신용카드 이외의 결제건에 대해서만 세금계산서
						발행이 가능함을 양지하여 주시기 바랍니다.</li>
				</ol>

				<h4>현금영수증 이용안내</h4>
				<ol>
					<li class="item1">1. 현금영수증은 1원 이상의 현금성거래(무통장입금, 실시간계좌이체, 에스크로,
						예치금)에 대해 발행이 됩니다.</li>
					<li class="item2">2. 현금영수증 발행 금액에는 배송비는 포함되고, 적립금사용액은 포함되지 않습니다.</li>
					<li class="item3">3. 발행신청 기간제한 현금영수증은 입금확인일로 부터 48시간안에 발행을 해야
						합니다.</li>
					<li class="item4">4. 현금영수증 발행 취소의 경우는 시간 제한이 없습니다. (국세청의 정책에 따라
						변경 될 수 있습니다.)</li>
					<li class="item5">5. 현금영수증이나 세금계산서 중 하나만 발행 가능 합니다.</li>
				</ol>
			</div>
		</div>

	</div>

	<jsp:include page="../index/index_bottom.jsp" />
</body>
</html>