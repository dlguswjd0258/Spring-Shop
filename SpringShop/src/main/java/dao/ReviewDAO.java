package dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import vo.ProductVO;
import vo.ReviewVO;

public class ReviewDAO {

	SqlSession sqlSession;

	public void setSqlSession(SqlSession sqlSession) {
		this.sqlSession = sqlSession;
	}

	// 전체 게시물 조회
	public List<ReviewVO> review_list() {
		List<ReviewVO> list = sqlSession.selectList("r.review_list");
		return list;
	}

	// 게시물 추가
	public int review_insert(ReviewVO vo) {
		int res = sqlSession.insert("r.review_insert", vo);
		return res;
	}

	// 게시물 상세
	public ReviewVO review_one(int idx) {
		ReviewVO vo = sqlSession.selectOne("r.review_one", idx);
		return vo;
	}

	// 조회수 증가
	public int update_readhit(int idx) {
		int res = sqlSession.update("r.update_readhit", idx);
		return res;
	}

	// 댓글위치 선정
	public int review_reply(ReviewVO vo) {
		int res = sqlSession.insert("r.review_reply", vo);
		return res;
	}

	// 삭제를 위한 게시글 정보 얻어오기
	public ReviewVO review_one(int idx, String pwd) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("idx", idx);
		map.put("pwd", pwd);
		ReviewVO vo = sqlSession.selectOne("r.review_one", map);
		return vo;
	}

	// 2020.06.30 EDITED
	// 게시글 삭제
	public int review_delete(String r_idx) {
		int res = sqlSession.update("r.del_update", r_idx);
		return res;
	}

	// 현재 상품 별점 가져오기
	public double get_product_grade(int idx) {
		return sqlSession.selectOne("r.get_product_grade", idx);
	}

	// 상품 별점 수정
	public int update_product_grade(Map<String, Object> map) {
		int res = sqlSession.update("r.update_product_grade", map);
		return res;
	}

	// 2020.06.30 EDITED
	// 같은 상품에 대한 후기 수 조회
	public int get_reviews_num(int idx) {
		return sqlSession.selectOne("r.review_count", idx);
	}

	// 2020.06.30 EDITED
	public int get_valid_reviews_num(int idx) {
		return sqlSession.selectOne("r.valid_review_count", idx);
	}

	// 2020.06.30 EDITED
	public int review_dat_insert(ReviewVO vo) {
		return sqlSession.insert("r.review_dat_insert", vo);
	}

	// 2020.06.30 EDITED
	public int update_step(int ref) {
		return sqlSession.update("r.update_step", ref);
	}

	// 2020.06.30 EDITED
	public int get_review_grade(int r_idx) {
		return sqlSession.selectOne("r.get_review_grade", r_idx);
	}

	// 2020.06.30 EDITED
	public String get_review_pwd(String r_idx) {
		return sqlSession.selectOne("r.get_review_pwd", r_idx);
	}

	// 2020.06.30 EDITED
	public int review_edit(ReviewVO vo) {
		if (vo.getFilename_r().equals("no_file")) {
			return sqlSession.update("r.review_edit_nofile", vo);
		} else {
			return sqlSession.update("r.review_edit", vo);
		}
	}

	// 2020.07.02 EDITED
	public List<ProductVO> product_list() {
		List<ProductVO> list = sqlSession.selectList("p.product_list");
		return list;
	}

	// 2020.07.02 EDITED
	public List<ReviewVO> product_reviews_all(Map<String, Integer> map) {
		List<ReviewVO> list = sqlSession.selectList("r.get_reviews_all", map);
		return list;
	}

	// 2020.07.02 EDITED
	public List<ReviewVO> product_reviews(int idx) {
		List<ReviewVO> list = sqlSession.selectList("r.get_reviews", idx);
		return list;
	}

	public List<ReviewVO> get_dadat_list(String idx){
		List<ReviewVO> list =sqlSession.selectList("r.get_dadat_list", idx);
		return list;
	}
	
	public List<ReviewVO> get_dadat_list_all(int idx) {
		List<ReviewVO> list = sqlSession.selectList("r.get_dadat_list_all", idx);
		return list;
	}

	// 2020.07.02 EDITED
	public List<ProductVO> page_product_list(Map<String, Integer> map) {
		List<ProductVO> list = sqlSession.selectList("p.page_product_list", map);
		return list;
	}

	// 2020.07.02 EDITED
	// 상품 전체 수
	public int product_count() {
		return sqlSession.selectOne("p.product_count");
	}

	public int all_review_count() {
		return sqlSession.selectOne("r.all_review_count");
	}

	public ProductVO product_one(int p_idx) {
		return sqlSession.selectOne("r.product_one", p_idx);
	}
}
