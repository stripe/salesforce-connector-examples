public class StripePaymentController {
	@AuraEnabled(cacheable=true)
    public static String getClientSecret() {
        // Your logic to interact with Salesforce Flow or directly with Stripe
        String clientSecret = 'pi_3Pkn'; // This would typically be fetched dynamically
        return clientSecret;
    }
    @AuraEnabled(cacheable=true)
    public static String getPublishablekey() {
        // Your logic to interact with Salesforce Flow or directly with Stripe
        String pubKey = 'pk_test_51Pio5aJDW'; // This would typically be fetched dynamically
        return pubKey;
    }
    @AuraEnabled(cacheable=true)
    public static String paymentIntent() {
        //Fetch Stripe Account
        StripeGC__Stripe_Account__c stripeAccount = [SELECT Id FROM StripeGC__Stripe_Account__c LIMIT 1];
        String stripeAccountID = stripeAccount.Id;
        // Create Call for invocable
        stripeGC.RawInvocableParameters parameters = new stripeGC.RawInvocableParameters();
        // Add HTTP Method
        parameters.method = 'POST';

        // Add endpoint
        parameters.endpoint = '/v1/payment_intents';

        // Get the Stripe Account ID from Salesforce
        // This assumes you already have the Stripe Account ID and will pass it in as a parameter
        // Alternately, you could use a SOQL query to obtain the Stripe Account ID as per previous examples
        parameters.accountId = stripeAccountID;

        // Prepare the request body
        List<String> postPaymentIntentParameters = new List<String>{
            'amount=' + 2000, // Pass in the amount to be charged for this payment intent in the minimum currency unit (for example, cents for USD)
            'currency=' + 'usd', // Pass in the currency for this payment intent (for example, 'usd' for USD)
            'automatic_payment_methods[enabled]=true' //Turning on automatic payment methods
        };

        parameters.requestBody = String.join(postPaymentIntentParameters, '&');

        List<stripeGC.RawInvocableParameters> paramsCollection = new List<stripeGC.RawInvocableParameters>{ parameters };

        List<String> results = stripeGC.AgnosticInvocable.callStripeEndpoint(paramsCollection);

        // Check if results are not null and have content
    	if (results != null && results.size() > 0) {
        	String jsonResponse = results[0];

        // Parse the JSON response to extract the client_secret
        	Map<String, Object> parsedResponse = (Map<String, Object>) JSON.deserializeUntyped(jsonResponse);

        	if (parsedResponse.containsKey('client_secret')) {
            	String clientSecret = (String) parsedResponse.get('client_secret');
            	return clientSecret;
        	}
    	}

    	return ''; // Return null if there's no client_secret
	}
    }