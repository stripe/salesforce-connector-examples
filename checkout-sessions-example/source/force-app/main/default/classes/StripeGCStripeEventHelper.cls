/**
 * @description This class handles Stripe events created from webhook events. In this case, the Stripe Customer Id custom field
 * of the Account object associated with the checkout session is populated if the event name is checkout.sessions.completed and
 * the Stripe Customer Id field is currently empty.
 * 
 */
public with sharing class StripeGCStripeEventHelper {

    /**
     * @description This class handles Stripe events created from webhook events. In this case, the Stripe Customer Id custom field
     * of the Account object associated with the checkout session is populated if the event name is checkout.sessions.completed and
     * the Stripe Customer Id field is currently empty.
     * 
     * @param stripeEvents A list of the newly inserted Stripe events 
     */
    public static void saveCustomerIds(List<stripeGC__Stripe_Event__c> stripeEvents) {
        Map<String, String> stripeCustomerIdsByAccountId = new Map<String, String>();

        //get account id metadata entry for all Stripe events that are of the type checkout.session.completed
        for (stripeGC__Stripe_Event__c stripeEvent : stripeEvents) {
            if (stripeEvent.stripeGC__Event_Name__c == 'checkout.session.completed') {

                //cast event data object to the checkout session class
                stripeGC.v01_CastCheckoutSession.Params params = new stripeGC.v01_CastCheckoutSession.Params();
                params.requestBody = stripeEvent.stripeGC__Request_Body__c;
                List<stripeGC.v01_CastCheckoutSession.Params> paramsCollection = new List<stripeGC.v01_CastCheckoutSession.Params>{
                    params
                };
                List<stripeGC.CheckoutSession> checkoutSessions = stripeGC.v01_CastCheckoutSession.castCheckoutSession_2022_11_15(paramsCollection);

                //gets Salesforce account id metadata entry
                for (stripeGC.AdditionalString metadataEntry : checkoutSessions[0].metadata.listAdditionalStringField) {
                    if (metadataEntry.key == 'Salesforce Account Id') {
                        stripeCustomerIdsByAccountId.put(metadataEntry.value, checkoutSessions[0].customer);
                        break;
                    }
                }
            }
        }

        List<Account> accountsToBeUpdated = new List<Account>();

        //update account with Stripe Customer id if the field is not already set
        for (Account account : [SELECT Id, Stripe_Customer_Id__c FROM Account WHERE Id IN :stripeCustomerIdsByAccountId.keySet()]) {
            if (String.isEmpty(account.Stripe_Customer_Id__c)) {
                account.Stripe_Customer_Id__c = stripeCustomerIdsByAccountId.get(account.Id);
                accountsToBeUpdated.add(account);
            }
        }

        update accountsToBeUpdated;
    }
}