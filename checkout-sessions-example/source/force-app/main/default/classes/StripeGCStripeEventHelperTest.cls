@isTest
private with sharing class StripeGCStripeEventHelperTest {

    //Stripe event request body
    private static String createRequestBody(String accountId) {
        Map<String, Object> requestBody = new Map<String, Object>{
            'id' => 'evt_1234',
            'object' => 'event',
            'data' => new Map<String, Object>{
                'object' => new Map<String, Object>{
                    'id' => 'cs_test_1234',
                    'customer' => 'cus_1234',
                    'metadata' => new Map<String, String>{
                        'Salesforce Account Id' => accountId
                    }
                }
            }
        };

        return JSON.serialize(requestBody);
    }

    @isTest
    private static void testCheckoutStripeEventHelper() {

        //create account
        Account account = new Account(
            Name='Test Account'
        );

        insert account;

        //create Stripe event
        stripeGC__Stripe_Event__c stripeEvent = new stripeGC__Stripe_Event__c(
            stripeGC__Event_Name__c = 'checkout.session.completed',
            stripeGC__Request_Body__c = createRequestBody(account.Id)
        );

        insert stripeEvent;

        //check that the Stripe Customer Id field has been set on insertion
        account = [
            SELECT Id, Stripe_Customer_Id__c 
            FROM Account 
            WHERE Id = :account.Id
        ];

        System.assertEquals('cus_1234', account.Stripe_Customer_Id__c);
    }
}