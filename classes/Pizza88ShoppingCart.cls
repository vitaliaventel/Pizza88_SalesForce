/**
 * Created by Denis on 26.05.2017.
 * This class contains products and their quantities 
 * that user add to shopping cart.
 * Supposed to serialize instances to JSON and save it into cookies.
 */

public with sharing class Pizza88ShoppingCart {

    //Fields
    public List<ProductWrapper> productItems {get; set;}

    //Constructors
    public Pizza88ShoppingCart() {
        System.debug('SHOPPING CART CONTROLLER EXECUTED');
        this.productItems = new List<ProductWrapper>();
    }

    //Methods

    //database
    public Boolean saveOrder(Custom_User__c user) {
        try {
            System.debug('In save order. User : ' + user);

            Custom_Order__c customOrder = new Custom_Order__c(
                    User__c = user.Id,
                    Total_Price__c = this.totalPrice());

            insert customOrder;

            System.debug('custom order inserted : ' + customOrder);
            System.debug('process productItems');

            List<Order_Product__c> orderProducts = new List<Order_Product__c>();
            for (ProductWrapper productItem : productItems) {
                Order_Product__c orderProduct = new Order_Product__c(
                        Order__c = customOrder.Id,
                        Product__c = productItem.product.Id,
                        Price__c = productItem.product.Price__c,
                        Quantity__c = productItem.quantity);

                System.debug('Order_Product constructed : ' + orderProduct);

                orderProducts.add(orderProduct);

                System.debug('Order Product added');

            }
            insert orderProducts;

            System.debug('order products inserted' + orderProducts);

            return true;
        } catch (Exception e) {
            System.debug('Exception occcured while processing order save in Pizza88ShoppingCart');
            System.debug(e.getMessage());
            ApexPages.addMessages(e);
            return false;
        }
    }

    //processing cart logic
    public ProductWrapper addProduct(Product__c product, Integer quantity) {
        try {
            System.assert(quantity > 0, Pizza88ErrorMessages.NEGATIVE_QUANTITY_ERROR);

            //if product exists in caart then update quantity
            ProductWrapper productItem = this.findProductItems(product);
            if (productItem == null) {
                productItem = new ProductWrapper(product, quantity);
                productItems.add(productItem);
            } else {
                productItem.quantity = quantity;
            }

            System.debug('Product added to cart: ' + product.Name + ' quantity : ' + quantity);

            return productItem;
        } catch (AssertException ae) {
            System.debug(ae);
            //ApexPages.addMessages(ae);
            ApexPages.Message msg = new Apexpages.Message(ApexPages.Severity.Warning, ae.getMessage() );
            ApexPages.addmessage(msg);
            return null;
        }
    }

    public ProductWrapper addOne(Product__c product) {
        try {

            ProductWrapper productItem = this.findProductItems(product);

            System.debug('ADD ONE METHOD: ' + productItem);
            System.debug('SHOPPING CART: ' + productItems);

            if (productItem == null) {//if product is not in cart
                productItem = new ProductWrapper(product, 1);
                productItems.add(productItem);
            } else {//if product already in cart
                productItem.quantity++;
            }

            System.debug('Product added to cart: ' + product.Name);
            System.debug('SHOPPING CART: AFTER ADD' + productItems);

            return productItem;
        } catch (AssertException ae) {
            System.debug(ae);
            ApexPages.addMessages(ae);
            return null;
        }
    }

    public ProductWrapper removeOne(Product__c product) {
        try {
            ProductWrapper productItem = this.findProductItems(product);

            System.assert(productItem != null);

            if (productItem.quantity == 1) {
                this.removeProductItems(productItem.product);
            } else {
                productItem.quantity--;
            }

            System.debug('One item removed from cart: ' + product.Name);

            return productItem;
        } catch (AssertException ae) {
            System.debug(ae);
            ApexPages.addMessages(ae);
            return null;
        }
    }

    public ProductWrapper findProductItems(Product__c product) {
        System.debug('find products: ' + product.Id);
        for (ProductWrapper pi : this.productItems) {
            if (pi.product.Id == product.Id) {
                System.debug('product found : ' + pi.product.Name);
                return pi;
            }
        }
        return null;
    }

    public ProductWrapper removeProductItems(Product__c product) {
        Integer i = 0;
        for (ProductWrapper pi : this.productItems) {
            if (pi.product.Id == product.Id) {
                this.productItems.remove(i);
                return pi;
            }
            i++;
        }
        return null;
    }

    public Integer countProducts() {
        return this.productItems.size();
    }

    public Integer totalItems() {
        Integer total = 0;
        for (ProductWrapper pi : productItems) {
            total += pi.quantity;
        }
        System.debug('Pizza88SC total items : ' + total);
        return total;
    }

    public Decimal totalPrice() {
        Decimal total = 0;
        for (ProductWrapper pi : productItems) {
            total += pi.product.Price__c * pi.quantity;
        }
        System.debug('Pizza88SC total price : ' + total);
        return total;
    }

    public void clearCart(){
        productItems.clear();
    }

}