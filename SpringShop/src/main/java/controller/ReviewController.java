package controller;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import dao.ReviewDAO;
import util.FloatPageUtil;
import util.ReviewsPageUtil;
import util.ReviewsPaging;
import vo.ProductVO;
import vo.ReviewVO;

@Controller
public class ReviewController {
	
    public static final String VIEW_PATH_U = "/WEB-INF/views/user/";
    public static final String VIEW_PATH_P = "/WEB-INF/views/product/";
    public static final String VIEW_PATH_H = "/WEB-INF/views/history/";
    public static final String VIEW_PATH_R = "/WEB-INF/views/review/";
    public static final String VIEW_PATH_C = "/WEB-INF/views/cart/";
    
    @Autowired
	HttpServletRequest request;
    
    // 2020.06.29 EDITED
	@Autowired
	ServletContext application;
    
	ReviewDAO review_dao;
	public void setReview_dao(ReviewDAO review_dao) {
		this.review_dao = review_dao;
	}
	
	// 2020.06.29 EDITED
	// 2020.06.30 EDITED
	@RequestMapping("/review_insert.do")
	public String review_insert(ReviewVO vo, RedirectAttributes redirectAttributes) {
		try {
			// 후기 추가 전
			double current_product_grade = review_dao.get_product_grade(vo.getP_idx());
			double current_product_reviews_num = (double)review_dao.get_valid_reviews_num(vo.getP_idx());
			double current_total_star = current_product_grade * current_product_reviews_num;
		
			vo.setContent(vo.getContent().replaceAll("<br>", "\n"));
			vo.setIp(request.getRemoteAddr());
			
			String webpath = "/resources/r_upload/";
			String savePath = application.getRealPath(webpath);
			System.out.println(savePath);
			
			MultipartFile file_r = vo.getFile_r();
			String filename_r = "no_file"; 
			
			// 업로드 한 파일이 실제로 존재한다면
			if (!file_r.isEmpty()) {
				filename_r = file_r.getOriginalFilename();// 업로드 된 실제 파일명
				// 저장할 파일 경로 지정
				File saveFile_r = new File(savePath, filename_r);
				if (!saveFile_r.exists()) {
					saveFile_r.mkdirs();// 없는 폴더 생성
				} else {
					// 동일 파일명 업로드 방지를 위해 현재 업로드 시간을 붙여서 중복을 방지
					long time = System.currentTimeMillis();
					filename_r = String.format("%d_%s", time, filename_r);
					saveFile_r = new File(savePath, filename_r);
				}
				try {
					// 업로드된 파일은 MultipartResolver라는 클래스가 지정해둔
					// 임시저장소에 있는데, 임시 저장소의 파일은 일정 시간이 지나면 사라지기 때문에
					// 내가 지정해준 savePath경로로 복사해준다
					file_r.transferTo(saveFile_r);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			vo.setFilename_r(filename_r);
			
			int res = review_dao.review_insert(vo);
			
			//후기 추가 후
			double new_product_grade = (current_total_star + (double)vo.getGrade())/((double)current_product_reviews_num+1.0);
					
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("p_idx", vo.getP_idx());	
			map.put("grade", Math.round(new_product_grade*10)/10.0);
			
			int res2 = review_dao.update_product_grade(map);

		}catch (NullPointerException e) {
			e.printStackTrace();
		}
		
		redirectAttributes.addAttribute("idx", vo.getP_idx());
		redirectAttributes.addAttribute("page", 1);
		return "redirect:/product_one.do";
	}

	// 2020.06.30 EDITED
	@RequestMapping("/review_dat_insert.do")
	public String review_dat_insert(ReviewVO vo, int page, RedirectAttributes redirectAttributes) {
		try {
			// idx 는 쿼리에서 시퀀스 사용
			// name 설정완료
			// subject는 "댓글"로 설정
			vo.setSubject("dadat");
			// content 설정완료
			vo.setContent(vo.getContent().replaceAll("<br>", "\n"));
			// pwd 설정완료
			// ip는 request로 설정
			vo.setIp(request.getRemoteAddr());
			// regidate는 쿼리에서 sysdate
			// readhit는 0으로
			// ref는 설정완료
			// step, depth = 1, del_info = 0, grade = 0
			// p_idx는 설정완료
			// filename_r = "no_file" 로 설정
			vo.setFilename_r("no_file");
			
			// 기존 대댓글 step먼저 이동
			int res = review_dao.update_step(vo.getRef());
			
			int res2 = review_dao.review_dat_insert(vo);
		}catch(Exception e) {
			e.printStackTrace();
		}

		
		redirectAttributes.addAttribute("idx", vo.getP_idx());
		redirectAttributes.addAttribute("page", page);
		redirectAttributes.addAttribute("r_idx", vo.getRef());
		return "redirect:/product_one.do";
	}
	
	// 2020.06.30 EDITED
	@RequestMapping("/review_delete.do")
	@ResponseBody
	public String review_delete(String r_idx, String idx, String page, String pwd) {
		
		double current_total_star = review_dao.get_product_grade(Integer.parseInt(idx))*review_dao.get_valid_reviews_num(Integer.parseInt(idx));
		System.out.println(current_total_star);
		
		
		String resstr="no";
		if(pwd.equals(review_dao.get_review_pwd(r_idx))){
			int res = review_dao.review_delete(r_idx);
			if(res > 0) {
				resstr = "yes";
				
				//별점 수정
				double new_total_star = current_total_star - review_dao.get_review_grade(Integer.parseInt(r_idx));
				double new_product_grade;
				if(review_dao.get_valid_reviews_num(Integer.parseInt(idx)) == 0) {
					new_product_grade = 0.0;
				}else{
					new_product_grade = new_total_star/review_dao.get_valid_reviews_num(Integer.parseInt(idx));
				}
				
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("p_idx", idx);	
				map.put("grade", Math.round(new_product_grade*10)/10.0);
				
				int res2 = review_dao.update_product_grade(map);
			}	
		}else {
			resstr="wrong_pwd";
		}

		
		String json = String.format("[{'res':'%s','idx':'%s','page':'%s'}]", resstr, idx, page);
		return json;
	}
	
	// 2020.06.30 EDITED
	@RequestMapping("/review_edit_form.do")
	@ResponseBody
	public String review_edit_form(String r_idx, String pwd) {
		String r_pwd = review_dao.get_review_pwd(r_idx);
		String resstr = "yes";
		if(!r_pwd.equals(pwd)) {
			resstr = "wrong_pwd";
		}
		
		// sh ==> + 0.*
		// ed ==> + 0.0*
		String json = String.format("[{'res':'%s', 'r_idx':'%s'}]", resstr, Integer.parseInt(r_idx));
		
		return json;
	}
	
	// 2020.06.30 EDITED
	@RequestMapping("/review_edit.do")
	public String review_edit(String r_idx, String page, String p_idx, String content, MultipartFile file_r, RedirectAttributes redirectAttributes) {
		try {
			String webpath = "/resources/r_upload/";
			String savePath = application.getRealPath(webpath);
			System.out.println(savePath);
			
			ReviewVO vo = new ReviewVO();
			vo.setIdx(Integer.parseInt(r_idx));
			vo.setContent(content.replaceAll("<br>", "\n"));
			vo.setIp(request.getRemoteAddr());
			
			String filename_r = "no_file"; 
			
			// 업로드 한 파일이 실제로 존재한다면
			if (!file_r.isEmpty()) {
				filename_r = file_r.getOriginalFilename();// 업로드 된 실제 파일명
				// 저장할 파일 경로 지정
				File saveFile_r = new File(savePath, filename_r);
				if (!saveFile_r.exists()) {
					saveFile_r.mkdirs();// 없는 폴더 생성
				} else {
					// 동일 파일명 업로드 방지를 위해 현재 업로드 시간을 붙여서 중복을 방지
					long time = System.currentTimeMillis();
					filename_r = String.format("%d_%s", time, filename_r);
					saveFile_r = new File(savePath, filename_r);
				}
				try {
					// 업로드된 파일은 MultipartResolver라는 클래스가 지정해둔
					// 임시저장소에 있는데, 임시 저장소의 파일은 일정 시간이 지나면 사라지기 때문에
					// 내가 지정해준 savePath경로로 복사해준다
					file_r.transferTo(saveFile_r);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			
			vo.setFilename_r(filename_r);
			
			String resstr = "no";
			int res = review_dao.review_edit(vo);
			if(res > 0) {
				resstr = "yes";
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		redirectAttributes.addAttribute("idx", p_idx);
		redirectAttributes.addAttribute("page", page);
		redirectAttributes.addAttribute("r_idx", r_idx);
		return "redirect:/product_one.do";
	}
	
	// 2020.06.30 EDITED
	@RequestMapping("/review_edit2.do")
	public String review_edit2(String r_idx, String page, String ref, String p_idx, String content, RedirectAttributes redirectAttributes) {
		ReviewVO vo = new ReviewVO();
		vo.setIdx(Integer.parseInt(r_idx));
		vo.setContent(content.replaceAll("<br>", "\n"));
		vo.setIp(request.getRemoteAddr());
		vo.setFilename_r("no_file");
		
		int res = review_dao.review_edit(vo);
		
		redirectAttributes.addAttribute("idx", p_idx);
		redirectAttributes.addAttribute("page", page);
		redirectAttributes.addAttribute("r_idx", ref);
		return "redirect:/product_one.do";
	}
	
	//2020.07.02 EDITED
	@RequestMapping("/review_list.do")
	public String review_list(Model model, String p_page, String r_page) {
		
		// main.do?page=1
		// main.do
		int p_nowPage = 1;// 기본페이지
		if (p_page != null && !p_page.isEmpty()) {
			p_nowPage = Integer.parseInt(p_page);
		}

		int r_nowPage = 1;// 기본페이지
		if (r_page != null && !r_page.isEmpty()) {
			r_nowPage = Integer.parseInt(r_page);
		}

		//--------------상품------------------
		// 한 페이지에 표시되는 게시물의 시작과 끝 번호를 계산
		int start = (p_nowPage - 1) * util.ReviewsPageUtil.Board.BLOCKLIST + 1;
		int end = (start + ReviewsPageUtil.Board.BLOCKLIST) - 1;

		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("start", start);
		map.put("end", end);

		// 페이지에 들어갈 상품목록 가져오기
		List<ProductVO> product_list = review_dao.page_product_list(map);

		// 전체 상품 수 구하기
		int p_row_total = review_dao.product_count();

		//-----------리뷰------------
		start = (r_nowPage - 1) * util.ReviewsPageUtil.Board.BLOCKLIST + 1;
		end = (start + ReviewsPageUtil.Board.BLOCKLIST) - 1;
		
		map.put("start", start);
		map.put("end", end);
		
		int review_empty = 1;
		
		// 상품의 후기 리스트
		Map<Integer, ProductVO> product_map = new HashMap<Integer, ProductVO>();
		Map<Integer, List<ReviewVO>> dadat_map = new HashMap<Integer, List<ReviewVO>>();

		List<ReviewVO> review_list = review_dao.product_reviews_all(map);
		if (!review_list.isEmpty()) {
			review_empty = 0;
		}

		// 후기의 댓글 리스트
		for (ReviewVO vo : review_list) {
			List<ReviewVO> dadat_list = review_dao.get_dadat_list_all(vo.getIdx());
			dadat_map.put(vo.getIdx(), dadat_list);
			product_map.put(vo.getIdx(), review_dao.product_one(vo.getP_idx()));
		}

		int r_row_total = review_dao.all_review_count();
		// 하단 페이지메뉴 생성하기
		List<String> pageMenu = ReviewsPaging.getPaging("review_list.do", p_nowPage, p_row_total, r_nowPage, r_row_total, 
				ReviewsPageUtil.Board.BLOCKLIST, ReviewsPageUtil.Board.BLOCKPAGE);
		
		model.addAttribute("product_list",  product_list);
		model.addAttribute("review_list",  review_list);
		model.addAttribute("pageMenu", pageMenu);
		model.addAttribute("dadat_map", dadat_map);
		model.addAttribute("product_map", product_map);

		model.addAttribute("review_empty", review_empty);
		
		return VIEW_PATH_R + "review_list.jsp";
	}
}









