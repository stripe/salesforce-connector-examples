@isTest
public with sharing class GenerateCheckoutLinkControllerTest {

    @isTest
    private static void testGenerateCheckoutLink() {

        //create Stripe account
        Map<String, Object> stripeAccountJson = new Map<String, Object>{
            'Name' => 'Test Stripe Account',
            'stripeGC__Is_Live_Mode__c' => false,
            'stripeGC__Access_Token__c' => 'at_1234',
            'stripeGC__Refresh_Token__c' => 'rt_1234',
            'stripeGC__Is_Connected__c' => true,
            'stripeGC__Stripe_Account_Id__c' => 'acct_1234'
        };

        String serializedJson = JSON.serialize(stripeAccountJson);
        stripeGC__Stripe_Account__c stripeAcc = stripeGC.HttpMockTest.createTestStripeAccount(serializedJson);

        insert stripeAcc;

        //create Salesforce account
        Account account = new Account(
            Name='Test Account',
            Stripe_Customer_Id__c = 'cus_1234'
        );

        insert account;
        
        //create product
        Product2 product = new Product2(
            Name='Test Product 1'
        );

        insert product;

        //create order
        Order order = new Order(
            AccountId = account.Id,
            Status = 'Draft',
            EffectiveDate = Date.today(),
            Pricebook2Id = Test.getStandardPricebookId()
        );

        insert order;

        //create pricebook entry
        PricebookEntry priceBookEntry = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(),
            Product2Id = product.Id,
            UnitPrice = 500
        );

        insert priceBookEntry;

        //create order item
        OrderItem orderItem = new OrderItem(
            OrderId = order.Id,
            UnitPrice = 500,
            Quantity = 10,
            Product2Id = product.Id,
            PricebookEntryId = priceBookEntry.Id
        );

        insert orderItem;

        //use the package set mock function
        stripeGC.HttpMockTest.setMock(HttpCalloutMock.class, new StripeCalloutMock());
        Test.startTest();

            //generate checkout link
            String url = GenerateCheckoutLinkController.generateCheckoutLink(order.Id);
            System.assertEquals('https://example.com', url);

        Test.stopTest();
    }

    class StripeCalloutMock implements HttpCalloutMock {

        public HttpResponse respond(HttpRequest request) {
            HttpResponse response = new HttpResponse();
            Map<String, Object> responseBody = new Map<String, Object>{
                'id' => 'cs_test_1234',
                'success_url' => 'https://stripe3.my.salesforce-sites.com/stripeExamplePages/Example_Checkout_Success',
                'cancel_url' => 'https://stripe3.my.salesforce-sites.com/stripeExamplePages/Example_Checkout_Cancel',
                'url' => 'https://example.com'
            };

            response.setStatusCode(200);
            response.setBody(JSON.serialize(responseBody));
            return response;
        }
    }

}