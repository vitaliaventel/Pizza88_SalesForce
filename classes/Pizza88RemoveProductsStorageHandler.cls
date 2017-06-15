/**
 * Created by new on 31.05.2017.
 */

public with sharing class Pizza88RemoveProductsStorageHandler {

    public static final Integer PRODUCT_LOW_LIMIT = 3;
    public static final Integer PRODUCT_AUTO_DELIVERY = 5;

    public static void onBeforeInsert(List<Custom_Order__c> orders) {
        for (Custom_Order__c customOrder : orders) {
            customOrder.Status__c = 'New';
        }
    }

    public static void onBeforeUpdate(List<Custom_Order__c> orders) {
        List<Id> orderIds = new List<Id>();
        for (Custom_Order__c order : orders) {
            if (order.Status__c == 'Closed') {
                orderIds.add(order.Id);
            }
        }

        List<Order_Product__c> orderProducts = [
                SELECT Id,
                        Quantity__c,
                        Product__r.Available__c,
                        Order__c
                FROM Order_Product__c
                WHERE Order__c IN :orderIds
        ];

        for (Order_Product__c op : orderProducts) {
            Product__c prod = op.Product__r;
            if (prod.Available__c < op.Quantity__c) {
                for (Custom_Order__c customOrder : orders) {
                    if (customOrder.Id == op.Order__c) {
                        customOrder.addError('Product quantity in order is greater than available products!!!!');
                    }
                }
            }
        }
    }

    public static void onAfterUpdate(List<Custom_Order__c> orders) {
        List<Product__c> products = new List<Product__c>();
        List<Id> orderIds = new List<Id>();
        for (Custom_Order__c order : orders) {
            if (order.Status__c == 'Closed') {
                orderIds.add(order.Id);
            }
        }

        List<Order_Product__c> orderProducts = [
                SELECT Id,
                        Quantity__c,
                        Product__r.Available__c
                FROM Order_Product__c
                WHERE Order__c IN :orderIds
        ];
        for (Order_Product__c op : orderProducts) {
            Product__c prod = op.Product__r;
            if (prod.Available__c >= op.Quantity__c) {
                prod.Available__c -= op.Quantity__c;
                if (prod.Available__c < PRODUCT_LOW_LIMIT) {
                    prod.Available__c += PRODUCT_AUTO_DELIVERY;
                }
                products.add(prod);
            } else {
                for (Custom_Order__c customOrder : orders) {
                    if (customOrder.Id == op.Order__c) {
                        customOrder.addError('Product quantity in order is greater than available products!!!!');
                    }
                }
            }
        }


        update products;
    }

}