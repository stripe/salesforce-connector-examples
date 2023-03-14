trigger StripeGCStripeEvent on stripeGC__Stripe_Event__c (after insert) {
    StripeGCStripeEventHelper.saveCustomerIds(Trigger.new);
}