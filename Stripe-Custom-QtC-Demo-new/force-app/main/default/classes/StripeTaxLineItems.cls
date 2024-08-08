global class StripeTaxLineItems {
	@AuraEnabled
    @InvocableVariable(required=true)
    global Integer amount;
    @AuraEnabled
    @InvocableVariable(required=true)
    global String StripeProduct;
    @AuraEnabled
    @InvocableVariable(required=true)
    global String quantity;
    @AuraEnabled
    @InvocableVariable
    global String tax_behavior;
    @AuraEnabled
    @InvocableVariable
    global String tax_code;
    @AuraEnabled
    @InvocableVariable(required=true)
    global String reference;
}