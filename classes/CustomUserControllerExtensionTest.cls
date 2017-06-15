/**
 * Created by new on 30.05.2017.
 */

@IsTest
private class CustomUserControllerExtensionTest {

    private static Custom_User__c user;

    @isTest
    private static void successLoginTest()
    {
        user = new Custom_User__c(Name='Test',Email__c='TestforTest@gmail.com',Password__c='123456');
        insert user;

        PageReference pageRef = Page.LoginPage;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(user);
        CustomUserControllerExtension userControllerExtension = new CustomUserControllerExtension(sc);
        System.assertEquals(new PageReference('/apex/Main').getUrl(),userControllerExtension.login().getUrl());
    }

    @isTest
    private static void incorrectPasswordTest()
    {
        user = new Custom_User__c(Name='Test',Email__c='TestforTest@gmail.com',Password__c='123456');
        insert user;

        Custom_User__c testUser = user.clone();
        testUser.Password__c = 'qwerty';

        PageReference pageRef = Page.LoginPage;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(testUser);
        CustomUserControllerExtension userControllerExtension = new CustomUserControllerExtension(sc);
        userControllerExtension.login();
        System.assertEquals('Incorrect password, try again!',userControllerExtension.errorMessage);
    }

    @isTest
    private static void incorrectLoginTest()
    {
        user = new Custom_User__c(Name='Test',Email__c='TestforTest@gmail.com',Password__c='123456');
        insert user;

        Custom_User__c testUser = user.clone();
        testUser.Email__c = 'qwerty@gmail.com';

        PageReference pageRef = Page.LoginPage;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(testUser);
        CustomUserControllerExtension userControllerExtension = new CustomUserControllerExtension(sc);
        userControllerExtension.login();
        System.assertEquals('No such user, create new user!',userControllerExtension.errorMessage);
    }

    @isTest
    private static void redirectToRegisterTest()
    {
        user = new Custom_User__c(Name='Test',Email__c='TestforTest@gmail.com',Password__c='123456');
        PageReference pageRef = Page.LoginPage;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(user);
        CustomUserControllerExtension userControllerExtension = new CustomUserControllerExtension(sc);
        System.assertEquals(new PageReference('/apex/Register').getUrl(),userControllerExtension.register().getUrl());
    }

}