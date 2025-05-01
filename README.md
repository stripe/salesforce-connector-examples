# Stripe for Salesforce Platform

The Stripe app for Salesforce is designed to bridge the gap between Stripe and Salesforce. This app functions as a versatile integration builder, enabling low-code solutions via Salesforce Flow Builder, APEX-driven processes, and event mapping through webhooks. By natively exposing Stripe's API as classes and objects within Salesforce, Salesforce Admins and Developers can develop custom flows with APEX with seamless drag-and-drop integrations between Stripe and Salesforce Flow. By handling authentication and event mappings, the connector drastically reduces the effort needed to build an integration between any Stripe product and any Core Salesforce product.

More information about this connector can be found on:
* [Stripe Documentation](https://docs.stripe.com/connectors/stripe-connector-for-salesforce/overview)
* [Salesforce App Exchange](https://appexchange.salesforce.com/appxListingDetail?listingId=4dff0f8e-0b10-47c2-a3a3-f3905e7f7927)

## Best Practices: Integrating Stripe with Salesforce Experience Cloud

This guide outlines key considerations and recommended approaches when building custom payment portals in Salesforce Experience Cloud using the Stripe app for Salesforce.

**Understanding the Landscape:**

The Stripe app for Salesforce provides robust tools for integrating Stripe with your Salesforce instance. However, extending these capabilities to public-facing Experience Cloud portals introduces unique challenges, particularly around JavaScript execution and user permissions.

**Key Learnings & Solutions:**

Here's how to navigate the identified limitations:

**1. Dynamic JavaScript Loading in LWC:**

* **Challenge:** Salesforce does not natively support dynamically loading external JavaScript libraries like Stripe.js within Lightning Web Components (LWCs).
* **Solution:**
    * **Aura Components as Bridges:** Embed Stripe-dependent functionalities within Aura components. These Aura components can then be seamlessly integrated into your LWCs or Visualforce pages within the Experience Cloud. This allows you to leverage the Stripe.js library effectively.
    * **Visualforce with LWC:** Alternatively, host LWCs requiring Stripe.js within a Visualforce page. This provides the necessary framework for including external JavaScript.

**2. Salesforce User Licensing and Access:**

* **Challenge:** The Stripe app for Salesforce is installed for Salesforce administrators and licensed users. Standard Experience Cloud users, especially unauthenticated guest users, lack direct access to the app's underlying objects and functionalities.
* **Solutions:** To enable Stripe interactions for a broader audience, consider these approaches:

    * **Run Flow as Admin:**
        * **Implementation:** If your Stripe integration logic is encapsulated within a Salesforce Flow, configure the Flow to run in System Context. This executes the Flow with administrator-level permissions, bypassing the Experience Cloud user's access restrictions.
        * **Guest User Permissions:** Ensure the Guest User profile associated with your Experience Cloud site has explicit permission to run the specific Flow.
        * **Considerations:** Exercise caution when granting Guest User access and thoroughly audit the Flow's logic for security implications.

    * **Custom API Endpoint (Apex REST):**
        * **Implementation:** Develop a custom Apex REST API endpoint. This endpoint would contain the necessary logic to interact with the Stripe app's data or functionalities. Configure the Apex class to execute with elevated permissions (`without sharing` keyword, if necessary, with careful security review).
        * **Invocation:** Your LWC or JavaScript within the Experience Cloud page can then call this custom API endpoint to perform Stripe-related actions.
        * **Considerations:** This approach offers granular control over data access and operations but requires Apex development and rigorous security considerations.

    * **Data Cloning:**
        * **Implementation:** For scenarios involving displaying Stripe-related information, consider cloning essential data from the Stripe app's protected objects into custom Salesforce objects accessible by your Experience Cloud users (including those with "Community Plus" licenses).
        * **Apex Query Adjustment:** Modify your Apex code within LWCs or controllers to query these newly created custom objects instead of the original, restricted Stripe app objects.
        * **Considerations:** This method involves data duplication and requires mechanisms to keep the cloned data synchronized with the original Stripe app data. Evaluate the volume and frequency of data changes to determine its feasibility.

**Choosing the Right Path:**

The optimal approach depends on the specific requirements of your custom portal, the complexity of the Stripe interactions, and your development resources.

* For simple data display, data cloning might be sufficient.
* For more complex operations requiring direct interaction with Stripe, running Flows as Admin or building custom API endpoints offer more flexibility.

By carefully considering these best practices and the unique challenges of integrating external services within Experience Cloud, you can build secure and functional custom payment portals leveraging the power of the Stripe app for Salesforce. Remember to prioritize security and thoroughly test all implementations.

