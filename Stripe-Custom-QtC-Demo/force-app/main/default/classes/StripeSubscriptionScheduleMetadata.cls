global class StripeSubscriptionScheduleMetadata {
    @AuraEnabled
    @InvocableVariable(required=true)
    global String key;
    @AuraEnabled
    @InvocableVariable(required=true)
    global String value;
}