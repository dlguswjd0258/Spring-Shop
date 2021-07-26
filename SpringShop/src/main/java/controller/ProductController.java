package controller;

import java.io.File;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import dao.HistoryDAO;
import dao.OrdersDAO;
import dao.P_informDAO;
import dao.ProductDAO;
import dao.UserDAO;
import util.CategoryPageUtil;
import util.CategoryPaging;
import util.FloatPageUtil;
import util.FloatPaging;
import util.PageUtil;
import util.Paging;
import util.ProductListManagerPageUtil;
import util.ProductListManagerPaging;
import util.ViewPageUtil;
import util.ViewPaging;
import vo.Buy_oneVO;
import vo.CashVO;
import vo.HistoryVO;
import vo.OrdersVO;
import vo.P_informVO;
import vo.PointVO;
import vo.ProductVO;
import vo.ReviewVO;
import vo.UserVO;

@Controller
public class ProductController {

	public static final String VIEW_PATH_U = "/WEB-INF/views/user/";
	public static final String VIEW_PATH_P = "/WEB-INF/views/product/";
	public static final String VIEW_PATH_H = "/WEB-INF/views/history/";
	public static final String VIEW_PATH_R = "/WEB-INF/views/review/";
	public static final String VIEW_PATH_C = "/WEB-INF/views/cart/";
	
	int product_idx;
	Buy_oneVO b_vo = new Buy_oneVO();
	
	@Autowired
	HttpSession session;

	@Autowired
	ServletContext application;

	@Autowired
	HttpServletRequest request;

	public static List<String> public_sessionList = new ArrayList<String>();

	OrdersDAO orders_dao;
	HistoryDAO history_dao;
	UserDAO user_dao;
	ProductDAO product_dao;
	// 200627
	P_informDAO p_inform_dao;

	// 200627
	public void setP_inform_dao(P_informDAO p_inform_dao) {
		this.p_inform_dao = p_inform_dao;
	}

	public void setOrders_dao(OrdersDAO orders_dao) {
		this.orders_dao = orders_dao;
	}

	public void setHistory_dao(HistoryDAO history_dao) {
		this.history_dao = history_dao;
	}

	public void setUser_dao(UserDAO user_dao) {
		this.user_dao = user_dao;
	}

	public void setProduct_dao(ProductDAO product_dao) {
		this.product_dao = product_dao;
	}

