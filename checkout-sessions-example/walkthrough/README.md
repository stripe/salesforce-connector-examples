# Walkthrough of the Checkout Sessions Example

This README is a walkthrough of the Checkout Sessions Example. 

## Generating Checkout Session Link

1. Follow the instructions in [the example README](../README.md) to install and configure the code example 

2. Create an order in your Salesforce org. For further information on creating an order, consult [Salesforce documentation](https://help.salesforce.com/s/articleView?id=sf.order_overview.htm&type=5).

3. On the order detail page, click the **Generate Checkout Link** button on the component placed in the previous step to generate a checkout session link.


## Stripe Event Trigger

1. Complete the steps in [Generating Checkout Session Link](#generating-checkout-session-link).

2. Navigate to the generated checkout session link.

3. Complete the checkout session on the page.

4. Once the checkout session has been successfully completed, the customer id should be added to the Account record assoicated with the order. 