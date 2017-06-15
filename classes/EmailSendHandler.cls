/**
 * Created by new on 01.06.2017.
 */

public with sharing class EmailSendHandler {

    public static void sendEmail(Custom_User__c user){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new List<String>{user.Email__c});
        mail.setSubject('Pizza88 Store order');
        mail.setPlainTextBody('Hi, ' + user.Name + '! Welcome to our pizza eaters team, your order was successfully created, please wait our delivery agent will call you.');
        Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{mail},true);
    }

}