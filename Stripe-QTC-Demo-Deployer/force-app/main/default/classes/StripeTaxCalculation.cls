global class StripeTaxCalculation {

    // Define the inner classes to match the JSON structure
    global class Address {
        @AuraEnabled
        @InvocableVariable
        public String city;
        @AuraEnabled
        @InvocableVariable
        public String country;
        @AuraEnabled
        @InvocableVariable
        public String line1;
        @AuraEnabled
        @InvocableVariable
        public String line2;
        @AuraEnabled
        @InvocableVariable
        public String postal_code;
        @AuraEnabled
        @InvocableVariable
        public String state;
    }

    global class CustomerDetails {
        @AuraEnabled
        @InvocableVariable
        public Address address;
        @AuraEnabled
        @InvocableVariable
        public String address_source;
        @AuraEnabled
        @InvocableVariable
        public String ip_address;
        @AuraEnabled
        @InvocableVariable
        public List<String> tax_ids;
        @AuraEnabled
        @InvocableVariable
        public String taxability_override;
    }

    global class ShippingCost {
        @AuraEnabled
        @InvocableVariable
        public Integer amount;
        @AuraEnabled
        @InvocableVariable
        public Integer amount_tax;
        @AuraEnabled
        @InvocableVariable
        public String tax_behavior;
        @AuraEnabled
        @InvocableVariable
        public String tax_code;
    }

    global class TaxRateDetails {
        @AuraEnabled
        @InvocableVariable
        public String country;
        @AuraEnabled
        @InvocableVariable
        public String percentage_decimal;
        @AuraEnabled
        @InvocableVariable
        public String state;
        @AuraEnabled
        @InvocableVariable
        public String tax_type;
    }

    global class TaxBreakdown {
        @AuraEnabled
        @InvocableVariable
        public Integer amount;
        @AuraEnabled
        @InvocableVariable
        public Boolean inclusive;
        @AuraEnabled
        @InvocableVariable
        public TaxRateDetails tax_rate_details;
        @AuraEnabled
        @InvocableVariable
        public String taxability_reason;
        @AuraEnabled
        @InvocableVariable
        public Integer taxable_amount;
    }

    // Define the properties for the main class
    @InvocableVariable
    @AuraEnabled
    global String id;
    @AuraEnabled
    @InvocableVariable
    global Integer amount_total;
    @AuraEnabled
    @InvocableVariable
    global String customer;
    @AuraEnabled
    @InvocableVariable
    global CustomerDetails customer_details;
    @AuraEnabled
    @InvocableVariable
    global Long expires_at;
    @AuraEnabled
    @InvocableVariable
    global Boolean livemode;
    @AuraEnabled
    @InvocableVariable
    global String ship_from_details;
    @AuraEnabled
    @InvocableVariable
    global ShippingCost shipping_cost;
    @AuraEnabled
    @InvocableVariable
    global Integer tax_amount_exclusive;
    @AuraEnabled
    @InvocableVariable
    global Integer tax_amount_inclusive;
    @AuraEnabled
    @InvocableVariable
    global List<TaxBreakdown> tax_breakdown;
    @AuraEnabled
    @InvocableVariable
    global Long tax_date;

    // Method to parse JSON and instantiate the class
    global static StripeTaxCalculation parse(String jsonString) {
        return (StripeTaxCalculation) JSON.deserialize(jsonString, StripeTaxCalculation.class);
    }

    // Wrapper class for the output of the InvocableMethod
    global class StripeTaxCalculationResult {
        @AuraEnabled
        @InvocableVariable
        global StripeTaxCalculation calculation;
    }

    // Invocable method to run the class in a Flow
    @InvocableMethod(label='Parse Stripe Tax Calculation' description='Parses the Stripe Tax Calculation JSON and returns an instance of the class')
    global static List<StripeTaxCalculationResult> parseJSON(List<String> jsonStrings) {
        List<StripeTaxCalculationResult> results = new List<StripeTaxCalculationResult>();
        for(String jsonString : jsonStrings) {
            StripeTaxCalculationResult result = new StripeTaxCalculationResult();
            result.calculation = parse(jsonString);
            results.add(result);
        }
        return results;
    }
}