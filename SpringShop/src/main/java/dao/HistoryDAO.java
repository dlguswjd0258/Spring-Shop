package dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import vo.Buy_oneVO;
import vo.Cart_viewVO;
import vo.CashVO;
import vo.HistoryVO;
import vo.PointVO;
import vo.ProductVO;
import vo.ReviewVO;
import vo.UserVO;

public class HistoryDAO {

	SqlSession sqlSession;

	public void setSqlSession(SqlSession sqlSession) {
		this.sqlSession = sqlSession;
	}

	// 200707
	public List<HistoryVO> select_list(Map<String, Integer> map) {
		List<HistoryVO> list = sqlSession.selectList("h.history_list", map);
		return list;
	}

	public List<HistoryVO> select_detail_list(int o_idx) {
		List<HistoryVO> list = sqlSession.selectList("h.history_detail_list", o_idx);
		return list;
	}

	// 200707
	public List<PointVO> select_point_save(Map<String, Integer> map) {
		List<PointVO> list = sqlSession.selectList("h.point_save", map);
		return list;
	}

	// 200707
	public List<PointVO> select_point_use(Map<String, Integer> map) {
		List<PointVO> list = sqlSession.selectList("h.point_use", map);
		return list;
	}

	// 200707
	public List<CashVO> select_cash_save(Map<String, Integer> map) {
		List<CashVO> list = sqlSession.selectList("h.cash_save", map);
		return list;
	}

	// 200707
	public List<CashVO> select_cash_use(Map<String, Integer> map) {
		List<CashVO> list = sqlSession.selectList("h.cash_use", map);
		return list;
	}

	// 200706
	public int cash_update(UserVO vo) {
		int res = sqlSession.update("h.cash_update", vo);
		return res;
	}

	// 200706
	public int cash_insert(CashVO c_vo) {
		int res = sqlSession.insert("h.cash_insert", c_vo);
		return res;
	}

	public int history_insert(List<Cart_viewVO> orderList, int o_idx) {
		HistoryVO vo = new HistoryVO();
		int res = 0;
		for (int i = 0; i < orderList.size(); i++) {
			vo.setO_idx(o_idx);
			vo.setU_idx(orderList.get(i).getU_idx());
			vo.setP_idx(orderList.get(i).getP_idx());
			vo.setP_color(orderList.get(i).getP_color());
			vo.setP_size(orderList.get(i).getP_size());
			vo.setP_cnt(orderList.get(i).getC_cnt());
			int result = sqlSession.insert("h.history_insert", vo);
			res = res + result;
		}
		return res;
	}

	// 바로구매
	public int history_insert(Buy_oneVO b_vo, int o_idx) {
		HistoryVO vo = new HistoryVO();
		int res = 0;
		vo.setO_idx(o_idx);
		vo.setU_idx(b_vo.getU_idx());
		vo.setP_idx(b_vo.getP_idx());
		vo.setP_color(b_vo.getP_color());
		vo.setP_size(b_vo.getP_size());
		vo.setP_cnt(b_vo.getC_cnt());
		res = sqlSession.insert("h.history_insert", vo);
		return res;
	}

	// 200707
	public int history_count(int u_idx) {
		int count = sqlSession.selectOne("h.history_count", u_idx);
		return count;
	}

	// 200707
	public int point_save_count(int u_idx) {
		int count = sqlSession.selectOne("h.point_save_count", u_idx);
		return count;
	}

	// 200707
	public int point_use_count(int u_idx) {
		int count = sqlSession.selectOne("h.point_use_count", u_idx);
		return count;
	}

	// 200707
	public int cash_save_count(int u_idx) {
		int count = sqlSession.selectOne("h.cash_save_count", u_idx);
		return count;
	}

	// 200707
	public int cash_use_count(int u_idx) {
		int count = sqlSession.selectOne("h.cash_use_count", u_idx);
		return count;
	}

	// 200708
	public int delivery_update(int u_idx) {
		int res = sqlSession.update("h.delivery_update", u_idx);
		return res;
	}

	// 200707
	public List<ReviewVO> select_review_list(Map<String, Integer> map) {
		List<ReviewVO> list = sqlSession.selectList("h.review_list", map);
		return list;
	}

	// 200707
	public int review_count(int u_idx) {
		int count = sqlSession.selectOne("h.review_count", u_idx);
		return count;
	}

	public ProductVO select_product(int p_idx) {
		ProductVO vo = sqlSession.selectOne("h.select_product", p_idx);
		return vo;
	}
	
	//200709
		public List<ReviewVO> select_dat_list(int ref) {
			List<ReviewVO> list = sqlSession.selectList("h.select_dat", ref);
			return list;
		}


}
