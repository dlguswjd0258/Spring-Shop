package vo;

import org.springframework.web.multipart.MultipartFile;

public class ProductVO {
	private String filename_s, filename_l;
	private MultipartFile p_image_s, p_image_l;
	private int idx, p_price, p_saleprice, p_sold, p_del;
	private String category, p_name, p_content, p_date;
	private int salerate;
	private double p_grade;
	
	
	public double getP_grade() {
		return p_grade;
	}
	public void setP_grade(double p_grade) {
		this.p_grade = p_grade;
	}
	public void setSalerate(int salerate) {
		this.salerate = salerate;
	}
	public String getFilename_s() {
		return filename_s;
	}
	public void setFilename_s(String filename_s) {
		this.filename_s = filename_s;
	}
	public String getFilename_l() {
		return filename_l;
	}
	public void setFilename_l(String filename_l) {
		this.filename_l = filename_l;
	}
	public MultipartFile getP_image_s() {
		return p_image_s;
	}
	public void setP_image_s(MultipartFile p_image_s) {
		this.p_image_s = p_image_s;
	}
	public MultipartFile getP_image_l() {
		return p_image_l;
	}
	public void setP_image_l(MultipartFile p_image_l) {
		this.p_image_l = p_image_l;
	}
	public int getIdx() {
		return idx;
	}
	public void setIdx(int idx) {
		this.idx = idx;
	}
	public int getP_price() {
		return p_price;
	}
	public void setP_price(int p_price) {
		this.p_price = p_price;
	}
	public int getP_saleprice() {
		return p_saleprice;
	}
	public void setP_saleprice(int p_saleprice) {
		this.p_saleprice = p_saleprice;
	}
	public int getP_sold() {
		return p_sold;
	}
	public void setP_sold(int p_sold) {
		this.p_sold = p_sold;
	}
	public int getP_del() {
		return p_del;
	}
	public void setP_del(int p_del) {
		this.p_del = p_del;
	}
	public String getCategory() {
		return category;
	}
	public void setCategory(String category) {
		this.category = category;
	}
	public String getP_name() {
		return p_name;
	}
	public void setP_name(String p_name) {
		this.p_name = p_name;
	}
	public String getP_content() {
		return p_content;
	}
	public void setP_content(String p_content) {
		this.p_content = p_content;
	}
	public String getP_date() {
		return p_date;
	}
	public void setP_date(String p_date) {
		this.p_date = p_date;
	}
	public int getSalerate() {
		return (int)((p_price - p_saleprice) / (double)p_price * 100);
	}

	
}
