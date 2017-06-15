/**
 * Created by new on 31.05.2017.
 */

trigger Pizza88RemoveProductsStorageTrigger on Custom_Order__c (before insert, before update, after update) {

    if (Trigger.isBefore) {

        if (Trigger.isInsert) {
            Pizza88RemoveProductsStorageHandler.onBeforeInsert(Trigger.new);
        }

        if (Trigger.isUpdate) {
            Pizza88RemoveProductsStorageHandler.onBeforeUpdate(Trigger.new);
        }
    }

    if (Trigger.isAfter) {
        if (Trigger.isUpdate) {
            Pizza88RemoveProductsStorageHandler.onAfterUpdate(Trigger.new);
        }
    }


}