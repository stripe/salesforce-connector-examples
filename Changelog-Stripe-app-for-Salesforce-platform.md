### v2.6.0
* Upgraded the Connected App (CA) used to receive webhook events to an External Client App (ECA)
* When subscribing to webhook events, the 'Events on connected accounts' column hides automatically if the Stripe account has no connected accounts. This avoids creating unnecessary webhook endpoints in your Stripe account

### v2.5.0
* Not a release candidate

### v2.4.0
* Resolved an issue that was preventing the deletion of a webhook endpoint in Salesforce when it was previously deleted in Stripe
* Fixed the initial state of the 'Toggle all' button when updating the list of webhook events subscribed to for Real-Time Stripe Billing Sync
* Renamed 'Billing Sync Settings' to 'Stripe Billing Sync' under Account Management

### v2.3.0
* Added the ability to update the list of webhook events subscribed to for Real Time Stripe Billing Sync
* During Real-Time Stripe Billing Sync, if a DUPLICATE_VALUE or UNABLE_TO_LOCK_ROW exception occurs during synchronous webhook event processing, an asynchronous Queueable job will be enqueued to retry the operation. Note: Only one Queueable is enqueued per transaction to ensure compliance with Salesforce governor limits and minimize performance impact

### v2.2.0
Introducing 2 new sections in the administration console:
* About section – keep track of connector versions and release notes
* Extensions section - manage Stripe extensions integrated with Salesforce

### v2.1.0
* Sync Billing data between connected Stripe accounts and Salesforce org
* Scheduled jobs for automated synchronization of Stripe Billing data, along with a new Salesforce app Stripe Billing Data containing dedicated custom objects
  
### v1.26
* Accept connected account names longer than 80 characters
* Upgraded Salesforce metadata to API version 63.0
  
### v1.25
* Potential errors are now logged asynchronously using platform events to avoid failures during multiple callout scenario in a single SF transaction
* Minor fixes in the  API Version Settings tab

### v1.24
* Update and refactor to make encrypt utilities global

### v1.23
* Add Idempotency-Key header to the AgnosticInvocable method

### v1.22
* Fix sync preferences input validation
* Create an invocable method to search for a metadata tag

### v1.21
* Cleanup Stripe Event and Sync Log records using a scheduled job instead of before insert trigger
* Create a Post Install Script that migrates users of the cleanup trigger to the scheduled job

### v1.20
* Update configuration to support extension support for Salesforce Billing Extension
* Added support for Salesforce Billing Extension
  * Implement card payment surcharges in the new Billing extension
  * Let users specify the surcharge amount using a flow

### v1.19
* Include error response body in the StripeCalloutException

### v1.18
* Update Connected Accounts tab in configuration
* Add support/fix for syncing each connected accounts page async in its individual Apex transaction

### v1.17
* Disable OAuth login mode and default to authenticating using API Restricted Access Keys & Secret Keys
* Added support to reauthorize an account using API key

### v1.16
* Fixed StripeCalloutException message

### v1.15
* Fixed CalloutException inside SyncStripeConnectedAccountsJob

### v1.13
* Renamed Stripe Connector Integration User to Stripe Connector Admin User
* Added support for reauth process for platform accounts (added using an API key)
* Bug fixes to event listings
* Sync all connected accounts (API pagination)

### v1.12
* Added support for showing long Stripe Account names and their badges on two separate lines
* Update soon-to-be deprecated if:true and if:false LWC directives
* Added fix to handle duplicate webhook events
* Added support for event retry with backoff mechanism to Stripe API callouts to overcome lock_timeout errors
* Update reference to use PACKAGE_VERSION instead of Publisher

### v1.11
* Add support for Stripe Connect
