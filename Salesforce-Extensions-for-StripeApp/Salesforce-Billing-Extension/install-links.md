## Test ## 
```v1.2.0```
https://test.salesforce.com/packaging/installPackage.apexp?p0=04tRN000005VfIXYA0

## Production ## 
```v1.2.0```
https://login.salesforce.com/packaging/installPackage.apexp?p0=04tRN000005VfIXYA0

Stripe Docs: [Click Here](https://docs.stripe.com/connectors/salesforce-billing-extension)

### Gateway Type picklist: ### 
```Stripe (Universal Extension)```

### Payment Gateway Value: ###
Please ensure the "Payment Gateway value" matches the same as listed under ```Billing Settings``` in the configuration UI of Stripe app for Salesforce

### Prerequisites
- This extension requires the [Stripe app for Salesforce](https://appexchange.salesforce.com/appxListingDetail?listingId=4dff0f8e-0b10-47c2-a3a3-f3905e7f7927&tab=r). Please install the parent/managed app before installing this extension.
- Some operations require your Stripe account to be gated for raw PANs. Ensure your Stripe account has this permission, especially when using the Salesforce Billing payment center.
- This unmanaged package includes support for Stripe's (beta) Surcharging API. To use the surcharging calculation functionality:
  - Ensure your Stripe account is gated for the Surcharging API.
  - Follow the instructions in the provided PDF for setting up the surcharging flow.


[Install and Config Salesforce Platform and Billing Extension.pdf](https://github.com/user-attachments/files/20785141/Install.and.Config.Salesforce.Platform.and.Billing.Extension.pdf)
