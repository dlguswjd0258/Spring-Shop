package dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;

import vo.Buy_oneVO;
import vo.Cart_viewVO;
import vo.P_informVO;
import vo.ProductVO;

public class P_informDAO {

	SqlSession sqlSession;

	public void setSqlSession(SqlSession sqlSession) {
		this.sqlSession = sqlSession;
	}

	public int p_inform_insert(P_informVO vo) {
		int res = sqlSession.insert("p_inform.p_inform_insert", vo);
		return res;
	}

	public List<P_informVO> selectList(int ref) {
		List<P_informVO> list = null;
		list = sqlSession.selectList("p_inform.select_list", ref);
		return list;
	}

	// 동일 사이즈,컬러처리를 위한 정보 가져오기
	public P_informVO selectOne(P_informVO vo) {
		P_informVO p_vo = sqlSession.selectOne("p_inform.select_one", vo);
		return p_vo;
	}

	// 동일 사이즈,컬러라면 수량만 수정
	public int update_stock(P_informVO vo) {
		int res = sqlSession.update("p_inform.update_stock", vo);
		return res;
	}

	// 200627
	// 세부정보 수정
	public int p_inform_update(P_informVO vo) {
		int res = sqlSession.update("p_inform.p_inform_update", vo);
		return res;
	}

	// 200629
	// 세부정보 삭제
	public int p_inform_delete(int idx) {
		int res = sqlSession.delete("p_inform.p_inform_delete", idx);
		return res;

	}
	
	//구매 완료시 수량 수정
	public int order_complete(List<Cart_viewVO> list) {
		P_informVO vo = new P_informVO();
		int res = 0;
		for (int i = 0; i < list.size(); i++) {
			vo.setRef(list.get(i).getP_idx());
			vo.setColor(list.get(i).getP_color());
			vo.setI_size(list.get(i).getP_size());
			P_informVO p_vo = sqlSession.selectOne("p_inform.select_one",vo);
			p_vo.setI_stock(p_vo.getI_stock()-list.get(i).getC_cnt());
			res = sqlSession.update("p_inform.update_stock", p_vo);
		}
		return res;
	}
	
	//바로구매 완료시 수량 수정
	public int order_complete(Buy_oneVO b_vo) {
		P_informVO vo = new P_informVO();
		int res = 0;
		vo.setRef(b_vo.getP_idx());
		vo.setColor(b_vo.getP_color());
		vo.setI_size(b_vo.getP_size());
		P_informVO p_vo = sqlSession.selectOne("p_inform.select_one",vo);
		p_vo.setI_stock(p_vo.getI_stock()-b_vo.getC_cnt());
		res = sqlSession.update("p_inform.update_stock", p_vo);
		return res;
	}
	
}
