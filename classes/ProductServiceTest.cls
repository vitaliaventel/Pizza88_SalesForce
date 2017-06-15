/**
 * Created by new on 30.05.2017.
 */

@IsTest
private class ProductServiceTest {

    private static List<Product__c> products;

    @testSetup
    public static void setup(){
        products = new List<Product__c>{
                new Product__c(Name='Test', Price__c=10.00, Type__c='Pizza', Active__c=true),
                new Product__c(Name='Test', Price__c=10.00, Type__c='Pizza', Active__c=true),
                new Product__c(Name='Test', Price__c=10.00, Type__c='Pizza', Active__c=true),
                new Product__c(Name='Test', Price__c=10.00, Type__c='Pizza', Active__c=true),
                new Product__c(Name='Test', Price__c=10.00, Type__c='Burger', Active__c=true),
                new Product__c(Name='Test', Price__c=10.00, Type__c='Burger', Active__c=true),
                new Product__c(Name='Test', Price__c=10.00, Type__c='Soup', Active__c=true),
                new Product__c(Name='Test', Price__c=10.00, Type__c='Wog', Active__c=true),
                new Product__c(Name='Test', Price__c=10.00, Type__c='Wog', Active__c=true),
                new Product__c(Name='Test', Price__c=10.00, Type__c='Wog', Active__c=true)
        };
        insert products;
    }

    @isTest
    private static void getAllProductsTest() {
        System.assertEquals(10, ProductService.retrieveAllProducts().size());
    }

    @isTest
    private static void getPizzaTest() {
        System.assertEquals(4, ProductService.retrievePizzas().size());
    }

    @isTest
    private static void getBurgerTest() {
        System.assertEquals(2, ProductService.retrieveBurgers().size());
    }

    @isTest
    private static void getSoupTest() {
        System.assertEquals(1, ProductService.retrieveSoups().size());
    }

    @isTest
    private static void getWogTest() {
        System.assertEquals(3, ProductService.retrieveWogs().size());
    }
}