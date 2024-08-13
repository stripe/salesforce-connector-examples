# Deployment

To Deploy this Example

- Clone the Repo
`git clone https://github.com/stripe/salesforce-connector-examples.git`

- Open salesforce-connector-examples Directory
`cd salesforce-connector-examples`

- Create a scratch ORG using the the 
`sf org create scratch -e developer -m -y 10 -a <Your_Alias> --target-dev-hub <Your_Dev_Hub> -f stripe-project.json`

- Install The Stripe for Salesforce Platform Connector
[Install Guide](https://docs.stripe.com/plugins/stripe-connector-for-salesforce/installation-guide)

- Deploy the Demo Solution
`cd Stripe-QTC-Demo-Deployer`
`sf project deploy start --target-org <Your_Org>`
