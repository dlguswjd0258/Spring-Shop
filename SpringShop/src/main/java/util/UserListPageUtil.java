package util;

public class UserListPageUtil {
	
	//게시판별 페이지의 속성을 관리하기 위한 내ㅜ클래스들을 만들어두면
	//일반 게시판과 공지사항등 게시판이 두 개 이상일 때 상수로 특정 클래스를 골라서 접근하기 편해진다
	public static class Board{
	    public static final String VIEW_PATH_U = "/WEB-INF/views/user/";
	    public static final String VIEW_PATH_P = "/WEB-INF/views/product/";
	    public static final String VIEW_PATH_H = "/WEB-INF/views/history/";
	    public static final String VIEW_PATH_R = "/WEB-INF/views/review/";
	    public static final String VIEW_PATH_C = "/WEB-INF/views/cart/";
		//한 페이지당 보여줄 게시물 수
		public final static int BLOCKLIST = 10;
		
		//한 화면에 보여지는 페이지 메뉴 수(prev 1 2 3 next)
		public final static int BLOCKPAGE = 3;
	}
	
	public static class Histroy{
		public final static int BLOCKLIST = 5;
		public final static int BLOCKPAGE = 5;
	}

}
