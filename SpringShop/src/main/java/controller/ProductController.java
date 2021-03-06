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

	// ???????????? ??????
	@RequestMapping(value = { "/", "/main.do" })
	public String mainPage(Model model, String page) {

		// 2020.06.29 EDITED
		// ????????? ???????????? ?????? show????????? ?????????
		if (request.getSession().getAttribute("user") == null) {
			for (int i = 0; i < public_sessionList.size(); i++) {
				request.getSession().removeAttribute(public_sessionList.get(i));
			}
		}

		// main.do?page=1
		// main.do
		int nowPage = 1;// ???????????????
		if (page != null && !page.isEmpty()) {
			nowPage = Integer.parseInt(page);
		}

		// ??? ???????????? ???????????? ???????????? ????????? ??? ????????? ??????
		int start = (nowPage - 1) * util.FloatPageUtil.FloatBoard.BLOCKLIST + 1;
		int end = (start + FloatPageUtil.FloatBoard.BLOCKLIST) - 1;

		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("start", start);
		map.put("end", end);

		// ???????????? ????????? ???????????? ????????????
		List<ProductVO> product_list = null;
		product_list = product_dao.page_product_list(map);

		// ?????? ?????? ??? ?????????
		int row_total = product_dao.product_count();

		// ?????? ??????????????? ????????????
		String pageMenu = FloatPaging.FloatgetPaging("main.do", nowPage, row_total, FloatPageUtil.FloatBoard.BLOCKLIST,
				FloatPageUtil.FloatBoard.BLOCKPAGE);

		request.setAttribute("list", product_list);
		request.setAttribute("pageMenu", pageMenu);

		Map<Integer, List<String>> color_map = new HashMap<Integer, List<String>>();
		for (int i = 0; i < product_list.size(); i++) {
			int curr_p_idx = product_list.get(i).getIdx();
			List<String> color_list = product_dao.product_color_list(curr_p_idx);

			// ????????? ??????
			for (int j = 0; j < color_list.size() - 1; j++) {
				for (int k = j + 1; k < color_list.size(); k++) {
					if (color_list.get(j).equals(color_list.get(k))) {
						color_list.remove(k);
						// 2020.06.26 EDITED
						k--;
					}
				}
			}

			// ??? idx??? ???????????? ?????? ?????? ??????
			color_map.put(curr_p_idx, color_list);
		}

		model.addAttribute("color_map", color_map);

		// 2020.06.29 EDITED
		// ????????? ?????? ~ ????????? ?????????
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

			// ????????? ??????
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
					// ??????, ????????? ?????????
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
			// ??? idx??? ???????????? ????????? ?????? ??????
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
			// ????????? ???????????? ????????????
			if ((curr_time - upload_time) / 1000 < 604800) {
				NEW.put(vo.getIdx(), "NEW");
			} else {
				NEW.put(vo.getIdx(), "");
			}

			// ??????????????? 100?????? ????????????
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

	// ?????? ?????? ??? ??????
	@RequestMapping("/product_insert_form.do")
	public String product_insert_form() {
		return PageUtil.Board.VIEW_PATH_P + "product_insert_form.jsp";
	}

	// ?????? db??? ??????(insert)
	@RequestMapping("/product_insert.do")
	public String product_insert(Model model, ProductVO vo) {
		String p_content = vo.getP_content().replace("\n", "<br>");

		vo.setP_content(p_content);

		String webpath = "/resources/upload/";
		String savePath = application.getRealPath(webpath);
		System.out.println(savePath);

		// ???????????? ????????? ??????
		MultipartFile p_image_s = vo.getP_image_s();
		MultipartFile p_image_l = vo.getP_image_l();
		String filename_s = "no_file";
		String filename_l = "no_file";

		// ????????? ??? ????????? ????????? ???????????????
		if (!p_image_s.isEmpty() && !p_image_l.isEmpty()) {
			filename_s = p_image_s.getOriginalFilename();// ????????? ??? ?????? ?????????
			filename_l = p_image_l.getOriginalFilename();// ????????? ??? ?????? ?????????
			// ????????? ?????? ?????? ??????
			File saveFile_s = new File(savePath, filename_s);
			File saveFile_l = new File(savePath, filename_l);
			if (!saveFile_s.exists()) {
				saveFile_s.mkdirs();// ?????? ?????? ??????
			} else {
				// ?????? ????????? ????????? ????????? ?????? ?????? ????????? ????????? ????????? ????????? ??????
				long time = System.currentTimeMillis();
				filename_s = String.format("%d_%s", time, filename_s);
				saveFile_s = new File(savePath, filename_s);
			}
			if (!saveFile_l.exists()) {
				saveFile_l.mkdirs();// ?????? ?????? ??????
			} else {
				// ?????? ????????? ????????? ????????? ?????? ?????? ????????? ????????? ????????? ????????? ??????
				long time = System.currentTimeMillis();
				filename_l = String.format("%d_%s", time, filename_l);
				saveFile_l = new File(savePath, filename_l);
			}
			try {
				// ???????????? ????????? MultipartResolver?????? ???????????? ????????????
				// ?????????????????? ?????????, ?????? ???????????? ????????? ?????? ????????? ????????? ???????????? ?????????
				// ?????? ???????????? savePath????????? ???????????????
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
		//????????? ????????? ???????????? ????????????
		int res = product_dao.product_insert(product_vo);
		this.product_idx = product_dao.product_idx_select(product_vo.getP_name());
		// db??? ???????????? ??? ?????????,????????? ???????????? ????????? ????????? ??? ????????? ??????
		// ???????????? ????????? ????????? ????????? ???????????? ????????? ???????????? ?????? update????????????
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
		// db??? ???????????? ??? ?????????,????????? ???????????? ????????? ????????? ??? ????????? ??????
		// ???????????? ????????? ????????? ????????? ???????????? ????????? ???????????? ?????? update????????????
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
			// ???????????? ?????????
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
				// ?????? ?????? ??????????????? ??????
				int res = product_dao.review_written(idx, uservo.getIdx());
				if (res > 0) {
					review_writable = "no";
				}
			}
			model.addAttribute("review_writable", review_writable);

			// ?????? ??????????????? ??????
			if (r_idx != null && !r_idx.isEmpty()) {
				ReviewVO r_vo = product_dao.get_review(Integer.parseInt(r_idx));
				model.addAttribute("r_content_fortxt", r_vo.getContent());

				r_vo.setContent(r_vo.getContent().replaceAll("\n", "<br>"));
				model.addAttribute("r_content", r_vo.getContent());

				// 2020.06.29 EDITED
				// ??????????????? ?????? ?????????
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
			// ????????? ???????????? ????????????
			if ((curr_time - upload_time) / 1000 < 604800) {
				System.out.println(vo.getIdx());
				model.addAttribute("NEW", "NEW");
			} else {
				model.addAttribute("NEW", "");
			}

			// ??????????????? 100?????? ????????????
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

			// ????????? ????????? ??????
			int nowPage = 1;// ???????????????
			if (page != null && !page.isEmpty()) {
				nowPage = Integer.parseInt(page);
			}

			int start = (nowPage - 1) * PageUtil.Board.BLOCKLIST + 1;
			int end = (start + PageUtil.Board.BLOCKLIST) - 1;

			Map<String, Integer> map = new HashMap<String, Integer>();
			map.put("start", start);
			map.put("end", end);
			map.put("idx", idx);

			// ????????? ???????????? ????????????
			List<ReviewVO> list = product_dao.review_list_paging(map);

			// ??????????????? ??? ?????????
			int row_total = product_dao.getRowTotal(idx);
			model.addAttribute("review_num", row_total);

			// ?????? ??????????????? ????????????
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
				// ????????? ???????????? ????????????
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
	// ?????? ???????????? ?????? ????????? ?????? ?????? ?????? ??????
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

	// ????????? ????????????
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

	// ????????? ?????? ????????? ??? ??????
	@RequestMapping("/product_list_form.do")
	public String product_list_form(Model model, String page, String category) {
		// main.do?page=1
		// main.do
		int nowPage = 1;// ???????????????
		if (page != null && !page.isEmpty()) {
			nowPage = Integer.parseInt(page);
		}

		// ??? ???????????? ???????????? ???????????? ????????? ??? ????????? ??????
		int start = (nowPage - 1) * util.ProductListManagerPageUtil.Board.BLOCKLIST + 1;
		int end = (start + ProductListManagerPageUtil.Board.BLOCKLIST) - 1;

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("start", start);
		map.put("end", end);

		// ???????????? ????????? ???????????? ????????????
		List<ProductVO> product_list = null;
		int row_total = 0;
		
		if (category == null || category.isEmpty() || category.equals("???????????? ??????")) {
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

		// ?????? ??????????????? ????????????
		String pageMenu = ProductListManagerPaging.getPaging("product_list_form.do", nowPage, category, row_total, ProductListManagerPageUtil.Board.BLOCKLIST,
				ProductListManagerPageUtil.Board.BLOCKPAGE);

		model.addAttribute("list", product_list);
		model.addAttribute("pageMenu", pageMenu);
		
		return PageUtil.Board.VIEW_PATH_P + "product_list_form.jsp";
	}

	// ?????? ?????? ????????? ????????? ?????? ??????????????? ????????? ????????? ????????? ??????(ex top,shirts, pants)???
	// ??????????????? ????????? ??? = view??? ??????
	@RequestMapping("view_list.do")
	public String view_list(Model model, String view_name, String page) {

		// main.do?page=1
		// main.do
		int nowPage = 1;// ???????????????
		if (page != null && !page.isEmpty()) {
			nowPage = Integer.parseInt(page);
		}

		// ??? ???????????? ???????????? ???????????? ????????? ??? ????????? ??????
		int start = (nowPage - 1) * util.ViewPageUtil.FloatBoard.BLOCKLIST + 1;
		int end = (start + ViewPageUtil.FloatBoard.BLOCKLIST) - 1;

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("start", start);
		map.put("end", end);
		System.out.println(view_name);
		map.put("view_name", view_name);

		// ???????????? ????????? ???????????? ????????????
		List<ProductVO> view_list = product_dao.page_view_list(map);

		// ?????? ?????? ??? ?????????
		int row_total = product_dao.view_count(view_name);

		// ?????? ??????????????? ????????????
		String pageMenu = ViewPaging.FloatgetPaging("view_list.do", nowPage, view_name, row_total,
				ViewPageUtil.FloatBoard.BLOCKLIST, ViewPageUtil.FloatBoard.BLOCKPAGE);

		model.addAttribute("list", view_list);
		model.addAttribute("pageMenu", pageMenu);

		Map<Integer, List<String>> color_map = new HashMap<Integer, List<String>>();
		for (int i = 0; i < view_list.size(); i++) {
			int curr_p_idx = view_list.get(i).getIdx();
			List<String> color_list = product_dao.product_color_list(curr_p_idx);

			// ????????? ??????
			for (int j = 0; j < color_list.size() - 1; j++) {
				for (int k = j + 1; k < color_list.size(); k++) {
					if (color_list.get(j).equals(color_list.get(k))) {
						color_list.remove(k);
						// 2020.06.26 EDITED
						k--;
					}
				}
			}

			// ??? idx??? ???????????? ?????? ?????? ??????
			color_map.put(curr_p_idx, color_list);
		}

		model.addAttribute("color_map", color_map);

		// 2020.06.29 EDITED
		// ????????? ?????? ~ ????????? ?????????
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

			// ????????? ??????
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
					// ??????, ????????? ?????????
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
			// ??? idx??? ???????????? ????????? ?????? ??????
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
			// ????????? ???????????? ????????????
			if ((curr_time - upload_time) / 1000 < 604800) {
				NEW.put(vo.getIdx(), "NEW");
			} else {
				NEW.put(vo.getIdx(), "");
			}

			// ??????????????? 100?????? ????????????
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
		int nowPage = 1;// ???????????????
		if (page != null && !page.isEmpty()) {
			nowPage = Integer.parseInt(page);
		}

		// ??? ???????????? ???????????? ???????????? ????????? ??? ????????? ??????
		int start = (nowPage - 1) * util.CategoryPageUtil.FloatBoard.BLOCKLIST + 1;
		int end = (start + CategoryPageUtil.FloatBoard.BLOCKLIST) - 1;

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("start", start);
		map.put("end", end);

		// ???????????? ????????? ???????????? ????????????
		List<ProductVO> category_list = null;

		for (int i = 0; i < category.length(); i++) {
			if (category.charAt(i) == ',') {
				param = category.replace(",", "&");
			}
		}

		// ?????? ?????? ??? ?????????
		int row_total;
		if (category.contains(",")) {
			map.put("category", param);
			row_total = product_dao.category_count(param);
		} else {
			map.put("category", category);
			row_total = product_dao.category_count(category);
		}
		category_list = product_dao.page_category_list(map);

		// ?????? ??????????????? ????????????
		String pageMenu = CategoryPaging.FloatgetPaging("category_list.do", nowPage, category, row_total,
				CategoryPageUtil.FloatBoard.BLOCKLIST, CategoryPageUtil.FloatBoard.BLOCKPAGE);

		model.addAttribute("list", category_list);
		model.addAttribute("pageMenu", pageMenu);

		Map<Integer, List<String>> color_map = new HashMap<Integer, List<String>>();
		for (int i = 0; i < category_list.size(); i++) {
			int curr_p_idx = category_list.get(i).getIdx();
			List<String> color_list = product_dao.product_color_list(curr_p_idx);

			// ????????? ??????
			for (int j = 0; j < color_list.size() - 1; j++) {
				for (int k = j + 1; k < color_list.size(); k++) {
					if (color_list.get(j).equals(color_list.get(k))) {
						color_list.remove(k);
						// 2020.06.26 EDITED
						k--;
					}
				}
			}

			// ??? idx??? ???????????? ?????? ?????? ??????
			color_map.put(curr_p_idx, color_list);
		}

		model.addAttribute("color_map", color_map);

		// 2020.06.29 EDITED
		// ????????? ?????? ~ ????????? ?????????
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

			// ????????? ??????
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
				// ??????, ????????? ?????????
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
			// ??? idx??? ???????????? ????????? ?????? ??????
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
			// ????????? ???????????? ????????????
			if ((curr_time - upload_time) / 1000 < 604800) {
				System.out.println(vo.getIdx());
				NEW.put(vo.getIdx(), "NEW");
			} else {
				NEW.put(vo.getIdx(), "");
			}

			// ??????????????? 100?????? ????????????
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
	// ????????? ?????? ?????? (p_del = 1??? ??????)
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
	// ?????? ?????? ??? ??????
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
	// ?????? ??????
	@RequestMapping("/product_update.do")
	public String product_update(Model model, ProductVO product_vo, P_informVO p_inform_vo) {
		String p_content = product_vo.getP_content().replace("\n", "<br>");
		product_vo.setP_content(p_content);

		String webpath = "/resources/upload/";
		String savePath = application.getRealPath(webpath);
		System.out.println(savePath);

		MultipartFile p_image_s = product_vo.getP_image_s();
		MultipartFile p_image_l = product_vo.getP_image_l();

		// ???????????? ?????? ???(s)
		if (p_image_s.getSize() != 0) {
			String filename_s = "no_file";
			if (!p_image_s.isEmpty()) {
				// ?????? ??????
				File removeFile_s = new File(savePath, product_vo.getFilename_s());
				removeFile_s.delete();

				filename_s = p_image_s.getOriginalFilename();// ????????? ??? ?????? ?????????
				// ????????? ?????? ?????? ??????
				File saveFile_s = new File(savePath, filename_s);
				if (!saveFile_s.exists()) {
					saveFile_s.mkdirs();// ?????? ?????? ??????
				} else {
					// ?????? ????????? ????????? ????????? ?????? ?????? ????????? ????????? ????????? ????????? ??????
					long time = System.currentTimeMillis();
					filename_s = String.format("%d_%s", time, filename_s);
					saveFile_s = new File(savePath, filename_s);
				}

				try {
					// ???????????? ????????? MultipartResolver?????? ???????????? ????????????
					// ?????????????????? ?????????, ?????? ???????????? ????????? ?????? ????????? ????????? ???????????? ?????????
					// ?????? ???????????? savePath????????? ???????????????
					p_image_s.transferTo(saveFile_s);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			product_vo.setFilename_s(filename_s);
		}

		// ???????????? ?????? ???(l)
		if (p_image_l.getSize() != 0) {
			String filename_l = "no_file";
			if (!p_image_l.isEmpty()) {
				// ?????? ??????
				File removeFile_l = new File(savePath, product_vo.getFilename_l());
				removeFile_l.delete();

				filename_l = p_image_l.getOriginalFilename();// ????????? ??? ?????? ?????????
				File saveFile_l = new File(savePath, filename_l);
				if (!saveFile_l.exists()) {
					saveFile_l.mkdirs();// ?????? ?????? ??????
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
			if (!p_inform_idx[i].equals("??????")) {
				vo.setI_idx(Integer.parseInt(p_inform_idx[i]));
				vo.setI_size(p_inform_size[i]);
				vo.setColor(p_inform_color[i]);
				vo.setI_stock(Integer.parseInt(p_inform_stock[i]));

				p_inform_dao.p_inform_update(vo);
			} else { // ?????? ??????
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

		int nowPage = 1;// ???????????????
		if (page != null && !page.isEmpty()) {
			nowPage = Integer.parseInt(page);
		}

		int start = (nowPage - 1) * util.FloatPageUtil.FloatBoard.BLOCKLIST + 1;
		int end = (start + FloatPageUtil.FloatBoard.BLOCKLIST) - 1;

		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("start", start);
		map.put("end", end);

		// ???????????? ????????? ???????????? ????????????
		List<ProductVO> product_list = null;
		product_list = product_dao.page_product_list(map);

		// ?????? ?????? ??? ?????????
		int row_total = product_dao.product_count();

		// ?????? ??????????????? ????????????
		String pageMenu = FloatPaging.FloatgetPaging("main.do", nowPage, row_total, FloatPageUtil.FloatBoard.BLOCKLIST,
				FloatPageUtil.FloatBoard.BLOCKPAGE);

		request.setAttribute("list", product_list);
		request.setAttribute("pageMenu", pageMenu);

		Map<Integer, List<String>> color_map = new HashMap<Integer, List<String>>();
		for (int i = 0; i < product_list.size(); i++) {
			int curr_p_idx = product_list.get(i).getIdx();
			List<String> color_list = product_dao.product_color_list(curr_p_idx);

			// ????????? ??????
			for (int j = 0; j < color_list.size() - 1; j++) {
				for (int k = j + 1; k < color_list.size(); k++) {
					if (color_list.get(j).equals(color_list.get(k))) {
						color_list.remove(k);
						// 2020.06.26 EDITED
						k--;
					}
				}
			}

			// ??? idx??? ???????????? ?????? ?????? ??????
			color_map.put(curr_p_idx, color_list);
		}

		model.addAttribute("color_map", color_map);

		// 2020.06.29 EDITED
		// ????????? ?????? ~ ????????? ?????????
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

			// ????????? ??????
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
					// ??????, ????????? ?????????
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
			// ??? idx??? ???????????? ????????? ?????? ??????
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
			// ????????? ???????????? ????????????
			if ((curr_time - upload_time) / 1000 < 604800) {
				NEW.put(vo.getIdx(), "NEW");
			} else {
				NEW.put(vo.getIdx(), "");
			}

			// ??????????????? 100?????? ????????????
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
		// ???????????? ??????
		int o_res = orders_dao.orders_insert(o_vo);

		c_vo.setU_idx(o_vo.getU_idx());
		c_vo.setAmount(o_vo.getO_total());
		// ?????? ????????? ?????? ????????? ?????? ????????????, ???????????? ??????????????????
		int[] res = orders_dao.cash_insert(o_vo);

		// ????????? ???????????? ??????
		p_vo.setU_idx(o_vo.getU_idx());
		p_vo.setO_idx(res[1]);
		p_vo.setAmount((int) usePoint);
		int p_res1 = orders_dao.use_point(p_vo);

		// ????????? ???????????? ??????
		p_vo.setAmount((int) addPoint);
		int p_res2 = orders_dao.add_point(p_vo);
		// ?????? ??????????????? ?????? ?????????????????? ??????
		history_dao.history_insert(b_vo, res[1]);
		// ?????? ?????????, ????????? ?????? ??????

		// idx??? ??? ?????? ?????? ?????? ????????????
		u_vo = user_dao.select_one_idx(o_vo.getU_idx());
		// ?????? ??????????????? ????????? ?????? ?????? ????????????
		u_vo.setCash(u_vo.getCash() - o_vo.getO_total());
		int u_cash_res = user_dao.use_cash(u_vo);

		// ????????? ????????? ?????????
		u_vo.setPoint(u_vo.getPoint() - ((int) usePoint));
		int u_usePoint_res = user_dao.use_point(u_vo);

		// ????????? ????????? ??????, ?????????????????? ?????????
		u_vo.setPoint(u_vo.getPoint() + ((int) addPoint));
		u_vo.setTotal_pay(u_vo.getTotal_pay() + o_vo.getO_total());
		int u_addPoint_res = user_dao.add_point(u_vo);

		// ?????? ????????? ?????? ?????? ??????
		p_inform_dao.order_complete(b_vo);

		// ?????? ????????? ?????? ????????? ??????
		orders_dao.update_p_sold(b_vo);

		// ?????? ?????? ???????????????
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
