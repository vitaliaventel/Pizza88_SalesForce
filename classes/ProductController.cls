/**
 * Created by new on 25.05.2017.
 */

public with sharing class ProductController {

    //Properties
    public List<ProductWrapper> products { get; private set; }
    public String category { get; private set; }
    public Pizza88ShoppingCart shoppingCart { get; set; }
    public String message { get; set; }

    public static final Integer CART_SIZE = 7;

    //Constructor
    public ProductController() {


        System.debug('ProductController Constructor: after showAllProducts method.');

        if (ApexPages.currentPage().getCookies() != null) {

            System.debug('ProductController Constructor: cookies != null.');

            if (!ApexPages.currentPage().getCookies().containsKey('cart')) {

                System.debug('ProductController Constructor: new ShoppingCart()');

                shoppingCart = new Pizza88ShoppingCart();
                makeCookies();
            }
        }

        System.debug('ProductController Constructor: after cookies.');

        String jsonCart = ApexPages.currentPage().getCookies().get('cart').getValue();
        shoppingCart = (Pizza88ShoppingCart) JSON.deserialize(jsonCart, Pizza88ShoppingCart.class);

        System.debug(shoppingCart);

        showAllProducts();
    }

    //Methods

    private void recalculateQuantities() {
        for (ProductWrapper pw : products) {
            ProductWrapper inCart = shoppingCart.findProductItems(pw.product);
            if (inCart != null) {
                pw.quantity = inCart.quantity;
            }
        }
    }

    public Integer getTotalItems() {
        return shoppingCart.totalItems();
    }

    public Decimal getTotalPrice() {
        return shoppingCart.totalPrice();
    }

    public PageReference toShoppingCart() {
        PageReference pr = new PageReference('/apex/ShoppingCart');
        pr.setRedirect(true);
        return pr;
    }

    public void showAllProducts() {
        products = ProductService.retrieveAllProducts();
        recalculateQuantities();
        category = 'All products';
    }

    public void showProductsPizza() {
        products = ProductService.retrievePizzas();
        recalculateQuantities();
        category = 'Pizzas';
    }
    public void showProductsSoup() {
        products = ProductService.retrieveSoups();
        recalculateQuantities();
        category = 'Soups';
    }
    public void showProductsWog() {
        products = ProductService.retrieveWogs();
        recalculateQuantities();
        category = 'Wogs';
    }
    public void showProductsBurger() {
        products = ProductService.retrieveBurgers();
        recalculateQuantities();
        category = 'Burgers';
    }

    public void addToCart() {
        try {
            if (shoppingCart.productItems.size() != CART_SIZE) {
                System.debug('ProductController.addToCart method: in add to cart debug');

                ProductWrapper prod;
                String prodIdString = ApexPages.currentPage().getParameters().get('prod');
                String quantityString = ApexPages.currentPage().getParameters().get('quantity');

                System.debug('ProductController.addToCart method : found ID = ' + prodIdString);
                System.debug('ProductController.addToCart Method : quantity = ' + quantityString);

                //find product in wrappers
                for (ProductWrapper pw : products) {
                    if (pw.product.Id == prodIdString) {
                        System.debug('product founded :  ' + pw);
                        prod = pw;
                        break;
                    }
                }
                ProductWrapper updatedPW;
                if (quantityString == null || String.isEmpty(quantityString)) {
                    updatedPW = shoppingCart.addOne(prod.product);
                } else {
                    Integer q = Integer.valueOf(quantityString);
                    updatedPW = shoppingCart.addProduct(prod.product, q);
                }

                prod.quantity = updatedPW.quantity;

                System.debug('ProductController.addToCart method : end method, over cookies.');

                makeCookies();
            }else{
                message = 'Shopping cart says: "Hey, I cannot carry too many items, try using 2 carts :)"';
            }
        } catch (Exception e) {
            System.debug(e);
            ApexPages.Message msg = new Apexpages.Message(ApexPages.Severity.Warning, 'Error in add to cart');
            ApexPages.addmessage(msg);
        }
    }

    private void makeCookies() {
        String jsonCart = JSON.serialize(shoppingCart);
        Cookie cookieJsonCart = new Cookie('cart', jsonCart, null, -1, false);
        Map<String, Cookie> cookieMap = ApexPages.currentPage().getCookies();
        List<Cookie> cookiesList = cookieMap.values();
        cookiesList.add(cookieJsonCart);

        System.debug('ProductController.makeCookies method, JSONCart: ' + cookieJsonCart);
        System.debug('ProductController.makeCookies method: before setCookies');

        ApexPages.currentPage().setCookies(cookiesList);

        System.debug('ProductController.makeCookies method: after setCookies');
    }

}