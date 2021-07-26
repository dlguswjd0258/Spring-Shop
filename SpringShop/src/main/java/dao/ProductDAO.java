package dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import vo.HistoryVO;
import vo.P_informVO;
import vo.ProductVO;
import vo.ReviewVO;

public class ProductDAO {

	SqlSession sqlSession;

	public void setSqlSession(SqlSession sqlSession) {
		this.sqlSession = sqlSession;
	}

	// 전체 상품 목록 출력
	public List<ProductVO> product_list() {
		List<ProductVO> list = null;
		list = sqlSession.selectList("p.product_list");
		return list;
	}

	// 페이지 상품 목록 가져오기
	public List<ProductVO> page_product_list(Map<String, Integer> map) {
		List<ProductVO> list = sqlSession.selectList("p.page_product_list", map);
		return list;
	}
	
	// 페이지 상품 목록 가져오기_관리자용
	public List<ProductVO> page_product_list_m(Map<String, Object> map) {
		List<ProductVO> list = sqlSession.selectList("p.page_product_list_m", map);
		return list;
	}

	// 상품 전체 수
	public int product_count() {
		return sqlSession.selectOne("p.product_count");
	}
	
	// 상품 전체 수_관리자용
	public int product_count_m() {
		return sqlSession.selectOne("p.product_count_m");
	}

	// 상품 등록
	public int product_insert(ProductVO vo) {
		int res = sqlSession.insert("p.product_insert", vo);
		return res;
	}

	// 가장 최근에 insert된 product의 idx를 가져온다
	public int product_idx_select(String p_name) {
		ProductVO vo = sqlSession.selectOne("p.p_one", p_name);
		return vo.getIdx();
	}

	public ProductVO product_one(int idx) {
		ProductVO vo = sqlSession.selectOne("p.product_one", idx);
		return vo;
	}

	// 해당 상품의 게시글 목록 가져오기
	public List<ReviewVO> get_reviews(int idx) {
		List<ReviewVO> list = sqlSession.selectList("r.get_reviews", idx);
		return list;
	}

	// 특정 게시글 인덱스로 가져오기
	public ReviewVO get_review(int r_idx) {
		ReviewVO vo = sqlSession.selectOne("r.get_review", r_idx);
		return vo;
	}

	// 페이징을 포함한 게시글 목록 출력
	public List<ReviewVO> review_list_paging(Map<String, Integer> map) {
		List<ReviewVO> list = sqlSession.selectList("r.review_list_paging", map);
		return list;
	}

	// 전체게시물 수
	public int getRowTotal(int idx) {
		int count = sqlSession.selectOne("r.review_count", idx);
		return count;
	}

	// 200626
	// 상품 삭제
	public int[] product_delete_all(int idx) {
		int inform_res = sqlSession.delete("p.product_delete_inform", idx);
		int p_res = sqlSession.delete("p.product_delete", idx);
		int[] res = { inform_res, p_res };
		return res;
	}

	// 상품등록시 중복확인을 위한 객체 가져오기
	public ProductVO selectOne(String p_name) {
		ProductVO vo = sqlSession.selectOne("p.select_one", p_name);
		return vo;
	}

	// 상품 별점
	public int product_grade(int idx) {
		return sqlSession.selectOne("p.product_grade", idx);
	}

	// 상품 색상 리스트 가져오기
	public List<String> product_color_list(int idx) {
		List<String> color_list = sqlSession.selectList("p.product_color_list", idx);
		return color_list;
	}

	// 상품 사이즈 리스트 가져오기
	public List<String> product_size_list(int idx) {
		List<String> size_list = sqlSession.selectList("p.product_size_list", idx);
		return size_list;
	}

	// 특정 후기글 조회수 증가
	public int update_readhit(int r_idx) {
		return sqlSession.update("r.update_readhit", r_idx);
	}

	// 대분류 카테고리 클릭시 view 가져오기
	public List<ProductVO> select_view(String view_name) {
		List<ProductVO> list = null;
		if (view_name.equals("best")) {
			list = sqlSession.selectList("p.selectList_best");
		} else if (view_name.equals("top")) {
			list = sqlSession.selectList("p.selectList_top");
		} else if (view_name.equals("shirts")) {
			list = sqlSession.selectList("p.selectList_shirts");
		} else if (view_name.equals("pants")) {
			list = sqlSession.selectList("p.selectList_pants");
		} else if (view_name.equals("outer")) {
			list = sqlSession.selectList("p.selectList_outer");
		}
		return list;

	}

	// 하위 카테코리 클릭시 리스트 가져오기
	public List<ProductVO> select_category(String category) {
		List<ProductVO> list = sqlSession.selectList("p.select_category", category);
		return list;
	}

	// 200626
	// 등록된 상품 삭제
	public int product_delete(int idx) {
		int res = sqlSession.update("p.product_del", idx);
		return res;
	}

