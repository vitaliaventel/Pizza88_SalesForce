/**
 * Created by new on 26.05.2017.
 */

public with sharing class ProductService {

    public static List<ProductWrapper> retrieveAllProducts() {
        List<Product__c> prods = [
                SELECT Id,
                        Name,
                        Type__c,
                        Active__c,
                        Description__c,
                        Image_URL__c,
                        Price__c,
                        Available__c
                FROM Product__c
                WHERE Active__c = true
                ORDER BY Name
        ];
        return ProductWrapperUtilis.getWrappersFromProducts(prods);
    }

    public static List<ProductWrapper> retrievePizzas() {
        List<Product__c> prods = [
                SELECT Id,
                        Name,
                        Type__c,
                        Active__c,
                        Description__c,
                        Image_URL__c,
                        Price__c,
                        Available__c
                FROM Product__c
                WHERE Active__c = true
                AND
                Type__c = 'Pizza'
        ];
        return ProductWrapperUtilis.getWrappersFromProducts(prods);
    }

    public static List<ProductWrapper> retrieveBurgers() {
        List<Product__c> prods = [
                SELECT Id,
                        Name,
                        Type__c,
                        Active__c,
                        Description__c,
                        Image_URL__c,
                        Price__c,
                        Available__c
                FROM Product__c
                WHERE Active__c = true
                AND
                Type__c = 'Burger'
        ];
        return ProductWrapperUtilis.getWrappersFromProducts(prods);
    }

    public static List<ProductWrapper> retrieveSoups() {
        List<Product__c> prods = [
                SELECT Id,
                        Name,
                        Type__c,
                        Active__c,
                        Description__c,
                        Image_URL__c,
                        Price__c,
                        Available__c
                FROM Product__c
                WHERE Active__c = true
                AND
                Type__c = 'Soup'
        ];
        return ProductWrapperUtilis.getWrappersFromProducts(prods);
    }

    public static List<ProductWrapper> retrieveWogs() {
        List<Product__c> prods = [
                SELECT Id,
                        Name,
                        Type__c,
                        Active__c,
                        Description__c,
                        Image_URL__c,
                        Price__c,
                        Available__c
                FROM Product__c
                WHERE Active__c = true
                AND
                Type__c = 'Wog'
        ];
        return ProductWrapperUtilis.getWrappersFromProducts(prods);
    }

}