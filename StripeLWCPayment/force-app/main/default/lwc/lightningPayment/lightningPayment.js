import { LightningElement, track, wire, api } from 'lwc';
import paymentIntent from '@salesforce/apex/stripePayment.paymentIntent';

export default class MyComponent extends LightningElement {
    amountString;
    @track jsonData;
    @track totalCost = 10.00;  // Example value for total
    @track stripeCustomerId = 'cus_ON5ZggzrFQ'; //Example this is the stripe customerId
    @track orderId = 'order_0001'; //Example orderID
    @track stripeAccountRecordID = 'a027g0000AAK' //Example recordID of the stripeGC.Stripe_Account
    @track stripeOnbehalfAccount = 'acct_1NdIVaFKXD' //Example Connect Stripe Account Id from Stripe Dashboard
    @track currency = 'usd' //Example currency to pass
    @track clientSec;
    @track pk_key = 'pk_test_SB3lf48h86WTFN'; //Public Key For main Stripe account
    amountString = (this.totalCost * 100);
    amountString = this.amountString.toString();
    _isWiredResultCompleted = false;

    @wire(paymentIntent, { StripeAccountID: '$stripeAccountRecordID', amount: '$amountString', stripecurrency: '$currency', orderID: '$orderId', onBehalfOf: '$stripeOnbehalfAccount', customerId: '$stripeCustomerId'})
    wiredResult({ error, data }) {
        if (data) {
            this.jsonData = JSON.parse(data);
            this.clientSec = this.jsonData.client_secret;
            this._isWiredResultCompleted = true;
        } else if (error) {
            // Handle error accordingly
            console.error("Error fetching paymentIntent:", error);
            this._isWiredResultCompleted = true;
        }
    }

    get vfUrl() {
        // Only return the URL when wire service has completed
        if (this._isWiredResultCompleted) {
            return '/apex/StripePaymentPage?clientSecret=' + this.clientSec + '&pkkey=' + this.pk_key;
        }
        return ''; // Or any default URL or placeholder value
    }
}