import { LightningElement, api } from 'lwc';

export default class StripeURLOpener extends LightningElement {

    @api
    get url() {
        return this._url;
    }
    set url(value) {
        this._url = value;
        console.log("In LWC: " + this._PublicKey);
        //this.sendValueToVF('PublicKey', value);
    }

    // Handle the button click to open the URL in a new window
    handleOpenUrl() {
        // Open the URL in a new window
        if (this._url) {
            window.open(this._url, '_blank');
        }
    }
}