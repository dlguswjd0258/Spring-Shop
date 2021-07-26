package controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import dao.P_informDAO;
import vo.P_informVO;
import vo.ProductVO;

@Controller
public class P_informController {
	public static final String VIEW_PATH_U = "/WEB-INF/views/user/";
	public static final String VIEW_PATH_P = "/WEB-INF/views/product/";
	public static final String VIEW_PATH_H = "/WEB-INF/views/history/";
	public static final String VIEW_PATH_R = "/WEB-INF/views/review/";
	public static final String VIEW_PATH_C = "/WEB-INF/views/cart/";

	P_informDAO p_inform_dao;

	public void setP_inform_dao(P_informDAO p_inform_dao) {
		this.p_inform_dao = p_inform_dao;
	}

	

	// 수정 취소시 상품 사이즈, 색상 삭제
	@RequestMapping("/p_inform_delete.do")
	public String p_inform_delete(String idx_s) {
		String[] idx = idx_s.split(",");

		for (int i = 0; i < idx.length; i++) {
			p_inform_dao.p_inform_delete(Integer.parseInt(idx[i]));
		}

		return "redirect:product_list_form.do";
	}
}
