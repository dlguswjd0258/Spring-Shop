package controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import dao.HistoryDAO;
import dao.OrdersDAO;
import util.FloatPageUtil;
import util.FloatPaging;
import util.HistoryPaging;
import util.PageUtil;
import vo.CashVO;
import vo.HistoryVO;
import vo.OrdersVO;
import vo.PointVO;
import vo.ProductVO;
import vo.ReviewVO;
import vo.UserVO;

@Controller
public class HistoryController {

	@Autowired
	HttpServletRequest request;

	@Autowired
	HttpSession session;

	HistoryDAO history_dao;
	OrdersDAO orders_dao;
	UserVO u_vo;
	int u_idx;

	public void setOrders_dao(OrdersDAO orders_dao) {
		this.orders_dao = orders_dao;
	}

	public void setHistory_dao(HistoryDAO history_dao) {
		this.history_dao = history_dao;
	}

	@RequestMapping("/mypage_form.do")
	public String mypage_form(Model model) {
		u_vo = (UserVO) session.getAttribute("user");
		if (u_vo != null) {
			u_idx = u_vo.getIdx();

			// delivery 갱신
			history_dao.delivery_update(u_idx);

			Map<String, Integer> map = new HashMap<String, Integer>();
			map.put("start", 1);
			map.put("end", 3);
			map.put("u_idx", u_idx);
			List<HistoryVO> h_list = history_dao.select_list(map);
			model.addAttribute("h_list", h_list);
		}
		return PageUtil.Board.VIEW_PATH_H + "mypage_form.jsp";
	}

	// 200630
	@RequestMapping("/myhistory_form.do")
	public String myhistory_form(Model model, String page) {
		// delivery 갱신
		history_dao.delivery_update(u_idx);
		// main.do?page=1
		// main.do
		int nowPage = 1;// 기본페이지
		if (page != null && !page.isEmpty()) {
			nowPage = Integer.parseInt(page);
		}

		// 한 페이지에 표시되는 게시물의 시작과 끝 번호를 계산
		int start = (nowPage - 1) * PageUtil.Histroy.BLOCKLIST + 1;
		int end = (start + PageUtil.Histroy.BLOCKLIST) - 1;

		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("start", start);
		map.put("end", end);
		map.put("u_idx", u_idx);

		List<HistoryVO> list = history_dao.select_list(map);
		List<List<HistoryVO>> b_list = new ArrayList<List<HistoryVO>>();

		if (!list.isEmpty()) {

			List<HistoryVO> temp_list = new ArrayList<HistoryVO>();
			temp_list.add(list.get(0));
			int o_idx = list.get(0).getO_idx();

			// 같은 주문번호인 것들끼리 묶기
			for (int i = 1; i < list.size(); i++) {
				if (o_idx == list.get(i).getO_idx()) {
					temp_list.add(list.get(i));
				} else {
					b_list.add(temp_list);
					temp_list = new ArrayList<HistoryVO>();
					temp_list.add(list.get(i));
					o_idx = list.get(i).getO_idx();
				}
			}
			b_list.add(temp_list);
		}

		model.addAttribute("b_list", b_list);

		int row_total = history_dao.history_count(u_idx);

		// 하단 페이지메뉴 생성하기
		String pageMenu = FloatPaging.FloatgetPaging("myhistory_form.do", nowPage, row_total,
				PageUtil.Histroy.BLOCKLIST, PageUtil.Histroy.BLOCKPAGE);

		request.setAttribute("pageMenu", pageMenu);

		return PageUtil.Board.VIEW_PATH_H + "myhistory_form.jsp";
	}

