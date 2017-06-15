/**
* Wrapper class
* product with quantity
*/

public with sharing class ProductWrapper {

    //Fields
    public Product__c product { get; set; }
    public Integer quantity { get; set; }
    public Decimal price {get; set;}

    //Constructors
    public ProductWrapper() {
        product = null;
        quantity = 1;
    }

    public ProductWrapper(Product__c product){
        this.product = product;
    }

    public ProductWrapper(Product__c product, Integer quantity) {
        this.product = product;
        this.quantity = quantity;
    }

    public ProductWrapper(Product__c product, Integer quantity, Decimal price) {
        this.product = product;
        this.quantity = quantity;
        this.price = price;
    }

}