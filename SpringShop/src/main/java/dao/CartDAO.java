package dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;

import vo.CartVO;
import vo.Cart_viewVO;
import vo.P_informVO;

public class CartDAO {

	SqlSession sqlSession;
	public void setSqlSession(SqlSession sqlSession) {
		this.sqlSession = sqlSession;
	}
	
	//세션에 등록된 유저의 장바구니 리스트 가져오기
	public List<Cart_viewVO> cart_view_list(int u_idx){
		List<Cart_viewVO> list = sqlSession.selectList("c.cart_view_list",u_idx);
		return list;
	}
	
	//동일 상품의 사이즈,색상 중복 여부를 확인하기 위해 한개의 장바구니 내용을 검색
	public CartVO select_one(CartVO vo) {
		CartVO vo_exist = sqlSession.selectOne("c.cart_select_one", vo);
		return vo_exist;
	}
	
	//장바구니 담기 클릭시 장바구니에 추가
	public int cart_insert(CartVO vo) {
		int res = sqlSession.insert("c.cart_insert", vo);
		return res;
	}
	
	//장바구니 담기 클릭시 중복상품이 있을 경우 수량만 추가
	public int cart_update_cnt(CartVO vo) {
		int res = sqlSession.update("c.cart_update_cnt", vo);
		return res;
	}
	
	//장바구니 목록 삭제
	public int delete(int c_idx) {
		int res = sqlSession.delete("c.cart_delete", c_idx);
		return res;
	}
	
	//장바구니 목록에서 수정버튼 클릭시 수량 수정
	public int cart_update(CartVO vo) {
		int res = sqlSession.update("c.cart_update",vo);
		return res;
	}
	//상품 재고와 장바구니 수량을 비교하기 위한 상세정보 불러오기
	public int p_inform_one(P_informVO vo) {
		P_informVO p_vo = sqlSession.selectOne("p_inform.select_one",vo);
		int stock = 0;
		if (p_vo != null) {
			stock = p_vo.getI_stock();
		}
		return stock;
	}
	
	//장바구니 목록 내에서 수정할 때 해당 상품 재고 가져오기
	public P_informVO p_inform_select_one(CartVO vo) {
		CartVO c_vo = sqlSession.selectOne("c.select_one",vo);
		P_informVO p_vo = new P_informVO();
		p_vo.setRef(c_vo.getP_idx());
		p_vo.setColor(c_vo.getP_color());
		p_vo.setI_size(c_vo.getP_size());
		return p_vo;
	}
	
	//장바구니 전체 비우기
	public int cart_clear(int u_idx) {
		int res = sqlSession.delete("c.cart_clear", u_idx);
		return res;
	}
	
	//장바구니에서 구매 클릭시 전체 장바구니 상품정보 가져오기
	public List<Cart_viewVO> cart_order_list(int u_idx){
		List<Cart_viewVO> list = sqlSession.selectList("c.cart_order_list", u_idx);
		return list;
	}
	
	public int cart_delete_all(List<Cart_viewVO> list) {
		int res = 0;
		for (int i = 0; i < list.size(); i++) {
			int res2 = sqlSession.delete("c.cart_delete_all", list.get(i));
			res = res + res2;
		}
		return res;
	}
}
