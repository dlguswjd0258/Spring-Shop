package util;

import java.util.ArrayList;
import java.util.List;

/*
        nowPage:현재페이지
        rowTotal:전체데이터갯수
        blockList:한페이지당 게시물수
        blockPage:한화면에 나타낼 페이지 메뉴 수
 */
public class HistoryPaging {
	public static List<String> FloatgetPaging(String pageURL, int save_nowPage, int save_rowTotal, int use_nowPage,
			int use_rowTotal, int blockList, int blockPage) {
		List<String> pageString = new ArrayList<String>();

		int totalPage/* 전체페이지수 */, 
			startPage/* 시작페이지번호 */, 
			endPage;/* 마지막페이지번호 */

		boolean isPrevPage, isNextPage;
		StringBuffer sb; // 모든 상황을 판단하여 HTML코드를 저장할 곳

		// ----------------save 처리---------------------
		isPrevPage = isNextPage = false;
		// 입력된 전체 자원을 통해 전체 페이지 수를 구한다..
		totalPage = (int) (save_rowTotal / blockList);
		if (save_rowTotal % blockList != 0)
			totalPage++;

		// 만약 잘못된 연산과 움직임으로 인하여 현재 페이지 수가 전체 페이지 수를
		// 넘을 경우 강제로 현재페이지 값을 전체 페이지 값으로 변경
		if (save_nowPage > totalPage)
			save_nowPage = totalPage;

		// 시작 페이지와 마지막 페이지를 구함.
		startPage = (int) (((save_nowPage - 1) / blockPage) * blockPage + 1);
		endPage = startPage + blockPage - 1; //

		// 마지막 페이지 수가 전체페이지수보다 크면 마지막페이지 값을 변경
		if (endPage > totalPage)
			endPage = totalPage;

		// 마지막페이지가 전체페이지보다 작을 경우 다음 페이징이 적용할 수 있도록
		// boolean형 변수의 값을 설정
		if (endPage < totalPage)
			isNextPage = true;
		// 시작페이지의 값이 1보다 작으면 이전페이징 적용할 수 있도록 값설정
		if (startPage > 1)
			isPrevPage = true;

		// HTML코드를 저장할 StringBuffer생성=>코드생성
		sb = new StringBuffer();
		//-----그룹페이지처리 이전 --------------------------------------------------------------------------------------------		
		if (isPrevPage) {
			sb.append("<a href ='" + pageURL + "?save_page=");
			sb.append(startPage - 1);
			sb.append("&use_page=" + use_nowPage);
			sb.append("'>prev</a>");
		} else
			sb.append("prev&nbsp;&nbsp;&nbsp;");

		//------페이지 목록 출력 -------------------------------------------------------------------------------------------------
		// sb.append("|");
		for (int i = startPage; i <= endPage; i++) {
			if (i > totalPage)
				break;
			if (i == save_nowPage) { // 현재 있는 페이지
				sb.append("&nbsp;&nbsp;&nbsp;<b><font color='#f00'>");
				sb.append(i);
				sb.append("</font></b>&nbsp;&nbsp;");
			} else {// 현재 페이지가 아니면
				sb.append("&nbsp;<a href='" + pageURL + "?save_page=");
				sb.append(i);
				sb.append("&use_page=" + use_nowPage);
				sb.append("'>");
				sb.append(i);
				sb.append("</a>");
			}
		} // end for

		sb.append("&nbsp;");

		//-----그룹페이지처리 다음 ----------------------------------------------------------------------------------------------
		if (isNextPage) {
			sb.append("<a href='" + pageURL + "?save_page=");
			sb.append(endPage + 1);
			sb.append("&use_page=" + use_nowPage);
			sb.append("'>next</a>");
		} else
			sb.append("&nbsp;&nbsp;&nbsp;next");
		//---------------------------------------------------------------------------------------------------------------------	    
		pageString.add(sb.toString());

		
		// ----------------use 처리---------------------
		isPrevPage = isNextPage = false;
		// 입력된 전체 자원을 통해 전체 페이지 수를 구한다..
		totalPage = (int) (use_rowTotal / blockList);
		if (use_rowTotal % blockList != 0)
			totalPage++;

		// 만약 잘못된 연산과 움직임으로 인하여 현재 페이지 수가 전체 페이지 수를
		// 넘을 경우 강제로 현재페이지 값을 전체 페이지 값으로 변경
		if (use_nowPage > totalPage)
			use_nowPage = totalPage;

		// 시작 페이지와 마지막 페이지를 구함.
		startPage = (int) (((use_nowPage - 1) / blockPage) * blockPage + 1);
		endPage = startPage + blockPage - 1; //

		// 마지막 페이지 수가 전체페이지수보다 크면 마지막페이지 값을 변경
		if (endPage > totalPage)
			endPage = totalPage;

		// 마지막페이지가 전체페이지보다 작을 경우 다음 페이징이 적용할 수 있도록
		// boolean형 변수의 값을 설정
		if (endPage < totalPage)
			isNextPage = true;
		// 시작페이지의 값이 1보다 작으면 이전페이징 적용할 수 있도록 값설정
		if (startPage > 1)
			isPrevPage = true;

		// HTML코드를 저장할 StringBuffer생성=>코드생성
		sb = new StringBuffer();
		// -----그룹페이지처리 이전
		// --------------------------------------------------------------------------------------------
		if (isPrevPage) {
			sb.append("<a href ='" + pageURL + "?save_page=" + save_nowPage);
			sb.append("&use_page=");
			sb.append(startPage - 1);
			sb.append("'>prev</a>");
		} else
			sb.append("prev&nbsp;&nbsp;&nbsp;");

		// ------페이지 목록 출력
		// -------------------------------------------------------------------------------------------------
		// sb.append("|");
		for (int i = startPage; i <= endPage; i++) {
			if (i > totalPage)
				break;
			if (i == use_nowPage) { // 현재 있는 페이지
				sb.append("&nbsp;&nbsp;&nbsp;<b><font color='#f00'>");
				sb.append(i);
				sb.append("</font></b>&nbsp;&nbsp;");
			} else {// 현재 페이지가 아니면
				sb.append("&nbsp;<a href='" + pageURL + "?save_page=" + save_nowPage);
				sb.append("&use_page=");
				sb.append(i);
				sb.append("'>");
				sb.append(i);
				sb.append("</a>");
			}
		} // end for

		sb.append("&nbsp;");

		// -----그룹페이지처리 다음
		// ----------------------------------------------------------------------------------------------
		if (isNextPage) {
			sb.append("<a href='" + pageURL + "?save_page=" + save_nowPage);
			sb.append("&use_page=");
			sb.append(endPage + 1);
			sb.append("'>next</a>");
		} else
			sb.append("&nbsp;&nbsp;&nbsp;next");
		// ---------------------------------------------------------------------------------------------------------------------
		pageString.add(sb.toString());
		
		return pageString;
	}
}