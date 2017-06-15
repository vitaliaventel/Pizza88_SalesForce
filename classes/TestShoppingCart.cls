/**
 * Created by new on 25.05.2017.
 */

public with sharing class TestShoppingCart {

    public static void test() {
        Pizza88ShoppingCart shoppingCart = new Pizza88ShoppingCart();
        List<Product__c> allProducts = [SELECT Id, Name, Active__c, Price__c FROM Product__c];
        Product__c p = allProducts[0];
        shoppingCart.addOne(p);
        shoppingCart.addOne(p);
        shoppingCart.removeOne(p);
        shoppingCart.addProduct(allProducts[1], -5);

        shoppingCart.removeOne(allProducts[1]);
        shoppingCart.removeOne(allProducts[1]);
        shoppingCart.removeOne(allProducts[1]);
        shoppingCart.removeOne(allProducts[1]);
        shoppingCart.removeOne(allProducts[1]);
        shoppingCart.removeOne(allProducts[1]);

        String jsonCart = JSON.serialize(shoppingCart);
        System.debug(jsonCart);
        Pizza88ShoppingCart shoppingCart1 = (Pizza88ShoppingCart) JSON.deserialize(jsonCart, Pizza88ShoppingCart.class);
//        System.debug(shoppingCart1.count());
        System.debug(shoppingCart1);
//        shoppingCart1.removeOne(p);
//        shoppingCart1.removeOne(p);
//        shoppingCart1.removeOne(p);

    }

}