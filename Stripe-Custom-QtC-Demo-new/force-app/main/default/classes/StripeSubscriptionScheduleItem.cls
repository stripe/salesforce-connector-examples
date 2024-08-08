global class StripeSubscriptionScheduleItem {
    @AuraEnabled
    @InvocableVariable
    global String billing_thresholds; // Serialized JSON string of the map
    @AuraEnabled
    @InvocableVariable(required=true)
    global String price;
    @AuraEnabled
    @InvocableVariable
    global Integer quantity;
    @AuraEnabled
    @InvocableVariable
    global List<StripeSubscriptionScheduleDiscount> discounts;
    @AuraEnabled
    @InvocableVariable
    global List<StripeSubscriptionScheduleMetadata> metadata; // Serialized JSON string of the map
	@AuraEnabled
    @InvocableVariable
    global String plan;
    @AuraEnabled
    @InvocableVariable(required=true)
    global Boolean SubProduct;
}