public class StripeSubscriptionSchedules {

    public class SubscriptionScheduleRequest {
        @InvocableVariable(required=true)
        public String customer;
        @InvocableVariable
        public Long start_date;
        @InvocableVariable
        public String start_date_now;
        @InvocableVariable(required=true)
        public List<StripeSubscriptionSchedulePhase> phases;
        @InvocableVariable
        public List<StripeSubscriptionScheduleMetadata> metadata; // Serialized JSON string of the map
        @InvocableVariable(required=true)
        public String stripeAccountId;
        @InvocableVariable
        public String connectAccount;
    }

    @InvocableMethod
    public static List<String> createSubscriptionSchedule(List<SubscriptionScheduleRequest> requests) {
        List<String> results = new List<String>();

        for (SubscriptionScheduleRequest request : requests) {
            // Deserialize metadata
            // Convert metadata to map
            Map<String, String> requestMetadata = new Map<String, String>();
            if (request.metadata != null) {
                for (StripeSubscriptionScheduleMetadata metadataItem : request.metadata) {
                    requestMetadata.put(metadataItem.key, metadataItem.value);
                }
            }

            // Prepare the request body
            List<String> postParameters = new List<String>{
                'customer=' + request.customer
            };
            if (request.start_date != Null){
                postParameters.add('start_date=' + request.start_date);
            }
            if (request.start_date_now != Null){
                postParameters.add('start_date=' + request.start_date_now);
            }

            for (Integer i = 0; i < request.phases.size(); i++) {
                StripeSubscriptionSchedulePhase phase = request.phases[i];
                if (phase.collection_method != null) {
                    postParameters.add('phases[' + i + '][collection_method]=' + phase.collection_method);
                }
                if (phase.iterations != null) {
                    postParameters.add('phases[' + i + '][iterations]=' + phase.iterations);
                }
                if (phase.automatic_tax_enabled != null) {
                    postParameters.add('phases[' + i + '][automatic_tax][enabled]=' + phase.automatic_tax_enabled);
                }
                if (phase.proration_behavior != null) {
                    postParameters.add('phases[' + i + '][proration_behavior]=' + phase.proration_behavior);
                }
                if (phase.invoice_settings_days_until_due != null) { 
                    postParameters.add('phases[' + i + '][invoice_settings][days_until_due]=' + phase.invoice_settings_days_until_due);
                }
                if (phase.end_date != Null){
                    postParameters.add('phases[' + i + '][end_date]=' + phase.end_date);
                }
                
                Map<String, String> phaseMetadata = new Map<String, String>();
                if (phase.metadata != null) {
                    for (StripeSubscriptionScheduleMetadata metadataItem : phase.metadata) {
                        phaseMetadata.put(metadataItem.key, metadataItem.value);
                    }
                }

                for (String key : phaseMetadata.keySet()) {
                    postParameters.add('phases[' + i + '][metadata][' + key + ']=' + phaseMetadata.get(key));
                }
                
                Integer priceSub = 0;
                Integer priceInv = 0;
                for (Integer j = 0; j < phase.items.size(); j++) {
                    StripeSubscriptionScheduleItem item = phase.items[j];
                    
                    // Check for price or plan for each item
                    if (item.price == null) {
                        throw new CalloutException('Each item must have a price specified.');
                    }

                    Map<String, Integer> itemBillingThresholds = item.billing_thresholds != null ? (Map<String, Integer>)JSON.deserialize(item.billing_thresholds, Map<String, Integer>.class) : new Map<String, Integer>();
                    if(item.SubProduct == True){
                        for (String key : itemBillingThresholds.keySet()) {
                            postParameters.add('phases[' + i + '][items][' + priceSub + '][billing_thresholds][' + key + ']=' + itemBillingThresholds.get(key));
                        }
                        if(item.price != Null){
                            postParameters.add('phases[' + i + '][items][' + priceSub + '][price]=' + item.price);
                        }
                        if (item.quantity != Null){
                            postParameters.add('phases[' + i + '][items][' + priceSub + '][quantity]=' + item.quantity);
                        }
                        for (Integer k = 0; k < (item.discounts != null ? item.discounts.size() : 0); k++) {
                            postParameters.add('phases[' + i + '][items][' + priceSub + '][discounts][' + k + '][coupon]=' + item.discounts[k].coupon);
                        }

                        Map<String, String> itemMetadata = new Map<String, String>();
                        if (item.metadata != null) {
                            for (StripeSubscriptionScheduleMetadata metadataItem : item.metadata) {
                                itemMetadata.put(metadataItem.key, metadataItem.value);
                            }
                        }
                        for (String key : itemMetadata.keySet()) {
                            postParameters.add('phases[' + i + '][items][' + priceSub + '][metadata][' + key + ']=' + itemMetadata.get(key));
                        }
                        priceSub++;
                    }
                    if(item.SubProduct == False){ 
                        if(item.price != Null){
                            postParameters.add('phases[' + i + '][add_invoice_items][' + priceInv + '][price]=' + item.price);
                        }
                        if (item.quantity != Null){
                            postParameters.add('phases[' + i + '][add_invoice_items][' + priceInv + '][quantity]=' + item.quantity);
                        }
                        for (Integer k = 0; k < (item.discounts != null ? item.discounts.size() : 0); k++) {
                            postParameters.add('phases[' + i + '][add_invoice_items][' + priceInv + '][discounts][' + k + '][coupon]=' + item.discounts[k].coupon);
                        }

                        Map<String, String> itemMetadata = new Map<String, String>();
                        if (item.metadata != null) {
                            for (StripeSubscriptionScheduleMetadata metadataItem : item.metadata) {
                                itemMetadata.put(metadataItem.key, metadataItem.value);
                            }
                        }
                        for (String key : itemMetadata.keySet()) {
                            postParameters.add('phases[' + i + '][add_invoice_items][' + priceInv + '][metadata][' + key + ']=' + itemMetadata.get(key));
                        }
                        priceInv++;
                    }
                }
            }

            for (String key : requestMetadata.keySet()) {
                postParameters.add('metadata[' + key + ']=' + requestMetadata.get(key));
            }

            String requestBody = String.join(postParameters, '&');

            // Stripe callout
            stripeGC.RawInvocableParameters parameters = new stripeGC.RawInvocableParameters();
            parameters.method = 'POST';
            parameters.endpoint = '/v1/subscription_schedules';
            parameters.requestBody = requestBody;
            
            parameters.accountId = request.stripeAccountId;

            List<stripeGC.RawInvocableParameters> paramsCollection = new List<stripeGC.RawInvocableParameters>{ parameters };
            List<String> calloutResults = stripeGC.AgnosticInvocable.callStripeEndpoint(paramsCollection);

            if (calloutResults != null && calloutResults.size() > 0) {
                results.add(calloutResults[0]);
            } else {
                throw new CalloutException('Stripe callout failed');
            }
        }
        
        return results;
    }
}
