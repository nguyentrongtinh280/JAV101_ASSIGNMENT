package Entity;

public class Categories {
	private int id;
	private String name;
	
	//Getter - setter
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	
	//constructor
	public Categories() {
		super();
	}
	public Categories(int id, String name) {
		super();
		this.id = id;
		this.name = name;
	}
}
