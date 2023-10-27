import { LightningElement, api } from 'lwc';

export default class stripePayment extends LightningElement {
    @api
    get PublicKey() {
        return this._PublicKey;
    }
    set PublicKey(value) {
        this._PublicKey = value;
        console.log("In LWC: " + this._PublicKey);
        //this.sendValueToVF('PublicKey', value);
    }

    @api
    get theme() {
        return this._theme;
    }
    set theme(value) {
        this._theme = value;
    }

    @api
    get ClientSecret() {
        return this._ClientSecret;
    }
    set ClientSecret(value) {
        this._ClientSecret = value;
        console.log("In LWC: " + this._ClientSecret);
        //this.sendValueToVF('ClientSecret', value);
    }

    sendToVF() {
        const vfIframe = this.template.querySelector('iframe');
        if (vfIframe.contentWindow) {
            const message = {
                PublicKey: this.PublicKey,
                ClientSecret: this.ClientSecret,
                theme: this.theme
            }
            vfIframe.contentWindow.postMessage(message, '*');
        }
    }
    
//     sendValueToVF(variableName, value) {
//         const vfWindow = this.template.querySelector('iframe').contentWindow;
//         const message = {
//             variableName: variableName,
//             value: value
//         };
//         vfWindow.postMessage(message, '*');  // Use '*' for simplicity, but ideally specify the VF domain
//     }
}