	@RequestMapping("/myhistory_detail_form.do")
	public String myhistory_detail_form(Model model, int o_idx) {
		// delivery 갱신
		history_dao.delivery_update(u_idx);
		OrdersVO o_vo = orders_dao.select_orders_one(o_idx);
		PointVO p_vo = orders_dao.select_point_one(o_idx);
		List<HistoryVO> h_list = history_dao.select_detail_list(o_idx);

		int p_total = 0;
		int sale_total = 0;

		for (HistoryVO vo : h_list) {
			p_total += vo.getP_price() * vo.getP_cnt();
			sale_total += vo.getP_saleprice() * vo.getP_cnt();
		}
		int s_price = p_total - sale_total;

		model.addAttribute("o_vo", o_vo);
		model.addAttribute("p_vo", p_vo);
		model.addAttribute("h_list", h_list);
		model.addAttribute("p_total", p_total);
		model.addAttribute("s_price", s_price);

		return PageUtil.Board.VIEW_PATH_H + "myhistory_detail_form.jsp";
	}

	@RequestMapping("/myarticle_form.do")
	public String myarticle_form(Model model, String page) {
		//delivery 갱신
		history_dao.delivery_update(u_idx);
		
		// main.do?page=1
		// main.do
		int nowPage = 1;// 기본페이지
		if (page != null && !page.isEmpty()) {
			nowPage = Integer.parseInt(page);
		}

		// 한 페이지에 표시되는 게시물의 시작과 끝 번호를 계산
		int start = (nowPage - 1) * PageUtil.Histroy.BLOCKLIST + 1;
		int end = (start + PageUtil.Histroy.BLOCKLIST) - 1;

		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("start", start);
		map.put("end", end);
		map.put("u_idx", u_idx);
		
		List<ReviewVO> r_list = history_dao.select_review_list( map );
		List<List<ReviewVO>> dat_list = new ArrayList<List<ReviewVO>>();
		for(ReviewVO r : r_list) {
			String content = r.getContent().replaceAll("\n", "<br>");
			r.setContent(content);
			dat_list.add(history_dao.select_dat_list(r.getIdx()));
		}
		List<ProductVO> p_list = new ArrayList<ProductVO>();
		
		for(ReviewVO vo: r_list) {
			 p_list.add(history_dao.select_product(vo.getP_idx()));
		}
		model.addAttribute("r_list", r_list);
		model.addAttribute("p_list", p_list);
		model.addAttribute("dat_list", dat_list);
		
		int row_total = history_dao.review_count(u_idx);
		
		// 하단 페이지메뉴 생성하기
		String pageMenu = FloatPaging.FloatgetPaging("myarticle_form.do", nowPage, row_total, PageUtil.Histroy.BLOCKLIST,
				PageUtil.Histroy.BLOCKPAGE);

		model.addAttribute("pageMenu", pageMenu);
		
		
		return PageUtil.Board.VIEW_PATH_H + "myarticle_form.jsp";
	}

	// 200706
	@RequestMapping("/mypoint_form.do")
	public String mypoint_form(Model model, String save_page, String use_page) {
		int save_nowPage = 1, use_nowPage = 1;// 기본페이지
		if (save_page != null && !save_page.isEmpty()) {
			save_nowPage = Integer.parseInt(save_page);
		}

		if (use_page != null && !use_page.isEmpty()) {
			use_nowPage = Integer.parseInt(use_page);
		}

		// save 페이지 처리
		// save의 한 페이지에 표시되는 게시물의 시작과 끝 번호를 계산
		int start = (save_nowPage - 1) * PageUtil.Histroy.BLOCKLIST + 1;
		int end = (start + PageUtil.Histroy.BLOCKLIST) - 1;

		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("start", start);
		map.put("end", end);
		map.put("u_idx", u_idx);

		List<PointVO> save_list = history_dao.select_point_save(map);

		// use 페이지 처리
		start = (use_nowPage - 1) * PageUtil.Histroy.BLOCKLIST + 1;
		end = (start + PageUtil.Histroy.BLOCKLIST) - 1;

		map = new HashMap<String, Integer>();
		map.put("start", start);
		map.put("end", end);
		map.put("u_idx", u_idx);

		List<PointVO> use_list = history_dao.select_point_use(map);

		int use_point = 0;
		for (PointVO vo : use_list) {
			use_point += vo.getAmount();
		}

		int save_row_total = history_dao.point_save_count(u_idx);
		int use_row_total = history_dao.point_use_count(u_idx);

		// 하단 페이지메뉴 생성하기
		List<String> pageMenu = HistoryPaging.FloatgetPaging("mypoint_form.do", save_nowPage, save_row_total,
				use_nowPage, use_row_total, PageUtil.Histroy.BLOCKLIST, PageUtil.Histroy.BLOCKPAGE);

		request.setAttribute("pageMenu", pageMenu);

		model.addAttribute("save_list", save_list);
		model.addAttribute("use_list", use_list);
		model.addAttribute("use_point", use_point);

		return PageUtil.Board.VIEW_PATH_H + "mypoint_form.jsp";
	}

