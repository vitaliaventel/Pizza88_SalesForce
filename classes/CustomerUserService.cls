/**
 * Created by new on 26.05.2017.
 */

public with sharing class CustomerUserService {

    public static Custom_User__c getUserByEmail(String userEmail) {
        return [
                SELECT Id,
                        Name,
                        Password__c,
                        Email__c
                FROM Custom_User__c
                WHERE Email__c = :userEmail
        ];
    }

    public static Custom_User__c getUserById(String userId){
        return [
                SELECT Id,
                        Name,
                        Password__c,
                        Email__c
                FROM Custom_User__c
                WHERE Id = :userId
        ];
    }
}