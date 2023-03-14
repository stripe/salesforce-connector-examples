import { api, LightningElement } from 'lwc';
import stripeIcon from '@salesforce/resourceUrl/stripe_icon';
import generateCheckoutLink from '@salesforce/apex/GenerateCheckoutLinkController.generateCheckoutLink';

export default class GenerateCheckoutLink extends LightningElement {
    @api recordId;

    iconUrl = stripeIcon;
    checkoutLink = '';
    loading = false;

    get generateButtonDisabled() {
        return this.loading;
    }

    get copyButtonDisabled() {
        return this.loading;
    }

    get linkGenerated() {
        return this.checkoutLink.length > 0;
    }

    async generateLink() {
        try {
            this.loading = true;
            this.checkoutLink = await generateCheckoutLink({
                orderId: this.recordId
            });

        } finally {
            this.loading = false;
        }
    }

    copyLink() {
        const displayLink = this.template.querySelector('input.stripe-checkout-link');
        if (displayLink) {
            displayLink.select();
            document.execCommand('copy');
            this.template.querySelector('.stripe-button_container lightning-button-icon').focus();
            this.template.querySelector('.stripe-button_overlay').classList.remove('slds-hide');
        }
    }

    resetCopyOverlay(event) {
        event.currentTarget.classList.add('slds-hide');
    }
}