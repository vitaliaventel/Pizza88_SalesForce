/**
 * Created by new on 26.05.2017.
 */

public with sharing class Pizza88ShoppingCartController {

    //fields
    public Pizza88ShoppingCart shoppingCart { get; set; }
    public Id productId { get; set; }
    public String message {get; set; }

    //controllers
    public Pizza88ShoppingCartController() {
        if (ApexPages.currentPage().getCookies() != null) {
            System.debug('cookies is not null');
            if (!ApexPages.currentPage().getCookies().containsKey('cart')) {
                System.debug('cookies not contains CART');
                shoppingCart = new Pizza88ShoppingCart();
                makeCookies();
            }
        }
        System.debug('cart is in cookies');
        String jsonCart = ApexPages.currentPage().getCookies().get('cart').getValue();
        System.debug(jsonCart);
        shoppingCart = (Pizza88ShoppingCart) JSON.deserialize(jsonCart, Pizza88ShoppingCart.class);
        System.debug(shoppingCart);
    }

    //methods
    public void init() {
        if (ApexPages.currentPage().getCookies() != null) {
            System.debug('cookies is not null');
            if (!ApexPages.currentPage().getCookies().containsKey('cart')) {
                System.debug('cookies not contains CART');
                shoppingCart = new Pizza88ShoppingCart();
                makeCookies();
            }
        }
        System.debug('cart is in cookies');
        String jsonCart = ApexPages.currentPage().getCookies().get('cart').getValue();
        System.debug(jsonCart);
        shoppingCart = (Pizza88ShoppingCart) JSON.deserialize(jsonCart, Pizza88ShoppingCart.class);
        System.debug(shoppingCart);
    }

    public Integer getTotalItems(){
        return shoppingCart.totalItems();
    }

    public Decimal getTotalPrice(){
        return shoppingCart.totalPrice();
    }

    public void removeFromCart() {
        System.debug('Remove id: ' + productId);
        ProductWrapper pi = shoppingCart.removeProductItems(new Product__c(Id = productId));
        System.debug(pi + ' was removed.');
        makeCookies();
    }

    public void addOneToCart() {
        System.debug('Add id: ' + productId);
        shoppingCart.addOne(new Product__c(Id = productId));
        System.debug('1 Added!');
        makeCookies();
    }

    public void removeOneFromCart() {
        System.debug('Remove id: ' + productId);
        shoppingCart.removeOne(new Product__c(Id = productId));
        System.debug('1 removed');
        makeCookies();
    }

    public PageReference makeOrder() {
        try {
            if(shoppingCart.productItems.isEmpty()){
                message = 'Sorry! Your shopping cart is empty! Try to add some products.';
                return null;
            }

            PageReference page;
            if (ApexPages.currentPage().getCookies().get('username') != null) {

                String userId = ApexPages.currentPage().getCookies().get('userId').getValue();
                System.debug('Recieved userId : ' + userId);

                Custom_User__c user = new Custom_User__c(Id = userId);

                if(shoppingCart.saveOrder(user)){
                    message = 'Your order was created successfully, check email.';
                    EmailSendHandler.sendEmail(CustomerUserService.getUserById(userId));
                }else{
                    message = 'Some problems, try again later!';
                }

                page = null;
            } else {
                page = new PageReference('/apex/LoginPage');
                page.setRedirect(true);
            }

            return page;
        } catch (Exception e) {
            System.debug('Exception was occured while processing makeOrder in SCController');
            message = 'Exception was occured while processing makeOrder in SCController';
            System.debug(e.getMessage());
            ApexPages.addMessages(e);
            return null;
        }
    }

    public void cancelCart(){
        String jsonCart = ApexPages.currentPage().getCookies().get('cart').getValue();
        shoppingCart = (Pizza88ShoppingCart) JSON.deserialize(jsonCart, Pizza88ShoppingCart.class);
        shoppingCart.clearCart();
        makeCookies();
    }

    private void makeCookies() {
        String jsonCart = JSON.serialize(shoppingCart);
        Cookie cookieJsonCart = new Cookie('cart', jsonCart, null, -1, false);
        List<Cookie> cookies = new List<Cookie>{
                cookieJsonCart
        };
        System.debug('makeCookies: before setCookies');
        ApexPages.currentPage().setCookies(cookies);
        System.debug('makeCookies: after setCookies');

        //debug
        String jsonCartDebug = ApexPages.currentPage().getCookies().get('cart').getValue();
        System.debug('new cart : ' + jsonCartDebug);
    }

}