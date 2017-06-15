/**
 * Created by new on 30.05.2017.
 */

@IsTest
private class ProductControllerTest {

    @isTest
    private static void productsTest()
    {
       ProductController pc = new ProductController();
        pc.showAllProducts();
        System.assertEquals('All products',pc.category);
        pc.showProductsBurger();
        System.assertEquals('Burgers',pc.category);
        pc.showProductsPizza();
        System.assertEquals('Pizzas',pc.category);
        pc.showProductsSoup();
        System.assertEquals('Soups',pc.category);
        pc.showProductsWog();
        System.assertEquals('Wogs',pc.category);
    }
}