	// 200706
	@RequestMapping("/mycash_form.do")
	public String mycash_form(Model model, String save_page, String use_page) {
		int save_nowPage = 1, use_nowPage = 1;// 기본페이지
		if (save_page != null && !save_page.isEmpty()) {
			save_nowPage = Integer.parseInt(save_page);
		}

		if (use_page != null && !use_page.isEmpty()) {
			use_nowPage = Integer.parseInt(use_page);
		}

		// save 페이지 처리
		// save의 한 페이지에 표시되는 게시물의 시작과 끝 번호를 계산
		int start = (save_nowPage - 1) * PageUtil.Histroy.BLOCKLIST + 1;
		int end = (start + PageUtil.Histroy.BLOCKLIST) - 1;

		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("start", start);
		map.put("end", end);
		map.put("u_idx", u_idx);

		List<CashVO> save_list = history_dao.select_cash_save(map);

		// use 페이지 처리
		start = (use_nowPage - 1) * PageUtil.Histroy.BLOCKLIST + 1;
		end = (start + PageUtil.Histroy.BLOCKLIST) - 1;

		map = new HashMap<String, Integer>();
		map.put("start", start);
		map.put("end", end);
		map.put("u_idx", u_idx);

		List<CashVO> use_list = history_dao.select_cash_use(map);

		int use_cash = 0;
		for (CashVO vo : use_list) {
			use_cash += vo.getAmount();
		}

		int save_row_total = history_dao.cash_save_count(u_idx);
		int use_row_total = history_dao.cash_use_count(u_idx);

		// 하단 페이지메뉴 생성하기
		List<String> pageMenu = HistoryPaging.FloatgetPaging("mycash_form.do", save_nowPage, save_row_total,
				use_nowPage, use_row_total, PageUtil.Histroy.BLOCKLIST, PageUtil.Histroy.BLOCKPAGE);

		request.setAttribute("pageMenu", pageMenu);

		model.addAttribute("save_list", save_list);
		model.addAttribute("use_list", use_list);
		model.addAttribute("use_cash", use_cash);

		return PageUtil.Board.VIEW_PATH_H + "mycash_form.jsp";
	}

	// 200706
	@RequestMapping("/cash_update.do")
	@ResponseBody
	public String cash_update(int u_idx, int cash) {
		String result = "no";
		UserVO vo = new UserVO();
		vo.setIdx(u_idx);
		vo.setCash(cash);

		// users 테이블 변경
		int res = history_dao.cash_update(vo);
		if (res > 0) {
			CashVO c_vo = new CashVO();
			c_vo.setAmount(cash);
			c_vo.setU_idx(u_idx);

			// cash 테이블 추가
			history_dao.cash_insert(c_vo);

			// session에 담긴 user도 update
			UserVO user = (UserVO) session.getAttribute("user");
			user.setCash(user.getCash() + cash);
			session.setAttribute("user", user);

			result = "yes";
		}

		return result;
	}
}
