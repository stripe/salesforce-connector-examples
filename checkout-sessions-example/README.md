This example creates a [Checkout Session](https://stripe.com/docs/api/checkout/sessions) from a component on an order detail page. Once the checkout session is completed, a trigger will
fire after the Stripe Event has been created from the webhook event. The trigger will populate the Stripe Customer Id custom field on the Account object if it is empty with the Stripe Customer Id associated with the checkout session.

# Installation

1. Complete the [installation of the Stripe Universal Connector](/README.md). Be sure to install the Stripe Universal Connector Extension package in the API Version Enablement step of the Setup Assistant wizard to complete this example. 

    If you have already completed the initial setup and haven't installed the extension package, you can install it from the API Version settings tab.

2. Deploy this code example into your Salesforce org. 

# Configuration

## Configurating the Connector

1. Go to the Stripe Universal Connector Setup tab.

2. On the Account Management tab, click on the connected account.

3. Go to the __All Webhook Events__ tab and search the __Stripe Object__ dropdown menu for the __Checkout Session__ Stripe object.

4. Enable the __checkout.session.completed__ event and click **Save**.

## Configurating the Order Detail Page

1. Go to the app launcher and search for **Orders**. Click on the Orders item under Items.

2. Click the gear icon on the top right side of the browser and click on **Edit Object**.

3. Click on the **Lightning Record Pages** tab and click **New**.

4. Follow the instructions on the screen. Be sure that the object field of the record page is set to **Order**.

7. In the list of components on the right side, scroll down until you see the component labeled **Stripe Checkout Link**. Drag the component onto the layout section. Save the record page and follow the instructions that appear.

# Source Directory

- `classes` - Apex classes
    + GenerateCheckoutLinkController - Controller class for the generateCheckoutLink component. This class queries the order and associated children and parent objects and calls out to Stripe with this information to generate a checkout session.
    + `GenerateCheckoutLinkControllerTest` - Test class for the `GenerateCheckoutLinkController` class
    + `StripeGCStripeEventHelper` - Helper class for the Stripe Event triggerthat holds the logic of casting the request body field of the Stripe event to a Checkout Session, extracting the information from the Checkout Session object, and updating the Account with the Stripe customer id if needed.
    +` StripeGCStripeEventHelperTest` - Test class for the `StripeGCStripeEventHelper` class
- `lwc` - Lightning web components
    + `generateCheckoutLink` - Component that lives on an order detail page that will generate a chceckout session link when the **Generate Checkout Link** button is clicked,
- `objects` - Custom fields and objects in the code sample
    + `Account/fields/Stripe_Customer_Id__c` - Custom field on the Account object that holds a Stripe customer id
- `staticresources` - Static resources
    + 
- `triggers` - Apex triggers
    + `StripeGCStripeEventTrigger` - Trigger that fires when a Stripe Event has been created. Saves the customer id associated with the checkout sessions to the Stripe_Account_Id__c field in the Account record if it has not been set.