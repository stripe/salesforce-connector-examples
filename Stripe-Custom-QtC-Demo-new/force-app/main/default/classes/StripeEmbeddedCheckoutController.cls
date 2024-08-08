public with sharing class StripeEmbeddedCheckoutController {
    public String stripeAccountID { get; set; }
    public String lineItems { get; set; }
    public String clientSecKey { get; set; }
    public String publishableKey { get; set; }

    public StripeEmbeddedCheckoutController(){
        List<StripeGC__Stripe_Account__c> stripeAccounts = [SELECT Publishable_key__c FROM StripeGC__Stripe_Account__c WHERE Publishable_key__c != null LIMIT 1];
        if (!stripeAccounts.isEmpty()) {
            publishableKey = stripeAccounts[0].Publishable_key__c;
            stripeAccountID = stripeAccounts[0].id;
        }
    }

    // PageReference method to be called by apex:actionFunction
    public PageReference createStripeCheckoutSessionPage() {
        String result = createStripeCheckoutSession(lineItems);
        System.debug('API Response: ' + result);
        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(result);
        if (responseMap.containsKey('client_secret')) {
            clientSecKey = (String) responseMap.get('client_secret');
        } else {
            clientSecKey = 'Client secret not found in response';
        }
        System.debug('Client Secret Key: ' + clientSecKey);
        return null;
    }

    public static String createStripeCheckoutSession(String lineItemsJson) {
        String stripeAID;
        List<StripeGC__Stripe_Account__c> stripeAccount = [SELECT Publishable_key__c FROM StripeGC__Stripe_Account__c WHERE Publishable_key__c != null LIMIT 1];
        if (!stripeAccount.isEmpty()) {
            stripeAID = stripeAccount[0].id;
        }
        List<LineItem> lineItems = (List<LineItem>) JSON.deserialize(lineItemsJson, List<LineItem>.class);
        stripeGC.RawInvocableParameters parameters = new stripeGC.RawInvocableParameters();
        parameters.method = 'POST';
        parameters.endpoint = '/v1/checkout/sessions';
        parameters.accountId = stripeAID;

        List<String> postSessionParameters = new List<String>();
        postSessionParameters.add('mode=payment');
        postSessionParameters.add('return_url=https://example.com/success');
        postSessionParameters.add('ui_mode=embedded');
        postSessionParameters.add('customer_creation=always');

        for (Integer i = 0; i < lineItems.size(); i++) {
            LineItem item = lineItems[i];
            if (item.name != null) {
                postSessionParameters.add('line_items[' + i + '][price_data][product_data][name]=' + item.name);
            }
            if (item.description != null) {
                postSessionParameters.add('line_items[' + i + '][price_data][product_data][description]=' + item.description);
            }
            if (item.images != null && !item.images.isEmpty()) {
                postSessionParameters.add('line_items[' + i + '][price_data][product_data][images][0]=' + String.join(item.images, ','));
            }
            if (item.amount != null) {
                postSessionParameters.add('line_items[' + i + '][price_data][unit_amount]=' + item.amount);
            }
            if (item.itemcurrency != null) {
                postSessionParameters.add('line_items[' + i + '][price_data][currency]=' + item.itemcurrency);
            }
            if (item.quantity != null) {
                postSessionParameters.add('line_items[' + i + '][quantity]=' + item.quantity);
                postSessionParameters.add('line_items[' + i + '][adjustable_quantity][enabled]=true');

            }
        }
        parameters.requestBody = String.join(postSessionParameters, '&');

        List<stripeGC.RawInvocableParameters> paramsCollection = new List<stripeGC.RawInvocableParameters> { parameters };
        List<String> results = stripeGC.AgnosticInvocable.callStripeEndpoint(paramsCollection);

        System.debug('Stripe API Response: ' + results);

        if (results != null && results.size() > 0) {
            return results[0];
        } else {
            return '{"error": "Failed to create session"}';
        }
    }

    public String getClientSecKey() {
        return clientSecKey;
    }

    public class LineItem {
        public String name;
        public String description;
        public List<String> images;
        public Integer amount;
        public String itemcurrency;
        public Integer quantity;
    }
}