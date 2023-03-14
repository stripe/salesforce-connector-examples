/**
 * @description This class handles generation of a Stripe checkout session from a Salesforce order
 */
public with sharing class GenerateCheckoutLinkController {

    /**
     * @description This class handles Stripe events created from webhook events. In this case, the Stripe Customer Id custom field
     * of the Account object associated with the checkout session is populated if the event name is checkout.sessions.completed and
     * the Stripe Customer Id field is currently empty.
     * 
     * @param orderId The id of the Salesforce Order Id to create into a checkout session 
     * @return the URL of the checkout session that was created
     */
    @AuraEnabled
    public static String generateCheckoutLink(String orderId){
        try {

            //query for information used in the checkout session
            List<OrderItem> orderItems = [
                SELECT
                    Id,
                    UnitPrice,
                    Quantity,
                    Product2.Name,
                    Order.Account.Id,
                    Order.Account.Stripe_Customer_Id__c
                FROM OrderItem
                WHERE OrderId = :orderId
            ];

            //add Create Checkout Sessions parameters
            stripeGC.CreateCheckoutSessions.V1 params = new stripeGC.CreateCheckoutSessions.V1();
            stripeGC__Stripe_Account__c stripeAccount = [
                SELECT Id
                FROM stripeGC__Stripe_Account__c
                LIMIT 1
            ];

            params.accountRecordId = stripeAccount.Id;
            
            params.successUrl = String.format(
                'https://stripe3.my.salesforce-sites.com/stripeExamplePages/Example_Checkout_Success?order_number={0}',
                new List<String>{ 
                    orderId 
                }
            );
            params.cancelUrl = 'https://stripe3.my.salesforce-sites.com/stripeExamplePages/Example_Checkout_Cancel';
            params.paymentMethodTypes = new List<String>{
                'card',
                'us_bank_account'
            };
            params.mode = 'payment';
            params.customerCreation = 'always';

            if (orderItems.size() > 0) {
                Order parentOrder = orderItems[0].Order;

                //add parent account id as metadata
                params.metadata = new stripeGC.Metadata();
                params.metadata.listAdditionalStringField = new List<stripeGC.AdditionalString>{
                    new stripeGC.AdditionalString('Salesforce Account Id', parentOrder.Account.Id)
                };

                //add Stripe customer id if it exists
                if (String.isNotBlank(parentOrder.Account.Stripe_Customer_Id__c)) {
                    params.customer = parentOrder.Account.Stripe_Customer_Id__c;
                }
            }

            params.lineItems = new List<stripeGC.CreateCheckoutSessionsReqLineItem>();

            //add line items to the parameters
            for (OrderItem orderItem : orderItems) {

                stripeGC.CreateCheckoutSessionsReqLineItem lineItemParams = new stripeGC.CreateCheckoutSessionsReqLineItem();
                lineItemParams.priceData = new stripeGC.CreateCOSsReqLineItemPdata();
                lineItemParams.priceData.productData = new stripeGC.CreateCOSsReqLineItemPdataProdData();

                lineItemParams.priceData.productData.name = orderItem.Product2.Name;
                lineItemParams.priceData.unitAmount = (Integer) orderItem.UnitPrice * 100;
                lineItemParams.priceData.r_currency = 'USD';
                lineItemParams.quantity = (Integer) orderItem.Quantity;

                params.lineItems.add(lineItemParams);
            }

            //create checkout session
            List<stripeGC.CreateCheckoutSessions.V1> paramsCollection = new List<stripeGC.CreateCheckoutSessions.V1>{ 
                params
            }; 
            List<stripeGC.CheckoutSession> checkoutSessions = stripeGC.v01_CreateCheckoutSessions.createCheckoutSessions_2022_11_15(paramsCollection);
            return checkoutSessions[0].url;
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}