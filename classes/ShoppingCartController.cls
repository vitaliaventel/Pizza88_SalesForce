/**
 * Created by new on 30.05.2017.
 */

public with sharing class ShoppingCartController {

    public String jsonCart { get; set; }
    public List<CartItem> items { get; set; }
    public Pizza88ShoppingCart shoppingCart { get; set; }
    public Id productId { get; set; }

    public void retrieveCart() {
        try {
            System.debug('In retrieveCart : ');
            this.jsonCart = ApexPages.currentPage().getParameters().get('cart');
            System.debug(jsonCart);
            this.items = (List<CartItem>) JSON.deserialize(jsonCart, List<CartItem>.class);
            //validations FIXME

            //retrieve products ids
            List<Id> productIds = new List<Id>();
            for (CartItem item : items) {
                productIds.add(item.productId);
            }

            //this.productItems = new List<ProductItem>();
            List<Product__c> productsList = [
                    SELECT Id,
                            Name,
                            Type__c,
                            Active__c,
                            Description__c,
                            Image_URL__c,
                            Price__c
                    FROM Product__c
                    WHERE Id IN :productIds
            ];
            Map<Id, Product__c> mapProductsByIds = new Map<Id, Product__c>();
            for (Product__c p : productsList) {
                mapProductsByIds.put(p.Id, p);
            }

            //construct shoppingCart
            this.shoppingCart = new Pizza88ShoppingCart();

            for (Integer i = 0; i < items.size(); i++) {
                //ProductItem pi = new ProductItem(mapProductsByIds.get(productIds[i]), items[i].quantity, items[i].price);
                //productItems.add(pi);
                shoppingCart.addProduct(mapProductsByIds.get(productIds[i]), items[i].quantity);
            }

            System.debug('ProductItems length : ' + shoppingCart.productItems.size());

        } catch (Exception e) {
            System.debug('error in controller constructor');
            System.debug(e.getMessage());
        }
    }

    public void removeFromCart() {
        System.debug('Remove id: ' + productId);
        ProductItem pi  = shoppingCart.removeProductItems(new Product__c(Id=productId));
        System.debug(pi + ' was removed.');
    }

    public void addOneToCart() {
        System.debug('Remove id: ' + productId);
        shoppingCart.addOne(new Product__c(Id=productId));
        //this.jsonCart = shoppingCart.constructCartItems();
    }

    public void removeOneFromCart() {
        System.debug('Remove id: ' + productId);
        shoppingCart.removeOne(new Product__c(Id=productId));
    }

}