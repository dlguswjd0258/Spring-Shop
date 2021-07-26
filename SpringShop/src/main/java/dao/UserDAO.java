package dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import vo.UserVO;

public class UserDAO {

	SqlSession sqlSession;

	public void setSqlSession(SqlSession sqlSession) {
		this.sqlSession = sqlSession;
	}

	// 아이디와 일치한 정보 가져오기
	public UserVO select_one(String id) {
		UserVO vo = sqlSession.selectOne("user.user_one", id);
		return vo;
	}

	// 전화번호와 일치한 정보 가져오기
	public UserVO select_tel(String tel) {
		UserVO vo = sqlSession.selectOne("user.user_tel_check", tel);
		return vo;
	}

	// 이메일과 일치한 정보 가져오기
	public UserVO select_email(String email) {
		UserVO vo = sqlSession.selectOne("user.user_email_check", email);
		return vo;
	}

	// 회원가입 등록하기
	public int insert(UserVO vo) {
		int res = sqlSession.insert("user.user_insert", vo);
		return res;
	}

	// 입력한 정보와 일치하는 회원 아이디 찾기
	public UserVO select_id(UserVO vo) {
		UserVO findVo = sqlSession.selectOne("user.user_id", vo);
		return findVo;
	}

	// 입력한 정보와 일치하는 회원 비밀번호 찾기
	public UserVO select_pwd(UserVO vo) {
		UserVO findVo = sqlSession.selectOne("user.user_pwd", vo);
		return findVo;
	}

	// 비밀번호 재설정
	public int update_pwd(UserVO vo) {
		int res = sqlSession.update("user.pwd_reset", vo);
		return res;
	}

	// 회원 삭제(실제로 안지움)
	public int delete(int idx) {
		int res = sqlSession.delete("user.user_delete", idx);
		return res;
	}

	// 유저명단 불러오기
	public List<UserVO> selectlist() {
		List<UserVO> list = sqlSession.selectList("user.user_whole");
		return list;
	}
	
	public List<UserVO> page_selectlist(Map<String, Object> map) {
		List<UserVO> list = sqlSession.selectList("user.user_by_page", map);
		return list;
	}

	// 회원 권한 변경
	public int modify_user(Map<String, Integer> map) {
		int res = sqlSession.update("user.user_modify", map);
		return res;
	}

	// 해당 유저번호의 현재 정보 넘기기
	public UserVO select_one_idx(int idx) {
		UserVO vo = sqlSession.selectOne("user.user_select_one_idx", idx);
		return vo;
	}

	public int use_cash(UserVO vo) {
		int res = sqlSession.update("user.user_cash_update", vo);
		return res;
	}

	public int use_point(UserVO vo) {
		int res = sqlSession.update("user.user_use_point", vo);
		return res;
	}

	public int add_point(UserVO vo) {
		int res = sqlSession.update("user.user_add_point", vo);
		return res;
	}
	
	//200707
	public int update(UserVO vo) {
		int res = sqlSession.update("user.user_update", vo);
		return res;
	}
	
	//로그인시 멤버십등급 확인 및 수정
	public int update_membership(UserVO vo) {
		int res = sqlSession.update("user.update_membership", vo);
		return res;
	}
	
	public int user_count() {
		return sqlSession.selectOne("user.user_count");
	}
}
