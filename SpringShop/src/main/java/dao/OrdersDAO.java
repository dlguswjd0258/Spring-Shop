package dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;

import vo.Buy_oneVO;
import vo.Cart_viewVO;
import vo.OrdersVO;
import vo.PointVO;
import vo.ProductVO;

public class OrdersDAO {
	
	SqlSession sqlSession;
	public void setSqlSession(SqlSession sqlSession) {
		this.sqlSession = sqlSession;
	}
	
	public OrdersVO select_orders_one(int o_idx) {
		OrdersVO vo = sqlSession.selectOne("o.orders_one", o_idx);
		return vo;
	}
	
	public PointVO select_point_one(int o_idx) {
		PointVO vo = sqlSession.selectOne("o.point_one", o_idx);
		return vo;
	}
	
	public int orders_insert(OrdersVO o_vo) {
		int o_res = sqlSession.insert("o.orders_insert", o_vo);
		return o_res;
	}
	
	public int[] cash_insert(OrdersVO o_vo) {
		int c_res = sqlSession.insert("o.cash_insert",o_vo);
		List<OrdersVO> list = sqlSession.selectList("o.orders_index_one", o_vo);
		int[] res = {c_res, list.get(0).getO_idx()};
		return res;
	}
	
	public int use_point(PointVO vo) {
		int res = sqlSession.insert("o.use_point",vo);
		System.out.println(vo.getAmount());
		return res;
	}
	
	public int add_point(PointVO vo) {
		int res = sqlSession.insert("o.add_point",vo);
		return res;
	}
	
	//구매완료시 상품 누적 판매량 수정
	public int update_p_sold(List<Cart_viewVO> list) {
		ProductVO vo = new ProductVO();
		int res = 0;
		for (int i = 0; i < list.size(); i++) {
			int idx = list.get(i).getP_idx();
			ProductVO vo2 = sqlSession.selectOne("p.product_one", idx);
			vo.setIdx(idx);
			vo.setP_sold(vo2.getP_sold()+list.get(i).getC_cnt());
			res = res + sqlSession.update("p.update_p_sold", vo);
		}
		return res;
	}

	
	//바로구매완료시 상품 누적 판매량 수정
	public int update_p_sold(Buy_oneVO b_vo) {
		ProductVO vo = new ProductVO();
		int res = 0;
		int idx = b_vo.getP_idx();
		ProductVO vo2 = sqlSession.selectOne("p.product_one", idx);
		vo.setIdx(idx);
		vo.setP_sold(vo2.getP_sold()+b_vo.getC_cnt());
		res = res + sqlSession.update("p.update_p_sold", vo);
		return res;
	}
}


