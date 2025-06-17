A Salesforce extension is a separate package that adds functionality to an existing managed package. Think of it as an add-on to your core application that provides additional features or customizations without modifying the original package.  This allows for a modular approach to development and deployment.

## Why to use Extensions
Salesforce extensions are particularly valuable for apps like the [Stripe app for Salesforce platform](https://appexchange.salesforce.com/appxListingDetail?listingId=4dff0f8e-0b10-47c2-a3a3-f3905e7f7927&tab=r) because they:

* **Provide Flexibility:** Allow for customization of the Stripe Connector to fit specific business needs without altering the core, managed package.  This ensures that the core functionality remains stable and upgradeable.
* **Enable Targeted Functionality:** Deliver specific features to certain user segments or use cases. For example, an extension might add advanced reporting for finance teams or custom payment workflows for a particular industry.
* **Simplify Upgrades:** Since extensions are separate, the core Stripe app can be upgraded without affecting the customizations provided by the extension. This reduces the risk of conflicts and simplifies the upgrade process.
* **Promote Modularity:** Encourage a more organized and maintainable Salesforce environment.  Functionality is broken down into logical units, making it easier to manage and troubleshoot.
* **Extend without Bloating:** Prevent the core Stripe app managed package from becoming bloated with niche features. Extension allows you to install only the functionality they need.

## Current Supported Extensions

| Extensions    | Description |
| -------- | ------- |
| Salesforce Billing Extension| Provides support for ACH and credit card payments through Salesforce Billing and Payment Center|
|Stripe API v2022 Extension| Enables invocables and access to Stripe API in SF Flow Builder and Apex|

