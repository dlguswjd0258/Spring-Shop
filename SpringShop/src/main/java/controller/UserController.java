package controller;

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

import dao.UserDAO;
import util.PageUtil;
import util.ProductListManagerPageUtil;
import util.UserListPageUtil;
import util.UserListPaging;
import vo.UserVO;

@Controller
public class UserController {

	@Autowired
	HttpServletRequest request;

	@Autowired
	HttpSession session;

	UserDAO user_dao;

	public void setUser_dao(UserDAO user_dao) {
		this.user_dao = user_dao;
	}

	// 회원가입 폼 이동
	@RequestMapping("/user_insert_form.do")
	public String user_insert_form() {
		return PageUtil.Board.VIEW_PATH_U + "user_insert_form.jsp";
	}

	// 중복체크
	@RequestMapping("/check_id.do")
	@ResponseBody
	public String check_id(String id) {
		UserVO vo = user_dao.select_one(id);

		String result = "yes";
		if (vo != null) {
			result = "no";
		}

		return result;
	}

	//200707
	// 전화번호 중복체크
	@RequestMapping("/check_tel.do")
	@ResponseBody
	public String check_tel(String tel) {
		UserVO vo = user_dao.select_tel(tel);

		String result = "yes";
		if (vo != null) {
			result = "no";
		}

		return result;
	}

	//200707
	// 이메일 중복체크
	@RequestMapping("/check_email.do")
	@ResponseBody
	public String check_email(String email) {
		UserVO vo = user_dao.select_email(email);

		String result = "yes";
		if (vo != null) {
			result = "no";
		}

		return result;
	}

	// 회원가입 등록
	@RequestMapping("/user_insert.do")
	public String user_insert(UserVO vo) {
		user_dao.insert(vo);

		return "redirect:login_form.do?id=" + vo.getId();
	}

	// 아이디 찾기 폼 이동
	@RequestMapping("/id_find_form.do")
	public String id_find_form() {
		return PageUtil.Board.VIEW_PATH_U + "id_find_form.jsp";
	}

	// 아이디 찾기
	@RequestMapping("/id_find.do")
	@ResponseBody
	public String id_find(UserVO vo) {
		String result = "no"; // 찾는 아이디 없음

		UserVO findVo = user_dao.select_id(vo);
		if (findVo != null) {
			result = "id=" + findVo.getId();
		}

		return result;
	}

	// 200627
	// 아이디 알려주는 폼 이동
	@RequestMapping("/id_inform.do")
	public String id_inform(Model model, String id) {
		UserVO vo = user_dao.select_one(id);
		model.addAttribute("vo", vo);
		return PageUtil.Board.VIEW_PATH_U + "id_inform.jsp";
	}

	// 비밀번호 찾기 폼 이동
	@RequestMapping("/pwd_find_form.do")
	public String pwd_find_form() {
		return PageUtil.Board.VIEW_PATH_U + "pwd_find_form.jsp";
	}

	// 비밀번호 찾기
	@RequestMapping("/pwd_find.do")
	@ResponseBody
	public String pwd_find(UserVO vo) {
		String result = "no"; // 찾는 아이디 없음

		UserVO findVo = user_dao.select_id(vo);
		if (findVo != null) {
			result = "idx=" + findVo.getIdx() + "&id=" + findVo.getId();
		}

		return result;
	}

	// 비밀번호 재설정 폼 이동
	@RequestMapping("/pwd_reset_form.do")
	public String pwd_reset_form(int idx, String id) {
		return PageUtil.Board.VIEW_PATH_U + "pwd_reset_form.jsp";
	}

	// 200630
	// 비밀번호 재설정
	@RequestMapping("/pwd_reset.do")
	public String pwd_reset(UserVO vo) {
		user_dao.update_pwd(vo);

		return "redirect:login_form.do?id=" + vo.getId();
	}

	// 로그인 폼 이동
	@RequestMapping("/login_form.do")
	public String login_form() {
		return PageUtil.Board.VIEW_PATH_U + "login_form.jsp";
	}

	// 로그인
	@RequestMapping("/login.do")
	@ResponseBody
	public String login(String id, String pwd, String idx) {
		String result = "no_id";

		UserVO vo = user_dao.select_one(id);

		if (vo != null) {
			if (!pwd.equals(vo.getPwd())) {
				result = "no_pwd";
			} else {
				// 2020.06.26 EDITED
				if (idx.isEmpty() || idx == null) {
					result = "home";
				} else {
					result = idx;
				}
				
				if (vo.getTotal_pay() > 50000 && vo.getTotal_pay() <= 100000) {
					vo.setMembership("gold");
					user_dao.update_membership(vo);
				}else if (vo.getTotal_pay() > 100000) {
					vo.setMembership("vip");
					user_dao.update_membership(vo);
				}
				session.setAttribute("user", vo);
				session.setMaxInactiveInterval(60 * 60); // 1시간동안 유지되는 세션
			}
		}

		return result;
	}

	// 로그아웃
	@RequestMapping("/logout.do")
	public String logout() {
		session.removeAttribute("user");
		session.invalidate();

		return "main.do";
	}

	// 회원 삭제
	@RequestMapping("/user_delete.do")
	@ResponseBody
	public String usert_delete(int idx) {
		String result = "no";

		int res = user_dao.delete(idx);
		if (res != 0) {
			result = "yes";
		}

		return result;
	}

	// 회원 정보 수정 폼 이동
	@RequestMapping("/myinfo_update_form.do")
	public String myinfo_form(Model model, String u_id) {
		UserVO vo = user_dao.select_one(u_id);
		model.addAttribute("vo", vo);
		return PageUtil.Board.VIEW_PATH_U + "myinfo_update_form.jsp";
	}

	// 200707
	// 회원 정보 수정
	@RequestMapping("/myinfo_update.do")
	public String myinfo_update(UserVO vo) {
		user_dao.update(vo);
		
		UserVO user = user_dao.select_one_idx(vo.getIdx());
		session.setAttribute("user", user);
		
		return "redirect:mypage_form.do";
	}
	
	// 회원관리로 가기
	@RequestMapping("/usermanagement.do")
	public String usermanagement(Model model, String page) {
		// main.do?page=1
		// main.do
		int nowPage = 1;// 기본페이지
		if (page != null && !page.isEmpty()) {
			nowPage = Integer.parseInt(page);
		}

		// 한 페이지에 표시되는 게시물의 시작과 끝 번호를 계산
		int start = (nowPage - 1) * util.UserListPageUtil.Board.BLOCKLIST + 1;
		int end = (start + UserListPageUtil.Board.BLOCKLIST) - 1;

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("start", start);
		map.put("end", end);

		// 페이지에 들어갈 상품목록 가져오기
		List<UserVO> list = user_dao.page_selectlist(map);
		int row_total = user_dao.user_count();
		
		// 하단 페이지메뉴 생성하기
		String pageMenu = UserListPaging.getPaging("usermanagement.do", nowPage, row_total, UserListPageUtil.Board.BLOCKLIST,
				UserListPageUtil.Board.BLOCKPAGE);

		model.addAttribute("list", list);
		model.addAttribute("pageMenu", pageMenu);
		
		return PageUtil.Board.VIEW_PATH_U + "user_management.jsp";
	}

	// 회원 권한 수정
	@RequestMapping("/usermodify.do")
	@ResponseBody
	public String modify_user(int idx, int selectoption) {

		String result = "no";
		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("idx", idx);
		map.put("selectoption", selectoption);
		int res = user_dao.modify_user(map);
		if (res != 0) {
			result = "yes";
		}

		return result;
	}
	
}
