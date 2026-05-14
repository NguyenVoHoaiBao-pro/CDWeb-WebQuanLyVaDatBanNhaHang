package vn.edu.hcmuaf.fit.model;

public class Product {
    private int id;
    private String name;
    private double price;
    private String description;
    private String image;
    private String category;
    private String aiKeywords;
    private String aiDescription;

    // 🔥 THÊM DÒNG NÀY
    private int quantity;

    // getter setter
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    // 🔥 THÊM GET/SET
    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
    public String getAiKeywords() {
        return aiKeywords;
    }

    public void setAiKeywords(String aiKeywords) {
        this.aiKeywords = aiKeywords;
    }

    public String getAiDescription() {
        return aiDescription;
    }

    public void setAiDescription(String aiDescription) {
        this.aiDescription = aiDescription;
    }
}