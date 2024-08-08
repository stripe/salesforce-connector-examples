global class StripeSubscriptionScheduleDiscount {
    @AuraEnabled
    @InvocableVariable(required=true)
    global String coupon;
}