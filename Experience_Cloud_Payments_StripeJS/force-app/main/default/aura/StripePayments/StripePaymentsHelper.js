({
    
    initializeStripe: function(component, clientSecret) {
        var stripe = component.get("v.stripe");
        var elements = stripe.elements({ clientSecret: clientSecret, appearance: {theme: 'stripe'} });

        var paymentElementOptions = {
            layout: "tabs"
        };
        var paymentElement = elements.create("payment", paymentElementOptions);
        paymentElement.mount("#payment-element");

        component.set("v.stripe", stripe);
        component.set("v.elements", elements);
        component.set("v.paymentElement", paymentElement);
    },

    submitPayment: function(component) {
        var stripe = component.get("v.stripe");
        var elements = component.get("v.elements");
        //this.setLoading(component, true);

    	 stripe.confirmPayment({
    		elements: elements,
    		confirmParams: {
        	return_url: window.location.href,
    	},
		}).then(function(result) {
    		if (result.error) {
        	console.log("Payment error:", result.error.message);
        	this.showMessage(component, result.error.message);
    		} else {
        		console.log("Payment process seems to have run without immediate errors.");
        		// Handle success or redirection here
    		}
	}.bind(this)).catch(function(error) {
    	console.error("Caught error in payment promise:", error);
    	this.showMessage(component, "Error during payment: " + error.message);
	}.bind(this));
    },

    checkStatus: function(component) {
        var clientSecret = new URLSearchParams(window.location.search).get("payment_intent_client_secret");
        if (!clientSecret) {
            return;
        }
        var stripe = component.get("v.stripe");
        stripe.retrievePaymentIntent(clientSecret).then(function(result) {
            if (result.paymentIntent) {
                switch (result.paymentIntent.status) {
                    case "succeeded":
                        this.showMessage(component, "Payment succeeded!");
                        break;
                    case "processing":
                        this.showMessage(component, "Your payment is processing.");
                        break;
                    case "requires_payment_method":
                        this.showMessage(component, "Your payment was not successful, please try again.");
                        break;
                    default:
                        this.showMessage(component, "Something went wrong.");
                        break;
                }
            }
        }.bind(this));
    },

    showMessage: function(component, message) {
        var messageContainer = component.find("payment-message").getElement();
        messageContainer.textContent = message;
        $A.util.removeClass(messageContainer, "hidden");
        setTimeout(function() {
            $A.util.addClass(messageContainer, "hidden");
            messageContainer.textContent = "";
        }, 4000);
    },

    setLoading: function(component, isLoading) {
        var submitButton = component.find("submit").getElement();
        var spinner = component.find("spinner").getElement();
        var buttonText = component.find("button-text").getElement();
        if (isLoading) {
            submitButton.disabled = true;
            $A.util.removeClass(spinner, "hidden");
            $A.util.addClass(buttonText, "hidden");
        } else {
            submitButton.disabled = false;
            $A.util.addClass(spinner, "hidden");
            $A.util.removeClass(buttonText, "hidden");
        }
    }
})