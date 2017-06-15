/**
 * Created by new on 29.05.2017.
 */

public with sharing class ProductWrapperUtilis {

    public static List<ProductWrapper> getWrappersFromProducts(List<Product__c> prods) {
        List<ProductWrapper> productWrappers = new List<ProductWrapper>();
        for (Product__c p : prods) {
            productWrappers.add(new ProductWrapper(p));
        }
        return productWrappers;
    }

}