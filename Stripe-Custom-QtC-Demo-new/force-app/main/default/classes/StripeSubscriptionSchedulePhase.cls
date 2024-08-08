global class StripeSubscriptionSchedulePhase {
    @AuraEnabled
    @InvocableVariable(required=true)
    global List<StripeSubscriptionScheduleItem> items;
    @AuraEnabled
    @InvocableVariable(required=true)
    global String collection_method;
    @AuraEnabled
    @InvocableVariable
    global Integer iterations;
    @AuraEnabled
    @InvocableVariable
    global Boolean automatic_tax_enabled;
    @AuraEnabled
    @InvocableVariable
    global String proration_behavior;
    @AuraEnabled
    @InvocableVariable
    global List<StripeSubscriptionScheduleMetadata> metadata; // Serialized JSON string of the map
    @AuraEnabled
    @InvocableVariable
    global String invoice_settings_days_until_due;
    @AuraEnabled
    @InvocableVariable
    global String start_date_now;
    @AuraEnabled
    @InvocableVariable
    global Integer start_date;
    @AuraEnabled
    @InvocableVariable
    global Integer end_date;
    @AuraEnabled
    @InvocableVariable
    global String status;
}