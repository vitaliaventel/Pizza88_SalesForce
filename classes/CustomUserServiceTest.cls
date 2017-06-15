/**
 * Created by new on 30.05.2017.
 */

@IsTest
private class CustomUserServiceTest {

    private static Custom_User__c user;

    @testSetup
    public static void setup(){
        user = new Custom_User__c(Name='Test',Email__c='TestforTest@gmail.com',Password__c='123456');
        insert user;
    }

    @isTest
    private static void findByEmailTest() {
        String email = 'TestforTest@gmail.com';
        Custom_User__c testUser = CustomerUserService.getUserByEmail(email);
        System.assertNotEquals(null, testUser);
        System.assertEquals('Test',testUser.Name);
        System.assertEquals('123456', testUser.Password__c);
    }
}