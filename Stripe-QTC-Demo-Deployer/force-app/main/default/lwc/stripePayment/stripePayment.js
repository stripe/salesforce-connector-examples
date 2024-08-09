import { LightningElement, track } from 'lwc';
import { loadScript } from 'lightning/platformResourceLoader';
import STRIPEJS from '@salesforce/resourceUrl/stripeJS';

export default class StripePayment extends LightningElement {
    @track stripe;
    @track elements;
    @track clientSecret;
    @track paymentElement;

    connectedCallback() {
        loadScript(this, STRIPEJS)
            .then(() => {
                this.initializeCustomEventListeners();
                console.log('StripeJS loaded successfully');
            })
            .catch(error => {
                console.error('Error loading StripeJS', error);
            });
    }

    initializeCustomEventListeners() {
        document.addEventListener('securitypolicyviolation', (event) => {
            console.log('Security Policy Violation:', event);
        });
        console.log('Custom event listener initialized.');
    }

    handleClientSecretChange(event) {
        this.clientSecret = event.target.value;
    }

    initializeStripe() {
        if (!this.clientSecret) {
            console.error('Client secret is not set.');
            return;
        }

        this.stripe = Stripe('pk_test_51PVw0rFBiKI27fV55NzQ8Kngxym0DSxJb6uKlpWs402htmNg7uxht4uwpgEKUVHyN5b4MXwcDH6aJYojNPaZCKB300zOZo4DDm');
        this.elements = this.stripe.elements({ clientSecret: this.clientSecret });
        this.paymentElement = this.elements.create('payment');
        this.paymentElement.mount(this.template.querySelector('#payment-element'));
        this.template.querySelector('#submit-button').style.display = 'block';
    }

    handleSubmit() {
        this.stripe.confirmCardPayment(this.clientSecret, {
            payment_method: {
                card: this.paymentElement,
            }
        }).then(result => {
            if (result.error) {
                console.error(result.error.message);
            } else {
                console.log('Payment successful!', result.paymentIntent);
            }
        });
    }
}