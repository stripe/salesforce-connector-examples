# Example Of Using Any Stripe Payment Type/Method On Any Salesforce Surface using Flow

## Description
An Example to show how to build flows to accept (Terminal, Payment Elements, Checkout, Payment Links, Invoices...) Payments using Stripe inside Salesforce. 
Could help build 
- Field Service Integrations
- Custom B2B Payments
- Custom QtC processes
- Donations
- Almost Any Other Payment senario you can dream or build

Demo Video Showing this Example In action. 
[Video]([https://drive.google.com/file/d/1Q8JI_1bM4edp3HOXhmv_Yg_3Sb_SiOsH/view?usp=share_link](https://youtu.be/V65XTpNRa9Q))

## Run the sample on your Org

_This example can be installed on your salesforce org
configuration will vary depending on your salesforce environment._

### Requirements

- **A Stripe account**: You can sign up for a Stripe account here: https://dashboard.stripe.com/register
- **A Salesforce Org**: You can register for a Salesforce account here: https://developer.salesforce.com
- **Stripe For Salesforce Platform Connector [Salesforce AppExhange](https://appexchange.salesforce.com/appxListingDetail?listingId=4dff0f8e-0b10-47c2-a3a3-f3905e7f7927)**
- **Stripe For Salesforce Platform Installed [Docs](https://site-admin.stripe.com/docs/plugins/stripe-connector-for-salesforce/installation-guide)**

### Installing the example

To download a Salesforce project from GitHub and deploy it into a Dev or Scratch org, follow these steps:

1. Clone the GitHub repository that contains the Salesforce project you want to download onto your local machine using the git clone command. 
```sh
git clone https://github.com/stripe/salesforce-connector-examples.git
```

2. Once the repository is cloned, navigate to the root directory of the example in the command line interface.
```sh
cd Payments-On-Every-Surface
```

3. Deploy the project to your salesforce org:
```sh
sf project retrieve start --target-org <YOUR_ORG>
```

## Author(s)

- [@millin-stripe](https://github.com/millin-stripe)