	// 메인화면 호출
	@RequestMapping(value = { "/", "/main.do" })
	public String mainPage(Model model, String page) {

		// 2020.06.29 EDITED
		// 세션에 기록되어 있는 show정보를 지운다
		if (request.getSession().getAttribute("user") == null) {
			for (int i = 0; i < public_sessionList.size(); i++) {
				request.getSession().removeAttribute(public_sessionList.get(i));
			}
		}

		// main.do?page=1
		// main.do
		int nowPage = 1;// 기본페이지
		if (page != null && !page.isEmpty()) {
			nowPage = Integer.parseInt(page);
		}

		// 한 페이지에 표시되는 게시물의 시작과 끝 번호를 계산
		int start = (nowPage - 1) * util.FloatPageUtil.FloatBoard.BLOCKLIST + 1;
		int end = (start + FloatPageUtil.FloatBoard.BLOCKLIST) - 1;

		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("start", start);
		map.put("end", end);

		// 페이지에 들어갈 상품목록 가져오기
		List<ProductVO> product_list = null;
		product_list = product_dao.page_product_list(map);

		// 전체 상품 수 구하기
		int row_total = product_dao.product_count();

		// 하단 페이지메뉴 생성하기
		String pageMenu = FloatPaging.FloatgetPaging("main.do", nowPage, row_total, FloatPageUtil.FloatBoard.BLOCKLIST,
				FloatPageUtil.FloatBoard.BLOCKPAGE);

		request.setAttribute("list", product_list);
		request.setAttribute("pageMenu", pageMenu);

		Map<Integer, List<String>> color_map = new HashMap<Integer, List<String>>();
		for (int i = 0; i < product_list.size(); i++) {
			int curr_p_idx = product_list.get(i).getIdx();
			List<String> color_list = product_dao.product_color_list(curr_p_idx);

			// 중복값 제거
			for (int j = 0; j < color_list.size() - 1; j++) {
				for (int k = j + 1; k < color_list.size(); k++) {
					if (color_list.get(j).equals(color_list.get(k))) {
						color_list.remove(k);
						// 2020.06.26 EDITED
						k--;
					}
				}
			}

			// 각 idx에 해당하는 색상 배열 추가
			color_map.put(curr_p_idx, color_list);
		}

		model.addAttribute("color_map", color_map);

		// 2020.06.29 EDITED
		// 사이즈 최소 ~ 최대값 바인딩
		Map<String, Integer> map2 = new HashMap<String, Integer>();
		map2.put("FREE", 10);
		map2.put("4XL", 9);
		map2.put("3XL", 8);
		map2.put("2XL", 7);
		map2.put("XL", 6);
		map2.put("L", 5);
		map2.put("M", 4);
		map2.put("S", 3);
		map2.put("XS", 2);
		map2.put("XXS", 1);

		Map<Integer, String> size_str_map = new HashMap<Integer, String>();

		Map<Integer, String> NEW = new HashMap<Integer, String>();
		Map<Integer, String> HOT = new HashMap<Integer, String>();
		Map<Integer, String> SOLD_OUT = new HashMap<Integer, String>();

		for (int i = 0; i < product_list.size(); i++) {
			int curr_p_idx2 = product_list.get(i).getIdx();
			List<String> size_list = product_dao.product_size_list(curr_p_idx2);

			// 중복값 제거
			for (int j = 0; j < size_list.size() - 1; j++) {
				for (int k = j + 1; k < size_list.size(); k++) {
					if (size_list.get(j).equals(size_list.get(k))) {
						size_list.remove(k);
						k--;
					}
				}
			}

			String size_str = "";
			if (size_list != null && !size_list.isEmpty()) {
				if (size_list.size() < 2) {
					size_str = size_list.get(0);
				} else {
					// 최소, 최대값 구하기
					int min = map2.get(size_list.get(0));
					String min_str = size_list.get(0);
					for (int m = 1; m < size_list.size(); m++) {
						if (min > map2.get(size_list.get(m))) {
							min = map2.get(size_list.get(m));
							min_str = size_list.get(m);
						}
					}

					int max = map2.get(size_list.get(0));
					String max_str = size_list.get(0);
					for (int m = 1; m < size_list.size(); m++) {
						if (max < map2.get(size_list.get(m))) {
							max = map2.get(size_list.get(m));
							max_str = size_list.get(m);
						}
					}
					size_str = min_str + " ~ " + max_str;
				}
			}
			// 각 idx에 해당하는 사이즈 배열 추가
			size_str_map.put(curr_p_idx2, size_str);

			// 2020.07.03 EDITED
			// NEW, HOT, SOLD_OUT
			ProductVO vo = product_list.get(i);

			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			Date upload_date = null;
			try {
				upload_date = sdf.parse(vo.getP_date());
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

			long curr_time = System.currentTimeMillis();
			long upload_time = upload_date.getTime();
			// 업로드 일주일이 안됐다면
			if ((curr_time - upload_time) / 1000 < 604800) {
				NEW.put(vo.getIdx(), "NEW");
			} else {
				NEW.put(vo.getIdx(), "");
			}

			// 일주일안에 100장이 팔렸다면
			if ((curr_time - upload_time) / 1000 < 604800 && vo.getP_sold() > 10) {
				HOT.put(vo.getIdx(), "HOT");
			} else {
				HOT.put(vo.getIdx(), "");
			}

			List<Integer> stock_list = product_dao.product_stock_list(vo.getIdx());
			int j;
			for (j = 0; j < stock_list.size(); j++) {
				if (stock_list.get(j) != 0) {
					break;
				}
			}
			if (j == stock_list.size()) {
				SOLD_OUT.put(vo.getIdx(), "SOLD_OUT");
			} else {
				SOLD_OUT.put(vo.getIdx(), "");
			}

		}

		model.addAttribute("NEW", NEW);
		model.addAttribute("HOT", HOT);
		model.addAttribute("SOLD_OUT", SOLD_OUT);
		model.addAttribute("size_str_map", size_str_map);

		return VIEW_PATH_P + "home.jsp";
	}

	// 상품 입력 폼 호출
	@RequestMapping("/product_insert_form.do")
	public String product_insert_form() {
		return PageUtil.Board.VIEW_PATH_P + "product_insert_form.jsp";
	}

	// 상품 db에 저장(insert)
	@RequestMapping("/product_insert.do")
	public String product_insert(Model model, ProductVO vo) {
		String p_content = vo.getP_content().replace("\n", "<br>");

		vo.setP_content(p_content);

		String webpath = "/resources/upload/";
		String savePath = application.getRealPath(webpath);
		System.out.println(savePath);

		// 업로드된 파일의 정보
		MultipartFile p_image_s = vo.getP_image_s();
		MultipartFile p_image_l = vo.getP_image_l();
		String filename_s = "no_file";
		String filename_l = "no_file";

		// 업로드 한 파일이 실제로 존재한다면
		if (!p_image_s.isEmpty() && !p_image_l.isEmpty()) {
			filename_s = p_image_s.getOriginalFilename();// 업로드 된 실제 파일명
			filename_l = p_image_l.getOriginalFilename();// 업로드 된 실제 파일명
			// 저장할 파일 경로 지정
			File saveFile_s = new File(savePath, filename_s);
			File saveFile_l = new File(savePath, filename_l);
			if (!saveFile_s.exists()) {
				saveFile_s.mkdirs();// 없는 폴더 생성
			} else {
				// 동일 파일명 업로드 방지를 위해 현재 업로드 시간을 붙여서 중복을 방지
				long time = System.currentTimeMillis();
				filename_s = String.format("%d_%s", time, filename_s);
				saveFile_s = new File(savePath, filename_s);
			}
			if (!saveFile_l.exists()) {
				saveFile_l.mkdirs();// 없는 폴더 생성
			} else {
				// 동일 파일명 업로드 방지를 위해 현재 업로드 시간을 붙여서 중복을 방지
				long time = System.currentTimeMillis();
				filename_l = String.format("%d_%s", time, filename_l);
				saveFile_l = new File(savePath, filename_l);
			}
			try {
				// 업로드된 파일은 MultipartResolver라는 클래스가 지정해둔
				// 임시저장소에 있는데, 임시 저장소의 파일은 일정 시간이 지나면 사라지기 때문에
				// 내가 지정해준 savePath경로로 복사해준다
				p_image_s.transferTo(saveFile_s);
				p_image_l.transferTo(saveFile_l);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		vo.setFilename_s(filename_s);
		vo.setFilename_l(filename_l);
		//if (res != 0) {
			model.addAttribute("product_vo", vo);
		//}
		return PageUtil.Board.VIEW_PATH_P + "p_inform_insert_form.jsp";
	}

	@RequestMapping("/p_inform_insert_first.do")
	public String p_inform_insert_first(Model model, ProductVO product_vo, P_informVO vo) {
		//첫번째 옵션을 추가할때 상품등록
		int res = product_dao.product_insert(product_vo);
		this.product_idx = product_dao.product_idx_select(product_vo.getP_name());
		// db에 추가하기 전 사이즈,색상이 같을경우 수량만 추가할 수 있도록 처리
		// 사이즈랑 색상을 보내서 객체를 가져오고 객체가 존재하면 수량 update쿼리실행
		vo.setRef(this.product_idx);
		P_informVO p_vo = p_inform_dao.selectOne(vo);
		if (p_vo != null) {
			p_vo.setI_stock(p_vo.getI_stock() + vo.getI_stock());
			p_inform_dao.update_stock(p_vo);
		} else {
			p_inform_dao.p_inform_insert(vo);
		}
		List<P_informVO> list = p_inform_dao.selectList(vo.getRef());
		model.addAttribute("idx", vo.getRef());
		model.addAttribute("list", list);
		model.addAttribute("check", "yes");
		
		return VIEW_PATH_P + "p_inform_insert_form.jsp";
	}
	
	@RequestMapping("/p_inform_insert.do")
	public String p_inform_insert(Model model, P_informVO vo) {
		// db에 추가하기 전 사이즈,색상이 같을경우 수량만 추가할 수 있도록 처리
		// 사이즈랑 색상을 보내서 객체를 가져오고 객체가 존재하면 수량 update쿼리실행
		P_informVO p_vo = p_inform_dao.selectOne(vo);
		if (p_vo != null) {
			p_vo.setI_stock(p_vo.getI_stock() + vo.getI_stock());
			p_inform_dao.update_stock(p_vo);
		} else {
			p_inform_dao.p_inform_insert(vo);
		}
		List<P_informVO> list = p_inform_dao.selectList(vo.getRef());
		model.addAttribute("idx", vo.getRef());
		model.addAttribute("list", list);
		model.addAttribute("check", "yes");
		
		return VIEW_PATH_P + "p_inform_insert_form.jsp";
	}
	
	// 200626
	@RequestMapping("/product_delete.do")
	@ResponseBody
	public String product_delete(int idx) {
		int[] res = product_dao.product_delete_all(idx);

		String rstr = "no";
		if (res[1] > 0) {
			rstr = "yes";
		}

		String resultStr = String.format("[{'res', '%s}]", rstr);
		return resultStr;
	}

	@RequestMapping("/product_one.do")
	public String product_one(int idx, String page, String r_idx, Model model) {
		try {
			// 상품정보 넘기기
			ProductVO vo = product_dao.product_one(idx);
			model.addAttribute("vo", vo);
			UserVO uservo = (UserVO) request.getSession().getAttribute("user");

			String review_writable = "no";
			if (uservo != null) {
				List<HistoryVO> history_list = product_dao.get_history_list(uservo.getIdx());
				for (int i = 0; i < history_list.size(); i++) {
					if (history_list.get(i).getP_idx() == idx) {
						review_writable = "yes";
						break;
					}
				}

				// 2020.07.09 EDITED
				// 후기 이미 작성했는지 확인
				int res = product_dao.review_written(idx, uservo.getIdx());
				if (res > 0) {
					review_writable = "no";
				}
			}
			model.addAttribute("review_writable", review_writable);

			// 리뷰 클릭했는지 확인
			if (r_idx != null && !r_idx.isEmpty()) {
				ReviewVO r_vo = product_dao.get_review(Integer.parseInt(r_idx));
				model.addAttribute("r_content_fortxt", r_vo.getContent());

				r_vo.setContent(r_vo.getContent().replaceAll("\n", "<br>"));
				model.addAttribute("r_content", r_vo.getContent());

				// 2020.06.29 EDITED
				// 조회수증가 세션 리스트
				HttpSession session = request.getSession();
				String show = (String) session.getAttribute("show" + r_idx);
				if (show == null) {
					product_dao.update_readhit(Integer.parseInt(r_idx));
					session.setAttribute("show" + r_idx, "shown");
					public_sessionList.add("show" + r_idx);
				}

				Map<Integer, String> dadat_ORcontent = new HashMap<Integer, String>();
				List<ReviewVO> dadat_list = null;
				dadat_list = product_dao.get_dadat_list(r_idx);
				for (int i = 0; i < dadat_list.size(); i++) {
					dadat_ORcontent.put(dadat_list.get(i).getIdx(), dadat_list.get(i).getContent());
					dadat_list.get(i).setContent(dadat_list.get(i).getContent().replaceAll("\n", "<br>"));
				}
				model.addAttribute("dadat_ORcontent", dadat_ORcontent);
				model.addAttribute("dadat_list", dadat_list);

			}

			// 2020.07.03 EDITED
			// NEW, HOT, SOLD_OUT

			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			Date upload_date = null;
			try {
				upload_date = sdf.parse(vo.getP_date());
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

			long curr_time = System.currentTimeMillis();
			long upload_time = upload_date.getTime();
			// 업로드 일주일이 안됐다면
			if ((curr_time - upload_time) / 1000 < 604800) {
				System.out.println(vo.getIdx());
				model.addAttribute("NEW", "NEW");
			} else {
				model.addAttribute("NEW", "");
			}

			// 일주일안에 100장이 팔렸다면
			if ((curr_time - upload_time) / 1000 < 604800 && vo.getP_sold() > 10) {
				model.addAttribute("HOT", "HOT");
			} else {
				model.addAttribute("HOT", "");
			}

			List<Integer> stock_list = product_dao.product_stock_list(vo.getIdx());
			int j;
			for (j = 0; j < stock_list.size(); j++) {
				if (stock_list.get(j) != 0) {
					break;
				}
			}
			if (j == stock_list.size()) {
				model.addAttribute("SOLD_OUT", "SOLD_OUT");
			} else {
				model.addAttribute("SOLD_OUT", "");
			}

			// 게시글 페이징 처리
			int nowPage = 1;// 기본페이지
			if (page != null && !page.isEmpty()) {
				nowPage = Integer.parseInt(page);
			}

			int start = (nowPage - 1) * PageUtil.Board.BLOCKLIST + 1;
			int end = (start + PageUtil.Board.BLOCKLIST) - 1;

			Map<String, Integer> map = new HashMap<String, Integer>();
			map.put("start", start);
			map.put("end", end);
			map.put("idx", idx);

			// 게시글 전체목록 가져오기
			List<ReviewVO> list = product_dao.review_list_paging(map);

			// 전체게시물 수 구하기
			int row_total = product_dao.getRowTotal(idx);
			model.addAttribute("review_num", row_total);

			// 하단 페이지메뉴 생성하기
			String pageMenu = Paging.getPaging("product_one.do", nowPage, idx, row_total, PageUtil.Board.BLOCKLIST,
					PageUtil.Board.BLOCKPAGE);

			model.addAttribute("reviews", list);
			model.addAttribute("pageMenu", pageMenu);

			// 2020.06.28 EDITED
			List<String> color_list = product_dao.product_color_list(vo.getIdx());
			for (int j1 = 0; j1 < color_list.size() - 1; j1++) {
				for (int k = j1 + 1; k < color_list.size(); k++) {
					if (color_list.get(j1).equals(color_list.get(k))) {
						color_list.remove(k);
						// 2020.06.26 EDITED
						k--;
					}
				}
			}
			model.addAttribute("color_list", color_list);

			// 2020.06.28 EDITED
			Map<String, Object> map2 = new HashMap<String, Object>();
			Map<String, List<String>> size_map = new HashMap<String, List<String>>();
			int t_idx = vo.getIdx();
			for (int i = 0; i < color_list.size(); i++) {
				map2.put("idx", t_idx);
				String t_color = color_list.get(i);
				t_color = t_color.replace("#", "");
				map2.put("color", t_color);

				List<String> corr_sizes = product_dao.color_size_match(map2);
				// 사이즈 순서대로 정렬하기
				Map<String, Integer> map3 = new HashMap<String, Integer>();
				map3.put("FREE", 10);
				map3.put("4XL", 9);
				map3.put("3XL", 8);
				map3.put("2XL", 7);
				map3.put("XL", 6);
				map3.put("L", 5);
				map3.put("M", 4);
				map3.put("S", 3);
				map3.put("XS", 2);
				map3.put("XXS", 1);

				for (int j1 = 1; j1 < corr_sizes.size(); j1++) {
					System.out.println(corr_sizes.size());
					int k = j1 - 1;
					System.out.println("j:" + Integer.toString(j1));

					String key = corr_sizes.get(j1);
					while (k >= 0) {
						if (map3.get(corr_sizes.get(k)) > map3.get(key)) {
							corr_sizes.set(k + 1, corr_sizes.get(k));
							k--;
						} else {
							break;
						}
					}
					corr_sizes.set(k + 1, key);
				}

				size_map.put(color_list.get(i), corr_sizes);
			}
			model.addAttribute("size_map", size_map);

			Map<String, Map<String, Integer>> stock_map = new HashMap<String, Map<String, Integer>>();
			for (int i = 0; i < color_list.size(); i++) {

				Map<String, Integer> size_stock = new HashMap<String, Integer>();
				for (int j1 = 0; j1 < size_map.get(color_list.get(i)).size(); j1++) {

					Map<String, String> color_size = new HashMap<String, String>();
					color_size.put("ref", Integer.toString(vo.getIdx()));
					color_size.put("color", color_list.get(i));
					color_size.put("i_size", size_map.get(color_list.get(i)).get(j1));

					int res = product_dao.product_stock(color_size);
					size_stock.put(size_map.get(color_list.get(i)).get(j1), res);
				}
				stock_map.put(color_list.get(i), size_stock);
			}
			model.addAttribute("stock_map", stock_map);

		} catch (Exception e) {
			e.printStackTrace();
		}

		return PageUtil.Board.VIEW_PATH_P + "product_info.jsp";
	}

	// 200626
	// 상품 등록도중 취소 클릭시 해당 상품 전체 삭제
	@RequestMapping("/product_delete_all.do")
	@ResponseBody
	public String product_delete_all(int idx) {
		int[] res = new int[2];
		res = product_dao.product_delete_all(idx);
		String result = "no";
		if (res[1] != 0) {
			result = "yes";
		}
		String param = String.format("[{'result':'%s'}]", result);
		return param;
	}

	// 상품명 중복체크
	@RequestMapping("/p_name_check.do")
	@ResponseBody
	public String select_One(String p_name) {
		ProductVO vo = product_dao.selectOne(p_name);
		String result = "no";
		if (vo == null) {
			result = "yes";
		}
		String param = String.format("[{'result':'%s'}]", result);
		return param;
	}

	// 관리자 상품 리스트 폼 이동
	@RequestMapping("/product_list_form.do")
	public String product_list_form(Model model, String page, String category) {
		// main.do?page=1
		// main.do
		int nowPage = 1;// 기본페이지
		if (page != null && !page.isEmpty()) {
			nowPage = Integer.parseInt(page);
		}

		// 한 페이지에 표시되는 게시물의 시작과 끝 번호를 계산
		int start = (nowPage - 1) * util.ProductListManagerPageUtil.Board.BLOCKLIST + 1;
		int end = (start + ProductListManagerPageUtil.Board.BLOCKLIST) - 1;

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("start", start);
		map.put("end", end);

		// 페이지에 들어갈 상품목록 가져오기
		List<ProductVO> product_list = null;
		int row_total = 0;
		
		if (category == null || category.isEmpty() || category.equals("카테고리 선택")) {
			category = "";
			product_list = product_dao.page_product_list_m(map);
			row_total = product_dao.product_count_m();
		} else if (category.equals("BEST") || category.equals("---TOP---") || category.equals("---PANTS---")
						|| category.equals("---SHIRTS---") || category.equals("---OUTER---")) {
			category = category.replaceAll("-", "");
			category = category.toLowerCase();
			map.put("view_name", category);
			product_list = product_dao.page_view_list_m(map);
			row_total = product_dao.view_count_m(category);
			
		} else {
			category = category.replace(',', '&');
			
			map.put("category", category);
			product_list = product_dao.page_category_list_m(map);
			row_total = product_dao.category_count_m(category);
		}
		model.addAttribute("category", category);

		// 하단 페이지메뉴 생성하기
		String pageMenu = ProductListManagerPaging.getPaging("product_list_form.do", nowPage, category, row_total, ProductListManagerPageUtil.Board.BLOCKLIST,
				ProductListManagerPageUtil.Board.BLOCKPAGE);

		model.addAttribute("list", product_list);
		model.addAttribute("pageMenu", pageMenu);
		
		return PageUtil.Board.VIEW_PATH_P + "product_list_form.jsp";
	}

	// 상단 메뉴 대분류 클릭시 하위 카테고리를 포함한 대분류 리스트 출력(ex top,shirts, pants)등
	// 파라미터로 넘어온 값 = view의 이름
	@RequestMapping("view_list.do")
	public String view_list(Model model, String view_name, String page) {

		// main.do?page=1
		// main.do
		int nowPage = 1;// 기본페이지
		if (page != null && !page.isEmpty()) {
			nowPage = Integer.parseInt(page);
		}

		// 한 페이지에 표시되는 게시물의 시작과 끝 번호를 계산
		int start = (nowPage - 1) * util.ViewPageUtil.FloatBoard.BLOCKLIST + 1;
		int end = (start + ViewPageUtil.FloatBoard.BLOCKLIST) - 1;

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("start", start);
		map.put("end", end);
		System.out.println(view_name);
		map.put("view_name", view_name);

		// 페이지에 들어갈 상품목록 가져오기
		List<ProductVO> view_list = product_dao.page_view_list(map);

		// 전체 상품 수 구하기
		int row_total = product_dao.view_count(view_name);

		// 하단 페이지메뉴 생성하기
		String pageMenu = ViewPaging.FloatgetPaging("view_list.do", nowPage, view_name, row_total,
				ViewPageUtil.FloatBoard.BLOCKLIST, ViewPageUtil.FloatBoard.BLOCKPAGE);

		model.addAttribute("list", view_list);
		model.addAttribute("pageMenu", pageMenu);

		Map<Integer, List<String>> color_map = new HashMap<Integer, List<String>>();
		for (int i = 0; i < view_list.size(); i++) {
			int curr_p_idx = view_list.get(i).getIdx();
			List<String> color_list = product_dao.product_color_list(curr_p_idx);

			// 중복값 제거
			for (int j = 0; j < color_list.size() - 1; j++) {
				for (int k = j + 1; k < color_list.size(); k++) {
					if (color_list.get(j).equals(color_list.get(k))) {
						color_list.remove(k);
						// 2020.06.26 EDITED
						k--;
					}
				}
			}

			// 각 idx에 해당하는 색상 배열 추가
			color_map.put(curr_p_idx, color_list);
		}

		model.addAttribute("color_map", color_map);

		// 2020.06.29 EDITED
		// 사이즈 최소 ~ 최대값 바인딩
		Map<String, Integer> map2 = new HashMap<String, Integer>();
		map2.put("4XL", 9);
		map2.put("3XL", 8);
		map2.put("2XL", 7);
		map2.put("XL", 6);
		map2.put("L", 5);
		map2.put("M", 4);
		map2.put("S", 3);
		map2.put("XS", 2);
		map2.put("XXS", 1);

		Map<Integer, String> size_str_map = new HashMap<Integer, String>();

		Map<Integer, String> NEW = new HashMap<Integer, String>();
		Map<Integer, String> HOT = new HashMap<Integer, String>();
		Map<Integer, String> SOLD_OUT = new HashMap<Integer, String>();

		for (int i = 0; i < view_list.size(); i++) {
			int curr_p_idx2 = view_list.get(i).getIdx();
			List<String> size_list = product_dao.product_size_list(curr_p_idx2);

			// 중복값 제거
			for (int j = 0; j < size_list.size() - 1; j++) {
				for (int k = j + 1; k < size_list.size(); k++) {
					if (size_list.get(j).equals(size_list.get(k))) {
						size_list.remove(k);
						k--;
					}
				}
			}

			String size_str = "";
			if (size_list != null && !size_list.isEmpty()) {
				if (size_list.size() < 2) {
					size_str = size_list.get(0);
				} else {
					// 최소, 최대값 구하기
					int min = map2.get(size_list.get(0));
					String min_str = size_list.get(0);
					for (int m = 1; m < size_list.size(); m++) {
						if (min > map2.get(size_list.get(m))) {
							min = map2.get(size_list.get(m));
							min_str = size_list.get(m);
						}
					}

					int max = map2.get(size_list.get(0));
					String max_str = size_list.get(0);
					for (int m = 1; m < size_list.size(); m++) {
						if (max < map2.get(size_list.get(m))) {
							max = map2.get(size_list.get(m));
							max_str = size_list.get(m);
						}
					}
					size_str = min_str + " ~ " + max_str;
				}
			}
			// 각 idx에 해당하는 사이즈 배열 추가
			size_str_map.put(curr_p_idx2, size_str);

			// 2020.07.03 EDITED
			// NEW, HOT, SOLD_OUT
			ProductVO vo = view_list.get(i);

			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			Date upload_date = null;
			try {
				upload_date = sdf.parse(vo.getP_date());
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

			long curr_time = System.currentTimeMillis();
			long upload_time = upload_date.getTime();
			// 업로드 일주일이 안됐다면
			if ((curr_time - upload_time) / 1000 < 604800) {
				NEW.put(vo.getIdx(), "NEW");
			} else {
				NEW.put(vo.getIdx(), "");
			}

			// 일주일안에 100장이 팔렸다면
			if ((curr_time - upload_time) / 1000 < 604800 && vo.getP_sold() > 10) {
				HOT.put(vo.getIdx(), "HOT");
			} else {
				HOT.put(vo.getIdx(), "");
			}

			List<Integer> stock_list = product_dao.product_stock_list(vo.getIdx());
			int j;
			for (j = 0; j < stock_list.size(); j++) {
				if (stock_list.get(j) != 0) {
					break;
				}
			}
			if (j == stock_list.size()) {
				SOLD_OUT.put(vo.getIdx(), "SOLD_OUT");
			} else {
				SOLD_OUT.put(vo.getIdx(), "");
			}

		}

		model.addAttribute("NEW", NEW);
		model.addAttribute("HOT", HOT);
		model.addAttribute("SOLD_OUT", SOLD_OUT);
		model.addAttribute("size_str_map", size_str_map);

		return PageUtil.Board.VIEW_PATH_P + "category_list.jsp";
	}

	@RequestMapping("category_list.do")
	public String category_list(Model model, String category, String page) {
		String param = category;

		// main.do?page=1
		// main.do
		int nowPage = 1;// 기본페이지
		if (page != null && !page.isEmpty()) {
			nowPage = Integer.parseInt(page);
		}

		// 한 페이지에 표시되는 게시물의 시작과 끝 번호를 계산
		int start = (nowPage - 1) * util.CategoryPageUtil.FloatBoard.BLOCKLIST + 1;
		int end = (start + CategoryPageUtil.FloatBoard.BLOCKLIST) - 1;

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("start", start);
		map.put("end", end);

		// 페이지에 들어갈 상품목록 가져오기
		List<ProductVO> category_list = null;

		for (int i = 0; i < category.length(); i++) {
			if (category.charAt(i) == ',') {
				param = category.replace(",", "&");
			}
		}

		// 전체 상품 수 구하기
		int row_total;
		if (category.contains(",")) {
			map.put("category", param);
			row_total = product_dao.category_count(param);
		} else {
			map.put("category", category);
			row_total = product_dao.category_count(category);
		}
		category_list = product_dao.page_category_list(map);

		// 하단 페이지메뉴 생성하기
		String pageMenu = CategoryPaging.FloatgetPaging("category_list.do", nowPage, category, row_total,
				CategoryPageUtil.FloatBoard.BLOCKLIST, CategoryPageUtil.FloatBoard.BLOCKPAGE);

		model.addAttribute("list", category_list);
		model.addAttribute("pageMenu", pageMenu);

		Map<Integer, List<String>> color_map = new HashMap<Integer, List<String>>();
		for (int i = 0; i < category_list.size(); i++) {
			int curr_p_idx = category_list.get(i).getIdx();
			List<String> color_list = product_dao.product_color_list(curr_p_idx);

			// 중복값 제거
			for (int j = 0; j < color_list.size() - 1; j++) {
				for (int k = j + 1; k < color_list.size(); k++) {
					if (color_list.get(j).equals(color_list.get(k))) {
						color_list.remove(k);
						// 2020.06.26 EDITED
						k--;
					}
				}
			}

			// 각 idx에 해당하는 색상 배열 추가
			color_map.put(curr_p_idx, color_list);
		}

		model.addAttribute("color_map", color_map);

		// 2020.06.29 EDITED
		// 사이즈 최소 ~ 최대값 바인딩
		Map<String, Integer> map2 = new HashMap<String, Integer>();
		map2.put("FREE", 10);
		map2.put("4XL", 9);
		map2.put("3XL", 8);
		map2.put("2XL", 7);
		map2.put("XL", 6);
		map2.put("L", 5);
		map2.put("M", 4);
		map2.put("S", 3);
		map2.put("XS", 2);
		map2.put("XXS", 1);

		Map<Integer, String> size_str_map = new HashMap<Integer, String>();

		Map<Integer, String> NEW = new HashMap<Integer, String>();
		Map<Integer, String> HOT = new HashMap<Integer, String>();
		Map<Integer, String> SOLD_OUT = new HashMap<Integer, String>();

		for (int i = 0; i < category_list.size(); i++) {
			int curr_p_idx2 = category_list.get(i).getIdx();
			List<String> size_list = product_dao.product_size_list(curr_p_idx2);

			// 중복값 제거
			for (int j = 0; j < size_list.size() - 1; j++) {
				for (int k = j + 1; k < size_list.size(); k++) {
					if (size_list.get(j).equals(size_list.get(k))) {
						size_list.remove(k);
						k--;
					}
				}
			}

			String size_str = "";
			if (size_list.size() < 2) {
				size_str = size_list.get(0);
			} else {
				// 최소, 최대값 구하기
				int min = map2.get(size_list.get(0));
				String min_str = size_list.get(0);
				for (int m = 1; m < size_list.size(); m++) {
					if (min > map2.get(size_list.get(m))) {
						min = map2.get(size_list.get(m));
						min_str = size_list.get(m);
					}
				}

				int max = map2.get(size_list.get(0));
				String max_str = size_list.get(0);
				for (int m = 1; m < size_list.size(); m++) {
					if (max < map2.get(size_list.get(m))) {
						max = map2.get(size_list.get(m));
						max_str = size_list.get(m);
					}
				}
				size_str = min_str + " ~ " + max_str;
			}
			// 각 idx에 해당하는 사이즈 배열 추가
			size_str_map.put(curr_p_idx2, size_str);

			// 2020.07.03 EDITED
			// NEW, HOT, SOLD_OUT
			ProductVO vo = category_list.get(i);

			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			Date upload_date = null;
			try {
				upload_date = sdf.parse(vo.getP_date());
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

			long curr_time = System.currentTimeMillis();
			long upload_time = upload_date.getTime();
			// 업로드 일주일이 안됐다면
			if ((curr_time - upload_time) / 1000 < 604800) {
				System.out.println(vo.getIdx());
				NEW.put(vo.getIdx(), "NEW");
			} else {
				NEW.put(vo.getIdx(), "");
			}

			// 일주일안에 100장이 팔렸다면
			if ((curr_time - upload_time) / 1000 < 604800 && vo.getP_sold() > 10) {
				HOT.put(vo.getIdx(), "HOT");
			} else {
				HOT.put(vo.getIdx(), "");
			}

			List<Integer> stock_list = product_dao.product_stock_list(vo.getIdx());
			int j;
			for (j = 0; j < stock_list.size(); j++) {
				if (stock_list.get(j) != 0) {
					break;
				}
			}
			if (j == stock_list.size()) {
				SOLD_OUT.put(vo.getIdx(), "SOLD_OUT");
			} else {
				SOLD_OUT.put(vo.getIdx(), "");
			}

		}

		model.addAttribute("NEW", NEW);
		model.addAttribute("HOT", HOT);
		model.addAttribute("SOLD_OUT", SOLD_OUT);
		model.addAttribute("size_str_map", size_str_map);

		return PageUtil.Board.VIEW_PATH_P + "category_list.jsp";
	}

	// 200626
	// 등록된 상품 삭제 (p_del = 1로 변경)
	@RequestMapping("/product_delet.do")
	@ResponseBody
	public String product_delet(int idx) {
		String result = "no";

		int res = product_dao.review_delete(idx); 
		res = product_dao.product_delete(idx);
		if (res != 0) {
			result = "yes";
		}

		return result;
	}

	// 200626
	// 상품 수정 폼 이동
	@RequestMapping("/product_update_form.do")
	public String product_update_form(Model model, int idx) {
		ProductVO vo = product_dao.product_one(idx);
		String p_content = vo.getP_content().replaceAll("<br>", "\n");
		vo.setP_content(p_content);
		model.addAttribute("vo", vo);

		List<P_informVO> list = p_inform_dao.selectList(idx);
		model.addAttribute("list", list);

		return PageUtil.Board.VIEW_PATH_P + "product_update_form.jsp";
	}

	// 200629
	// 상품 수정
	@RequestMapping("/product_update.do")
	public String product_update(Model model, ProductVO product_vo, P_informVO p_inform_vo) {
		String p_content = product_vo.getP_content().replace("\n", "<br>");
		product_vo.setP_content(p_content);

		String webpath = "/resources/upload/";
		String savePath = application.getRealPath(webpath);
		System.out.println(savePath);

		MultipartFile p_image_s = product_vo.getP_image_s();
		MultipartFile p_image_l = product_vo.getP_image_l();

		// 사진변경 했을 때(s)
		if (p_image_s.getSize() != 0) {
			String filename_s = "no_file";
			if (!p_image_s.isEmpty()) {
				// 파일 삭제
				File removeFile_s = new File(savePath, product_vo.getFilename_s());
				removeFile_s.delete();

				filename_s = p_image_s.getOriginalFilename();// 업로드 된 실제 파일명
				// 저장할 파일 경로 지정
				File saveFile_s = new File(savePath, filename_s);
				if (!saveFile_s.exists()) {
					saveFile_s.mkdirs();// 없는 폴더 생성
				} else {
					// 동일 파일명 업로드 방지를 위해 현재 업로드 시간을 붙여서 중복을 방지
					long time = System.currentTimeMillis();
					filename_s = String.format("%d_%s", time, filename_s);
					saveFile_s = new File(savePath, filename_s);
				}

				try {
					// 업로드된 파일은 MultipartResolver라는 클래스가 지정해둔
					// 임시저장소에 있는데, 임시 저장소의 파일은 일정 시간이 지나면 사라지기 때문에
					// 내가 지정해준 savePath경로로 복사해준다
					p_image_s.transferTo(saveFile_s);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			product_vo.setFilename_s(filename_s);
		}

		// 사진변경 했을 때(l)
		if (p_image_l.getSize() != 0) {
			String filename_l = "no_file";
			if (!p_image_l.isEmpty()) {
				// 파일 삭제
				File removeFile_l = new File(savePath, product_vo.getFilename_l());
				removeFile_l.delete();

				filename_l = p_image_l.getOriginalFilename();// 업로드 된 실제 파일명
				File saveFile_l = new File(savePath, filename_l);
				if (!saveFile_l.exists()) {
					saveFile_l.mkdirs();// 없는 폴더 생성
				} else {
					long time = System.currentTimeMillis();
					filename_l = String.format("%d_%s", time, filename_l);
					saveFile_l = new File(savePath, filename_l);
				}

				try {
					p_image_l.transferTo(saveFile_l);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			product_vo.setFilename_l(filename_l);
		}

		product_dao.product_update(product_vo);

		String[] p_inform_idx = p_inform_vo.getI_idx_s().split(",");
		String[] p_inform_size = p_inform_vo.getI_size().split(",");
		String[] p_inform_color = p_inform_vo.getColor().split(",");
		String[] p_inform_stock = p_inform_vo.getI_stock_s().split(",");

		for (int i = 0; i < p_inform_idx.length; i++) {
			P_informVO vo = new P_informVO();
			if (!p_inform_idx[i].equals("추가")) {
				vo.setI_idx(Integer.parseInt(p_inform_idx[i]));
				vo.setI_size(p_inform_size[i]);
				vo.setColor(p_inform_color[i]);
				vo.setI_stock(Integer.parseInt(p_inform_stock[i]));

				p_inform_dao.p_inform_update(vo);
			} else { // 추가 등록
				vo.setRef(product_vo.getIdx());
				vo.setI_size(p_inform_size[i]);
				vo.setColor(p_inform_color[i]);
				vo.setI_stock(Integer.parseInt(p_inform_stock[i]));

				p_inform_dao.p_inform_insert(vo);
			}
		}

		return "redirect:product_list_form.do";
	}

	@RequestMapping("search_one.do")
	public String search_one(Model model, String search1, String page) {
		List<ProductVO> list = product_dao.search_list(search1);

		int nowPage = 1;// 기본페이지
		if (page != null && !page.isEmpty()) {
			nowPage = Integer.parseInt(page);
		}

		int start = (nowPage - 1) * util.FloatPageUtil.FloatBoard.BLOCKLIST + 1;
		int end = (start + FloatPageUtil.FloatBoard.BLOCKLIST) - 1;

		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("start", start);
		map.put("end", end);

		// 페이지에 들어갈 상품목록 가져오기
		List<ProductVO> product_list = null;
		product_list = product_dao.page_product_list(map);

		// 전체 상품 수 구하기
		int row_total = product_dao.product_count();

		// 하단 페이지메뉴 생성하기
		String pageMenu = FloatPaging.FloatgetPaging("main.do", nowPage, row_total, FloatPageUtil.FloatBoard.BLOCKLIST,
				FloatPageUtil.FloatBoard.BLOCKPAGE);

		request.setAttribute("list", product_list);
		request.setAttribute("pageMenu", pageMenu);

		Map<Integer, List<String>> color_map = new HashMap<Integer, List<String>>();
		for (int i = 0; i < product_list.size(); i++) {
			int curr_p_idx = product_list.get(i).getIdx();
			List<String> color_list = product_dao.product_color_list(curr_p_idx);

			// 중복값 제거
			for (int j = 0; j < color_list.size() - 1; j++) {
				for (int k = j + 1; k < color_list.size(); k++) {
					if (color_list.get(j).equals(color_list.get(k))) {
						color_list.remove(k);
						// 2020.06.26 EDITED
						k--;
					}
				}
			}

			// 각 idx에 해당하는 색상 배열 추가
			color_map.put(curr_p_idx, color_list);
		}

		model.addAttribute("color_map", color_map);

		// 2020.06.29 EDITED
		// 사이즈 최소 ~ 최대값 바인딩
		Map<String, Integer> map2 = new HashMap<String, Integer>();
		map2.put("FREE", 10);
		map2.put("4XL", 9);
		map2.put("3XL", 8);
		map2.put("2XL", 7);
		map2.put("XL", 6);
		map2.put("L", 5);
		map2.put("M", 4);
		map2.put("S", 3);
		map2.put("XS", 2);
		map2.put("XXS", 1);

		Map<Integer, String> size_str_map = new HashMap<Integer, String>();

		Map<Integer, String> NEW = new HashMap<Integer, String>();
		Map<Integer, String> HOT = new HashMap<Integer, String>();
		Map<Integer, String> SOLD_OUT = new HashMap<Integer, String>();

		for (int i = 0; i < product_list.size(); i++) {
			int curr_p_idx2 = product_list.get(i).getIdx();
			List<String> size_list = product_dao.product_size_list(curr_p_idx2);

			// 중복값 제거
			for (int j = 0; j < size_list.size() - 1; j++) {
				for (int k = j + 1; k < size_list.size(); k++) {
					if (size_list.get(j).equals(size_list.get(k))) {
						size_list.remove(k);
						k--;
					}
				}
			}

			String size_str = "";
			if (size_list != null && !size_list.isEmpty()) {

				if (size_list.size() < 2) {
					size_str = size_list.get(0);
				} else {
					// 최소, 최대값 구하기
					int min = map2.get(size_list.get(0));
					String min_str = size_list.get(0);
					for (int m = 1; m < size_list.size(); m++) {
						if (min > map2.get(size_list.get(m))) {
							min = map2.get(size_list.get(m));
							min_str = size_list.get(m);
						}
					}

					int max = map2.get(size_list.get(0));
					String max_str = size_list.get(0);
					for (int m = 1; m < size_list.size(); m++) {
						if (max < map2.get(size_list.get(m))) {
							max = map2.get(size_list.get(m));
							max_str = size_list.get(m);
						}
					}
					size_str = min_str + " ~ " + max_str;
				}
			}
			// 각 idx에 해당하는 사이즈 배열 추가
			size_str_map.put(curr_p_idx2, size_str);

			// 2020.07.03 EDITED
			// NEW, HOT, SOLD_OUT
			ProductVO vo = product_list.get(i);

			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			Date upload_date = null;
			try {
				upload_date = sdf.parse(vo.getP_date());
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

			long curr_time = System.currentTimeMillis();
			long upload_time = upload_date.getTime();
			// 업로드 일주일이 안됐다면
			if ((curr_time - upload_time) / 1000 < 604800) {
				NEW.put(vo.getIdx(), "NEW");
			} else {
				NEW.put(vo.getIdx(), "");
			}

			// 일주일안에 100장이 팔렸다면
			if ((curr_time - upload_time) / 1000 < 604800 && vo.getP_sold() > 10) {
				HOT.put(vo.getIdx(), "HOT");
			} else {
				HOT.put(vo.getIdx(), "");
			}

			List<Integer> stock_list = product_dao.product_stock_list(vo.getIdx());
			int j;
			for (j = 0; j < stock_list.size(); j++) {
				if (stock_list.get(j) != 0) {
					break;
				}
			}
			if (j == stock_list.size()) {
				SOLD_OUT.put(vo.getIdx(), "SOLD_OUT");
			} else {
				SOLD_OUT.put(vo.getIdx(), "");
			}

		}

		model.addAttribute("NEW", NEW);
		model.addAttribute("HOT", HOT);
		model.addAttribute("SOLD_OUT", SOLD_OUT);
		model.addAttribute("size_str_map", size_str_map);
		model.addAttribute("list", list);
		model.addAttribute("search", search1);
		return PageUtil.Board.VIEW_PATH_P + "product_search_list.jsp";

	}


	@RequestMapping("product_order_form.do")
	public String product_order_form(Model model, Buy_oneVO vo) {
		vo.setTotal_price(vo.getC_cnt() * vo.getP_saleprice());
		System.out.println(vo.getP_saleprice());
		List<Buy_oneVO> list = new ArrayList<Buy_oneVO>();
		list.add(vo);
		model.addAttribute("list", list);
		model.addAttribute("check", 1);
		this.b_vo = vo;
		return VIEW_PATH_P + "product_order_form.jsp";
	}

	@RequestMapping("order_one.do")
	public String order_one(OrdersVO o_vo, double usePoint, double addPoint) {

		CashVO c_vo = new CashVO();
		PointVO p_vo = new PointVO();
		UserVO u_vo = new UserVO();
		// 주문정보 저장
		int o_res = orders_dao.orders_insert(o_vo);

		c_vo.setU_idx(o_vo.getU_idx());
		c_vo.setAmount(o_vo.getO_total());
		// 주문 건수에 대한 적립금 사용 내역저장, 유저번호 가지고나오기
		int[] res = orders_dao.cash_insert(o_vo);

		// 적립금 사용내역 추가
		p_vo.setU_idx(o_vo.getU_idx());
		p_vo.setO_idx(res[1]);
		p_vo.setAmount((int) usePoint);
		int p_res1 = orders_dao.use_point(p_vo);

		// 적립금 적립내역 추가
		p_vo.setAmount((int) addPoint);
		int p_res2 = orders_dao.add_point(p_vo);
		// 해당 주문건수에 대한 상품구매내역 추가
		history_dao.history_insert(b_vo, res[1]);
		// 유저 적립금, 예치금 정보 수정

		// idx로 된 유저 객체 하나 가져오기
		u_vo = user_dao.select_one_idx(o_vo.getU_idx());
		// 기존 예치금에서 주문한 금액 빼고 업데이트
		u_vo.setCash(u_vo.getCash() - o_vo.getO_total());
		int u_cash_res = user_dao.use_cash(u_vo);

		// 사용한 포인트 빼주기
		u_vo.setPoint(u_vo.getPoint() - ((int) usePoint));
		int u_usePoint_res = user_dao.use_point(u_vo);

		// 적립된 포인트 넣고, 누적이용금액 올리기
		u_vo.setPoint(u_vo.getPoint() + ((int) addPoint));
		u_vo.setTotal_pay(u_vo.getTotal_pay() + o_vo.getO_total());
		int u_addPoint_res = user_dao.add_point(u_vo);

		// 주문 완료된 상품 수량 수정
		p_inform_dao.order_complete(b_vo);

		// 주문 완료된 상품 판매량 수정
		orders_dao.update_p_sold(b_vo);

		// 세션 유저 덮어씌우기
		u_vo = user_dao.select_one_idx(o_vo.getU_idx());
		if (u_vo.getTotal_pay() > 50000 && u_vo.getTotal_pay() <= 100000) {
			u_vo.setMembership("gold");
			user_dao.update_membership(u_vo);
		} else if (u_vo.getTotal_pay() > 100000) {
			u_vo.setMembership("vip");
			user_dao.update_membership(u_vo);
		}
		session.setAttribute("user", u_vo);
		session.setMaxInactiveInterval(60 * 60);
		return "redirect:mypage_form.do";
	}
}
