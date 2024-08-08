global class StripeSubscriptionScheduleUpdate {

    global class SubscriptionScheduleUpdateRequest {
        @InvocableVariable(required=true)
        public String subscription_schedule_id;
        @InvocableVariable(required=true)
        public List<StripeSubscriptionSchedulePhase> phases;
        @InvocableVariable
        public List<StripeSubscriptionScheduleMetadata> metadata; // Serialized JSON string of the map
        @InvocableVariable(required=true)
        public String stripeAccountId;
        @InvocableVariable
        public String connectAccount;
        @InvocableVariable(required=true)
        public Integer ammendment_Date_Start;
    }

    global class StripeSubscriptionSchedulePhaseWrapper {
        public StripeSubscriptionSchedulePhase phase;
        public StripeSubscriptionSchedulePhaseWrapper(StripeSubscriptionSchedulePhase phase) {
            this.phase = phase;
        }
    }

    @InvocableMethod
    public static List<String> updateSubscriptionSchedule(List<SubscriptionScheduleUpdateRequest> requests) {
        List<String> results = new List<String>();

        for (SubscriptionScheduleUpdateRequest request : requests) {
            System.debug('Processing request for subscription_schedule_id: ' + request.subscription_schedule_id);
            
            // Add Callout to get Schedule
            stripeGC.RawInvocableParameters getparameters = new stripeGC.RawInvocableParameters();
            getparameters.method = 'GET';
            getparameters.endpoint = '/v1/subscription_schedules/' + request.subscription_schedule_id;
            getparameters.accountId = request.stripeAccountId;

            List<stripeGC.RawInvocableParameters> getparamsCollection = new List<stripeGC.RawInvocableParameters>{ getparameters };
            List<String> getcalloutResults = stripeGC.AgnosticInvocable.callStripeEndpoint(getparamsCollection);

            if (getcalloutResults != null && getcalloutResults.size() > 0) {
                Map<String, Object> subSchedule = (Map<String, Object>)JSON.deserializeUntyped(getcalloutResults[0]);
                if (subSchedule.containsKey('current_phase')) {
                    Map<String, Object> currentPhase = (Map<String, Object>)subSchedule.get('current_phase');

                    Integer startDate = currentPhase.containsKey('start_date') ? (Integer)currentPhase.get('start_date') : null;
                    Integer endDate = currentPhase.containsKey('end_date') ? (Integer)currentPhase.get('end_date') : null;
                    List<Object> subphases = (List<Object>)subSchedule.get('phases');
                    for (Object phaseObj : subphases) {
                        Map<String, Object> subphase = (Map<String, Object>)phaseObj;
                        Integer currentphaseStart = (Integer)subphase.get('start_date');
                        if (currentphaseStart == startDate) {
                            StripeSubscriptionSchedulePhase oldPhase = new StripeSubscriptionSchedulePhase();
                            oldPhase.status = 'active';
                            oldPhase.end_date = request.ammendment_Date_Start;
                            oldPhase.start_date = (Integer)subphase.get('start_date');
                            if (subphase.containsKey('automatic_tax')) {
                                Map<String, Object> subphaseAutomatic_tax = (Map<String, Object>)subphase.get('automatic_tax');
                                oldPhase.automatic_tax_enabled = (Boolean)subphaseAutomatic_tax.get('enabled');
                            }
                            oldPhase.collection_method = (String)subphase.get('collection_method');
                            if (subphase.containsKey('invoice_settings')) {
                                Map<String, Object> subphaseInvoiceSettings = (Map<String, Object>)subphase.get('invoice_settings');
                                oldPhase.invoice_settings_days_until_due = String.valueOf(subphaseInvoiceSettings.get('days_until_due'));
                            }
                            oldPhase.proration_behavior = (String)subphase.get('proration_behavior');
                            oldPhase.metadata = new List<StripeSubscriptionScheduleMetadata>();
                            if (subphase.containsKey('metadata')) {
                                Map<String, Object> subphaseMetadata = (Map<String, Object>)subphase.get('metadata');
                                for (String key : subphaseMetadata.keySet()) {
                                    StripeSubscriptionScheduleMetadata metadata = new StripeSubscriptionScheduleMetadata();
                                    metadata.key = key;
                                    metadata.value = String.valueOf(subphaseMetadata.get(key));
                                    oldPhase.metadata.add(metadata);
                                }
                            }
                            oldPhase.items = new List<StripeSubscriptionScheduleItem>();
                            List<Object> subphaseItems = (List<Object>)subphase.get('items');
                            for (Object subphaseItem : subphaseItems) {
                                Map<String, Object> subitem = (Map<String, Object>)subphaseItem;
                                StripeSubscriptionScheduleItem oldItem = new StripeSubscriptionScheduleItem();
                                oldItem.price = (String)subitem.get('price');
                                oldItem.quantity = (Integer)subitem.get('quantity');
                                oldItem.discounts = new List<StripeSubscriptionScheduleDiscount>();
                                oldItem.SubProduct = True;
                                if (subitem.containsKey('plan')) {
                                   oldItem.plan = (String)subitem.get('plan'); 
                                }
                                if (subitem.containsKey('discounts')) {
                                    List<Object> subitemDiscounts = (List<Object>)subitem.get('discounts');
                                    for (Object discountObjss : subitemDiscounts) {
                                        Map<String, Object> discount = (Map<String, Object>)discountObjss;
                                        StripeSubscriptionScheduleDiscount discountObj = new StripeSubscriptionScheduleDiscount();
                                        discountObj.coupon = (String)discount.get('coupon');
                                        oldItem.discounts.add(discountObj);
                                    }
                                }
                                oldItem.metadata = new List<StripeSubscriptionScheduleMetadata>();
                                if (subitem.containsKey('metadata')) {
                                    Map<String, Object> subitemMetadata = (Map<String, Object>)subitem.get('metadata');
                                    for (String key : subitemMetadata.keySet()) {
                                        StripeSubscriptionScheduleMetadata metadata = new StripeSubscriptionScheduleMetadata();
                                        metadata.key = key;
                                        metadata.value = String.valueOf(subitemMetadata.get(key));
                                        oldItem.metadata.add(metadata);
                                    }
                                }
                                oldPhase.items.add(oldItem);
                            }
                            request.phases.add(0, oldPhase);
                        }
                    }
                    String customerId = (String)subSchedule.get('customer');
                } else {
                    throw new CalloutException('current_phase not found in the response');
                }
            } else {
                throw new CalloutException('Stripe callout failed');
            }
            
            // Deserialize metadata
            // Convert metadata to map
            Map<String, String> requestMetadata = new Map<String, String>();
            if (request.metadata != null) {
                for (StripeSubscriptionScheduleMetadata metadataItem : request.metadata) {
                    requestMetadata.put(metadataItem.key, metadataItem.value);
                }
            }

            // Prepare the request body
            List<String> postParameters = new List<String>{};
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
                if (phase.start_date_now != null){
                    postParameters.add('phases[' + i + '][start_date]=' + phase.start_date_now);
                }
                if (phase.start_date != null){
                    postParameters.add('phases[' + i + '][start_date]=' + phase.start_date);
                }
                if (phase.status != null) {
                   postParameters.add('phases[' + i + '][end_date]=' + request.ammendment_Date_Start);
                    
                }
                if (phase.status == null){
                   if (phase.end_date != null){
                    postParameters.add('phases[' + i + '][end_date]=' + phase.end_date);
                    postParameters.add('phases[' + i + '][start_date]=' + phase.start_date);
                   }
                   if (request.ammendment_Date_Start != null){
                    postParameters.add('phases[' + i + '][start_date]=' + request.ammendment_Date_Start);
                   }
                }

                // Handle phase metadata
                Map<String, String> phaseMetadata = new Map<String, String>();
                if (phase.metadata != null) {
                    for (StripeSubscriptionScheduleMetadata metadataItem : phase.metadata) {
                        phaseMetadata.put(metadataItem.key, metadataItem.value);
                    }
                }
                for (String key : phaseMetadata.keySet()) {
                    postParameters.add('phases[' + i + '][metadata][' + key + ']=' + phaseMetadata.get(key));
                }

                // Handle items within the phase
                Integer priceSub = 0;
                Integer priceInv = 0;
                for (StripeSubscriptionScheduleItem item : phase.items) {
                    if (item.SubProduct == True) {
                        // Subscription items
                        postParameters.add('phases[' + i + '][items][' + priceSub + '][price]=' + item.price);
                        postParameters.add('phases[' + i + '][items][' + priceSub + '][quantity]=' + item.quantity);
                        if (item.plan != null) {
                            postParameters.add('phases[' + i + '][items][' + priceSub + '][plan]=' + item.plan);
                        }
                        if (item.discounts != null) {
                            for (StripeSubscriptionScheduleDiscount discount : item.discounts) {
                                postParameters.add('phases[' + i + '][items][' + priceSub + '][discounts][0][coupon]=' + discount.coupon);
                            }
                        }

                        // Item metadata
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
                    } else {
                        // Invoice items
                        postParameters.add('phases[' + i + '][add_invoice_items][' + priceInv + '][price]=' + item.price);
                        postParameters.add('phases[' + i + '][add_invoice_items][' + priceInv + '][quantity]=' + item.quantity);
                        if (item.plan != null) {
                            postParameters.add('phases[' + i + '][add_invoice_items][' + priceInv + '][plan]=' + item.plan);
                        }
                        if (item.discounts != null) {
                            for (StripeSubscriptionScheduleDiscount discount : item.discounts) {
                                postParameters.add('phases[' + i + '][add_invoice_items][' + priceInv + '][discounts][0][coupon]=' + discount.coupon);
                            }
                        }

                        // Item metadata
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

            // Add general metadata to the request
            for (String key : requestMetadata.keySet()) {
                postParameters.add('metadata[' + key + ']=' + requestMetadata.get(key));
            }

            String requestBody = String.join(postParameters, '&');
            System.debug('Request body: ' + requestBody);

            // Stripe callout
            stripeGC.RawInvocableParameters parameters = new stripeGC.RawInvocableParameters();
            parameters.method = 'POST';
            parameters.endpoint = '/v1/subscription_schedules/' + request.subscription_schedule_id;
            parameters.requestBody = requestBody;
            
            parameters.accountId = request.stripeAccountId;
            if (request.connectAccount != null) {
                parameters.connectAccount = request.connectAccount;
            }

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