	// 200627
	// 상품 수정
	public int product_update(ProductVO vo) {
		int res = sqlSession.update("p.product_update", vo);
		return res;
	}

	// 상품 인덱스로 해당 상품에 등록된 상세정보 리스트 가져오기
	public List<P_informVO> p_inform_list(int ref) {
		List<P_informVO> list = sqlSession.selectList("p_inform.select_list", ref);
		return list;
	}

	// 0703추가
	public List<String> color_size_match(Map<String, Object> map) {
		List<String> list = sqlSession.selectList("p.color_size_match", map);
		return list;
	}

	public List<ReviewVO> get_dadat_list(String r_idx) {
		List<ReviewVO> list = sqlSession.selectList("r.get_dadat_list", r_idx);
		return list;
	}

	public int product_stock(Map<String, String> color_size) {
		int res = sqlSession.selectOne("p.product_stock", color_size);
		return res;
	}

	public List<Integer> product_stock_list(int p_idx) {
		List<Integer> list = sqlSession.selectList("p_inform.product_stock_list", p_idx);
		return list;
	}
	
	public List<ProductVO> search_list(String search){
		List<ProductVO> list = sqlSession.selectList("p.search_list",search);
		return list;
	}
	
	public List<HistoryVO> get_history_list(int u_idx){
		List<HistoryVO> list = sqlSession.selectList("h.get_history_list", u_idx);
		return list;
	}
	
	public int review_written(int p_idx, int u_idx) {
		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("p_idx", p_idx);
		map.put("u_idx", u_idx);
		return sqlSession.selectOne("r.review_written", map);
	}
	
	public List<ProductVO> page_view_list(Map<String, Object> map){
		List<ProductVO> list = null;
		if (map.get("view_name").equals("best")) {
			list = sqlSession.selectList("p.page_list_best", map);
		}else if (map.get("view_name").equals("top")) {
			list = sqlSession.selectList("p.page_list_top", map);
		}else if (map.get("view_name").equals("shirts")) {
			list = sqlSession.selectList("p.page_list_shirts", map);
		}else if (map.get("view_name").equals("pants")) {
			list = sqlSession.selectList("p.page_list_pants", map);
		}else if (map.get("view_name").equals("outer")) {
			list = sqlSession.selectList("p.page_list_outer", map);
		}
		return list;
		
	}
	
	public List<ProductVO> page_view_list_m(Map<String, Object> map){
		List<ProductVO> list = null;
		if (map.get("view_name").equals("best")) {
			list = sqlSession.selectList("p.page_list_best_m", map);
		}else if (map.get("view_name").equals("top")) {
			list = sqlSession.selectList("p.page_list_top_m", map);
		}else if (map.get("view_name").equals("shirts")) {
			list = sqlSession.selectList("p.page_list_shirts_m", map);
		}else if (map.get("view_name").equals("pants")) {
			list = sqlSession.selectList("p.page_list_pants_m", map);
		}else if (map.get("view_name").equals("outer")) {
			list = sqlSession.selectList("p.page_list_outer_m", map);
		}
		return list;
		
	}
	
	public int view_count(String view_name) {
		if (view_name.equals("best")) {
			return sqlSession.selectOne("p.count_best");
		}else if (view_name.equals("top")) {
			return sqlSession.selectOne("p.count_top");
		}else if (view_name.equals("shirts")) {
			return sqlSession.selectOne("p.count_shirts");
		}else if (view_name.equals("pants")) {
			return sqlSession.selectOne("p.count_pants");
		}else if (view_name.equals("outer")) {
			return sqlSession.selectOne("p.count_outer");
		}else {
			return 0;
		}
	}
	
	public int view_count_m(String view_name) {
		if (view_name.equals("best")) {
			return sqlSession.selectOne("p.count_best_m");
		}else if (view_name.equals("top")) {
			return sqlSession.selectOne("p.count_top_m");
		}else if (view_name.equals("shirts")) {
			return sqlSession.selectOne("p.count_shirts_m");
		}else if (view_name.equals("pants")) {
			return sqlSession.selectOne("p.count_pants_m");
		}else if (view_name.equals("outer")) {
			return sqlSession.selectOne("p.count_outer_m");
		}else {
			return 0;
		}
	}
	
	public List<ProductVO> page_category_list(Map<String, Object> map){
		List<ProductVO> list = sqlSession.selectList("p.page_category_list", map);
		return list;
	}
	
	public List<ProductVO> page_category_list_m(Map<String, Object> map){
		List<ProductVO> list = sqlSession.selectList("p.page_category_list_m", map);
		return list;
	}
	
	public int category_count(String category) {
		return sqlSession.selectOne("p.category_count", category);
	}
	
	public int category_count_m(String category) {
		return sqlSession.selectOne("p.category_count_m", category);
	}
	
	public int review_delete(int idx) {
		return sqlSession.update("r.review_delete", idx);
	}
}
