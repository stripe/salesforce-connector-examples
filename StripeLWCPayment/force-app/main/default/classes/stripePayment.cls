public class stripePayment {  
    @AuraEnabled(cacheable=true)  
    public static String paymentIntent(String StripeAccountID, String amount, String stripecurrency, String orderID, String onBehalfOf, String customerId) {  
        // Create Call for invocable  
        stripeGC.RawInvocableParameters parameters = new stripeGC.RawInvocableParameters();  
        // Add HTTP Method  
        parameters.method = 'POST';  
  
        // Add endpoint  
        parameters.endpoint = '/v1/payment_intents';  
  
        // Get the Stripe Account ID from Salesforce  
        // This assumes you already have the Stripe Account ID and will pass it in as a parameter  
        // Alternately, you could use a SOQL query to obtain the Stripe Account ID as per previous examples  
        parameters.accountId = StripeAccountID;  
        parameters.connectAccount = onBehalfOf;
        // Prepare the request body  
        List<String> postPaymentIntentParameters = new List<String>{  
            'amount=' + amount, // Pass in the amount to be charged for this payment intent in the minimum currency unit (for example, cents for USD)  
            'currency=' + stripecurrency, // Pass in the currency for this payment intent (for example, 'usd' for USD)  
            'customer=' + customerId, // Pass in customer to payment intent
            'automatic_payment_methods[enabled]=true', //Turning on automatic payment methods
            'metadata[order_id]=' + orderID
        };  
  
        parameters.requestBody = String.join(postPaymentIntentParameters, '&');  
  
        List<stripeGC.RawInvocableParameters> paramsCollection = new List<stripeGC.RawInvocableParameters>{ parameters };  
  
        List<String> results = stripeGC.AgnosticInvocable.callStripeEndpoint(paramsCollection);  
  
        return (results != null && results.size() > 0) ? results[0] : null;  
    }  
}  
