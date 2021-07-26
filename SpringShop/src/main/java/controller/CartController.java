package controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import dao.CartDAO;
import dao.HistoryDAO;
import dao.OrdersDAO;
import dao.P_informDAO;
import dao.UserDAO;
import util.PageUtil;
import vo.CartVO;
import vo.Cart_viewVO;
import vo.CashVO;
import vo.OrdersVO;
import vo.P_informVO;
import vo.PointVO;
import vo.UserVO;

@Controller
public class CartController {
	
	@Autowired
	HttpSession session;
	
	List<Cart_viewVO> orderList = null;
	
	CartDAO cart_dao;
	OrdersDAO orders_dao;
	HistoryDAO history_dao;
	UserDAO user_dao;
	P_informDAO p_inform_dao;
	
	public void setCart_dao(CartDAO cart_dao) {
		this.cart_dao = cart_dao;
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
	public void setP_inform_dao(P_informDAO p_inform_dao) {
		this.p_inform_dao = p_inform_dao;
	}
	
	//유저 번호로 해당 유저의 장바구니 목록을 불러오기
	@RequestMapping("cart_list.do")
	public String cart_list(Model model, int u_idx) {
		List<Cart_viewVO> list = cart_dao.cart_view_list(u_idx);
		model.addAttribute("list",list);
		return PageUtil.Board.VIEW_PATH_C + "cart_list.jsp";
	}
	
	//장바구니 추가 액션
	//사이즈,컬러가 중복시엔 수량만 업데이트
	@RequestMapping("cart_insert.do")
	@ResponseBody
	public String cart_insert(CartVO vo) {
		
		//받아온 정보를 토대로 동일사이즈,색상의 상품이 존재하는지 검색
		CartVO vo_exist = cart_dao.select_one(vo);
		P_informVO p_vo = new P_informVO();
		p_vo.setRef(vo.getP_idx());
		p_vo.setColor(vo.getP_color());
		p_vo.setI_size(vo.getP_size());
		
		int stock = cart_dao.p_inform_one(p_vo);
		int res;
		String str;
		
		if (vo.getC_cnt() <= 0) {
			str = "tooLow";
		}else {
			if (vo_exist == null) {
				if (stock < vo.getC_cnt()) {
					str = "noStock";
				}else {
					res = cart_dao.cart_insert(vo);
					str = "yes";
				}
			}else {
					str = "already";
			}
		}
		
		return str;
	}
	
	@RequestMapping("cart_delete.do")
	@ResponseBody
	public String cart_delete(int c_idx) {
		int res = cart_dao.delete(c_idx);
		String str = "no";
		if (res != 0) {
			str = "yes";
		}
		return str;
	}
	
	@RequestMapping("cart_modify.do")
	@ResponseBody
	public String cart_modify(CartVO vo) {
		
		//장바구니 idx로 p_idx,color,size값 들고나오기
		P_informVO p_vo = cart_dao.p_inform_select_one(vo);
		
		int stock = cart_dao.p_inform_one(p_vo);
		String str;
		
		if (vo.getC_cnt() <= 0) {
			str = "tooLow";
		}else {
			if (stock < vo.getC_cnt()) {
				str = "noStock";
			}else {
				int res = cart_dao.cart_update(vo);
				str = "yes";
			}
		}
		
		return str;
	}
	
	@RequestMapping("cart_clear.do")
	public String cart_clear(int u_idx) {
		int res = cart_dao.cart_clear(u_idx);
		return "redirect:cart_list.do?u_idx="+u_idx;
	}
	
	//장바구니에서 상품구매 클릭시 주문 폼 이동
	@RequestMapping("cart_order_form.do")
	public String cart_order_form(Model model, int u_idx) {
		List<Cart_viewVO> list = cart_dao.cart_order_list(u_idx);
		model.addAttribute("list",list);
		orderList = list;
		return PageUtil.Board.VIEW_PATH_P + "product_order_form.jsp";
	}
	
	
	//상품주문완료
	@RequestMapping("order.do")
	public String test(OrdersVO o_vo, double usePoint, double addPoint) {
		
		CashVO c_vo = new CashVO();
		PointVO p_vo = new PointVO();
		UserVO u_vo = new UserVO();
		//주문정보 저장
		int o_res = orders_dao.orders_insert(o_vo);
		
		c_vo.setU_idx(o_vo.getU_idx());
		c_vo.setAmount(o_vo.getO_total());
		//주문 건수에 대한 적립금 사용 내역저장, 유저번호 가지고나오기
		int[] res = orders_dao.cash_insert(o_vo);
		
		//적립금 사용내역 추가
		p_vo.setU_idx(o_vo.getU_idx());
		p_vo.setO_idx(res[1]);
		p_vo.setAmount((int)usePoint);
		int p_res1 = orders_dao.use_point(p_vo);
		
		//적립금 적립내역 추가
		p_vo.setAmount((int)addPoint);
		int p_res2 = orders_dao.add_point(p_vo);
		//해당 주문건수에 대한 상품구매내역 추가
		history_dao.history_insert(orderList, res[1]);
		//장바구니 비우기
		int c_res = cart_dao.cart_delete_all(orderList);
		//유저 적립금, 예치금 정보 수정
		
		//idx로 된 유저 객체 하나 가져오기
		u_vo = user_dao.select_one_idx(o_vo.getU_idx());
		//기존 예치금에서 주문한 금액 빼고 업데이트
		u_vo.setCash(u_vo.getCash()-o_vo.getO_total());
		int u_cash_res = user_dao.use_cash(u_vo);
		
		//사용한 포인트 빼주기
		u_vo.setPoint(u_vo.getPoint()-((int)usePoint));
		int u_usePoint_res = user_dao.use_point(u_vo);
		
		//적립된 포인트 넣고, 누적이용금액 올리기 
		u_vo.setPoint(u_vo.getPoint()+((int)addPoint));
		u_vo.setTotal_pay(u_vo.getTotal_pay() + o_vo.getO_total());
		int u_addPoint_res = user_dao.add_point(u_vo);
		
		//주문 완료된 상품 수량 수정
		p_inform_dao.order_complete(orderList);
		
		//주문 완료된 상품 판매량 수정
		orders_dao.update_p_sold(orderList);
		
		//세션 유저 덮어씌우기
		u_vo = user_dao.select_one_idx(o_vo.getU_idx());
		
		//주문완료시 멤버십 등급 확인 후 수정
		if (u_vo.getTotal_pay() > 50000 && u_vo.getTotal_pay() <= 100000) {
			u_vo.setMembership("gold");
			user_dao.update_membership(u_vo);
		}else if (u_vo.getTotal_pay() > 100000) {
			u_vo.setMembership("vip");
			user_dao.update_membership(u_vo);
		}
		session.setAttribute("user", u_vo);
		session.setMaxInactiveInterval(60 * 60);
		return "redirect:mypage_form.do";
	}
}
