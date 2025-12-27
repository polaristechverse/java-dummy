package com.devops.ecommerce.product;

public class Product {

    private String name;
    private int price;
    private int discount;     // percentage
    private int finalPrice;
    private String image;

    public Product(String name, int price, int discount, String image) {
        this.name = name;
        this.price = price;
        this.discount = discount;
        this.finalPrice = price - (price * discount / 100);
        this.image = image;
    }

    public String getName() {
        return name;
    }

    public int getPrice() {
        return price;
    }

    public int getDiscount() {
        return discount;
    }

    public int getFinalPrice() {
        return finalPrice;
    }

    public String getImage() {
        return image;
    }
}
